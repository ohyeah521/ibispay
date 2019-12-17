package model

import (
	"strings"

	ut "github.com/go-playground/universal-translator"
	"github.com/kataras/iris"
	validator "gopkg.in/go-playground/validator.v9"
)

//FieldTrans 本地化后的字段，供validator使用
type FieldTrans map[string]string

//ErrorDetail 错误详情
type ErrorDetail map[string]interface{}

//ValidatorErrorCombine validator的错误返回格式
type ValidatorErrorCombine struct {
	Detail ErrorDetail
	Err    error
}

//CommonError api统一的错误返回格式
type CommonError struct {
	Ok     bool        `json:"ok"`
	Msg    string      `json:"msg"`
	Code   int         `json:"code"`
	Errors ErrorDetail `json:"errors,omitempty"`
}

//NewValidatorErrorDetail 本地化后的validator的error detail
func NewValidatorErrorDetail(trans ut.Translator, err error, fieldTrans FieldTrans) ValidatorErrorCombine {
	errReturn := ValidatorErrorCombine{}
	if err == nil {
		return errReturn
	}
	res := ErrorDetail{}
	errs := err.(validator.ValidationErrors)
	for _, e := range errs {
		transtr := e.Translate(trans)
		//将结构体字段转换map中的key为小写
		f := strings.ToLower(e.Field())

		//判断错误字段是否在命名中，如果在，则替换错误信息中的字段
		if rp, ok := fieldTrans[e.Field()]; ok {
			res[f] = strings.Replace(transtr, e.Field(), rp, 1)
		} else {
			res[f] = transtr
		}
	}
	//返回错误信息
	errReturn.Err = err
	errReturn.Detail = res
	return errReturn
}

//CheckError iris 通用错误处理以及返回
func (ce *CommonError) CheckError(ctx iris.Context, err error, code int, msg string, detail ErrorDetail) {
	if ce != nil && err != nil {
		ce.Ok = false
		ce.Msg = msg
		ce.Code = code
		if detail != nil {
			ce.Errors = detail
		}
		ctx.JSON(ce) //错误统一为200、ok=false。参见api.md
		panic(ce)
	}
}

//ReturnError iris 通用错误返回
func (ce *CommonError) ReturnError(ctx iris.Context, code int, msg string) {
	if ce != nil {
		ce.Ok = false
		ce.Msg = msg
		ce.Code = code
		ctx.JSON(ce) //错误统一为200、ok=false。参见api.md
		panic(ce)
	}
}

//FinalError iris 通用错误最终返回，无panic
func (ce *CommonError) FinalError(ctx iris.Context, code int, msg string) {
	if ce != nil {
		ce.Ok = false
		ce.Msg = msg
		ce.Code = code
		ctx.JSON(ce) //错误统一为200、ok=false。参见api.md
	}
}
