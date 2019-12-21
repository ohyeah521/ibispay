package controller

import (
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"io"
	"sort"
	"strings"
	"time"

	"github.com/kr/beanstalk"

	"github.com/go-xorm/xorm"
	"github.com/kataras/iris"
	"github.com/rs/xid"
	"reqing.org/ibispay/config"
	"reqing.org/ibispay/db"
	"reqing.org/ibispay/model"
	"reqing.org/ibispay/util"
)

//NewPay 发行或转手鸟币
func NewPay(ctx iris.Context, form model.NewPayForm) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	coinName := GetJwtUser(ctx)[config.JwtNameKey].(string)
	lock := GetTxLocks(ctx)

	var checkDBErr = func(err error) {
		if err != nil {
			util.LogDebugAll(err)
		}
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	}

	var checkInsertErr = func(affected int64, err error) {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
		if affected == 0 {
			e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1004)
		}
	}

	//不能转账给自己
	if form.Receiver == coinName {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1024)
	}

	//注意：转账接口(pay)通常用于发币和转手！如果鸟币回流到收款人是为了兑现，那么应该使用兑现接口。
	//此处注释后，则包含直接回流的鸟币。也可取消注释，则强制所有鸟币回流都是兑现鸟币。
	//支付表(pay)=鸟币发行记录+鸟币转手记录（包含直接回流的鸟币），兑现表(repay)=鸟币兑现记录。所有交易=发行+转手+兑现。
	if form.Receiver == form.TransCoin {
		// e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1021)
	}

	//检查收款人是否存在
	exist, err := pq.Exist(&db.Coin{Name: form.Receiver})
	checkDBErr(err)
	if exist == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1018)
	}

	//检查要转账的鸟币是否存在
	exist, err = pq.Exist(&db.Coin{Name: form.TransCoin})
	checkDBErr(err)
	if exist == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1020)
	}

	//=====参数整理=====
	payerName := coinName         //持有者
	txCoinName := form.TransCoin  //被转账的鸟币
	receiverName := form.Receiver //收款人
	state := 1                    //1.非血盟发行 2.血盟发行 3.非血盟转手 4.血盟转手
	//判断是否是发行
	isIssue := false
	if form.TransCoin == coinName {
		isIssue = true
	}
	if isIssue {
		//发行
		if form.IsMarker {
			//血盟，忽略技能
			state = 2
		} else {
			//非血盟，需要有至少一项技能
			state = 1
		}
	} else {
		//转手
		if form.IsMarker {
			//血盟转手
			state = 4
		} else {
			//非血盟
			state = 3
		}
	}

	//===========开始执行交易操作============
	//1.锁住双方的交易事务直到转账结束
	if lock.Locks[payerName] == true || lock.Locks[receiverName] == true {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1019)
		return
	}
	lock.Locks[payerName] = true
	lock.Locks[receiverName] = true
	defer func() {
		delete(lock.Locks, payerName)
		delete(lock.Locks, receiverName)
	}()

	//2.参数准备，pay表、sum表、subsum表、snap表、snap_set表
	//---新建pay记录---
	pay := db.Pay{Amount: form.Amount, TransCoin: txCoinName, Receiver: receiverName, Payer: payerName, IsIssue: isIssue, IsMarker: form.IsMarker, GUID: xid.New().String()}
	//payer鸟币数量减少，receiver鸟币数量增加
	payerAdd := -int64(form.Amount)
	receiverAdd := int64(form.Amount)
	//---不存在则新建sum记录，并在稍后加入事务---
	//付款方sum
	payerSum := db.Sum{Bearer: payerName, Coin: txCoinName, IsMarker: form.IsMarker}
	has, err := pq.UseBool().Get(&payerSum)
	checkDBErr(err)
	if has == false {
		if state == 3 || state == 4 {
			//并不拥有此鸟币，返回错误（因为转手必定已经先有记录可查询）
			e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1025)
		}
		//注意此处sum值为0，需要在最后的事务中更新为真实值
		affected, err := pq.InsertOne(&payerSum)
		checkInsertErr(affected, err)
	}
	//检查转手的鸟币数量是否足够
	if state == 3 || state == 4 {
		if payerSum.Sum < int64(form.Amount) {
			e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1023)
		}
	}
	payerSum.Sum += payerAdd
	//收款方sum
	receiverSum := db.Sum{Bearer: receiverName, Coin: txCoinName, IsMarker: form.IsMarker}
	has, err = pq.UseBool().Get(&receiverSum)
	checkDBErr(err)
	if has == false {
		//注意此处sum值为0，需要在最后的事务中更新为真实值
		affected, err := pq.InsertOne(&receiverSum)
		checkInsertErr(affected, err)
	}
	receiverSum.Sum += receiverAdd

	//---非血盟时：不存在则新建subsum记录，并在稍后加入事务---
	pays := []*db.Pay{}
	payerSubSumsToUpdate := []*db.SubSum{}
	receiverSubSumsToUpdate := []*db.SubSum{}
	if state == 1 {
		//---非血盟发行，不存在则新建snap、snap_set记录---
		skillNum := 0
		snapSetValue := uint64(0)
		//获取payer所有最新技能
		skills := []db.Skill{}
		err = pq.Where("owner = ?", payerName).Find(&skills)
		checkDBErr(err)
		util.LogDebugAll(skills)
		skillNum = len(skills)
		if skillNum == 0 {
			e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1022)
		}
		//拼接snap_ids
		snapIDs := []uint64{}
		for i := 0; i < skillNum; i++ {
			snapSetValue += skills[i].Price
			//是否需要新建snap记录。若不存在可以提前插入数据库，不用加入到事务
			snap := db.Snap{SkillID: skills[i].ID, Version: skills[i].Version}
			has, err := pq.Cols("id").Get(&snap)
			checkDBErr(err)
			if has == false {
				//新建snap
				snap = db.Snap{Owner: payerName, Title: skills[i].Title, Price: skills[i].Price, Desc: skills[i].Desc, Tags: skills[i].Tags, Pics: skills[i].Pics, SkillID: skills[i].ID, Version: skills[i].Version}
				affected, err := pq.InsertOne(&snap)
				checkInsertErr(affected, err)
			}
			snapIDs = append(snapIDs, snap.ID)
		}
		//倒序排列
		sort.Slice(snapIDs, func(i, j int) bool {
			return snapIDs[i] > snapIDs[j]
		})
		//获得ids的md5值
		hash := md5.New()
		ids, err := json.Marshal(snapIDs)
		checkDBErr(err)
		_, err = io.Copy(hash, strings.NewReader(string(ids)))
		checkDBErr(err)
		strMd5 := hex.EncodeToString(hash.Sum(nil))

		//检查是否已经存在snap_set。若不存在可以提前插入数据库，不用加入到事务
		issuerSS := db.SnapSet{Md5: strMd5}
		has, err = pq.Get(&issuerSS)
		checkDBErr(err)
		if has == false {
			issuerSS = db.SnapSet{Owner: payerName, Md5: strMd5, SnapIDs: snapIDs, Value: snapSetValue, Count: uint32(skillNum)}
			affected, err := pq.InsertOne(&issuerSS)
			checkInsertErr(affected, err)
		}
		pay.SnapSetID = issuerSS.ID

		//是否需要新建sub_sum记录
		//付款方subsum
		payerSubSum := db.SubSum{Bearer: payerName, Coin: txCoinName, SnapSetID: issuerSS.ID}
		has, err = pq.Get(&payerSubSum)
		checkDBErr(err)
		if has == false {
			//新建sub_sum，注意此处sum值为0，需要在最后的事务中更新为真实值
			payerSubSum.SnapIDs = snapIDs
			affected, err := pq.InsertOne(&payerSubSum)
			checkInsertErr(affected, err)
		}
		payerSubSum.Sum += payerAdd
		payerSubSumsToUpdate = append(payerSubSumsToUpdate, &payerSubSum)

		//收款方subsum
		receiverSubSum := db.SubSum{Bearer: receiverName, Coin: txCoinName, SnapSetID: issuerSS.ID}
		has, err = pq.Get(&receiverSubSum)
		checkDBErr(err)
		if has == false {
			//新建sub_sum，注意此处sum值为0，需要在最后的事务中更新为真实值
			receiverSubSum.SnapIDs = snapIDs
			affected, err := pq.InsertOne(&receiverSubSum)
			checkInsertErr(affected, err)
		}
		receiverSubSum.Sum += receiverAdd
		receiverSubSumsToUpdate = append(receiverSubSumsToUpdate, &receiverSubSum)
	} else if state == 3 {
		//非血盟转手，持有人的subsum一定已经存在
		//查询持有人所拥有的某个鸟币的所有版本。注意：兑现时持有者仅可兑现所拥有的鸟币版本号之后的版本的技能
		limit := 10 //每次获取10条
		start := 0
		breakNow := false
		guid := xid.New().String()
		leftAmount := int64(form.Amount)
	Exit:
		for {
			subsums := []*db.SubSum{}
			err = pq.Where("coin = ? and bearer = ?", txCoinName, payerName).And("sum > ?", 0).Desc("snap_set_id").Limit(limit, start).Find(&subsums)
			checkDBErr(err)
			util.LogDebugAll(subsums)
			if len(subsums) == 0 {
				break
			}

			for _, subsum := range subsums {
				snapSetSum := subsum.Sum
				//此版本鸟币不够时，剩余未转的账目使用更老一个版本的鸟币
				payerSubSumAdd := -snapSetSum
				receiverSubSumAdd := snapSetSum
				if snapSetSum >= leftAmount {
					//此版本鸟币可以完成转账数额，准备退出循环
					payerSubSumAdd = -leftAmount
					receiverSubSumAdd = leftAmount
					breakNow = true
				} else {
					if snapSetSum == 0 {
						continue
					}
					leftAmount -= snapSetSum
				}

				//收款方subsum
				//是否需要新建sub_sum记录
				receiverSubSum := db.SubSum{Bearer: receiverName, Coin: txCoinName, SnapSetID: subsum.SnapSetID}
				has, err := pq.Get(&receiverSubSum)
				checkDBErr(err)
				if has == false {
					//新建sub_sum，注意此处sum值为0，需要在最后的事务中更新为真实值
					receiverSubSum.SnapIDs = subsum.SnapIDs
					affected, err := pq.InsertOne(&receiverSubSum)
					checkInsertErr(affected, err)
				}
				receiverSubSum.Sum += receiverSubSumAdd
				receiverSubSumsToUpdate = append(receiverSubSumsToUpdate, &receiverSubSum)

				//付款方subsum记录
				payerSubSum := db.SubSum{ID: subsum.ID, Sum: subsum.Sum + payerSubSumAdd}
				payerSubSumsToUpdate = append(payerSubSumsToUpdate, &payerSubSum)

				//每个版本的鸟币都需要新建一个pay
				//倒序排列
				snapIDs := subsum.SnapIDs
				sort.Slice(snapIDs, func(i, j int) bool {
					return snapIDs[i] > snapIDs[j]
				})
				//获得ids的md5值
				hash := md5.New()
				ids, err := json.Marshal(snapIDs)
				checkDBErr(err)
				_, err = io.Copy(hash, strings.NewReader(string(ids)))
				checkDBErr(err)
				strMd5 := hex.EncodeToString(hash.Sum(nil))
				//转手时，发行者的snap_set一定存在，否则返回错误
				issuerSS := db.SnapSet{Md5: strMd5}
				has, err = pq.Get(&issuerSS)
				checkDBErr(err)
				if has == false {
					e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1031)
				}
				mutiPay := db.Pay{TransCoin: txCoinName, Receiver: receiverName, Payer: payerName, IsIssue: isIssue, IsMarker: form.IsMarker, GUID: guid, SnapSetID: issuerSS.ID, Amount: uint64(receiverSubSumAdd)}
				pays = append(pays, &mutiPay)
				if breakNow {
					break Exit
				}
			}
			start += limit
		}
	}

	//新的news
	payerNews := db.News{Owner: payerName, Desc: config.Public.Tips.T1000, Amount: payerAdd, Buddy: receiverName}
	receiverNews := db.News{Owner: receiverName, Desc: config.Public.Tips.T1001, Amount: receiverAdd, Buddy: payerName}

	//是否需要新建info记录
	var insertInfo = func(record db.Info) {
		has, err := pq.Exist(&record)
		checkDBErr(err)
		if has == false {
			affected, err := pq.InsertOne(&record)
			checkInsertErr(affected, err)
		}
	}
	insertInfo(db.Info{Owner: payerName})
	insertInfo(db.Info{Owner: receiverName})

	//数据库事务
	//处理pay表、sum表/sub_sum表、news表/info表
	_, err = pq.Transaction(func(session *xorm.Session) (interface{}, error) {
		//new pay
		if len(pays) > 0 {
			//xorm批量插入一次最多150条左右，所以需要分割成多个，这里分割成每次插入20条
			batchSize := 20
			mutiPays := [][]*db.Pay{}
			for batchSize < len(pays) {
				pays, mutiPays = pays[batchSize:], append(mutiPays, pays[0:batchSize:batchSize])
			}
			mutiPays = append(mutiPays, pays)
			for _, mpays := range mutiPays {
				_, err := session.InsertMulti(mpays)
				if err != nil {
					return nil, err
				}
			}
		} else {
			_, err := session.InsertOne(&pay)
			if err != nil {
				return nil, err
			}
		}

		//update sum
		_, err = session.Id(payerSum.ID).Cols("sum").Update(&payerSum)
		if err != nil {
			return nil, err
		}
		_, err = session.Id(receiverSum.ID).Cols("sum").Update(&receiverSum)
		if err != nil {
			return nil, err
		}

		//update subsum
		if len(payerSubSumsToUpdate) > 0 {
			for _, subsum := range payerSubSumsToUpdate {
				_, err = session.ID(subsum.ID).Cols("sum").Update(subsum)
				if err != nil {
					return nil, err
				}
			}
		}
		if len(receiverSubSumsToUpdate) > 0 {
			for _, subsum := range receiverSubSumsToUpdate {
				_, err = session.ID(subsum.ID).Cols("sum").Update(subsum)
				if err != nil {
					return nil, err
				}
			}
		}

		//new news
		_, err := session.Insert(&payerNews, &receiverNews)
		if err != nil {
			return nil, err
		}

		//update info
		_, err = session.Where("owner = ?", payerName).UseBool().Update(&db.Info{HasNews: true})
		if err != nil {
			return nil, err
		}
		_, err = session.Where("owner = ?", receiverName).UseBool().Update(&db.Info{HasNews: true})
		if err != nil {
			return nil, err
		}

		return nil, nil
	})
	checkDBErr(err)

	ctx.JSON(&model.UpdateRes{Ok: true})

	//在后台更新coin表的鸟币信用和个人统计
	go func() {

	}()
}

