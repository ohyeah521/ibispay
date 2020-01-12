package controller

import (
	"encoding/hex"
	"image/jpeg"
	"io/ioutil"
	"os"
	"time"

	"github.com/boombuler/barcode"
	"github.com/boombuler/barcode/qr"
	"github.com/go-xorm/xorm"
	"github.com/ipsn/go-adorable"
	"github.com/iris-contrib/middleware/jwt"
	"github.com/jinzhu/copier"
	"github.com/kataras/iris"
	"github.com/rs/xid"
	"github.com/ttacon/libphonenumber"
	"golang.org/x/crypto/scrypt"
	"gopkg.in/h2non/bimg.v1"

	"reqing.org/ibispay/config"
	"reqing.org/ibispay/db"
	"reqing.org/ibispay/model"
	"reqing.org/ibispay/util"
)

//Login 登录
func Login(ctx iris.Context, form model.LoginForm) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)

	//检查手机号
	num, err := libphonenumber.Parse(form.Phone, form.PhoneCC)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1008, nil)
	//手机号格式都为E164 eg.+8618612345678
	formattedNum := libphonenumber.Format(num, libphonenumber.E164)
	//检查手机号是否未注册
	exist, err := pq.Exist(&db.Coin{Phone: formattedNum})
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	if exist == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1009)
	}

	//获取加密后的密码
	strSafePwd, err := getSafePWD(form.Pwd)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1002, nil)

	//检查鸟币是否被注册
	coin := db.Coin{}
	has, err := pq.Where("phone = ? and pwd = ?", formattedNum, strSafePwd).Cols("id, name, pwd").Get(&coin)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	if has == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1005)
	}

	// 生成token
	token, exp := GetNewJwtToken(&coin)
	res := model.LoginRes{Token: token, Expire: exp}
	ctx.JSON(&res)
}

//Register 注册
func Register(ctx iris.Context, form model.RegisterForm) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	util.LogDebug("=====RegisterHandler=====")
	util.LogDebugAll(form)

	//检查鸟币名是否已经存在
	exist, err := pq.Exist(&db.Coin{Name: form.Name})
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	if exist {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1006)
	}

	//检查手机号
	num, err := libphonenumber.Parse(form.Phone, form.PhoneCC)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1008, nil)
	//手机号格式都为E164 eg.+8618612345678
	formattedNum := libphonenumber.Format(num, libphonenumber.E164)
	//检查手机号是否已经存在
	exist, err = pq.Exist(&db.Coin{Phone: formattedNum})
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	if exist {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1007)
	}

	//获取加密后的密码
	strSafePwd, err := getSafePWD(form.Pwd)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1002, nil)

	//事务，新建coin表\news表等
	coin := db.Coin{Name: form.Name, Pwd: strSafePwd, Phone: formattedNum, PhoneCC: form.PhoneCC}
	_, err = pq.Transaction(func(session *xorm.Session) (interface{}, error) {
		//new coin
		_, err := session.Insert(&coin)
		if err != nil {
			return nil, err
		}

		//new info
		info := db.Info{Owner: coin.Name}
		_, err = session.Insert(&info)
		if err != nil {
			return nil, err
		}

		pic := config.Public.Pic
		//coin qr code
		qrPic := db.Pic{
			Biggest: db.NewSquareJPGMeta(coin.Name+pic.QRCSuffix+pic.PicNameSuffixBiggest, pic.QRSizeBiggest),
			Large:   db.NewSquareJPGMeta(coin.Name+pic.QRCSuffix+pic.PicNameSuffixLarge, pic.QRSizeLarge),
			Middle:  db.NewSquareJPGMeta(coin.Name+pic.QRCSuffix+pic.PicNameSuffixMiddle, pic.QRSizeMiddle),
			Small:   db.NewSquareJPGMeta(coin.Name+pic.QRCSuffix+pic.PicNameSuffixSmall, pic.QRSizeSmall),
		}

		//default avatar，biggest先使用default图片
		avatar := db.Pic{
			Biggest: db.NewSquareJPGMeta(coin.Name+pic.AvatarSuffix+pic.PicNameSuffixDefault, pic.AvatarSizeDefault),
		}

		//update coin
		coin.Qrc = qrPic
		coin.Avatar = avatar
		_, err = session.ID(coin.ID).Update(&coin)
		if err != nil {
			return nil, err
		}

		return coin, nil
	})

	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	ctx.JSON(&coin)

	//生成鸟币号二维码
	GoGenQRC(&coin)
	//生成默认头像
	GoGenDefaultAvatar(&coin)
}

