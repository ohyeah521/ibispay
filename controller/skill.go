package controller

import (
	"crypto/md5"
	"encoding/hex"
	"errors"
	"io"
	"io/ioutil"
	"os"

	"github.com/asaskevich/govalidator"
	"github.com/go-xorm/xorm"
	"github.com/rs/xid"
	"gopkg.in/h2non/bimg.v1"

	"github.com/kataras/iris"
	"reqing.org/ibispay/config"
	"reqing.org/ibispay/db"
	"reqing.org/ibispay/model"
	"reqing.org/ibispay/util"
)

//NewSkill 新建技能
func NewSkill(ctx iris.Context, form model.NewSkillForm) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	coinName := GetJwtUser(ctx)[config.JwtNameKey].(string)
	lock := GetTxLocks(ctx)

	//转账和技能不能同时处理
	if lock.Locks[coinName] == true {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1019)
	}
	lock.Locks[coinName] = true
	defer func() {
		delete(lock.Locks, coinName)
	}()

	//上架的技能数量不能超过200
	count, err := pq.Count(&db.Skill{Owner: coinName})
	if err != nil {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	}
	if count+1 > config.MaxSkillNum {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1027)
	}

	//同一用户不能插入相同标题的技能
	has, err := pq.Exist(&db.Skill{Owner: coinName, Title: form.Title})
	if err != nil {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	}
	if has == true {
		e.ReturnError(ctx, iris.StatusInternalServerError, config.Public.Err.E1026)
	}

	err = ctx.Request().ParseMultipartForm(config.Public.Pic.MaxUploadPics)
	if err != nil {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1016, nil)
	}

	files := ctx.Request().MultipartForm.File["files"]
	if len(files) > 9 {
		e.ReturnError(ctx, iris.StatusInternalServerError, config.Public.Err.E1036)
	}
	imgs := []*db.Img{}
	conf := config.Public.Pic
	for _, file := range files {
		//取得hash值
		f, err := file.Open()
		if err != nil {
			continue
		}
		defer f.Close()
		hash := md5.New()
		if _, err := io.Copy(hash, f); err != nil {
			continue
		}
		sumByte := hash.Sum(nil)
		sum := hex.EncodeToString(sumByte)

		//检查图片hash是否已经存在于数据库
		img := db.Img{Hash: sum}
		has, err := pq.Get(&img)
		if err != nil {
			util.LogDebugAll(err)
			continue
		}
		if has == false {
			//新的client_hash
			img.Owner = coinName
			img.GUID = xid.New().String()
			//临时保存原图到路径：./files/udata/鸟币号/pic/鸟币号_guid-original.jpg
			pid := coinName + "_" + img.GUID
			meta := db.NewJPGMeta(pid+conf.PicNameSuffixOriginal, 0, 0)
			dirOriginal := db.GetUserPicDir(coinName, meta)
			f, err := file.Open()
			if err != nil {
				continue
			}
			defer f.Close()
			fileBuf, err := ioutil.ReadAll(f)
			if err != nil {
				continue
			}
			if ioutil.WriteFile(dirOriginal, fileBuf, os.ModePerm) != nil {
				continue
			}
			img.OriginalDir = dirOriginal
		}
		imgs = append(imgs, &img)
	}

	//出错时删除原图
	var delOnErr = func() {
		for _, img := range imgs {
			os.Remove(img.OriginalDir)
		}
	}

	//插入数据库
	skill := db.Skill{Owner: coinName, Title: form.Title, Price: form.Price, Desc: form.Desc, Tags: form.Tags, Pics: []*db.Pic{}}
	affected, err := pq.Insert(&skill)
	if err != nil {
		delOnErr()
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	}
	if affected == 0 {
		delOnErr()
		e.ReturnError(ctx, iris.StatusInternalServerError, config.Public.Err.E1004)
	}

	ctx.JSON(&skill)

	if len(imgs) == 0 {
		return
	}
	GenThumbnails(pq, imgs, coinName, &skill)
}

