//
//  CommonSectionModel.m
//  Action
//
//  Created by 鸟神 on 2016/9/23.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "CommonSectionModel.h"
#import "CommonCellModel.h"

@implementation CommonSectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cells" : [CommonCellModel class] };
}
@end
