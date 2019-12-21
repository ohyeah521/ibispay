package db

import (
	"time"
)

//Snap 技能快照，对应snap表。此表只可新建，不可删改。
type Snap struct {
	ID      uint64    `json:"snapID" xorm:"pk BIGINT autoincr 'id'"`
	Created time.Time `json:"created" xorm:"not null created"`

	Owner   string   `json:"owner" xorm:"not null index VARCHAR(20)"`         //鸟币号，必填
	Title   string   `json:"title" xorm:"not null index VARCHAR(100)"`        //技能名称，不可修改，同一用户下不能输入重复标题，不超过100个字符，必填
	Price   uint64   `json:"price" xorm:"not null index default 1 BIGINT"`    //技能价格（鸟币数/单位），大于0的整数，必填
	Desc    string   `json:"desc,omitempty" xorm:"index VARCHAR(10000)"`      //技能描述，少于10000个字符
	Pics    []*Pic   `json:"pics,omitempty" xorm:"index JSONB"`               //技能图片大小参考config
	Tags    []string `json:"tags,omitempty" xorm:"index JSONB"`               //类型如：技能、实物、服务、数字商品等，或者其他自定义标签
	SkillID uint64   `json:"skillID" xorm:"not null index BIGINT 'skill_id'"` //不同备份版本的技能的共同ID
	Version uint64   `json:"version" xorm:"not null default 1 BIGINT"`        //同技能表的version
}

//SnapSet 技能快照组，对应snap_set表，标识了鸟币不同版本。此表只可新建，不可删改。
type SnapSet struct {
	ID      uint64    `json:"snapSetID" xorm:"pk BIGINT autoincr 'id'"`
	Created time.Time `json:"created" xorm:"not null created"`

	Owner   string   `json:"owner" xorm:"not null index VARCHAR(20)"`      //鸟币号，必填
	SnapIDs []uint64 `json:"snapIDs" xorm:"not null JSONB 'snap_ids'"`     //技能快照snap_id的集合，倒序排列(snap_id为自增id)
	Md5     string   `json:"md5" xorm:"not null index unique VARCHAR(32)"` //snap_ids的snap按照version倒序排列后，生成的md5 hash。用于检查是否已经存在此技能快照组
	Value   uint64   `json:"value" xorm:"not null BIGINT"`                 //此鸟币版本的技能总价值，正整数
	Count   uint32   `json:"count" xorm:"not null INTEGER"`                //此鸟币版本的技能总数量，正整数
}
