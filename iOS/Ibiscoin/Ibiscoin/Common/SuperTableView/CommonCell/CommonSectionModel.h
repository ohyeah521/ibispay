//
//  CommonSectionModel.h
//  Action
//
//  Created by 鸟神 on 2016/9/23.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonSectionModel: NSObject

@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *footer;
@property (nonatomic, strong) NSArray *cells;

@property (nonatomic, strong) NSArray *cellLayouts;

@end
