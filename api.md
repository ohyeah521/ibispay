## API URL  
除了/login, /register外,  其它的都需要另外带Header: `Authorization: Bearer xxx.xxx.xxx`  

## 返回值结构
* 全部返回JSON, 除二进制文件(图片, 附件外), 返回的一定是JSON格式的值,
* 错误信息返回:
  1. 全部返回200 `{"ok": false, "msg": "对应错误信息", "code": "对应的https状态码", "errors" : "错误详情，可为空"}`
* 正确信息返回分3种:
  1. JWT_Login返回的token信息：`{"expire": "2016-09-01T10:25:41+08:00","token": "xxx.xxx.xxx"}`
  2. 一些操作型的api, 比如updateUser之类的, 成功后返回200 `{"ok": true}` 
  3. 一些获取型api, 如getUserList, 全部返回真实的数据
