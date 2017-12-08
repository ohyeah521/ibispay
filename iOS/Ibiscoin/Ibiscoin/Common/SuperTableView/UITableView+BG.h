//
//  UITableView+BG.h
//  Action
//
//  Created by 鸟神 on 2017/5/16.
//  Copyright © 2017年 xingdongpai.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>

@interface UITableView (BG)

- (void)tableEmptyBGImg:(NSString *)imgName title:(NSString *)title txt:(NSString *)txt withRowCount:(NSUInteger)count;
- (void)tableEmptyBGImg:(NSString *)imgName title:(NSString *)title txt:(NSString *)txt withRowCount:(NSUInteger)count andShoudBe:(NSUInteger)count0;

@end


/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface TableBGTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end
