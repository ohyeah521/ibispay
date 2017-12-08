//
//  UITableView+BG.m
//  Action
//
//  Created by 鸟神 on 2017/5/16.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "UITableView+BG.h"

@implementation UITableView (BG)

- (void)tableEmptyBGImg:(NSString *)imgName title:(NSString *)title txt:(NSString *)txt withRowCount:(NSUInteger)count{
    [self tableEmptyBGImg:imgName title:title txt:txt withRowCount:count andShoudBe:0];
}

- (void)tableEmptyBGImg:(NSString *)imgName title:(NSString *)title txt:(NSString *)txt withRowCount:(NSUInteger)count andShoudBe:(NSUInteger)count0{
    if (count == count0) {
        //Controlling the Background of a UITableView
        //setting an image as the background of UITableView through four steps
        
        //1.set backgroundColor property of tableView to clearColor, so that background image is visible
        [self setBackgroundColor:[UIColor clearColor]];
        
        //2.add title
        UILabel *lblTitle = [self addTitle:title];
        
        //3.add text
        YYLabel *lbl = [self addText:txt];
        
        //4.create an UIImageView that you want to appear behind the table
        if (isNullString(imgName)) {
            imgName = @"emptyTableBG";
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        
        //5.boxView+layout
        UIView *boxView = [UIView new];
        boxView.width = screenWidth;
        boxView.height = imageView.height+lblTitle.height+lbl.height;
        
        boxView.backgroundColor = [UIColor clearColor];
        [boxView addSubview:imageView];
        [boxView addSubview:lblTitle];
        [boxView addSubview:lbl];
        imageView.centerX = boxView.centerX;
        lblTitle.top = imageView.bottom+20;
        lblTitle.centerX = boxView.centerX;
        lbl.top = lblTitle.bottom;
        
        //replace backgroundView
        UIView *tableBackgroundView = [UIView new];
        tableBackgroundView.frame = self.frame;
        [tableBackgroundView addSubview:boxView];
        boxView.center = tableBackgroundView.center;
        
        self.backgroundView = tableBackgroundView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}


//======private func=========

- (UILabel *)addTitle:(NSString *)title{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:21.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithWhite:0.333 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraph};
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.attributedText = attrStr;
    [lblTitle sizeToFit];
    
    return lblTitle;
}

- (YYLabel *)addText:(NSString *)txt{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:txt];
    text.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    text.color = [UIColor colorWithWhite:0.5625 alpha:1.0];
    text.alignment = NSTextAlignmentCenter;
    
    if (text.length == 0) return nil;
    
    TableBGTextLinePositionModifier *modifier = [TableBGTextLinePositionModifier new];
    modifier.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    modifier.paddingTop = 10;
    modifier.paddingBottom = 10;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(screenWidth*0.764, HUGE);
    container.linePositionModifier = modifier;
    
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!textLayout) return nil;
    
    CGFloat height = [modifier heightForLineCount:textLayout.lines.count];
    
    YYLabel *lbl = [YYLabel new];
    lbl.left = screenWidth*0.236/2;
    lbl.width = screenWidth*0.764;
    lbl.height = height;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    lbl.displaysAsynchronously = YES;
    lbl.ignoreCommonProperties = NO;
    lbl.fadeOnAsynchronouslyDisplay = NO;
    lbl.fadeOnHighlight = NO;
    lbl.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
    };
    lbl.textLayout = textLayout;
    return lbl;
}


@end



/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation TableBGTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    if (kiOS9Later) {
        //        _lineHeightMultiple = 1.34;   // for PingFang SC
        _lineHeightMultiple = 1.48;
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    CGFloat ascent = _font.ascender;
    //    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    TableBGTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    CGFloat ascent = _font.ascender;
    CGFloat descent = -_font.descender;
    //    CGFloat ascent = _font.pointSize * 0.86;
    //    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end
