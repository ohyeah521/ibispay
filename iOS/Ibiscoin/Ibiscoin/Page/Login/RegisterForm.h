//
//  RegisterForm.h
//  Action
//
//  Created by caokun on 16/1/8.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import <XLForm/XLForm.h>

@interface RegisterForm : XLFormViewController

@property (nonatomic, copy) void (^back)(BOOL autoLogin,NSString *pwd);

@end
