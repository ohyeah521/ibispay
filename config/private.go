package config

import "fmt"

/*
===私有配置，不可泄漏===
密码salt:在梦里醒过来发现现实确实是场梦
jwt秘钥:发光!鸟神号海盗船起飞啦
===加密算法：SHA256===
*/
const (
	//APIVision api版本号
	APIVision   = "1.0" //鸟币API版本号
	MaxSkillNum = 200   //每个用户最多可以上架多少個技能
	//pg debug db
	PQIrisIDKey = "iris_pq"
	PQHost      = "localhost"
	PQPort      = 5432
	PQUser      = "postgres"
	PQPwd       = ""
	PQDBName    = "ibispay"
	//UUIDKey
	UUIDNameSpace = "ibispay-go"
	//PWDSalt 密码加密key
	PWDSalt = "f08ff5530360d348b97b4128d4ba4eb888a68a795980e3813afa3144fdce33d4"
	//JWTSecret jwt密钥
	JWTSecret    = "f8f3d913f6e9a60ef8cdd081946258d9649a96490639886866128e3923b2937e"
	JWTIrisIDKey = "iris_jwt"
	JWTExp       = 14 * 24 //两周。过期时间，以小时为单位
	JwtCIDKey    = "jwt_coin_id_key"
	JwtNameKey   = "jwt_name_key"
	//exr
	RMBExrIrisKey = "iris_rmbexr"
	//translocks
	TxLocksIrisKey = "iris_tx_locks"
	//beanstalk tube为不同延迟队列的分组
	BeanstalkURI     = "localhost:11300"
	BeanstalkTubeReq = "req"
	//NewsTableName
	NewsTableReq   = "req"
	NewsTablePay   = "pay"
	NewsTableRePay = "repay"
)

//PQInfo pq连接字符串
var PQInfo = fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=disable", PQUser, PQPwd, PQHost, PQPort, PQDBName)
