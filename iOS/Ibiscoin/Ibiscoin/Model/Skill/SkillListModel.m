//
//  SkillListModel.m
//  Action
//
//  Created by 鸟神 on 2016/10/28.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "SkillListModel.h"
#import "SkillModel.h"

@implementation SkillListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [SkillModel class] };
}
@end
