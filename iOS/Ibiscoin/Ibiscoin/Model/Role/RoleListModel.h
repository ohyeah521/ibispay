//
//  RoleListModel.h
//  Action
//
//  Created by 鸟神 on 2017/5/2.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "CoinModel.h"
#import "RoleModel.h"

@interface RoleListModel : NSObject
@property (nonatomic) int skip;
@property (nonatomic, strong) NSArray *list;
@end
@interface RoleListDetailModel : NSObject
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) RoleModel *role;
@property (nonatomic, strong) CoinModel *coin;
@end

@interface MyRoleListModel : NSObject
@property (nonatomic) int skip;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) UserModel *user;
@end
@interface MyRoleListDetailModel : NSObject
@property (nonatomic, strong) RoleModel *role;
@property (nonatomic, strong) CoinModel *coin;
@end
