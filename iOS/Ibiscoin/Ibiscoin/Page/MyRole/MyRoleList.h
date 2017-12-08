//
//  MyRoleList.h
//  Ibiscoin
//
//  Created by 鸟神 on 2017/7/6.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import "SuperList.h"
#import "RoleModel.h"
#import "RoleListModel.h"
#import "MyRoleCell.h"
#import "MyRoleCellLayout.h"

@interface MyRoleList : SuperList<UITableViewDelegate, UITableViewDataSource, SuperListDelegate, MyRoleCellDelegate>

@end
