//
//  RoleList.h
//  Action
//
//  Created by 鸟神 on 2017/5/30.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "SuperList.h"
#import "RoleModel.h"
#import "RoleListModel.h"
#import "RoleCell.h"
#import "RoleCellLayout.h"

@interface RoleList : SuperList <UITableViewDelegate, UITableViewDataSource, SuperListDelegate, RoleCellDelegate>

@end
