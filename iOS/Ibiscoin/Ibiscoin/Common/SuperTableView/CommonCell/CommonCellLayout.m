//
//  CommonCellLayout.m
//  Action
//
//  Created by 鸟神 on 2016/9/23.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "CommonCellLayout.h"
#import "CellHelper.h"


@implementation CommonCellLayout

- (void)setModel:(CommonCellModel *)model {
    if (_model != model) {
        _model = model;
        [self layout];
    }
}

- (void)layout {
    [self reset];
    if (!_model) {
        return;
    }
    
    CommonCellModel *model = self.displayedModel;
    
    UIFont *nameFont = [UIFont systemFontOfSize:kCCNameFontSize weight:UIFontWeightMedium];
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:(model.name ? model.name : @"")];
    nameText.font = nameFont;
    nameText.color = kCCNameColor;
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *nameContainer = [YYTextContainer containerWithSize:CGSizeMake(kCCContentWidth - _dateTextLayout.textBoundingRect.size.width, kCCNameFontSize * 2)];
    nameContainer.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameText];
    
    
    YYTextContainer *textContainer = [YYTextContainer containerWithSize:CGSizeMake(kCCContentWidth + 2 * kCCTextContainerInset, CGFLOAT_MAX)];
    textContainer.insets = UIEdgeInsetsMake(0, 0, 0, kCCTextContainerInset);
    _textLayout = [YYTextLayout layoutWithContainer:textContainer text:[self textForModel:model]];

    _paddingTop = kCCPadding;
    
    _textTop = _paddingTop + kCCNameFontSize + kCCInnerPadding;
    _textHeight = _textLayout ? (CGRectGetMaxY(_textLayout.textBoundingRect)) : 0;
    
    CGFloat height = 0;
    height = _textTop + _textHeight;
    if (height < _paddingTop + kCCAvatarSize) {
        height = _paddingTop + kCCAvatarSize;
    }
    height += kCCPadding;
    _height = height;
}

- (void)reset {
    _height = 0;
    _paddingTop = 0;
    _textTop = 0;
    _textHeight = 0;
    
    _showTopLine = NO;
    _showArraw = NO;
    _nameTextLayout = nil;
    _dateTextLayout = nil;
    _textLayout = nil;
}

- (NSAttributedString *)textForModel:(CommonCellModel *)model{
    if (model.text.length == 0) return nil;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.text];
    text.font = [UIFont systemFontOfSize:kCCTextFontSize];
    text.color = kCCTextColor;
    text.lineSpacing = kCCTextLineSpace;
    
    return text;
}

- (CommonCellModel *)displayedModel {
    return _model;
}



@end
