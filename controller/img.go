package controller

import (
	"crypto/md5"
	"encoding/hex"
	"io"
	"io/ioutil"
	"os"

	"github.com/kataras/iris"
	"github.com/rs/xid"
	"reqing.org/ibispay/config"
	"reqing.org/ibispay/db"
	"reqing.org/ibispay/model"
	"reqing.org/ibispay/util"
)

//NewPic 上传图片
func NewPic(ctx iris.Context) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	coinName := GetJwtUser(ctx)[config.JwtNameKey].(string)

	file, _, err := ctx.FormFile("file")
	if err != nil {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}
	defer file.Close()

	//取得hash值
	hash := md5.New()
	if _, err := io.Copy(hash, file); err != nil {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}
	sumByte := hash.Sum(nil)
	sum := hex.EncodeToString(sumByte)

	//检查图片hash是否已经存在于数据库
	img := db.Img{Hash: sum}
	has, err := pq.Get(&img)
	if err != nil {
		util.LogDebugAll(err)
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}
	if has == true {
		//图片已经存在
		e.ReturnError(ctx, iris.StatusInternalServerError, config.Public.Err.E1038)
	}

	//新的client_hash
	img.Owner = coinName
	img.GUID = xid.New().String()
	//临时保存原图到路径：./files/udata/鸟币号/pic/鸟币号_guid-original.jpg
	pid := coinName + "_" + img.GUID
	meta := db.NewJPGMeta(pid+config.Public.Pic.PicNameSuffixOriginal, 0, 0)
	dirOriginal := db.GetUserPicDir(coinName, meta)
	fileBuf, err := ioutil.ReadAll(file)
	if err != nil {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}
	if ioutil.WriteFile(dirOriginal, fileBuf, os.ModePerm) != nil {
		e.ReturnError(ctx, iris.StatusInternalServerError, config.Public.Err.E1015)
	}
	img.OriginalDir = dirOriginal
	ctx.JSON(&img)

	GenThumbnail(pq, &img, coinName)
}

//CheckPicHash 检查图片是否已经上传过
func CheckPicHash(ctx iris.Context) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	hash := ctx.Params().Get("hash")

	//检查图片hash是否已经存在于数据库
	img := db.Img{Hash: hash}
	has, err := pq.Get(&img)
	if err != nil {
		util.LogDebugAll(err)
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	}
	if has == true {
		ctx.JSON(&model.ImgExistRes{Exist: true})
		return
	}

	ctx.JSON(&model.ImgExistRes{Exist: false})
}
