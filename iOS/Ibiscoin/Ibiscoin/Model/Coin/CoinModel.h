//Created by niaoshenhao.com

//Coin 对应coin表
//角色发行的鸟币
/**
鸟币信用数值和等级的计算方法如下：

首先，定义发行出去的鸟币拥有3种状态：
状态A：已回收 信用权重：1=100%

状态B：未回收 信用权重：φ=61.8034%

B说明：未回收状态说明双方信任存在，鸟币信用良好
状态C：拒绝回收 信用权重：((1-φ)/(1+φ))²= 5.5728%

C说明：1.信用收缩和信用扩张未达成一致，协商延后也失败的状态
2.鸟币回流被拒绝后，发行者信用值会降低；若主动向债主提供服务，则可以立刻恢复正常信用值，即使债主拒绝

然后，定义计算方法和评级：
1.如果存在状态C: 鸟币信用 = (B*B个数＋C*C个数) / (B个数+C个数)

2.如果不存在状态C: 鸟币信用 = (A*A个数+B*B个数) / (A个数+B个数)


评级：
φ=61.8034%
x=(1-φ)/(1+φ)=23.6068%
y=1-x=(1+φ)/(1+x)=76.3932%

新用户无交易数据：鸟币信用 = 0

冒险型：0.0% < 鸟币信用 < 23.6068%

进击型：23.6068% <= 鸟币信用 < 50.0%

良好型：50.0% <= 鸟币信用 < 61.8034%

优秀型：61.8034% <= 鸟币信用 < 76.3932%

安全型：76.3932% <= 鸟币信用 <= 100.0%


说明：1.只要有1次状态C出现，则角色的鸟币信用为良（正常）
2.若有大于2次拒绝回收鸟币，则鸟币信用必然为冒险型信用
*/
@interface CoinModel : NSObject

@property (nonatomic, strong) NSString *coinID; //鸟币ID
@property (nonatomic, strong) NSString *userID; //用户ID，必填
@property (nonatomic, strong) NSString *roleID; //角色ID，必填

@property (nonatomic, strong) NSString *alias; //鸟币名称，"xxx币"，不可重复，不可更改，必填，5字内
@property (nonatomic, assign) double credit; //鸟币信用，默认为0
@property (nonatomic, assign) NSInteger vision; //最新的发行版本，版本号每次+1

@property (nonatomic, assign) NSInteger value; //技能总价值
@property (nonatomic, assign) NSInteger valueRMB; //技能约合人民币总价值
@property (nonatomic, strong) Pic* qrCode; //鸟币二维码(根据唯一的鸟币ID生成)
@property (nonatomic, assign) NSInteger skillNum; //技能数量
@property (nonatomic, assign) BOOL skillUpdated; //技能是否有更新，交易鸟币前检查，有更新则升级鸟币版本

@property (nonatomic, assign) NSInteger cashed; //已兑现承诺的次数
@property (nonatomic, assign) NSInteger uncashed; //未兑现承诺的次数

@property (nonatomic, assign) NSInteger updatedAt; //更新时间
@property (nonatomic, strong) NSString *createdAt; //创建日期

//=====for client=====
@property (nonatomic, strong) NSString *updateTimeAgo;
@property (nonatomic, strong) NSString *creditLevel;

@end



