package db

import (
	"time"
)

//Info 动态信息，对应info表
type Info struct {
	Owner   string    `json:"owner" xorm:"not null pk VARCHAR(20)"` //鸟币号
	Updated time.Time `json:"updated" xorm:"updated"`

	HasNews bool   `json:"-" xorm:"not null default false BOOL"`      //是否有新动态，为true时，计算并返回NewsNum
	ReadNum uint32 `json:"readNum" xorm:"not null default 0 INTEGER"` //已读消息数量
	NewsNum uint32 `json:"newsNum" xorm:"-"`                          //新消息数量=消息总数-ReadNum

	HasReq  bool   `json:"-" xorm:"not null default false BOOL"`      //是否有新的鸟币回收请求。为true时，计算并返回TodoNum
	DoneNum uint32 `json:"doneNum" xorm:"not null default 0 INTEGER"` //已完成鸟币回收的次数
	TodoNum uint32 `json:"todoNum" xorm:"-"`                          //待完成兑现的交易数量=总回收请求数-DoneNum

	RmbExr float64 `json:"rmbExr" xorm:"-"` //当前汇率(1鸟币合人民币多少)
}
