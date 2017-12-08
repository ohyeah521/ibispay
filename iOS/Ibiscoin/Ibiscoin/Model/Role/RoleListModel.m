//
//  RoleListModel.m
//  Action
//
//  Created by 鸟神 on 2017/5/2.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "RoleListModel.h"

@implementation RoleListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [RoleListDetailModel class] };
}
@end
@implementation RoleListDetailModel

@end

@implementation MyRoleListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [MyRoleListDetailModel class] };
}
@end
@implementation MyRoleListDetailModel

@end
