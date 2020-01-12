package config

import (
	"fmt"
	"io/ioutil"
	"os"

	"github.com/kezhuw/toml"
)

type (
	//TomlConfig 全局外部配置
	TomlConfig struct {
		Debug bool

		Server struct {
			Host        string
			Port        string
			AllowedHost []string
		}

		Dir struct {
			RootDir string
			DataDir string
		}

		// ExchangeRate
		Exr struct {
			RmbM2Now  float64
			RmbM2Init float64
			RmbExr    float64 //鸟币兑人民币汇率
		}

		Name struct {
			SysName []string //系统保留关键字
		}

		Pic struct {
			MaxUploadPic          int64
			MaxUploadPics         int64
			QualityOfPic          int
			PicNameSuffixOriginal string
			PicNameSuffixDefault  string
			PicNameSuffixBiggest  string
			PicNameSuffixLarge    string
			PicNameSuffixMiddle   string
			PicNameSuffixSmall    string
			QRCSuffix             string
			QRSizeBiggest         uint
			QRSizeLarge           uint
			QRSizeMiddle          uint
			QRSizeSmall           uint
			AvatarSuffix          string
			AvatarSizeDefault     uint
			AvatarSizeBiggest     uint
			AvatarSizeLarge       uint
			AvatarSizeMiddle      uint
			AvatarSizeSmall       uint
			SkillPicBiggest       uint
			SkillPicLarge         uint
			SkillPicMiddle        uint
			SkillPicSmall         uint
			SkillPicLongBigOri    uint
			SkillPicLongOri       uint
			SkillPicLongBigThum   uint
			SkillPicLongThum      uint
			SkillPicScaleMax      float64
		}

		Req struct {
			ReqBearer10 string
			ReqIssuer10 string
			ReqBearer11 string
			ReqIssuer11 string
			ReqBearer22 string
			ReqIssuer22 string
		}

		Err struct {
			E1000 string
			E1001 string
			E1002 string
			E1003 string
			E1004 string
			E1005 string
			E1006 string
			E1007 string
			E1008 string
			E1009 string
			E1010 string
			E1011 string
			E1012 string
			E1013 string
			E1014 string
			E1015 string
			E1016 string
			E1017 string
			E1018 string
			E1019 string
			E1020 string
			E1021 string
			E1022 string
			E1023 string
			E1024 string
			E1025 string
			E1026 string
			E1027 string
			E1028 string
			E1029 string
			E1030 string
			E1031 string
			E1032 string
			E1033 string
			E1034 string
			E1035 string
			E1036 string
			E1037 string
			E1038 string
			E1039 string
		}

		Tips struct {
			T1000 string
			T1001 string
			T1002 string
			T1003 string
		}
	}
)

//Public 公有配置
var Public TomlConfig

//Load 初始化配置
func Load() {
	buf, err := ioutil.ReadFile("config.toml")
	if err != nil {
		panic(err)
	}

	err = toml.Unmarshal(buf, &Public)
	if err != nil {
		panic(err)
	}

	Public.Exr.RmbExr = Public.Exr.RmbM2Now / Public.Exr.RmbM2Init

	if Public.Debug {
		fmt.Println("======config======")
		fmt.Printf("%+v\n", Public)
		fmt.Println("======config end======")
	}

	//建立文件夹
	os.MkdirAll(Public.Dir.DataDir, os.ModePerm)
	os.Chmod(Public.Dir.DataDir, os.ModePerm)
}
