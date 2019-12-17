package db

import (
	"time"
)

//Pay 支付的鸟币记录，对应pay表。此表只可新建，不可删改。
//注意：支付表=鸟币发行记录+鸟币转手记录，兑现表=鸟币兑现记录。所有交易=发行+转手+兑现。
//marker血盟，歃血为盟之意，也称作超级鸟币，承诺为持有者(bearer)做任何一件事。
type Pay struct {
	ID        uint64    `json:"payID" xorm:"pk BIGINT autoincr 'id'"`
	Amount    uint64    `json:"amount" xorm:"not null BIGINT"`                                                                                  //转账数额，大于0的整数
	TransCoin string    `json:"transCoin" xorm:"not null index(pay_payer_trans_coin_idx) index(pay_receiver_trans_coin_idx) index VARCHAR(20)"` //交易的鸟币名
	Receiver  string    `json:"receiver" xorm:"not null index index(pay_receiver_payer_idx) index(pay_receiver_trans_coin_idx) VARCHAR(20)"`    //收款方鸟币号
	Payer     string    `json:"payer" xorm:"not null index index(pay_payer_trans_coin_idx) index(pay_receiver_payer_idx) VARCHAR(20)"`          //付款方鸟币号
	SnapSetID uint64    `json:"snapSetID" xorm:"index BIGINT 'snap_set_id'"`                                                                    //技能快照组id
	IsIssue   bool      `json:"isIssue" xorm:"not null BOOL"`                                                                                   //标记是发行还是转手
	IsMarker  bool      `json:"isMarker" xorm:"not null BOOL"`                                                                                  //是否是血盟，血盟为true时，忽略技能快照组snap_set_id
	GUID      string    `json:"guid" xorm:"index VARCHAR(36) 'guid'"`                                                                           //转手时可能用到多个版本的鸟币，每个版本都需要新建一个pay，但这些pay都共享同一个guid
	Created   time.Time `json:"created" xorm:"not null created"`                                                                                //交易时间
}
