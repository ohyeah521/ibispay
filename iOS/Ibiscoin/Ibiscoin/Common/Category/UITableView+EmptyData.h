//
//  UITableView+EmptyData.h
//  Action
//
//  Created by caokun on 15/11/4.
//  Copyright © 2015年 xingdongpai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)

- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end
