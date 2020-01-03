package model

//NewPayForm 发行或转手
type NewPayForm struct {
	TransCoin string `json:"transCoin" validate:"required,lte=20" format:"trim"`         //交易的鸟币名
	Receiver  string `json:"receiver" validate:"required,lte=20" format:"trim"`          //收款方鸟币号
	Amount    uint64 `json:"amount" validate:"required,numeric,gte=1" format:"num,trim"` //转账数额，大于0的整数
	IsMarker  bool   `json:"isMarker"`                                                   //是否是血盟，血盟为true时，忽略技能快照组snap_set_id
}

//NewReqForm 兑现请求
type NewReqForm struct {
	Issuer   string `json:"issuer" validate:"required,lte=20" format:"trim"`            //发币者鸟币号(鸟币号即要兑现的鸟币)
	Amount   uint64 `json:"amount" validate:"required,numeric,gte=1" format:"num,trim"` //转账数额，大于0的整数
	SnapID   uint64 `json:"snapID" validate:"numeric" format:"num,trim"`                //实际兑现的技能ID
	IsMarker bool   `json:"isMarker"`                                                   //是否是血盟，血盟为true时，忽略技能快照snap_id
}

//NewRepayForm 兑现
type NewRepayForm struct {
	ReqID    uint64 `json:"reqID" validate:"required,numeric" format:"num,trim"`        //兑现请求ID
	Bearer   string `json:"bearer" validate:"required,lte=20" format:"trim"`            //发币者鸟币号(鸟币号即要兑现的鸟币)
	Amount   uint64 `json:"amount" validate:"required,numeric,gte=1" format:"num,trim"` //转账数额，大于0的整数
	SnapID   uint64 `json:"snapID" validate:"numeric" format:"num,trim"`                //实际兑现的技能ID
	IsMarker bool   `json:"isMarker"`                                                   //是否是血盟，血盟为true时，忽略技能快照snap_id
}

//===========err trans=============

//NewPayFieldTrans 字段本地化，供validator使用
func (form NewPayForm) NewPayFieldTrans() FieldTrans {
	m := FieldTrans{}
	m["TransCoin"] = "交易的鸟币名"
	m["Receiver"] = "收款方鸟币号"
	m["IsMarker"] = "血盟标记"
	m["Amount"] = "转账数额"
	return m
}

//NewReqFieldTrans 字段本地化，供validator使用
func (form NewReqForm) NewReqFieldTrans() FieldTrans {
	m := FieldTrans{}
	m["Issuer"] = "鸟币名"
	m["SnapID"] = "技能快照"
	m["IsMarker"] = "血盟标记"
	m["Amount"] = "兑现数额"
	return m
}

//NewRepayFieldTrans 字段本地化，供validator使用
func (form NewRepayForm) NewRepayFieldTrans() FieldTrans {
	m := FieldTrans{}
	m["ReqID"] = "兑现请求ID"
	m["Bearer"] = "持有者的鸟币号"
	m["SnapID"] = "技能快照"
	m["IsMarker"] = "血盟标记"
	m["Amount"] = "兑现数额"
	return m
}