//UpdateSkill 更新技能
//更新技能时，拖放图片直接上传，服务器返回图片hash值给前端，请求时仅带上图片的hash数组
func UpdateSkill(ctx iris.Context, form model.UpdateSkillForm) {
	e := new(model.CommonError)
	pq := GetPQ(ctx)
	coinName := GetJwtUser(ctx)[config.JwtNameKey].(string)
	lock := GetTxLocks(ctx)

	//转账和技能不能同时处理
	if lock.Locks[coinName] == true {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1019)
	}
	lock.Locks[coinName] = true
	defer func() {
		delete(lock.Locks, coinName)
	}()

	//检查是否是本人账号更新
	has, err := pq.Exist(&db.Skill{ID: form.SkillID, Owner: coinName})
	if err != nil {
		e.CheckError(ctx, err, iris.StatusInternalServerError, config.Public.Err.E1004, nil)
	}
	if has == false {
		e.ReturnError(ctx, iris.StatusInternalServerError, config.Public.Err.E1037)
	}

	pics := []*db.Pic{}
	if len(form.Pics) > 0 {
		for _, imgHash := range form.Pics {
			img := db.Img{Hash: imgHash}
			has, err := pq.Get(&img)
			if err != nil || has == false {
				continue
			}
			pics = append(pics, img.Thumb)
		}
	}
	skill := db.Skill{Price: form.Price, Desc: form.Desc, Tags: form.Tags, Pics: pics}
	affected, err := pq.ID(form.SkillID).Cols("price,desc,tags,pics").Update(&skill)
	if affected == 0 || err != nil {
		e.ReturnError(ctx, iris.StatusOK, config.Public.Err.E1004)
	}

	ctx.JSON(&model.UpdateRes{Ok: true})
}

//GenThumbnail 生成单张图片的缩略图
func GenThumbnail(pq *xorm.Engine, img *db.Img, coinName string) {
	images := []*db.Img{img}
	GenThumbnails(pq, images, coinName, nil)
}

