//
//  MyRoleCellLayout.m
//  Action
//
//  Created by 鸟神 on 2017/5/31.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "MyRoleCellLayout.h"

@implementation MyRoleCellLayout

- (instancetype)initWithRole:(RoleModel *)role user:(UserModel *)user coin:(CoinModel *)coin{
    if (isNull(role)) return nil;
    if (isNull(user)) return nil;
    if (isNull(coin)) return nil;
    self = [super init];
    _roleModel = role;
    _userModel = user;
    _coinModel = coin;
    [self layout];
    return self;
}

- (void)layout {
    [self _layout];
}

- (void)_layout {
    _marginTop = 0;
    _nameBottomHeight = 0;
    _detailTextHeight = 0;
    _picHeight = 0;
    _attrHeight = 0;
    _attrHeight2 = 0;
    _marginBottom = kMyRoleCellBottomMargin;
    
    //排版
    [self _layoutHeader];
    [self _layoutDetails];
//    [self _layoutPics];
    [self _layoutAttr1];
    [self _layoutAttr2];
    [self _layoutTime];
    
    // 计算高度
    _height = 0;
    _height += _marginTop;
    _height += _nameBottomHeight;
    _height += _detailTextHeight;
    _height += _attrHeight;
    _height += _attrHeight2;
    _height += _timeHeight;
    if (_picHeight > 0) {
        _height += _picHeight;
        _height += kMyRoleCellContentRightPadding;
    }
    _height += _marginBottom;
}

- (void)_layoutHeader {
    [self _layoutName];
    [self _layoutTag];
    
    _nameBottomHeight = kMyRoleCellNameBottomHeight;
}

//昵称
- (void)_layoutName{
    UserModel *user = _userModel;
    RoleModel *role = _roleModel;
    CoinModel *coin = _coinModel;
    if (role.name.length == 0) {
        _nameTextLayout = nil;
        return;
    }
    
    NSMutableAttributedString *strCoin = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@币",coin.alias]];
    strCoin.font = [UIFont systemFontOfSize:kMyRoleCellCoinNameFontSize weight:UIFontWeightMedium];
    strCoin.color = [UIColor blackColor];
    strCoin.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *strName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@",role.name]];
    strName.font = [UIFont systemFontOfSize:kMyRoleCellNameFontSize weight:UIFontWeightUltraLight];
    if (role.sponsor == YES) {
        strName.color = kColorMainYellow;//app赞助者为黄色昵称
    }else if (user.founder == YES){
        strName.color = kColorMainRed3;//app发起人为红色昵称
    }else{
        strName.color = kColorDarkGray2;
    }
    strName.lineBreakMode = NSLineBreakByTruncatingTail;
    [strCoin appendAttributedString:strName];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kMyRoleCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:strCoin];
}

//鸟币信用
- (void)_layoutTag{
    CoinModel *coin = _coinModel;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",coin.creditLevel]];
    str.font = [UIFont systemFontOfSize:kMyRoleCellTagFontSize weight:UIFontWeightUltraLight];
    str.color = kColorGray2;
    str.alignment = NSTextAlignmentCenter;
    
    YYTextBorder *border = [YYTextBorder new];
    border.strokeColor = kColorGray2;
    border.strokeWidth = 0.5;
    border.lineStyle = YYTextLineStyleSingle;
    border.insets = UIEdgeInsetsMake(-0.5, -2, -1, -1.5);
    str.textBackgroundBorder = border;
    
    RoleCellTextLinePositionModifier *modifier = [RoleCellTextLinePositionModifier new];
    modifier.font = [UIFont systemFontOfSize:kMyRoleCellTagFontSize weight:UIFontWeightUltraLight];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kMyRoleCellTagWidth, 9999)];
    container.linePositionModifier = modifier;
    container.maximumNumberOfRows = 1;
    
    _tagTextLayout = [YYTextLayout layoutWithContainer:container text:str];
}


//描述
- (void)_layoutDetails{
    _detailTextHeight = 0;
    _detailTextLayout = nil;
    
    NSString *strDetail = [NSString stringWithFormat:@"%@",_roleModel.descCutoff];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:strDetail];
    text.font = [UIFont systemFontOfSize:kMyRoleCellContentFontSize weight:UIFontWeightRegular];
    text.color = kColorDarkGray2;