//UpdatePwd 修改密码
func UpdatePwd(ctx iris.Context, form model.NewPwdForm) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	cid := GetJwtUser(ctx)[config.JwtCIDKey].(float64)

	//获取加密后的老密码
	strSafeOldPwd, err := getSafePWD(form.OldPwd)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1002, nil)
	//获取数据库里的老密码
	coin := db.Coin{}
	has, err := pq.ID(cid).Cols("pwd").Get(&coin)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	if has == false {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1005)
	}
	//判断与老密码是否一致
	if strSafeOldPwd != coin.Pwd {
		//老密码错误
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1012)
		return
	}

	//获取新密码
	strSafePwd, err := getSafePWD(form.Pwd)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1002, nil)
	//更新数据库
	coin.Pwd = strSafePwd
	affected, err := pq.ID(cid).Update(&coin)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	if affected == 0 {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1013)
	}

	ctx.JSON(&model.UpdateRes{Ok: true})
}

//UpdateAvatar 修改头像
func UpdateAvatar(ctx iris.Context) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	cid := GetJwtUser(ctx)[config.JwtCIDKey].(float64)
	coinName := GetJwtUser(ctx)[config.JwtNameKey].(string)

	//-----1.接收原图，移动到：./files/udata/鸟币号/pic/鸟币号_avatar-original.jpg-----
	_, fh, err := ctx.FormFile("file")
	if err != nil {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}

	//原图路径
	pic := config.Public.Pic
	meta := db.NewSquareJPGMeta(coinName+pic.AvatarSuffix+pic.PicNameSuffixOriginal, pic.AvatarSizeBiggest)
	dirOriginal := db.GetUserPicDir(coinName, meta)

	var delPic = func(err error) bool {
		if err != nil {
			os.Remove(dirOriginal)
			return true
		}
		return false
	}

	//保存原图
	_, err = util.SaveFileTo(fh, dirOriginal)
	if delPic(err) {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}

	//-----2.获取图片信息，生成缩略图------
	guid := xid.New().String()
	avatar := db.Pic{
		Biggest: db.NewSquareJPGMeta(coinName+pic.AvatarSuffix+guid+pic.PicNameSuffixBiggest, pic.AvatarSizeBiggest),
		Large:   db.NewSquareJPGMeta(coinName+pic.AvatarSuffix+guid+pic.PicNameSuffixLarge, pic.AvatarSizeLarge),
		Middle:  db.NewSquareJPGMeta(coinName+pic.AvatarSuffix+guid+pic.PicNameSuffixMiddle, pic.AvatarSizeMiddle),
		Small:   db.NewSquareJPGMeta(coinName+pic.AvatarSuffix+guid+pic.PicNameSuffixSmall, pic.AvatarSizeSmall),
	}

	//获取图片宽高信息
	oriBuffer, err := bimg.Read(dirOriginal)
	if delPic(err) {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}
	size, err := bimg.NewImage(oriBuffer).Size()
	if delPic(err) {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}
	width := uint(size.Width)

	//生成缩略图
	if width > pic.AvatarSizeBiggest {
		err = db.CompressUserJPG(coinName, oriBuffer, avatar.Biggest, true)
	} else {
		err = db.CompressUserJPG(coinName, oriBuffer, avatar.Biggest, false)
	}
	if width > pic.AvatarSizeLarge {
		err = db.CompressUserJPG(coinName, oriBuffer, avatar.Large, true)
	} else {
		err = db.CompressUserJPG(coinName, oriBuffer, avatar.Large, false)
	}
	if width > pic.AvatarSizeMiddle {
		err = db.CompressUserJPG(coinName, oriBuffer, avatar.Middle, true)
	} else {
		err = db.CompressUserJPG(coinName, oriBuffer, avatar.Middle, false)
	}
	if width > pic.AvatarSizeSmall {
		err = db.CompressUserJPG(coinName, oriBuffer, avatar.Small, true)
	} else {
		err = db.CompressUserJPG(coinName, oriBuffer, avatar.Small, false)
	}
	if delPic(err) {
		os.Remove(db.GetUserPicDir(coinName, avatar.Biggest))
		os.Remove(db.GetUserPicDir(coinName, avatar.Large))
		os.Remove(db.GetUserPicDir(coinName, avatar.Middle))
		os.Remove(db.GetUserPicDir(coinName, avatar.Small))
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}
	//删除原图
	os.Remove(dirOriginal)

	//-----3.更新数据库------
	//获取老头像
	coin := db.Coin{}
	_, err = pq.ID(cid).Cols("avatar").Get(&coin)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	oldAvatars := coin.Avatar
	coin.Avatar = avatar
	_, err = pq.ID(cid).Update(&coin)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)

	//移除老头像
	os.Remove(db.GetUserPicDir(coinName, oldAvatars.Biggest))
	os.Remove(db.GetUserPicDir(coinName, oldAvatars.Large))
	os.Remove(db.GetUserPicDir(coinName, oldAvatars.Middle))
	os.Remove(db.GetUserPicDir(coinName, oldAvatars.Small))

	ctx.JSON(&model.UpdateRes{Ok: true})
}

