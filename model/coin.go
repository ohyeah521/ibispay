package model

import (
	"time"

	"reqing.org/ibispay/db"
)

//UpdateRes 成功更新响应
type UpdateRes struct {
	Ok bool `json:"ok"`
}

//LoginForm 登录请求
type LoginForm struct {
	PhoneCC string `json:"phoneCC" validate:"required,lte=3" format:"trim"` //国家地区代码 Country Code
	Phone   string `json:"phone" validate:"required,lte=20" format:"trim"`  //绑定手机号，不可重复，可修改，主要用于登录和找回密码。统一格式为为E164，eg.+8618612345678
	Pwd     string `json:"pwd" validate:"required,lte=128" format:"trim"`   //密码
}

//LoginRes 登录响应
type LoginRes struct {
	Token  string `json:"token"`  //jwt token
	Expire int64  `json:"expire"` //jwt过期时间，unix格式
}

//RegisterForm 注册请求
type RegisterForm struct {
	PhoneCC string `json:"phoneCC" validate:"required,lte=3" format:"trim"`    //国家地区代码 Country Code
	Phone   string `json:"phone" validate:"required,lte=20" format:"trim"`     //绑定手机号，不可重复，可修改，主要用于登录和找回密码。统一格式为为E164，eg.+8618612345678
	Name    string `json:"name" validate:"required,lte=20" format:"name,slug"` //鸟币号，不可重复、不可修改、少于20个字符，可用于登录。统一格式化为去除首尾空格的、以字母开头的、仅包含字母(Unicode)数字短横线的全小写格式，中间空格以短横线替换。
	Pwd     string `json:"pwd" validate:"required,lte=128" format:"trim"`      //密码
}

//NewPwdForm 修改密码
type NewPwdForm struct {
	OldPwd string `json:"oldPwd" validate:"required,lte=128" format:"trim"`             //老密码
	Pwd    string `json:"pwd" validate:"required,lte=128,nefield=OldPwd" format:"trim"` //新密码，与老密码不相同
}

//ProfileForm 修改鸟币资料，可选填，空数据不更新到数据库
type ProfileForm struct {
	Bio   string `json:"bio,omitempty" validate:"lte=5000" format:"trim"` //技能简介，少于5000字
	Email string `json:"email,omitempty" validate:"email" format:"email"` //邮箱
}

//ProfileRes 返回别人的鸟币资料，剔除隐私信息！
type ProfileRes struct {
	ID uint64 `json:"coinID"` //鸟币ID

	Name     string `json:"name"`     //鸟币号，不可重复、不可修改、少于20个字符，可用于登录。统一格式化为去除首尾空格的、以字母开头的、仅包含字母(Unicode)数字短横线的全小写格式，中间空格以短横线替换。
	SkillNum uint32 `json:"skillNum"` //当前可用的技能数
	BreakNum uint32 `json:"breakNum"` //拒绝兑现的次数
	Credit   uint16 `json:"credit"`   //目前的鸟币信用，默认为0，范围0-1000

	Bio    string `json:"bio,omitempty"`    //技能简介，少于5000字
	Avatar db.Pic `json:"avatar,omitempty"` //头像，大小参考config
	Qrc    db.Pic `json:"qrc,omitempty"`    //收款二维码（根据鸟币号生成），大小参考config

	Created time.Time `json:"created"`
}

//===========err trans=============

//LoginFieldTrans 字段本地化，供validator使用
func (form LoginForm) LoginFieldTrans() FieldTrans {
	m := FieldTrans{}
	m["PhoneCC"] = "国家地区代码"
	m["Phone"] = "手机号"
	m["Pwd"] = "密码"
	return m
}

//RegisterFieldTrans 字段本地化，供validator使用
func (form RegisterForm) RegisterFieldTrans() FieldTrans {
	m := FieldTrans{}
	m["PhoneCC"] = "国家地区代码"
	m["Phone"] = "手机号"
	m["Name"] = "鸟币号"
	m["Pwd"] = "密码"
	return m
}

//NewPwdFieldTrans 字段本地化，供validator使用
func (form NewPwdForm) NewPwdFieldTrans() FieldTrans {
	m := FieldTrans{}
	m["OldPwd"] = "老密码"
	m["Pwd"] = "新密码"
	return m
}

//ProfileFieldTrans 字段本地化，供validator使用
func (form ProfileForm) ProfileFieldTrans() FieldTrans {
	m := FieldTrans{}
	m["Bio"] = "个人资料"
	m["Email"] = "电子邮箱"
	return m
}
