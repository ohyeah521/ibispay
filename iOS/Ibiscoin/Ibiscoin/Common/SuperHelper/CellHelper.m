//
//  CellHelper.m
//  Action
//
//  Created by caokun on 15/12/13.
//  Copyright © 2015年 xingdongpai. All rights reserved.
//

#import "CellHelper.h"

@implementation CellHelper

+ (YYWebImageManager *)avatarImageManager {
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:@"avatar"];
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            if (!image) return image;
            return [image imageByRoundCornerRadius:HUGE]; // a large value
        };
    });
    return manager;
}

+ (YYWebImageManager *)avatarImageManagerWithBorder {
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:@"avatar"];
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            if (!image) return image;
            return [image imageByRoundCornerRadius:HUGE borderWidth:1.0 borderColor:kAvatarDefaultBorderColor]; // a large value
        };
    });
    return manager;
}

+ (NSString *)stringWithTimelineDate:(NSDate *)date {
    if (!date) return @"";
    
    static NSDateFormatter *formatterFullDate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"M/d/yy"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // local time error
        return [formatterFullDate stringFromDate:date];
    } else if (delta < 60) {
        return [NSString stringWithFormat:@"%ds",(int)(delta)];
    } else if (delta < 60 * 60) {
        return [NSString stringWithFormat:@"%dm", (int)(delta / 60.0)];
    } else if (delta < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%dh", (int)(delta / 60.0 / 60.0)];
    } else if (delta < 60 * 60 * 24 * 7) {
        return [NSString stringWithFormat:@"%dd", (int)(delta / 60.0 / 60.0 / 24.0)];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}

+ (NSString *)shortedNumberDesc:(NSUInteger)number {
    if (number <= 999) return [NSString stringWithFormat:@"%d",(int)number];
    if (number <= 9999) return [NSString stringWithFormat:@"%d,%3.3d",(int)(number / 1000), (int)(number % 1000)];
    if (number < 1000 * 1000) return [NSString stringWithFormat:@"%.1fK", number / 1000.0];
    if (number < 1000 * 1000 * 1000) return [NSString stringWithFormat:@"%.1fM", number / 1000.0 / 1000.0];
    return [NSString stringWithFormat:@"%.1fB", number / 1000.0 / 1000.0 / 1000.0];
}

@end
