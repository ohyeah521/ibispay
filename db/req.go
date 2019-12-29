package db

import (
	"time"
)

//Req 兑现请求(request)，对应req表，2小时内只能向同一用户请求一次（未接受的情况下）。此表不可删除
/**
兑现状态 state：
10.	请求方提示：已发送兑现请求，等待对方确认（2小时内未接受将影响其鸟币信用）
   	执行方提示：收到新的兑现请求（请在2小时内确认，否则将影响鸟币信用）
	请求方提示—血盟：已发送血盟兑现请求，等待对方确认（2小时内未接受，将影响其血盟失败次数）
	执行方提示—血盟：收到新的血盟兑现请求（请在2小时内确认，否则将影响血盟失败次数）
20.	请求方提示：鸟币已被成功回收（成功回收后，请求方显示3种状态："已兑现"、"兑现中(默认选中)"、"未兑现"按钮）
   	执行方提示：鸟币已回收，尚未完成兑现
21.	请求方提示：对方拒绝了兑现请求，鸟币信用受到影响
	执行方提示：已拒绝了对方的请求，鸟币信用受到影响
22. 请求方提示：兑现请求超时未接受，对方鸟币信用受到影响
	执行方提示：由于超时，系统自动拒绝了对方的请求，鸟币信用受到影响
23.	请求方提示：对方未兑现技能，已直接影响其鸟币信用(状态显示选中"未兑现")
   	执行方提示：未兑现已影响鸟币信用，"重新兑现"即可立即恢复鸟币信用(点击"重新兑现"按钮后状态改为20"兑现中")，"关闭交易"则执行方不可进行任何操作
31.	请求方提示：交易完成
	执行方提示：交易完成
32.	请求方提示：交易已关闭
	执行方提示：交易已关闭
33.	请求方提示：由于鸟币不足等原因，交易自动关闭
	执行方提示：由于对方鸟币不足等原因，交易自动关闭
*/
type Req struct {
	ID       uint64    `json:"reqID" xorm:"pk BIGINT autoincr 'id'"`
	SnapID   uint64    `json:"snapID" xorm:"not null BIGINT 'snap_id'"`                                                                                              //具体要兑现的技能ID
	Bearer   string    `json:"bearer" xorm:"not null index index(req_bearer_issuer_idx) index(req_bearer_issuer_state_idx) index(req_bearer_state_idx) VARCHAR(20)"` //持有者的鸟币号
	Issuer   string    `json:"issuer" xorm:"not null index(req_bearer_issuer_idx) index(req_bearer_issuer_state_idx) index index(req_issuer_state_idx) VARCHAR(20)"` //发行者的鸟币号
	IsMarker bool      `json:"isMarker" xorm:"not null BOOL"`                                                                                                        //是否是血盟，是则忽略snap_id
	Amount   uint64    `json:"amount" xorm:"not null BIGINT"`                                                                                                        //兑现的鸟币数量，大于0的整数
	State    uint8     `json:"state" xorm:"not null default 1 index(req_bearer_issuer_state_idx) index(req_bearer_state_idx) index(req_issuer_state_idx) SMALLINT"`  //兑现状态（兑现时需要发行者确认，默认2小时响应，超时自动视为拒绝)
	Closed   bool      `json:"closed" xorm:"not null default false BOOL"`                                                                                            //是否已关闭交易
	Created  time.Time `json:"created" xorm:"not null created"`
	Updated  time.Time `json:"updated" xorm:"updated"`
}
