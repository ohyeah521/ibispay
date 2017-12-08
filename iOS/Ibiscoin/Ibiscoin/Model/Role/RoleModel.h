//Created by niaoshenhao.com

//Role 对应role表
//自己真正的角色("注定成为"或者"已经成为"的人）
@interface RoleModel : NSObject

@property (nonatomic, strong) NSString *roleID; //角色ID
@property (nonatomic, strong) NSString *userID; //用户ID，必填

//--必填--
@property (nonatomic, strong) NSString *name; //名字，不可重复 必填，少于10个字
@property (nonatomic, strong) NSString *desc; //描述 必填，少于300字
@property (nonatomic, strong) Pic* avatar; //头像 必选
@property (nonatomic, strong) Pic* image; //方形封面，同头像 必选
@property (nonatomic, strong) NSString *city; //所在地区，如 Neverland 或者 La La Land 必填，少于10个字
@property (nonatomic, strong) NSString *sex; //心里性别 必填，少于10个字
@property (nonatomic, strong) NSString *power; //能力和装备，逗号分隔 如[人类巅峰的体能与意志,大师级的格斗技巧和棍术,有如雷达感应般的听觉,超人般的触觉、嗅觉与味觉,特制的战斗棍] 必填
//--可填--
@property (nonatomic, strong) NSString *alias; //重要别名，如"地狱厨房的恶魔" 可填，少于10字
@property (nonatomic, strong) NSString *signal; //唤醒方法（咒语、信物、情景、环境等) 可填，少于200字
@property (nonatomic, strong) NSString *belief; //信念给予角色力量，让角色不断前进；信念也是梦境的种子 可填，少于200字
@property (nonatomic, assign) NSInteger birthday; //诞生日期，可以是心理上的 unix时间戳 默认为631123200（1990年1月1日） 可填
@property (nonatomic, strong) NSString *passion; //主要热情，逗号分隔，如[伏羲先天八卦,冥想梦境,地底蜥蜴人世界] 可填
@property (nonatomic, strong) NSString *mate; //伙伴,如[黑寡妇,幻影杀手] 可填
@property (nonatomic, strong) NSString *team; //所属团队，逗号分隔，如[神盾局,真纯会,尼尔森与梅铎律师事务所] 可填

//--鸟币--
//赚到的鸟币(发行的除外)：
@property (nonatomic, assign) NSInteger spend; //此角色总支出
@property (nonatomic, assign) NSInteger earned; //此角色的总收入
//发行的鸟币(此角色)：
@property (nonatomic, assign) NSInteger issued; //此角色历史总发行量
@property (nonatomic, assign) NSInteger back; //此角色历史总回收量
@property (nonatomic, assign) NSInteger issuedNow; //此角色当前发行量 IssuedNow=Issued-Back
//获得的赞助
@property (nonatomic, assign) NSInteger foundedMonthy; //目前的鸟币月收入
@property (nonatomic, assign) NSInteger founded; //募集的鸟币总数量

@property (nonatomic, assign) NSInteger loverNum; //赞助者人数
@property (nonatomic, assign) NSInteger lovedNum; //赞助的人数

@property (nonatomic, assign) BOOL sponsor; //鸟币app的赞助者标示 可以获得一些简单有爱的回报作为感谢，比如黄色昵称
@property (nonatomic, assign) BOOL deleted; //是否已删除
@property (nonatomic, assign) NSInteger updatedAt; //更新时间
@property (nonatomic, strong) NSString *createdAt; //首次登场时间

//=====for client=====
@property (nonatomic, strong) NSString *strBirthday;
@property (nonatomic, strong) NSString *updateTimeAgo;
@property (nonatomic, strong) NSString *coinAlias;
@property (nonatomic, strong) NSString *descCutoff;

@end