//NewReq 兑现鸟币请求
func NewReq(ctx iris.Context, form model.NewReqForm) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	coinName := GetJwtUser(ctx)[config.JwtNameKey].(string)

	//不能自我兑现
	if form.Issuer == coinName {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1028)
	}

	var checkDBErr = func(err error) {
		if err != nil {
			util.LogDebugAll(err)
		}
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	}

	//检查收款人是否存在
	exist, err := pq.Exist(&db.Coin{Name: form.Issuer})
	checkDBErr(err)
	if exist == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1018)
	}

	//检查拥有的鸟币是否足够
	sum := db.Sum{Bearer: coinName, Coin: form.Issuer, IsMarker: form.IsMarker}
	has, err := pq.UseBool().Get(&sum)
	checkDBErr(err)
	if has == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1004)
	}
	if sum.Sum < int64(form.Amount) {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1023)
	}

	//2小时内只能向同一用户请求一次（未处理请求的情况即state=10）
	r := db.Req{Closed: false, Issuer: form.Issuer, Bearer: coinName, State: 10}
	has, err = pq.UseBool().Cols("created").Desc("created").Get(&r)
	checkDBErr(err)
	if has == true {
		if r.Created.Add(time.Hour * 2).After(time.Now()) {
			e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1029)
		}
	}

	//数据库事务
	//处理req表、news表/info表
	_, err = pq.Transaction(func(session *xorm.Session) (interface{}, error) {
		//req
		req := db.Req{State: 10, Bearer: coinName, Issuer: form.Issuer, IsMarker: form.IsMarker, SnapID: form.SnapID, Amount: form.Amount}
		_, err := session.InsertOne(&req)
		if err != nil {
			return nil, err
		}

		//news
		tip1 := config.Public.Req.ReqBearer10 //请求方提示
		tip2 := config.Public.Req.ReqIssuer10 //执行方提示
		if form.IsMarker {
			tip1 = config.Public.Req.ReqBearer11 //请求方提示（血盟）
			tip2 = config.Public.Req.ReqIssuer11 //执行方提示（血盟）
		}
		bearerNews := db.News{Owner: coinName, Desc: tip1, Amount: int64(form.Amount), Buddy: form.Issuer, Table: config.NewsTableReq, SourceID: req.ID}
		issuerNews := db.News{Owner: form.Issuer, Desc: tip2, Amount: int64(form.Amount), Buddy: coinName, Table: config.NewsTableReq, SourceID: req.ID}
		_, err = session.Insert(&bearerNews, &issuerNews)
		if err != nil {
			return nil, err
		}

		//info
		_, err = session.Where("owner = ?", coinName).UseBool().Update(&db.Info{HasReq: true})
		if err != nil {
			return nil, err
		}
		_, err = session.Where("owner = ?", form.Issuer).UseBool().Update(&db.Info{HasReq: true})
		if err != nil {
			return nil, err
		}

		//加入延时tube，超时未接受的请求在main/jobReqCheck()中处理
		byteReq, err := json.Marshal(req)
		conn, err := beanstalk.Dial("tcp", config.BeanstalkURI)
		tube := &beanstalk.Tube{Conn: conn, Name: config.BeanstalkTubeReq}
		/**
		delay is time to wait before putting the job in
		the ready queue. The job will be in the "delayed" state during this time.

		ttr -- time to run -- is time to allow a worker
		to run this job. This time is counted from the moment a worker reserves
		this job. If the worker does not delete, release, or bury the job within
		ttr time, the job will time out and the server will release the job.
		*/
		//2小时后检查是否接受，ttr为1秒（数据库操作通常只需要十几毫秒）
		_, err = tube.Put(byteReq, 0, 2*time.Hour, 1*time.Second)
		if err != nil {
			return nil, err
		}

		return nil, nil
	})
	checkDBErr(err)

	ctx.JSON(&model.UpdateRes{Ok: true})

	//在后台更新coin表的鸟币信用和个人统计
	go func() {

	}()
}

