//
//  SimpleRoleListModel.m
//  Action
//
//  Created by 鸟神 on 2017/5/2.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "SimpleRoleListModel.h"
#import "RoleModel.h"

@implementation SimpleRoleListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [RoleModel class] };
}
@end
