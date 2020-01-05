package model

//NewImgRes 上传图片响应
type NewImgRes struct {
	Hash string `json:"hash"` //客户端上传的原图的 md5 hash 值，注意是原图。
}