//NewRepay 兑现鸟币（接受兑现请求）
func NewRepay(ctx iris.Context, form model.NewRepayForm) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	coinName := GetJwtUser(ctx)[config.JwtNameKey].(string)
	lock := GetTxLocks(ctx)

	var checkDBErr = func(err error) {
		if err != nil {
			util.LogDebugAll(err)
		}
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	}

	//检查持有者是否存在
	exist, err := pq.Exist(&db.Coin{Name: form.Bearer})
	checkDBErr(err)
	if exist == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1018)
	}

	//检查要兑现的技能快照是否存在
	exist, err = pq.ID(form.SnapID).Exist(&db.Snap{})
	checkDBErr(err)
	if exist == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1032)
	}

	//检查要请求是否存在
	req := db.Req{ID: form.ReqID, Closed: false, State: 10}
	exist, err = pq.UseBool().Get(&req)
	checkDBErr(err)
	if exist == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1033)
	}

	//=====参数整理=====
	issuer := coinName
	bearer := form.Bearer
	txCoin := coinName

	//========锁住双方的交易事务直到转账结束==========
	if lock.Locks[issuer] == true || lock.Locks[bearer] == true {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1019)
		return
	}
	lock.Locks[issuer] = true
	lock.Locks[bearer] = true
	defer func() {
		delete(lock.Locks, issuer)
		delete(lock.Locks, bearer)
	}()

	//---------回收鸟币---------
	//参数准备，repay表、sum表、subsum表
	//---新建repay记录---
	repay := db.Repay{ReqID: form.ReqID, SnapID: form.SnapID, Amount: form.Amount, Bearer: bearer, Issuer: issuer, IsMarker: form.IsMarker}
	//bearer鸟币数量减少，issuer鸟币数量增加
	bearerAdd := -int64(form.Amount)
	issuerAdd := int64(form.Amount)
	//---准备更新sum记录，并在稍后加入事务---
	//持有人sum
	bearerSum := db.Sum{Bearer: bearer, Coin: txCoin, IsMarker: form.IsMarker}
	has, err := pq.UseBool().Get(&bearerSum)
	checkDBErr(err)
	if has == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1004)
	}
	//检查持有人是否持有足够的鸟币
	if bearerSum.Sum < int64(form.Amount) {
		//关闭交易
		pq.ID(form.ReqID).UseBool("closed").Update(&db.Req{Closed: true, State: 33})
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1023)
	}
	bearerSum.Sum += bearerAdd
	//发行者sum
	issuerSum := db.Sum{Bearer: issuer, Coin: txCoin, IsMarker: form.IsMarker}
	has, err = pq.UseBool().Get(&issuerSum)
	checkDBErr(err)
	if has == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1004)
	}
	issuerSum.Sum += issuerAdd

	repays := []*db.Repay{}
	bearerSubSumsToUpdate := []*db.SubSum{}
	issuerSubSumsToUpdate := []*db.SubSum{}
	if form.IsMarker == false {
		//非血盟兑现，需要更新subsum表
		//注意：持有者仅可兑现所拥有的鸟币版本号之后的版本的技能，所消耗的鸟币顺序为：1.首先消耗兑现时选择的版本的鸟币 2.再消耗剩余的版本的鸟币（按倒序排列）
		start := 0
		limit := 10 //每次获取10条
		breakNow := false
		useOtherSnaps := false
		guid := xid.New().String()
		leftAmount := int64(form.Amount)
		snapID := []uint64{form.SnapID}
		data, _ := json.Marshal(snapID)
		for {
			subsums := []*db.SubSum{}
			if useOtherSnaps == false {
				//---1.消耗兑现时选择的版本的鸟币----
				err := pq.Where("coin = ? and bearer = ? and sum > ?", txCoin, bearer, 0).And("snap_ids @> ?", string(data)).Desc("snap_set_id").Limit(limit, start).Find(&subsums)
				checkDBErr(err)
				util.LogDebug("useOtherSnaps=false")
				util.LogDebugAll(subsums)
				if len(subsums) == 0 {
					start = 0
					useOtherSnaps = true
					continue
				}
			} else {
				//---2.消耗剩余的版本的鸟币（按倒序排列）---
				err := pq.Where("coin = ? and bearer = ? and sum > ?", txCoin, bearer, 0).And("NOT (snap_ids @> ?)", string(data)).Desc("snap_set_id").Limit(limit, start).Find(&subsums)
				checkDBErr(err)
				util.LogDebug("useOtherSnaps=true")
				util.LogDebugAll(subsums)
				if len(subsums) == 0 {
					break
				}
			}

			for _, subsum := range subsums {
				snapSetSum := subsum.Sum
				//此版本鸟币不够时，剩余未转的账目使用更老一个版本的鸟币
				bearerSubSumAdd := -snapSetSum
				issuerSubSumAdd := snapSetSum
				if snapSetSum >= leftAmount {
					//此版本鸟币可以完成转账数额，准备退出循环
					bearerSubSumAdd = -leftAmount
					issuerSubSumAdd = leftAmount
					breakNow = true
				} else {
					leftAmount -= snapSetSum
				}

				//发行方subsum
				issuerSubSum := db.SubSum{Bearer: issuer, Coin: txCoin, SnapSetID: subsum.SnapSetID}
				has, err := pq.Get(&issuerSubSum)
				checkDBErr(err)
				if has == false {
					e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1030)
				}
				issuerSubSum.Sum += issuerSubSumAdd
				issuerSubSumsToUpdate = append(issuerSubSumsToUpdate, &issuerSubSum)

				//持币方subsum记录
				bearerSubSum := db.SubSum{ID: subsum.ID, Sum: subsum.Sum + bearerSubSumAdd}
				bearerSubSumsToUpdate = append(bearerSubSumsToUpdate, &bearerSubSum)

				//每个版本的鸟币都需要新建一个repay
				mutiRepay := db.Repay{ReqID: form.ReqID, SnapID: form.SnapID, SnapSetID: subsum.SnapSetID, GUID: guid, Bearer: bearer, Issuer: issuer, Amount: uint64(issuerSubSumAdd), IsMarker: false}
				repays = append(repays, &mutiRepay)
				if breakNow {
					goto Exit
				}
			}
			start += limit
		}
	Exit:
	}

	//新的news
	bearerNews := db.News{Owner: bearer, Desc: config.Public.Tips.T1002, Amount: bearerAdd, Buddy: issuer, SourceID: form.ReqID, Table: config.NewsTableReq}
	issuerNews := db.News{Owner: issuer, Desc: config.Public.Tips.T1003, Amount: issuerAdd, Buddy: bearer, SourceID: form.ReqID, Table: config.NewsTableReq}

	//数据库事务
	//处理pay表、sum表/sub_sum、news表/info表、req表
	_, err = pq.Transaction(func(session *xorm.Session) (interface{}, error) {
		//new pay
		if len(repays) > 0 {
			//xorm批量插入一次最多150条左右，所以需要分割成多个，这里分割成每次插入20条
			batchSize := 20
			mutiRepays := [][]*db.Repay{}
			for batchSize < len(repays) {
				repays, mutiRepays = repays[batchSize:], append(mutiRepays, repays[0:batchSize:batchSize])
			}
			mutiRepays = append(mutiRepays, repays)
			for _, mpays := range mutiRepays {
				_, err := session.InsertMulti(mpays)
				if err != nil {
					return nil, err
				}
			}
		} else {
			_, err := session.InsertOne(&repay)
			if err != nil {
				return nil, err
			}
		}

		//update sum
		_, err = session.Id(bearerSum.ID).Cols("sum").Update(&bearerSum)
		if err != nil {
			return nil, err
		}
		_, err = session.Id(issuerSum.ID).Cols("sum").Update(&issuerSum)
		if err != nil {
			return nil, err
		}

		//update subsum
		if len(bearerSubSumsToUpdate) > 0 {
			for _, subsum := range bearerSubSumsToUpdate {
				_, err = session.ID(subsum.ID).Cols("sum").Update(subsum)
				if err != nil {
					return nil, err
				}
			}
		}
		if len(issuerSubSumsToUpdate) > 0 {
			for _, subsum := range issuerSubSumsToUpdate {
				_, err = session.ID(subsum.ID).Cols("sum").Update(subsum)
				if err != nil {
					return nil, err
				}
			}
		}

		//new news
		_, err := session.Insert(&bearerNews, &issuerNews)
		if err != nil {
			return nil, err
		}

		//update info
		_, err = session.Where("owner = ?", bearer).UseBool().Update(&db.Info{HasNews: true})
		if err != nil {
			return nil, err
		}
		_, err = session.Where("owner = ?", issuer).UseBool().Update(&db.Info{HasNews: true})
		if err != nil {
			return nil, err
		}

		//update req
		_, err = session.ID(form.ReqID).Update(&db.Req{State: 20})
		if err != nil {
			return nil, err
		}

		return nil, nil
	})
	checkDBErr(err)

	ctx.JSON(&model.UpdateRes{Ok: true})

	//在后台更新coin表的鸟币信用和个人统计
	go func() {

	}()
}
