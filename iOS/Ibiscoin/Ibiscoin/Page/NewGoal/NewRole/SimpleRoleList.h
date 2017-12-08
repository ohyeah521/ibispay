//
//  RoleSelectList.h
//  Action
//
//  Created by 鸟神 on 2017/5/25.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "SuperList.h"
#import "RoleModel.h"
#import "SimpleRoleListModel.h"

@interface SimpleRoleList : SuperList <SuperListDelegate>

@property (nonatomic) BOOL isFormNewSkill;
@property (nonatomic) BOOL isFormNewLove;
@property (nonatomic, copy) NSIndexPath *selectedIndexPath;
@property (nonatomic, copy) void (^saveBack)(RoleModel *role, NSIndexPath *indexPath);

@property (nonatomic, strong) RoleModel *role;

@end
