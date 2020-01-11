package main //niaobi.org by 鸟神

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/beanstalkd/go-beanstalk"
	"github.com/go-xorm/xorm"
	"github.com/gogf/gf/os/gtimer"
	"github.com/iris-contrib/middleware/jwt"
	"github.com/kataras/iris"
	"github.com/kataras/iris/hero"
	"github.com/kataras/iris/middleware/recover"
	_ "github.com/lib/pq"
	"github.com/robfig/cron"

	"reqing.org/ibispay/config"
	"reqing.org/ibispay/controller"
	"reqing.org/ibispay/db"
	"reqing.org/ibispay/model"
	"reqing.org/ibispay/util"
)

var (
	pq      *xorm.Engine
	rmbExr  float64
	txLocks *db.TransLocks
)

type rmbExrRes struct {
	RmbExr float64 `json:"rmbExr"` //jwt token
}

func main() {
	//-----初始化配置-----
	config.Load()
	rmbExr = config.Public.Exr.RmbExr
	//init locks
	txLocks = new(db.TransLocks)
	txLocks.Locks = make(map[string]bool)

	//-----同步数据库字段-----
	pq, _ = xorm.NewEngine("postgres", config.PQInfo)
	db.SyncDB(pq)

	//-----绑定model-----
	model.BindForm()

	//-----中间件-----
	jwtHandler := jwt.New(jwt.Config{
		ContextKey:    config.JWTIrisIDKey,
		SigningMethod: jwt.SigningMethodHS256,
		ValidationKeyGetter: func(token *jwt.Token) (interface{}, error) {
			return []byte(config.JWTSecret), nil
		},
		Expiration: true,
	})

	//-----定时任务-----
	startTimer()
	jobReqCheck()

	//-----路由-----
	app := iris.New()
	app.Use(recover.New())
	app.Use(dbHandler)

	//自定义路由规则
	app.Macros().Get("string").RegisterFunc("range", func(minLength, maxLength int) func(string) bool {
		return func(paramValue string) bool {
			return len(paramValue) >= minLength && len(paramValue) <= maxLength
		}
	})

	//人民币兑换鸟币汇率（1人民币=多少鸟币），仅供定价时参考，不可直接使用"RmbExr*人民币兑其他某个法币货币的汇率"来计算"其他某个法币货币兑鸟币的汇率"
	//在系统中正确的计算其他货币兑鸟币的汇率的方法：如港币，应该是港币当前的M2与鸟币创世时的港币M2的比值
	//注意，备用方案config.Public.Exr.RmbExr是管理员手动维护的数据，见config.toml
	app.Get("/exr/rmb", func(ctx iris.Context) {
		res := rmbExrRes{RmbExr: rmbExr}
		ctx.JSON(&res)
	})

	app.Post("/register", hero.Handler(controller.Register)) //注册
	app.Post("/login", hero.Handler(controller.Login))       //登录
	coin := app.Party("coin")
	{
		coin.Use(jwtHandler.Serve)
		{
			coin.Put("/updateProfile", hero.Handler(controller.UpdateProfile))             //修改个人资料
			coin.Put("/updatePwd", hero.Handler(controller.UpdatePwd))                     //修改密码
			coin.Put("/updateAvatar", picSizeHandler, controller.UpdateAvatar)             //修改头像
			coin.Get("/profile/{name:string range(1,20) else 400}", controller.GetProfile) //获取某用户资料
			coin.Get("/info", exrHandler, controller.GetMyActivity)                        //获取自己的动态
			//todo 找回密码
			//todo dashboard控制台，展示交易和鸟币等信息
		}
	}

	img := app.Party("img")
	{
		img.Use(jwtHandler.Serve)
		{
			img.Get("/exist/{hash:string range(64,64) else 400}", controller.CheckPicHash) //检查图片是否存在
			img.Post("/new", picSizeHandler, controller.NewPic)                            //上传图片
		}
	}

	skill := app.Party("skill")
	{
		skill.Use(jwtHandler.Serve)
		{
			skill.Post("/new", picsSizeHandler, transHandler, hero.Handler(controller.NewSkill)) //添加技能
			skill.Put("/update", transHandler, hero.Handler(controller.UpdateSkill))             //更新技能
			//todo 下架技能(transHandler)
			//todo 搜索技能，添加索引
		}
	}

	trans := app.Party("tx")
	{
		trans.Use(jwtHandler.Serve)
		{
			trans.Post("/pay", transHandler, hero.Handler(controller.NewPay))     //支付
			trans.Post("/req", hero.Handler(controller.NewReq))                   //发送兑现请求
			trans.Post("/repay", transHandler, hero.Handler(controller.NewRepay)) //兑现
		}
	}

	//认证失败
	app.OnErrorCode(iris.StatusUnauthorized, func(ctx iris.Context) {
		var e = new(model.CommonError)
		e.FinalError(ctx, iris.StatusUnauthorized, config.Public.Err.E1010)
	})
	//路由错误
	app.OnErrorCode(iris.StatusNotFound, func(ctx iris.Context) {
		var e = new(model.CommonError)
		e.FinalError(ctx, iris.StatusNotFound, config.Public.Err.E1011)
	})
	//上传文件过大
	app.OnErrorCode(iris.StatusRequestEntityTooLarge, func(ctx iris.Context) {
		var e = new(model.CommonError)
		e.FinalError(ctx, iris.StatusRequestEntityTooLarge, config.Public.Err.E1014)
	})
	app.Run(iris.Addr("localhost:3001"))
}

