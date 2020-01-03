package db

import (
	"time"
)

//Skill 最新技能（指自身天赋和任何对他人有用的东西），此表不可删除
//注意：发币是使用技能快照，而不是最新技能，每次更新skill后，在发币的时候就需要新建snap。
type Skill struct {
	ID      uint64    `json:"skillID" xorm:"pk unique(skill_id_owner_idx) BIGINT autoincr 'id'"`
	Created time.Time `json:"created" xorm:"not null index created"`
	Updated time.Time `json:"updated" xorm:"index updated"`
	Deleted time.Time `json:"-" xorm:"deleted"`

	Owner   string   `json:"owner" xorm:"not null index unique(skill_id_owner_idx) unique(skill_owner_title_idx) VARCHAR(20)"` //鸟币号ID，必填
	Title   string   `json:"title" xorm:"not null index unique(skill_owner_title_idx) VARCHAR(100)"`                           //技能名称，不可修改，同一用户下不能输入重复标题，不超过100个字符，必填
	Price   uint64   `json:"price" xorm:"not null index default 1 BIGINT"`                                                     //技能价格（鸟币数/单位），大于0的整数，必填
	Desc    string   `json:"desc,omitempty" xorm:"index VARCHAR(10000)"`                                                       //技能描述，少于10000个字符
	Pics    []*Pic   `json:"pics,omitempty" xorm:"index JSONB"`                                                                //技能图片大小参考config
	Tags    []string `json:"tags,omitempty" xorm:"index JSONB"`                                                                //类型如：技能、实物、服务、数字商品等，或者其他自定义标签
	Version uint64   `json:"version" xorm:"not null version"`                                                                  //更新时自动加1
}
