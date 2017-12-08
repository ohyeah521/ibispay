//Created by niaoshenhao.com

//Love 对应love表
//爱我所爱，如阳光般照耀大地！
@interface LoveModel : NSObject

@property (nonatomic, strong) NSString *loveID; //ID
@property (nonatomic, strong) NSString *userID; //用户ID，必填
@property (nonatomic, strong) NSString *roleID; //角色ID，必填

@property (nonatomic, strong) NSString *code; //行动代号 必填，少于15个字
@property (nonatomic, strong) NSString *heart; //初心，一句话介绍 20字内 如：获取到最厉害的智慧
@property (nonatomic, assign) BOOL secret; //绝密行动，默认否，目前前台并不展示此功能
@property (nonatomic, assign) NSInteger state; //行动状态 必填 1:筹备中 2.行动中 3.梦想达成 4:大梦初醒
@property (nonatomic, strong) NSString *vision; //行动可以是目标、梦想或任何想做的事情，必填 2000字内
@property (nonatomic, strong) NSString *joy; //乐趣，自己若能乐在其中，粉丝就会慕名而来，必填 500字内
@property (nonatomic, strong) NSString *thanks; //感谢，必填 500字内
@property (nonatomic, strong) NSString *log; //行动更新日志，可选  
@property (nonatomic, assign) NSInteger words; //日志的字数
@property (nonatomic, strong) Pic* photo; //行动标志 可选

@property (nonatomic, assign) BOOL deleted; //是否已删除
@property (nonatomic, assign) NSInteger updatedAt; //最后修改
@property (nonatomic, strong) NSString *createdAt; //创建日期

//=====for client=====
@property (nonatomic, strong) NSString *updateTimeAgo;
@property (nonatomic, strong) NSString *descCutoff;
@property (nonatomic, assign) BOOL showPicInFeed;
@property (nonatomic, strong) NSString *strState;

@end


//Lover 赞助者
@interface LoverModel : NSObject

@property (nonatomic, strong) NSString *loverID; //ID
@property (nonatomic, strong) NSString *loveID; //行动ID，必填
@property (nonatomic, strong) NSString *loverRID; //参与者角色ID
@property (nonatomic, strong) NSString *loverCoinID; //参与者鸟币ID
@property (nonatomic, strong) NSString *coinTLID; //鸟币转账记录ID
@property (nonatomic, assign) NSInteger coinNum; //支持的鸟币数量
@property (nonatomic, strong) NSString *createdAt; //参与日期

@end

