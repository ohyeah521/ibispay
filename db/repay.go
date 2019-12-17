package db

import (
	"time"
)

//Repay 兑现的鸟币记录，对应repay表。此表只可新建，不可删改。
//注意：支付表=鸟币发行记录+鸟币转手记录，兑现表=鸟币兑现记录。所有交易=发行+转手+兑现。
//marker血盟，歃血为盟之意，也称作超级鸟币，承诺为持有者(bearer)做任何一件事。
//注意，兑现的技能，只能是技能的最新版本或发币时所用的版本
type Repay struct {
	ID       uint64    `json:"fulfilID" xorm:"pk BIGINT autoincr 'id'"`
	ReqID    uint64    `json:"reqID" xorm:"not null index BIGINT 'req_id'"`                             //兑现请求ID
	SnapID   uint64    `json:"snapID" xorm:"index BIGINT 'snap_id'"`                                    //实际兑现的技能快照ID
	Bearer   string    `json:"bearer" xorm:"not null index index(repay_bearer_issuer_idx) VARCHAR(20)"` //持币者的鸟币号
	Issuer   string    `json:"issuer" xorm:"not null index index(repay_bearer_issuer_idx) VARCHAR(20)"` //发币者的鸟币号
	IsMarker bool      `json:"isMarker" xorm:"not null BOOL"`                                           //是否是血盟，是则忽略技能ID
	Amount   uint64    `json:"amount" xorm:"not null BIGINT"`                                           //兑现的鸟币数量，大于0的整数
	Created  time.Time `json:"created" xorm:"not null created"`                                         //交易时间
}