//-----中间件-----
func dbHandler(ctx iris.Context) {
	ctx.Values().Set(config.PQIrisIDKey, pq)
	ctx.Next()
}

//检查头像大小
func exrHandler(ctx iris.Context) {
	ctx.Values().Set(config.RMBExrIrisKey, rmbExr)
	ctx.Next()
}

//交易锁
func transHandler(ctx iris.Context) {
	ctx.Values().Set(config.TxLocksIrisKey, txLocks)
	ctx.Next()
}

//检查单张图片大小
func picSizeHandler(ctx iris.Context) {
	if ctx.GetContentLength() > config.Public.Pic.MaxUploadPic {
		ctx.StatusCode(iris.StatusRequestEntityTooLarge)
		return
	}
	ctx.Next()
}

//检查多图上传的大小
func picsSizeHandler(ctx iris.Context) {
	if ctx.GetContentLength() > config.Public.Pic.MaxUploadPics {
		ctx.StatusCode(iris.StatusRequestEntityTooLarge)
		return
	}
	ctx.Next()
}

//-----定时任务-----
func startTimer() {
	c := cron.New()

	//启动的时候执行一次，以后每隔5小时执行一次
	job1 := jobRMBExr{}
	job1.Run()
	c.AddJob("@every 5h", job1)
	// job2 := jobReqCheck{}
	// job2.Run()
	// c.AddJob("@every 5s", job2)

	c.Start()
}

type jobRMBExr struct {
}

func (jobRMBExr) Run() {
	fmt.Println("[timer]Running RmbExrJob...")

	//注意：不同国家需要使用各自国家的M2
	//每隔一段时间，自动更新人民币m2，数据来自新浪财经
	resp, err := http.Get("http://money.finance.sina.com.cn/mac/api/jsonp.php/SINAREMOTECALLCALLBACK/MacPage_Service.get_pagedata?cate=fininfo&event=1&from=0&num=1&condition")

	//http响应失败时，resp变量将为 nil，而 err变量将是 non-nil。
	//当得到一个重定向的错误时，两个变量都将是 non-nil。这意味着最后依然会内存泄露。
	//防止内存泄漏的正确写法:
	if resp != nil {
		defer resp.Body.Close()
	}
	if err != nil {
		rmbExr = config.Public.Exr.RmbExr
		return
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		rmbExr = config.Public.Exr.RmbExr
		return
	}

	//格式整理
	str := string(body)
	newstr := str[strings.LastIndex(str, "data:"):]
	newstr = util.SubString(newstr, 6, len(newstr)-10)
	util.LogDebug(newstr)
	var arr []string
	json.Unmarshal([]byte(newstr), &arr)
	if err != nil {
		rmbExr = config.Public.Exr.RmbExr
		return
	}
	m2Now, err := strconv.ParseFloat(arr[1], 64)
	if err != nil {
		rmbExr = config.Public.Exr.RmbExr
		return
	}
	rmbExr = m2Now / config.Public.Exr.RmbM2Init
	if rmbExr < config.Public.Exr.RmbExr {
		rmbExr = config.Public.Exr.RmbExr
	}
}

//超时未接受的兑现请求处理
func jobReqCheck() {
	//每隔10毫秒循环一次，一分钟可以查询6000条数据，记录读取超时时间为200毫秒
	interval := 10 * time.Millisecond
	timeOut := 200 * time.Millisecond
	gtimer.Add(interval, func() {
		conn, _ := beanstalk.Dial("tcp", config.BeanstalkURI)
		tubeSet := beanstalk.NewTubeSet(conn, config.BeanstalkTubeReq)
		jobID, body, err := tubeSet.Reserve(timeOut)
		if err != nil {
			defer conn.Close()
			return
		}

		req := db.Req{}
		err = json.Unmarshal(body, &req)
		if err != nil {
			conn.Delete(jobID)
			defer conn.Close()
			return
		}

		reqNow := db.Req{}
		pq.ID(req.ID).Cols("state").Get(&reqNow)
		if reqNow.State != 10 {
			conn.Delete(jobID)
			defer conn.Close()
			return
		}

		//数据库
		news1 := db.News{Owner: req.Bearer, Desc: config.Public.Req.ReqBearer22, Amount: int64(req.Amount), Buddy: req.Issuer, Table: config.NewsTableReq, SourceID: req.ID}
		news2 := db.News{Owner: req.Issuer, Desc: config.Public.Req.ReqIssuer22, Amount: int64(req.Amount), Buddy: req.Bearer, Table: config.NewsTableReq, SourceID: req.ID}
		pq.Insert(&news1, &news2)
		pq.ID(req.ID).Update(&db.Req{State: 22})

		conn.Delete(jobID)
		defer conn.Close()
	})
}
