//
//  CellTextLinePositionModifier.m
//  Action
//
//  Created by 鸟神 on 2017/6/8.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "CellTextLinePositionModifier.h"

/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，(0.86 ascent, 0.14 descent)
 但是在 PingFang SC 中，ascent + descent > font size。
 间距仍然用字体默认
 */
@implementation CellTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    // for PingFang SC
    _lineHeightMultiple = 1.34;
    // for Heiti SC
    //_lineHeightMultiple = 1.3125;
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    CGFloat ascent = _font.ascender;
    
    // for PingFang SC
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    // for Heiti SC
    //CGFloat ascent = _font.pointSize * 0.86;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    CellTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    
    // for PingFang SC
    CGFloat ascent = _font.ascender;
    CGFloat descent = -_font.descender;
    // for Heiti SC
    //CGFloat ascent = _font.pointSize * 0.86;
    //CGFloat descent = _font.pointSize * 0.14;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}
@end



@implementation RoleCellTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    // for PingFang SC
    self.lineHeightMultiple = lineHeightRoleCell;
    
    return self;
}
@end

@implementation CommonCellTextLinePositionModifier
- (instancetype)init {
    self = [super init];
    
    // for PingFang SC
    self.lineHeightMultiple = lineHeightCommonCell;
    
    return self;
}
@end