//GenThumbnails 生成多张图片的缩略图，并且更新到技能
func GenThumbnails(pq *xorm.Engine, imgs []*db.Img, coinName string, skill *db.Skill) {
	//生成图片缩略图，并且更新对应字段
	go func(pq *xorm.Engine, images []*db.Img, coinName string, skill *db.Skill) {
		pics := []*db.Pic{}
		conf := config.Public.Pic
		newInsertedImg := []*db.Img{}
		for _, img := range images {
			pic := new(db.Pic)
			if govalidator.IsNull(img.OriginalDir) == false {
				//===图片首次上传===
				pidPrefix := coinName + "_" + img.GUID
				var delPic = func(err error) bool {
					if err != nil {
						util.LogDebugAll(err)
						os.Remove(img.OriginalDir)
						return true
					}
					return false
				}

				//-----获取图片宽高信息-----
				util.LogDebug(img.OriginalDir)
				buf, err := bimg.Read(img.OriginalDir)
				if delPic(err) {
					continue
				}
				size, err := bimg.NewImage(buf).Size()
				if delPic(err) {
					continue
				}
				w := int(size.Width)
				h := int(size.Height)

				//-------计算缩略图大小，并把数据写入数组----------
				var getNewWH = func(w int, h int, longer float64, shorter float64, configSize float64) (newW uint, newH uint) {
					scale := configSize / longer
					longer = configSize
					shorter = shorter * scale
					if w > h {
						return uint(longer), uint(shorter)
					}
					return uint(shorter), uint(longer)
				}
				var getLongPicWH = func(w int, h int, longer float64, shorter float64, configSize float64) (newW uint, newH uint) {
					scale := configSize / shorter
					shorter = configSize
					longer = longer * scale
					if w > h {
						return uint(longer), uint(shorter)
					}
					return uint(shorter), uint(longer)
				}

				longer := float64(w)
				shorter := float64(h)
				if w < h {
					longer = float64(h)
					shorter = float64(w)
				}
				//图片太长，最大长宽比为短边:长边=0.025
				if shorter/longer < conf.SkillPicScaleMax {
					delPic(errors.New(config.Public.Err.E1017))
					continue
				}
				buffer, err := bimg.Read(img.OriginalDir)
				if (longer-shorter)/longer < 0.5 {
					//正常比例图，以长边对准设定值
					biggest := float64(conf.SkillPicBiggest)
					large := float64(conf.SkillPicLarge)
					middle := float64(conf.SkillPicMiddle)
					small := float64(conf.SkillPicSmall)
					if longer > biggest {
						w, h := getNewWH(w, h, longer, shorter, biggest)
						pic.Biggest = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixBiggest, w, h)
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Biggest, true)) {
							continue
						}
					} else {
						pic.Biggest = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixBiggest, uint(w), uint(h))
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Biggest, false)) {
							continue
						}
					}
					if longer > large {
						w, h := getNewWH(w, h, longer, shorter, large)
						pic.Large = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixLarge, w, h)
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Large, true)) {
							continue
						}
					} else {
						pic.Large = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixLarge, uint(w), uint(h))
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Large, false)) {
							continue
						}
					}
					if longer > middle {
						w, h := getNewWH(w, h, longer, shorter, middle)
						pic.Middle = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixMiddle, w, h)
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Middle, true)) {
							continue
						}
					} else {
						pic.Middle = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixMiddle, uint(w), uint(h))
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Middle, false)) {
							continue
						}
					}
					if longer > small {
						w, h := getNewWH(w, h, longer, shorter, small)
						pic.Small = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixSmall, w, h)
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Small, true)) {
							continue
						}
					} else {
						pic.Small = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixSmall, uint(w), uint(h))
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Small, false)) {
							continue
						}
					}
				} else {
					//长图，以短边对准设定值
					bigOri := float64(conf.SkillPicLongBigOri)
					ori := float64(conf.SkillPicLongOri)
					bigThum := float64(conf.SkillPicLongBigThum)
					thum := float64(conf.SkillPicLongThum)
					if shorter > bigOri {
						w, h := getLongPicWH(w, h, longer, shorter, bigOri)
						pic.Biggest = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixBiggest, w, h)
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Biggest, true)) {
							continue
						}
					} else {
						pic.Biggest = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixBiggest, uint(w), uint(h))
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Biggest, false)) {
							continue
						}
					}
					if shorter > ori {
						w, h := getLongPicWH(w, h, longer, shorter, ori)
						pic.Large = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixLarge, w, h)
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Large, true)) {
							continue
						}
					} else {
						pic.Large = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixLarge, uint(w), uint(h))
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Large, false)) {
							continue
						}
					}
					if shorter > bigThum {
						w, h := getLongPicWH(w, h, longer, shorter, bigThum)
						pic.Middle = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixMiddle, w, h)
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Middle, true)) {
							continue
						}
					} else {
						pic.Middle = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixMiddle, uint(w), uint(h))
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Middle, false)) {
							continue
						}
					}
					if shorter > thum {
						w, h := getLongPicWH(w, h, longer, shorter, thum)
						pic.Small = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixSmall, w, h)
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Small, true)) {
							continue
						}
					} else {
						pic.Small = db.NewJPGMeta(pidPrefix+conf.PicNameSuffixSmall, uint(w), uint(h))
						if delPic(db.CompressUserJPG(coinName, buffer, pic.Small, false)) {
							continue
						}
					}
				}
				img.Thumb = pic

				//数据库插入新图hash
				_, err = pq.Insert(img)
				if err == nil {
					newInsertedImg = append(newInsertedImg, img)
				}
			} else {
				//===图片已经上传过===
				pic = img.Thumb
			}
			//删除新原图
			os.Remove(img.OriginalDir)

			pics = append(pics, pic)
		}

		//出错时，删除缩略图
		var delOnErr = func() {
			for _, img := range newInsertedImg {
				pq.Delete(img)
			}
			for _, pic := range pics {
				os.Remove(db.GetUserPicDir(coinName, pic.Biggest))
				os.Remove(db.GetUserPicDir(coinName, pic.Large))
				os.Remove(db.GetUserPicDir(coinName, pic.Middle))
				os.Remove(db.GetUserPicDir(coinName, pic.Small))
			}
		}

		if skill != nil {
			//更新skill缩略图
			skill.Pics = pics
			affected, err := pq.ID(skill.ID).Update(skill)
			if affected == 0 || err != nil {
				delOnErr()
			}
		}
	}(pq, imgs, coinName, skill)
}
