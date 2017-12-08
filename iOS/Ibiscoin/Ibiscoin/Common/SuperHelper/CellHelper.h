//
//  CellHelper.h
//  Action
//
//  Created by caokun on 15/12/13.
//  Copyright © 2015年 xingdongpai. All rights reserved.
//


@interface CellHelper : NSObject

// 圆角头像的 manager
+ (YYWebImageManager *)avatarImageManager;
+ (YYWebImageManager *)avatarImageManagerWithBorder;

/// Convert date to friendly description.
+ (NSString *)stringWithTimelineDate:(NSDate *)date;

/// Convert number to friendly description.
+ (NSString *)shortedNumberDesc:(NSUInteger)number;

@end