//UpdateProfile 修改个人资料
func UpdateProfile(ctx iris.Context, form model.ProfileForm) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	cid := GetJwtUser(ctx)[config.JwtCIDKey].(float64)

	coin := db.Coin{}
	coin.Bio = form.Bio
	coin.Email = form.Email
	affected, err := pq.ID(cid).Update(&coin)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	if affected == 0 {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1013)
	}

	ctx.JSON(&model.UpdateRes{Ok: true})
}

//GetProfile 获取鸟币资料
func GetProfile(ctx iris.Context) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	cid := GetJwtUser(ctx)[config.JwtCIDKey].(float64)
	coinName := GetJwtUser(ctx)[config.JwtNameKey].(string)

	name := ctx.Params().Get("name")
	util.LogDebug(name)

	coin := db.Coin{}
	if coinName == name {
		//自己的鸟币资料
		has, err := pq.ID(cid).Get(&coin)
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
		if has == false {
			e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1005)
		}

		ctx.JSON(&coin)
	} else {
		//别人的鸟币资料
		has, err := pq.Where("name = ?", name).Get(&coin)
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
		if has == false {
			e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1005)
		}

		profile := model.ProfileRes{}
		copier.Copy(&profile, &coin)

		ctx.JSON(&profile)
	}
}

//GetMyActivity 获取我的新动态
func GetMyActivity(ctx iris.Context) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	coinName := GetJwtUser(ctx)[config.JwtNameKey].(string)

	info := db.Info{Owner: coinName}
	pq.Get(&info)
	info.RmbExr = GetRMBExr(ctx)

	if info.HasNews {
		news := db.News{}
		counts, err := pq.Where("owner = ", coinName).Count(&news)
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
		info.NewsNum = uint32(counts) - info.ReadNum
	}

	if info.HasReq {
		req := db.Req{Bearer: coinName, Closed: false}
		counts, err := pq.Where("state < 20").UseBool("closed").Count(&req)
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
		info.TodoNum = uint32(counts) - info.DoneNum
	}

	ctx.JSON(&info)
}

