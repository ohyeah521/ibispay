package model

//NewSkillForm 新建技能
type NewSkillForm struct {
	Title string   `form:"title" validate:"required,lte=100" format:"title,trim"`     //技能名称，不可修改，同一用户下不能输入重复标题，不超过100个字符，必填
	Price uint64   `form:"price" validate:"required,numeric,gte=1" format:"num,trim"` //技能价格（鸟币数/单位），大于0的整数，必填
	Desc  string   `form:"desc,omitempty" validate:"lte=10000" format:"ucfirst,trim"` //技能描述，少于10000个字符
	Tags  []string `form:"tags,omitempty" validate:"unique,dive,required"`            //类型如：技能、实物、服务、数字商品等，或者其他自定义标签
}

//===========err trans=============

//NewSkillFieldTrans 字段本地化，供validator使用
func (form NewSkillForm) NewSkillFieldTrans() FieldTrans {
	m := FieldTrans{}
	m["Title"] = "技能名称"
	m["Price"] = "价格"
	m["Desc"] = "描述"
	m["Tags"] = "标签"
	return m
}
