//
//  Pic.h
//  Action
//
//  Created by caokun on 16/2/15.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicMeta : NSObject
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *format;
@property (nonatomic) uint width;
@property (nonatomic) uint height;
//for display
@property (nonatomic, strong) NSString *urlSuffix;
@property (nonatomic, strong) NSURL *url; //Full image url
@end

@interface Pic : NSObject
@property (nonatomic, strong) PicMeta *thumbnail;
@property (nonatomic, strong) PicMeta *middle;
@property (nonatomic, strong) PicMeta *large;
@property (nonatomic, strong) PicMeta *largest;
//for display
@property (nonatomic) BOOL keepSize; //YES:固定为方形 NO:原始宽高比
@end
