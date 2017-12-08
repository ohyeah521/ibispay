//Created by niaoshenhao.com

//Skill 对应skill表
@interface SkillModel : NSObject

@property (nonatomic, strong) NSString *skillID; //技能ID
@property (nonatomic, strong) NSString *userID; //用户ID，必填
@property (nonatomic, strong) NSString *roleID; //角色ID，必填

@property (nonatomic, strong) NSString *title; //技能名称，不可修改，不超过20个中文，必填
@property (nonatomic, assign) NSInteger price; //技能价值（一次收取多少鸟币），以普通鸟币价格衡量，必填
@property (nonatomic, assign) BOOL hidden; //是否隐藏，必填

@property (nonatomic, strong) NSString *desc; //技能描述 
@property (nonatomic, strong) NSArray* pics; //图片，可选 1334/1136/320

@property (nonatomic, assign) BOOL deleted; //是否已删除
@property (nonatomic, assign) NSInteger updatedAt; //更新时间
@property (nonatomic, strong) NSString *createdAt; //创建日期

@property (nonatomic, assign) BOOL isSnap; //是否是备份版本
@property (nonatomic, strong) NSString *groupID; //技能当前版本和技能历史版本的同组ID

//=====for client=====
@property (nonatomic, strong) NSString *descCutoff;
@property (nonatomic, assign) BOOL showPicInFeed;
@property (nonatomic, strong) NSString *updateTimeAgo;

@end






