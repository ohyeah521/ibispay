//
//  CommonCell.h
//  Action
//
//  Created by 鸟神 on 2016/9/22.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYControl.h"
#import "YYTableViewCell.h"

#import "CommonCellLayout.h"

@class CommonCell;

@interface CommonCellView : YYControl
@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) YYControl *avatarView;
@property (nonatomic, strong) CALayer *avatarBorder;
@property (nonatomic, strong) YYControl *arrawImg;

@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *dateLabel;
@property (nonatomic, strong) YYLabel *textLabel;

@property (nonatomic, weak) CommonCell *cell;
@end

@protocol CommonCellDelegate <NSObject>
@optional
- (void)cell:(CommonCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
- (void)cell:(CommonCell *)cell didClickAvatarWithLongPress:(BOOL)longPress;
- (void)cell:(CommonCell *)cell didClickContentWithLongPress:(BOOL)longPress;
@end

//带头像的基本Cell
@interface CommonCell : YYTableViewCell
@property (nonatomic, strong) CommonCellView *statusView;
@property (nonatomic, strong) CommonCellLayout *layout;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic, weak) id<CommonCellDelegate> delegate;
@end


