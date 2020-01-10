package controller

import (
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

	_, header, err := ctx.FormFile("file")
	if err != nil {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}

	//临时保存原图到路径：./files/udata/鸟币号/pic/鸟币号_guid-original.jpg
	guid := xid.New().String()
	pid := coinName + "_" + guid
	meta := db.NewJPGMeta(pid+config.Public.Pic.PicNameSuffixOriginal, 0, 0)
	dirOriginal := db.GetUserPicDir(coinName, meta)
	_, err = util.SaveFileTo(header, dirOriginal)
	if err != nil {
		os.Remove(dirOriginal)
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}

	//取得hash值
	checksum, err := util.GetHash256(dirOriginal)
	if err != nil {
		os.Remove(dirOriginal)
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}

	//检查图片hash是否已经存在于数据库
	img := db.Img{Hash: checksum}
	has, err := pq.Get(&img)
	if err != nil {
		util.LogDebugAll(err)
		os.Remove(dirOriginal)
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1015, nil)
	}
	if has == true {
		//图片已经存在
		os.Remove(dirOriginal)
		e.ReturnError(ctx, iris.StatusInternalServerError, config.Public.Err.E1038)
	}

	//新的client_hash
	img.Owner = coinName
	img.GUID = guid
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
