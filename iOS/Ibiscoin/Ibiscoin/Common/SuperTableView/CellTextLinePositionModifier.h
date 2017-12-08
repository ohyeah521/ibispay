//
//  CellTextLinePositionModifier.h
//  Action
//
//  Created by 鸟神 on 2017/6/8.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#define lineHeightRoleCell 1.47 //16号字=29像素高 29/47=0.618
#define lineHeightCommonCell 1.48

@interface CellTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end

@interface RoleCellTextLinePositionModifier : CellTextLinePositionModifier
@end

@interface CommonCellTextLinePositionModifier : CellTextLinePositionModifier
@end