//GoGenQRC 异步生成鸟币号二维码
func GoGenQRC(coin *db.Coin) {
	go func(coin *db.Coin) {
		//生成qrcode原图：./files/udata/鸟币号/pic/鸟币号_qrc-original.jpg
		pic := config.Public.Pic
		qrc, err := qr.Encode(coin.Name, qr.M, qr.Auto)
		meta := db.NewSquareJPGMeta(coin.Name+pic.QRCSuffix+pic.PicNameSuffixOriginal, config.Public.Pic.QRSizeBiggest)
		dir := db.GetUserPicDir(coin.Name, meta)
		if err != nil {
			return
		}

		qrc, err = barcode.Scale(qrc, int(meta.W), int(meta.H))
		file, err := os.Create(dir)
		defer file.Close()
		err = jpeg.Encode(file, qrc, nil)
		if err != nil {
			return
		}

		//生成4种大小的二维码jpg缩略图，并且删除"鸟币号_qrc-original.jpg"
		buffer, _ := bimg.Read(dir)
		err = db.ResizeUserPic(coin.Name, buffer, coin.Qrc.Biggest)
		err = db.ResizeUserPic(coin.Name, buffer, coin.Qrc.Large)
		err = db.ResizeUserPic(coin.Name, buffer, coin.Qrc.Middle)
		err = db.ResizeUserPic(coin.Name, buffer, coin.Qrc.Small)
		if err != nil {
			return
		}
		os.Remove(dir)
	}(coin)
}

//GoGenDefaultAvatar 异步生成默认头像，使用default填充biggest字段
func GoGenDefaultAvatar(user *db.Coin) {
	//生成默认头像
	go func(user *db.Coin) {
		//生成默认头像原图，大小400x400：./files/udata/鸟币号/pic/鸟币号_defaut-avatar.png
		pic := config.Public.Pic
		meta := db.NewSquarePNGMeta(user.Name+pic.AvatarSuffix+pic.PicNameSuffixDefault, pic.AvatarSizeDefault)
		dir := db.GetUserPicDir(user.Name, meta)

		avatar := adorable.PseudoRandom([]byte(user.Name))
		err := ioutil.WriteFile(dir, avatar, 0600)
		if err != nil {
			return
		}

		//生成400x400的默认头像缩略图：./files/udata/鸟币号/pic/鸟币号_defaut-avatar.jpg。并且删除png原图。
		buffer, _ := bimg.Read(dir)
		err = db.ResizeUserPic(user.Name, buffer, user.Avatar.Biggest)
		if err != nil {
			return
		}
		os.Remove(dir)
	}(user)
}

//获取加密后的秘密码
func getSafePWD(pwd string) (string, error) {
	//密码加密
	safePwd, err := scrypt.Key([]byte(pwd), []byte(config.PWDSalt), 32768, 8, 1, 32)
	if err != nil {
		return "", err
	}
	strSafePwd := hex.EncodeToString(safePwd)
	util.LogDebug("encrypted password : " + strSafePwd)
	return strSafePwd, nil
}

//GetPQ 获取PQ
func GetPQ(ctx iris.Context) *xorm.Engine {
	return ctx.Values().Get(config.PQIrisIDKey).(*xorm.Engine)
}

//GetRMBExr 获取RMBExr
func GetRMBExr(ctx iris.Context) float64 {
	return ctx.Values().Get(config.RMBExrIrisKey).(float64)
}

//GetTxLocks 获取交易锁
func GetTxLocks(ctx iris.Context) *db.TransLocks {
	return ctx.Values().Get(config.TxLocksIrisKey).(*db.TransLocks)
}

//GetJwtUser 获取JwtUser
func GetJwtUser(ctx iris.Context) jwt.MapClaims {
	return ctx.Values().Get(config.JWTIrisIDKey).(*jwt.Token).Claims.(jwt.MapClaims)
}

//GetNewJwtToken 生成新的jwttoken
func GetNewJwtToken(coin *db.Coin) (string, int64) {
	unixExp := time.Now().Add(config.JWTExp * time.Hour * time.Duration(1)).Unix()
	token := jwt.NewTokenWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		config.JwtCIDKey:  coin.ID,
		config.JwtNameKey: coin.Name,
		"iss":             config.Public.Server.Host, //签发人
		"iat":             time.Now().Unix(),         //签发时间,必须为unix时间戳
		"exp":             unixExp,                   //过期时间,必须为unix时间戳
	})
	strToken, _ := token.SignedString([]byte(config.JWTSecret))
	return strToken, unixExp
}