//    text.kern = [NSNumber numberWithFloat:0.4];
//    text.alignment = NSTextAlignmentJustified;
    
    if (text.length == 0) return;
    
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kColorGray3;
    
    // 匹配 ＃标签
    NSArray *tagResults = [RX(@"[#@]\\w\\S*\\b") matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    for (NSTextCheckingResult *tag in tagResults) {
        if (tag.range.location == NSNotFound && tag.range.length <= 1) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:tag.range.location] == nil) {
            [text setColor:kColorGray2 range:tag.range];
            [text setFont:[UIFont systemFontOfSize:kMyRoleCellContentFontSize weight:UIFontWeightLight] range:tag.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{@"kMyRoleCellDescTagKey" : [text.string substringWithRange:NSMakeRange(tag.range.location + 1, tag.range.length - 1)]};
            [text setTextHighlight:highlight range:tag.range];
        }
    }
    
    
    RoleCellTextLinePositionModifier *modifier = [RoleCellTextLinePositionModifier new];
    modifier.font = [UIFont systemFontOfSize:kMyRoleCellContentFontSize weight:UIFontWeightRegular];
    modifier.paddingTop = kMyRoleCellPaddingText;
    modifier.paddingBottom = kMyRoleCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kMyRoleCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    _detailTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_detailTextLayout) return;
    
    _detailTextHeight = [modifier heightForLineCount:_detailTextLayout.lines.count];
}

//属性1
- (void)_layoutAttr1{
    NSArray *arrPower = [_roleModel.power componentsSeparatedByString:@","];
    NSString *power = arrPower.count>0?[arrPower objectAtIndex:0]:_roleModel.power;
    
    NSString *strNote = [NSString stringWithFormat:@"擅长 • %@",power];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:strNote];
    text.font = [UIFont systemFontOfSize:kMyRoleCellAttrFontSize weight:UIFontWeightUltraLight];
    text.color = kColorGray1;
    text.lineBreakMode = NSLineBreakByTruncatingTail;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kMyRoleCellContentWidth, 999);
    container.maximumNumberOfRows = 1;
    _attrLayout = [YYTextLayout layoutWithContainer:container text:text];
    _attrHeight = kMyRoleCellPadding+kMyRoleCellPaddingText;
}

//属性2
-(void)_layoutAttr2{
    NSString *strNote;
    if (_roleModel.foundedMonthy>0) {
        strNote = [NSString stringWithFormat:@"收入%ld鸟币/月",(long)_roleModel.foundedMonthy];
    }else{
        NSArray *arrPassion = [_roleModel.passion componentsSeparatedByString:@","];
        if(arrPassion.count>0){
            strNote = [NSString stringWithFormat:@"热爱 • %@",[arrPassion objectAtIndex:0]];
        }else{
            strNote = [NSString stringWithFormat:@"坐标 • %@",_roleModel.city];
        }
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", strNote]];
    text.font = [UIFont systemFontOfSize:kMyRoleCellAttrFontSize weight:UIFontWeightUltraLight];
    text.color = kColorGray1;
    text.lineBreakMode = NSLineBreakByTruncatingTail;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kMyRoleCellContentWidth, 999);
    container.maximumNumberOfRows = 1;
    _attrLayout2 = [YYTextLayout layoutWithContainer:container text:text];
    _attrHeight2 = kMyRoleCellPadding+kMyRoleCellPaddingText;
}

- (void)_layoutTime{
    NSString *timeAgo = _roleModel.updateTimeAgo;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:timeAgo];
    text.font = [UIFont systemFontOfSize:kMyRoleCellTimeFontSize weight:UIFontWeightUltraLight];
    text.color = kColorGray1;
    text.lineBreakMode = NSLineBreakByTruncatingTail;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kMyRoleCellContentWidth-64, 999);
    container.maximumNumberOfRows = 1;
    _timeLayout = [YYTextLayout layoutWithContainer:container text:text];
    _timeHeight = 30;
}


