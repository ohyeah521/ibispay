//
//  Pic.m
//  Action
//
//  Created by caokun on 16/2/15.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "PicModel.h"

@implementation PicMeta

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"width" : @"w", @"height" : @"h", @"format": @"f"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _urlSuffix = getUserImageSuffix(_pid,_format);
    return YES;
}
@end

@implementation Pic


@end

