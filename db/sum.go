package db

import (
	"time"
)

//Sum 鸟币持有量，对应sum表。此表不可删除
type Sum struct {
	ID       int64     `json:"sumID" xorm:"pk BIGINT autoincr 'id'"`
	Bearer   string    `json:"bearer" xorm:"not null index unique(sum_bearer_coin_is_marker_idx) VARCHAR(20)"` //持有者的鸟币号
	Coin     string    `json:"coin" xorm:"not null index unique(sum_bearer_coin_is_marker_idx) VARCHAR(20)"`   //持有的鸟币名称
	IsMarker bool      `json:"isMarker" xorm:"not null index unique(sum_bearer_coin_is_marker_idx) BOOL"`      //是否为血盟
	Sum      int64     `json:"sum" xorm:"not null default 0 index BIGINT"`                                     //持有量，收入者sum+正数，支出者sum+负数
	Updated  time.Time `json:"updated" xorm:"not null updated"`
}

//SubSum 不同版本的鸟币持有量(注意版本是以snap_set_id来划分的)，对应sub_sum表。此表不可删除
type SubSum struct {
	ID        uint64    `json:"sumID" xorm:"pk BIGINT autoincr 'id'"`
	Bearer    string    `json:"bearer" xorm:"not null index unique(sub_sum_bearer_coin_snap_set_id_idx) VARCHAR(20)"`             //持有者的鸟币号
	Coin      string    `json:"coin" xorm:"not null index unique(sub_sum_bearer_coin_snap_set_id_idx) VARCHAR(20)"`               //持有的鸟币名称
	SnapSetID uint64    `json:"snapSetID" xorm:"not null index unique(sub_sum_bearer_coin_snap_set_id_idx) BIGINT 'snap_set_id'"` //技能版本ID
	SnapIDs   []uint64  `json:"snapIDs" xorm:"not null index JSONB 'snap_ids'"`                                                   //SnapSetID下的技能快照snap_id的集合，倒序排列(snap_id为自增id) //冗余字段，方便查询，gin索引
	Sum       int64     `json:"sum" xorm:"not null default 0 index BIGINT"`                                                       //收入者sum+正数，支出者sum+负数
	Updated   time.Time `json:"updated" xorm:"not null updated"`
}
