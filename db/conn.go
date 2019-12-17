package db

import (
	"database/sql"
	"errors"
	"fmt"
	"log"
	"os"

	"github.com/go-xorm/xorm"
	"gopkg.in/h2non/bimg.v1"

	"reqing.org/ibispay/config"
)

//PicMeta 图片信息
type PicMeta struct {
	PID    string `json:"pid,omitempty"`
	W      uint   `json:"w,omitempty"`
	H      uint   `json:"h,omitempty"`
	Format string `json:"f,omitempty"`
}

//Pic 图片
type Pic struct {
	Small   *PicMeta `json:"small,omitempty" xorm:"extends"`
	Middle  *PicMeta `json:"middle,omitempty" xorm:"extends"`
	Large   *PicMeta `json:"large,omitempty" xorm:"extends"`
	Biggest *PicMeta `json:"biggest,omitempty" xorm:"extends"`
}

//NewSquareJPGMeta 正方形jpg pic meta
func NewSquareJPGMeta(pid string, wh uint) *PicMeta {
	meta := PicMeta{
		PID:    pid,
		W:      wh,
		H:      wh,
		Format: "jpg",
	}
	return &meta
}

//NewSquarePNGMeta 正方形png pic meta
func NewSquarePNGMeta(pid string, wh uint) *PicMeta {
	meta := PicMeta{
		PID:    pid,
		W:      wh,
		H:      wh,
		Format: "png",
	}
	return &meta
}

//NewJPGMeta jpg pic meta
func NewJPGMeta(pid string, w uint, h uint) *PicMeta {
	meta := PicMeta{
		PID:    pid,
		W:      w,
		H:      h,
		Format: "jpg",
	}
	return &meta
}

//NewPicMeta  pic meta
func NewPicMeta(pid string, w int, h int, f string) *PicMeta {
	meta := PicMeta{
		PID:    pid,
		W:      uint(w),
		H:      uint(h),
		Format: f,
	}
	return &meta
}

//GetUserPicDir 用户图片dir
func GetUserPicDir(userName string, meta *PicMeta) string {
	if meta == nil {
		return ""
	}
	//如果用户的pic目录不存在则新建
	picDir := fmt.Sprintf("%s%s/%s/pic", config.Public.Dir.RootDir, config.Public.Dir.DataDir, userName)
	os.MkdirAll(picDir, os.ModePerm)
	os.Chmod(picDir, os.ModePerm)
	//文件全路径
	fullPath := fmt.Sprintf("%s/%s.%s", picDir, meta.PID, meta.Format)
	return fullPath
}

//ResizeUserPic 生成用户图片的缩略图
func ResizeUserPic(userName string, buffer []byte, meta *PicMeta) error {
	if meta == nil {
		return errors.New("null pic meta")
	}
	newImage, err := bimg.NewImage(buffer).Resize(int(meta.W), int(meta.H))
	if err != nil {
		return err
	}
	dir := GetUserPicDir(userName, meta)
	err = bimg.Write(dir, newImage)
	if err != nil {
		return err
	}
	return nil
}

//CompressUserJPG 压缩用户图片，并且转换成jpeg格式
func CompressUserJPG(userName string, buffer []byte, meta *PicMeta, isResize bool) error {
	//统一转换成jpeg
	image := bimg.NewImage(buffer)
	if image.Type() != "JPEG" {
		buf, err := image.Convert(bimg.JPEG)
		if err != nil {
			return err
		}
		buffer = buf
	}

	options := bimg.Options{}
	if isResize {
		//压缩并且调整大小
		options = bimg.Options{
			Width:   int(meta.W),
			Height:  int(meta.H),
			Quality: config.Public.Pic.QualityOfPic,
			Embed:   true,
		}
	} else {
		//仅压缩
		options = bimg.Options{
			Quality: config.Public.Pic.QualityOfPic,
			Embed:   true,
		}
	}

	newImage, err := image.Process(options)
	if err != nil {
		return err
	}
	dir := GetUserPicDir(userName, meta)
	err = bimg.Write(dir, newImage)
	if err != nil {
		return err
	}
	return nil
}

//TestDB 测试数据库连接
func TestDB() {
	//========连接测试====PostgreSQL数据库===========
	log.Println("Connecting PostgreSQL....")

	db, err := sql.Open("postgres", config.PQInfo)
	if err != nil {
		log.Fatal("Connect PG Failed: ", err)
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		log.Fatal("Ping GP Failed: ", err)
	}
	fmt.Println("PG Successfull Connected!")
}

//SyncDB 同步数据库字段
func SyncDB(engine *xorm.Engine) {
	fmt.Println("--------", engine.DriverName(), "----------")
	if config.Public.Debug {
		engine.ShowSQL(true)
		engine.ShowExecTime(true)
	}

	err := engine.Sync2(new(Coin), new(Skill), new(Snap), new(SnapSet), new(Pay), new(Repay), new(Info), new(News), new(Req), new(Img), new(Sum))
	if err != nil {
		log.Fatal("sync db err:", err)
		panic(err.Error())
	}
}
