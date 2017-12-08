//
//  CommonCellLayout.h
//  Action
//
//  Created by 鸟神 on 2016/9/23.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCellModel.h"


#define kCCPadding 12
#define kCCInnerPadding 7
#define kCCAvatarSize 44
#define kCCAvatarBorderWidth 1
#define kCCContentLeft (kCCPadding + kCCAvatarSize + kCCInnerPadding)
#define kCCContentWidth (kScreenWidth - 2 * kCCPadding - kCCAvatarSize - kCCInnerPadding)
#define kCCTextContainerInset 4
#define kCCArrawSizeW 8
#define kCCArrawSizeH 12

#define kCCNameFontSize 14
#define kCCTextFontSize 14
#define kCCTextLineSpace 4

#define kCCTopLineColor [UIColor colorWithWhite:0.82 alpha:1.0]
#define kCCBGHighlightColor [UIColor colorWithWhite:0.000 alpha:0.034]
#define kCCNameColor [UIColor colorWithHue:204.0/360.0 saturation:0.18 brightness:0.18 alpha:1.0]
#define kCCTextColor [UIColor colorWithHue:204.0/360.0 saturation:0.18 brightness:0.666 alpha:1.0]

@interface CommonCellLayout : NSObject

@property (nonatomic, strong) CommonCellModel *model;

@property (nonatomic) BOOL showArraw;
@property (nonatomic) BOOL showTopLine;
@property (nonatomic) BOOL webImage;
@property (nonatomic) BOOL roundImg;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat textTop;
@property (nonatomic, assign) CGFloat textHeight;

@property (nonatomic, strong) YYTextLayout *nameTextLayout;
@property (nonatomic, strong) YYTextLayout *dateTextLayout;
@property (nonatomic, strong) YYTextLayout *textLayout;

@property (nonatomic, readonly) CommonCellModel *displayedModel;

@end

