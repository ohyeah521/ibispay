//
//  SkillForm.h
//  Action
//
//  Created by 鸟神 on 2016/10/5.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "SkillModel.h"

@interface NewSkill : XLFormViewController

@property (nonatomic) BOOL isPresented;
@property (nonatomic) BOOL isFormSkillList;
@property (nonatomic) BOOL isEdit;
@property (nonatomic, strong) SkillModel *skill;

@property (nonatomic, copy) void (^saveBack)(BOOL refresh,int refreshTab);

@end
