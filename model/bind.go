package model

import (
	zhongwen "github.com/go-playground/locales/zh"
	ut "github.com/go-playground/universal-translator"
	"github.com/kataras/iris"
	"github.com/kataras/iris/hero"
	validator "gopkg.in/go-playground/validator.v9"
	zh_translations "gopkg.in/go-playground/validator.v9/translations/zh"
	"reqing.org/ibispay/config"
	"reqing.org/ibispay/util"
)

var (
	validate *validator.Validate
	trans    ut.Translator
)

//BindForm 绑定model到对应controller的handler
//例如：login()绑定loginform到对应的loginHandler
func BindForm() {
	//实例化需要转换的语言
	zh := zhongwen.New()
	uni := ut.New(zh, zh)
	trans, _ = uni.GetTranslator("zh")
	validate = validator.New()
	//注册转换的语言为默认语言
	zh_translations.RegisterDefaultTranslations(validate, trans)

	//=====bind & check=====
	//user
	register()
	login()
	newPwd()
	newProfie()
	//skill
	newSkill()
	updateSkill()
	//trans
	newPay()
	newReq()
	newRepay()
}

func register() {
	hero.Register(func(ctx iris.Context) (form RegisterForm) {
		handleJSON(ctx, &form, form.RegisterFieldTrans())
		return
	})
}

func login() {
	hero.Register(func(ctx iris.Context) (form LoginForm) {
		handleJSON(ctx, &form, form.LoginFieldTrans())
		return
	})
}

func newPwd() {
	hero.Register(func(ctx iris.Context) (form NewPwdForm) {
		handleJSON(ctx, &form, form.NewPwdFieldTrans())
		return
	})
}

func newProfie() {
	hero.Register(func(ctx iris.Context) (form ProfileForm) {
		handleJSON(ctx, &form, form.ProfileFieldTrans())
		return
	})
}

func newSkill() {
	hero.Register(func(ctx iris.Context) (form NewSkillForm) {
		handleForm(ctx, &form, form.NewSkillFieldTrans())
		return
	})
}

func updateSkill() {
	hero.Register(func(ctx iris.Context) (form UpdateSkillForm) {
		handleJSON(ctx, &form, form.UpdateSkillFieldTrans())
		return
	})
}

func newPay() {
	hero.Register(func(ctx iris.Context) (form NewPayForm) {
		handleJSON(ctx, &form, form.NewPayFieldTrans())
		return
	})
}

func newReq() {
	hero.Register(func(ctx iris.Context) (form NewReqForm) {
		handleJSON(ctx, &form, form.NewReqFieldTrans())
		return
	})
}

func newRepay() {
	hero.Register(func(ctx iris.Context) (form NewRepayForm) {
		handleJSON(ctx, &form, form.NewRepayFieldTrans())
		return
	})
}

//=========common func==========

func handleJSON(ctx iris.Context, form interface{}, fieldTrans FieldTrans) {
	e := new(CommonError)
	// ---bind form---
	err := ctx.ReadJSON(form)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1000, nil)

	//---check struct---
	err = validate.Struct(form)
	errComine := NewValidatorErrorDetail(trans, err, fieldTrans)
	e.CheckError(ctx, errComine.Err, iris.StatusNotAcceptable, config.Public.Err.E1001, errComine.Detail)

	//------format------
	err = util.Strings(form)
	e.CheckError(ctx, err, iris.StatusNotAcceptable, config.Public.Err.E1002, nil)
}

func handleForm(ctx iris.Context, form interface{}, fieldTrans FieldTrans) {
	e := new(CommonError)
	// ---bind form---
	err := ctx.ReadForm(form)
	e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1000, nil)

	//---check struct---
	err = validate.Struct(form)
	errComine := NewValidatorErrorDetail(trans, err, fieldTrans)
	e.CheckError(ctx, errComine.Err, iris.StatusNotAcceptable, config.Public.Err.E1001, errComine.Detail)

	//------format------
	err = util.Strings(form)
	e.CheckError(ctx, err, iris.StatusNotAcceptable, config.Public.Err.E1002, nil)
}
