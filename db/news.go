package db

import "time"

//News 用户消息，对应news表
type News struct {
	ID      uint64    `json:"newsID" xorm:"pk BIGINT autoincr 'id'"`
	Owner   string    `json:"owner" xorm:"not null index VARCHAR(20)"` //接受消息的鸟币号
	Desc    string    `json:"desc" xorm:"not null TEXT"`               //主要内容
	Created time.Time `json:"created" xorm:"not null created"`

	Amount   int64  `json:"amount,omitempty" xorm:"index BIGINT"`         //交易金额
	Buddy    string `json:"buddy,omitempty" xorm:"index VARCHAR(20)"`     //交易对象的鸟币号
	Table    string `json:"table,omitempty" xorm:"index VARCHAR(20)"`     //相关数据库表名
	SourceID uint64 `json:"sourceID,omitempty" xorm:"BIGINT 'source_id'"` //相关记录ID
}
