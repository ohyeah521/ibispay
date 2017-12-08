//
//  LogEditor.h
//  Action
//
//  Created by 鸟神 on 2017/2/15.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoveLogEditor : UIViewController<XLFormRowDescriptorViewController>

@property (nonatomic) BOOL isEdit;
@property (nonatomic, strong) NSString *loveID;

@property (nonatomic, strong) NSString *desc;

@end