//图片
- (void)_layoutPics {
    _picSize = CGSizeZero;
    _picHeight = 0;
    
    if (isNullString(_coinModel.qrCode.largest.pid)) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = (kMyRoleCellContentWidth + kMyRoleCellPaddingPic) / 3 - kMyRoleCellPaddingPic;
    len1_3 = CGFloatPixelRound(len1_3);
//    if (_feedType == 0) {
//        //只显示1、2、4、9四种图片排列
//        switch (_skill.pics.count) {
//            case 1: {
//                Pic *pic = _skill.pics.firstObject;
//                PicMeta *middle = pic.middle;
//                if (pic.keepSize || middle.width < 1 || middle.height < 1) {
//                    CGFloat maxLen = kMyRoleCellContentWidth;
//                    maxLen = CGFloatPixelRound(maxLen);
//                    picSize = CGSizeMake(maxLen, maxLen);
//                    picHeight = maxLen;
//                } else {
//                    CGFloat maxLen = kMyRoleCellContentWidth;
//                    if (middle.width <= middle.height) {
//                        picSize.width = (float)middle.width / (float)middle.height * maxLen;
//                        picSize.height = maxLen*0.75;
//                    } else {
//                        picSize.width = maxLen;
//                        picSize.height = (float)middle.height / (float)middle.width * maxLen;
//                    }
//                    picSize = CGSizePixelRound(picSize);
//                    picHeight = picSize.height;
//                }
//            } break;
//            case 2: case 3:{
//                CGFloat maxLen = kMyRoleCellContentWidth;
//                CGFloat halfLen = CGFloatPixelRound((maxLen-kMyRoleCellPaddingPic)/2);
//                CGFloat height = CGFloatPixelRound(maxLen*0.5625);//16:9
//                picSize = CGSizeMake(halfLen, height);
//                picSize = CGSizePixelRound(picSize);
//                picHeight = height;
//            } break;
//                //            case 3: {
//                //                CGFloat maxLen = kMyRoleCellContentWidth;
//                //                CGFloat height = CGFloatPixelRound(maxLen*9/16);
//                //                picSize = CGSizeMake(len1_3, height);
//                //                picHeight = height;
//                //            } break;
//                //            case 5: case 6: {
//                //                picSize = CGSizeMake(len1_3, len1_3);
//                //                picHeight = len1_3 * 2 + kMyRoleCellPaddingPic;
//                //            } break;
//            case 9:{
//                picSize = CGSizeMake(len1_3, len1_3);
//                picHeight = len1_3 * 3 + kMyRoleCellPaddingPic * 2;
//            }break;
//
//            default: { // 4、5、6、7, 8
//                CGFloat maxLen = kMyRoleCellContentWidth;
//                CGFloat halfLen = CGFloatPixelRound((maxLen-kMyRoleCellPaddingPic)/2);
//                //                CGFloat height = CGFloatPixelRound(maxLen*0.61);
//                CGFloat height = CGFloatPixelRound(maxLen);
//                CGFloat halfHeight = CGFloatPixelRound(height/2);
//                picSize = CGSizeMake(halfLen, halfHeight);
//                picSize = CGSizePixelRound(picSize);
//                picHeight = height;
//            } break;
//        }
//    }else{
        Pic *pic = _coinModel.qrCode;
        PicMeta *middle = pic.largest;
        if (pic.keepSize || middle.width < 1 || middle.height < 1) {
            CGFloat maxLen = kMyRoleCellContentWidth;
            maxLen = CGFloatPixelRound(maxLen);
            picSize = CGSizeMake(maxLen, maxLen);
            picHeight = maxLen;
        } else {
            CGFloat maxLen = kMyRoleCellContentWidth;
            if (middle.width <= middle.height) {
                picSize.width = (float)middle.width / (float)middle.height * maxLen;
                picSize.height = maxLen*0.618;
            } else {
                picSize.width = maxLen;
                picSize.height = (float)middle.height / (float)middle.width * maxLen;
            }
            picSize = CGSizePixelRound(picSize);
            picHeight = picSize.height;
        }
//    }
    
    _picSize = picSize;
    _picHeight = picHeight;
}


@end
