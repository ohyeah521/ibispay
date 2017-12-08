//
//  MyRoleCell.h
//  Action
//
//  Created by 鸟神 on 2017/5/30.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "YYTableViewCell.h"
#import "MyRoleCellLayout.h"
#import "YYControl.h"
#import "CellHelper.h"

@protocol MyRoleCellDelegate;
@class MyRoleCellHeader;
@class MyRoleCellView;

@interface MyRoleCell : YYTableViewCell
@property (nonatomic, weak) id<MyRoleCellDelegate> delegate;
@property (nonatomic, strong) MyRoleCellView *cellView;
- (void)setLayout:(MyRoleCellLayout *)layout;
@end

@interface MyRoleCellHeader : UIView
@property (nonatomic, strong) UIImageView *imgAvatar;   //头像
@property (nonatomic, strong) UIImageView *imgVerify;   //真人照片标示
@property (nonatomic, strong) YYLabel *lblName;         //昵称
@property (nonatomic, strong) YYLabel *lblTag;          //标签

@property (nonatomic, assign) UserType userType;        //用户类型
@property (nonatomic, weak) MyRoleCell *cell;
@end

@interface MyRoleCellView : UIView
@property (nonatomic) BOOL isTouchMoving;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) MyRoleCellHeader *header;

@property (nonatomic, strong) YYLabel *lblDetail;       //描述
@property (nonatomic, strong) UIView *picBGView;        //图片的背景和圆角
@property (nonatomic, strong) NSArray *picViews;        //图片1-9张 //Array<UIImageView>
@property (nonatomic, strong) YYLabel *lblAttr1;        //属性1
@property (nonatomic, strong) YYLabel *lblAttr2;        //属性2
@property (nonatomic, strong) YYLabel *lblTime;         //更新时间
@property (nonatomic, strong) UIButton *button;         //按钮

@property (nonatomic, strong) MyRoleCellLayout *layout;
@property (nonatomic, weak) MyRoleCell *cell;
@end

@protocol MyRoleCellDelegate <NSObject>
@optional
//点击了Cell
- (void)cellDidClick:(MyRoleCell *)cell;
//点击了用户
- (void)cell:(MyRoleCell *)cell didClickUser:(UserModel *)user;
//点击了图片
- (void)cell:(MyRoleCell *)cell didClickImageAtIndex:(NSUInteger)index;
//点击了按钮
- (void)cellDidClickBuy:(MyRoleCell *)cell;
//点击了链接
- (void)cell:(MyRoleCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
@end

