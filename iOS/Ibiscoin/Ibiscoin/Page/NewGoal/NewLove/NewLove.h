//
//  NewLove.h
//  Action
//
//  Created by 鸟神 on 2017/2/15.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "LoveModel.h"

@interface NewLove : XLFormViewController

@property (nonatomic) BOOL isPresented;
@property (nonatomic) BOOL isEdit;

@property (nonatomic, strong) LoveModel *loveModel;

@property (nonatomic, copy) void (^saveBack)(BOOL refresh,int refreshTab);

@end
