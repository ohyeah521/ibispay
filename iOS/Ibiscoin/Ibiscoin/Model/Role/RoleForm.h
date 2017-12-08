//
//  RoleForm.h
//  Action
//
//  Created by 鸟神 on 2017/4/30.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoleForm : NSObject
    
@property (nonatomic, strong) NSString *userID; //用户ID，必填
//--必填--
@property (nonatomic, strong) NSString *coinAlias;

@property (nonatomic, strong) NSString *name; //名字，不可重复 必填，少于10个字
@property (nonatomic, strong) NSString *desc; //描述 必填，少于300字
@property (nonatomic, strong) NSString *city; //当前城市，如 Neverland 或者 La La Land 必填，少于10个字
@property (nonatomic, strong) NSString *sex; //性别 必填，少于5个字
@property (nonatomic, strong) NSString *power; //能力，逗号分隔 如[人类巅峰的体能与意志,大师级的格斗技巧和棍术,有如雷达感应般的听觉,超人般的触觉、嗅觉与味觉,特制的战斗棍] 必填
//--可填--
@property (nonatomic, strong) NSString *alias; //重要别名，如"地狱厨房的恶魔" 可填，少于10字
@property (nonatomic, strong) NSString *signal; //唤醒角色的方法（口令、仪式、情景、环境、首饰等) 可填，少于20字
@property (nonatomic, strong) NSString *belief; //信念给予角色力量，让角色不断前进；一个小小的信念，是梦境的引子，能引发一场大梦 可填，少于200字
@property (nonatomic, assign) NSInteger birthday; //生日 unix时间戳 默认为631123200（1990年1月1日） 可填
@property (nonatomic, strong) NSString *passion; //主要热情，逗号分隔，如[造物图,造梦法,地底蜥蜴人世界] 可填
@property (nonatomic, strong) NSString *mate; //伙伴,如[黑寡妇,幻影杀手] 可填
@property (nonatomic, strong) NSString *team; //所属团队，逗号分隔，如[神盾局,真纯会,尼尔森与梅铎律师事务所] 可填
    
@end
