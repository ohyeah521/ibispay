package db

// Img 对应img表，所有新的原图都要生成一个hash保存，用来检查是否有相同的图片存在。
// 知道name和guid就可以拼接得到服务器存放图片的路径，如： ./files/udata/鸟币号/pic/鸟币号_guid-biggest.jpg
type Img struct {
	Hash        string `xorm:"not null pk VARCHAR(32)"`                  //客户端上传的原图的 md5 hash 值，注意是原图。
	Owner       string `xorm:"not null index VARCHAR(20)"`               //鸟币号
	GUID        string `xorm:"not null index unique VARCHAR(36) 'guid'"` //图片唯一id
	Thumb       *Pic   `xorm:"not null JSONB"`                           //缩略图属性
	OriginalDir string `xorm:"-"`                                        //上传时临时存放新的原图的路径
}
