//
//  LoveForm.h
//  Action
//
//  Created by 鸟神 on 2017/2/16.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoveForm : NSObject

@property (nonatomic, strong) NSString *loveID; //更新时必填
@property (nonatomic, strong) NSString *userID; //用户ID，必填
@property (nonatomic, strong) NSString *roleID; //角色ID，必填

@property (nonatomic, strong) NSString *code; //行动代号 必填，少于15个字
@property (nonatomic, strong) NSString *heart; //初心，可选 20字内 如：获取到最厉害的智慧
@property (nonatomic, assign) BOOL secret; //绝密行动，默认否，目前前台并不展示此功能
@property (nonatomic, assign) NSInteger state; //行动状态 必填 1:筹备中 2.行动中 3.梦想达成 4:大梦初醒
@property (nonatomic, strong) NSString *vision; //行动可以是目标、梦想或任何想做的事情，必填 2000字内
@property (nonatomic, strong) NSString *joy; //乐趣，自己若能乐在其中，粉丝就会慕名而来，必填 500字内
@property (nonatomic, strong) NSString *thanks; //感谢，必填 500字内
@property (nonatomic, strong) NSString *log; //行动更新日志，可选
@property (nonatomic, assign) NSInteger words; //日志的字数

@end
