//
//  HomeDetailList.h
//  Ibiscoin
//
//  Created by 鸟神 on 2017/8/1.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import "SuperList.h"
#import "RoleCellLayout.h"

@interface HomeDetailList : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RoleCellLayout *lastPageLayout;

@end
