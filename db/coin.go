package db

import (
	"time"
)

//Coin 对应coin表，此表不可删除
//鸟币号=鸟币名称=用户名
type Coin struct {
	ID uint64 `json:"coinID" xorm:"pk autoincr BIGINT 'id'"`

	Name     string `json:"name" xorm:"not null unique unique(coin_name_pwd_idx) VARCHAR(20)"`                      //鸟币号，不可重复、不可修改、少于20个字符，可用于登录。统一格式化为去除首尾空格的、以字母开头的、仅包含字母(Unicode)数字短横线的全小写格式，中间空格以短横线替换。
	Phone    string `json:"phone,omitempty" xorm:"not null unique unique(coin_phone_pwd_idx) VARCHAR(20)"`          //绑定手机号，不可重复，可修改，主要用于登录和找回密码。统一格式为为E164，eg.+8618612345678
	PhoneCC  string `json:"phoneCC,omitempty" xorm:"not null VARCHAR(3) 'phone_cc'"`                                //国家地区代码 Country Code
	Pwd      string `json:"-" xorm:"not null -> unique(coin_name_pwd_idx) unique(coin_phone_pwd_idx) VARCHAR(128)"` //密码加密，不从服务器返回前端
	TransIn  uint64 `json:"transIn" xorm:"not null default 0 index BIGINT"`                                         //总收入（包含收款+回收）
	TransOut uint64 `json:"transOut" xorm:"not null default 0 index BIGINT"`                                        //总支出（包含发行+转手）
	Issued   uint64 `json:"issued" xorm:"not null default 0 index BIGINT"`                                          //发行量 (承诺的鸟币总量）
	Cashed   uint64 `json:"cashed" xorm:"not null default 0 index BIGINT"`                                          //回收量（兑现的鸟币总量)
	Denied   uint64 `json:"denied" xorm:"not null default 0 index BIGINT"`                                          //拒绝量 (拒绝兑现的鸟币总量）
	SkillNum uint32 `json:"skillNum" xorm:"not null default 0 INTEGER"`                                             //当前可用的技能数
	BreakNum uint32 `json:"breakNum" xorm:"not null default 0 INTEGER"`                                             //拒绝兑现的次数
	Credit   uint16 `json:"credit" xorm:"not null default 0 index SMALLINT"`                                        //目前的鸟币信用，默认为0，范围0-1000

	Bio    string `json:"bio,omitempty" xorm:"TEXT"`          //技能简介，少于5000字
	Email  string `json:"email,omitempty" xorm:"VARCHAR(30)"` //邮箱
	Avatar Pic    `json:"avatar,omitempty" xorm:"JSONB"`      //头像，大小参考config
	Qrc    Pic    `json:"qrc,omitempty" xorm:"JSONB"`         //收款二维码（根据鸟币号生成），大小参考config

	Created time.Time `json:"created" xorm:"not null created"`
	Updated time.Time `json:"updated" xorm:"updated"`
}

//TransLocks 交易锁
//只允许付款方和收款方同时进行一个交易
type TransLocks struct {
	Locks map[string]bool
}
