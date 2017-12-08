//Created by niaoshenhao.com

//User 对应user表
@interface UserModel : NSObject
//=====所有系统共享属性，子系统以①②③...区分=====
//--个人资料--
@property (nonatomic, strong) NSString *userID; //用户ID
@property (nonatomic, strong) NSString *phone; //用户手机号，不可重复，全部注册必填
@property (nonatomic, strong) NSString *phoneCC; //Country Code，全部注册必填
@property (nonatomic, strong) NSString *pwd; //密码不从服务器返回，全部注册必填
@property (nonatomic, strong) NSString *name; //@昵称 不可重复 最多10个汉字 ①注册必填(默认自动为电话) 
@property (nonatomic, strong) NSString *city; //城市 ①可填 
@property (nonatomic, assign) double lat; //纬度 ①可填 
@property (nonatomic, assign) double lng; //经度 ①可填 
@property (nonatomic, strong) Pic* avatar; //头像 原图/640/320/160 ①可填 
@property (nonatomic, strong) Pic* realPhoto; //真人头像 原图/640/320/160 ①可填
@property (nonatomic, strong) NSString *bio; //个性签名 最多128个汉字，支持标签、支持链接 ①可填  
@property (nonatomic, assign) double birthday; //生日 unix时间戳 默认为631123200（1990年1月1日）①可填  
@property (nonatomic, assign) NSInteger sex; //生理性别，默认为 男 ①可填  
@property (nonatomic, strong) NSString *email; //邮箱，用来登录和发送产品信息 ①可填
//--其他--
@property (nonatomic, assign) BOOL founder; //联合创始人标示 拥有一些特殊权限，比如红色昵称 
@property (nonatomic, assign) BOOL hasPhoto; //真人照片的标示 头像有打勾icon 
@property (nonatomic, assign) BOOL actUser; //行动派用户标示，用来区分其他app比如行动超人 
@property (nonatomic, strong) NSString *createdAt; //加入时间 
@property (nonatomic, strong) NSString *deviceToken; //iPhone消息推送token
@property (nonatomic, strong) NSString *userActivity;

//=====①私有属性=====
//--鸟币--
//赚到的鸟币(自己发行的除外)：
@property (nonatomic, assign) NSInteger spend; //总花费量
@property (nonatomic, assign) NSInteger earned; //总赚取量
//发行的鸟币(自己所有角色)：
@property (nonatomic, assign) NSInteger issued; //总发行量
@property (nonatomic, assign) NSInteger back; //总回收量

//--其他--
@property (nonatomic, assign) NSInteger actionNum; //行动数
@property (nonatomic, assign) NSInteger likedNum; //喜欢的人的数量

//=====for client=====
@property (nonatomic, strong) NSString *strSex;
@property (nonatomic, strong) NSString *strBirthday;
@property (nonatomic, assign) NSInteger age;

//--鸟币--
//历史总盈利
@property (nonatomic, assign) NSInteger outAll;
@property (nonatomic, assign) NSInteger incomeAll;
@property (nonatomic, assign) NSInteger benifitAll;
//总月收入：
@property (nonatomic, assign) NSInteger earnedMonthy;

@end



//UserActivity 对应userActivity表
//用户动态信息监测
//1.app处于开启时，每隔1分钟自动查询
//2.刷新首页时同时检查动态
//3.刷新我的主页同时检查动态
@interface UserActivityModel : NSObject
@property (nonatomic, strong) NSString *userActivityID; //用户动态信息ID
@property (nonatomic, strong) NSString *userID; //用户ID

//=====所有系统通用=====
@property (nonatomic, assign) double rmbExr; //汇率(1鸟币合人民币多少)
@property (nonatomic, assign) NSInteger updatedAt; //最后活跃时间

//=====①私有=====
//--消息--
@property (nonatomic, assign) NSInteger newsNum; //新消息数量
//--鸟币兑现--
@property (nonatomic, assign) NSInteger uncashedNum; //所有角色未兑现的请求总数

//=====for client=====
@property (nonatomic, strong) NSString *strUpdatedAt;

@end



//UserToken jwt返回信息
@interface UserTokenModel : NSObject

@property (nonatomic, strong) NSString *expire;
@property (nonatomic, strong) NSString *token;

@end

