//
//  CommonCell.m
//  Action
//
//  Created by 鸟神 on 2016/9/22.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "CommonCell.h"

@implementation CommonCellView

- (instancetype)init {
    self = [super init];
//    自定义点击效果用这两行
    self.width = kScreenWidth;
    self.backgroundColor = [UIColor whiteColor];
    self.exclusiveTouch = YES;
    self.clipsToBounds = YES;
//    自带点击效果用这两行，通常适用于选择态
    //    self.width = kScreenWidth;
    //    self.backgroundColor = [UIColor clearColor];
    //    self.userInteractionEnabled = NO;
    //    self.clipsToBounds = YES;
    
    _avatarView = [YYControl new];
    _avatarView.clipsToBounds = YES;
    _avatarView.backgroundColor = [UIColor clearColor];
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarView.left = kCCPadding;
    _avatarView.size = CGSizeMake(kCCAvatarSize, kCCAvatarSize);
    _avatarView.exclusiveTouch = YES;
    [self addSubview:_avatarView];
    
    _avatarBorder = [CALayer layer];
    _avatarBorder.frame = _avatarView.bounds;
    _avatarBorder.width += 2*CGFloatFromPixel(kCCAvatarBorderWidth);
    _avatarBorder.centerX -= CGFloatFromPixel(kCCAvatarBorderWidth);
    _avatarBorder.height += 2*CGFloatFromPixel(kCCAvatarBorderWidth);
    _avatarBorder.centerY -= CGFloatFromPixel(kCCAvatarBorderWidth);
    _avatarBorder.borderWidth = 2*CGFloatFromPixel(kCCAvatarBorderWidth);
    _avatarBorder.borderColor = kAvatarDefaultBorderColor.CGColor;
    _avatarBorder.cornerRadius = kCCAvatarSize/2;
    _avatarBorder.shouldRasterize = YES;
    _avatarBorder.allowsEdgeAntialiasing = YES;//反锯齿
    _avatarBorder.rasterizationScale = kScreenScale;
    _avatarBorder.hidden = YES;
    [_avatarView.layer addSublayer:_avatarBorder];
    
    _nameLabel = [YYLabel new];
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.left = kCCContentLeft;
    _nameLabel.width = kCCContentWidth;
    _nameLabel.height = kCCNameFontSize * 2;
    _nameLabel.userInteractionEnabled = NO;
    _nameLabel.exclusiveTouch = YES;
    [self addSubview:_nameLabel];
    
    _dateLabel = [YYLabel new];
    _dateLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _dateLabel.displaysAsynchronously = YES;
    _dateLabel.ignoreCommonProperties = YES;
    _dateLabel.fadeOnHighlight = NO;
    _dateLabel.fadeOnAsynchronouslyDisplay = NO;
    _dateLabel.frame = _nameLabel.frame;
    _dateLabel.userInteractionEnabled = NO;
    [self addSubview:_dateLabel];
    
    _textLabel = [YYLabel new];
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnHighlight = NO;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.left = kCCContentLeft;
    _textLabel.width = kCCContentWidth;
    __weak typeof(self) _self = self;
    _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [_self.cell.delegate cell:_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [self addSubview:_textLabel];
    
    _arrawImg = [YYControl new];
    _arrawImg.clipsToBounds = YES;
    _arrawImg.backgroundColor = [UIColor clearColor];
    _arrawImg.contentMode = UIViewContentModeScaleAspectFit;
    _arrawImg.size = CGSizeMake(kCCArrawSizeW, kCCArrawSizeH);
    _arrawImg.left = screenWidth - kCCArrawSizeW -kCCPadding;
    [self addSubview:_arrawImg];
    
    _topLine = [UIView new];
    _topLine.width = kScreenWidth;
    _topLine.height = CGFloatFromPixel(1);
    _topLine.backgroundColor = kCCTopLineColor;
    [self addSubview:_topLine];
    
    @weakify(self);
    self.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (!self) return;
        if (state == YYGestureRecognizerStateBegan) {
            self.backgroundColor = kCCBGHighlightColor;
        } else if (state != YYGestureRecognizerStateMoved) {
            self.backgroundColor = [UIColor whiteColor];
        }
        
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *t = touches.anyObject;
            CGPoint p = [t locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                if ([self.cell.delegate respondsToSelector:@selector(cell:didClickContentWithLongPress:)]) {
                    [self.cell.delegate cell:self.cell didClickContentWithLongPress:NO];
                }
            }
        }
    };
    
    
    _avatarView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (!self) return;
        if (state == YYGestureRecognizerStateBegan) {
            self.backgroundColor = kCCBGHighlightColor;
        } else if (state != YYGestureRecognizerStateMoved) {
            self.backgroundColor = [UIColor whiteColor];
        }
        
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *t = touches.anyObject;
            CGPoint p = [t locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                if ([self.cell.delegate respondsToSelector:@selector(cell:didClickAvatarWithLongPress:)]) {
                    [self.cell.delegate cell:self.cell didClickAvatarWithLongPress:NO];
                }
            }
        }
    };
    return self;
}

- (void)setWithLayout:(CommonCellLayout *)layout {
    self.height = layout.height;
    self.topLine.hidden = !layout.showTopLine;
    self.arrawImg.hidden = !layout.showArraw;
    
    if (_avatarView.hidden) {
        _avatarView.hidden = NO;
        _nameLabel.hidden = NO;
        _dateLabel.hidden = NO;
    }
    
    CommonCellModel *model = layout.displayedModel;
    _avatarView.top = layout.paddingTop;
    if (layout.webImage) {
        NSURL *imgUrl = [NSURL URLWithString:layout.model.icon];
        [_avatarView.layer setImageWithURL:imgUrl
                                    placeholder:nil
                                        options:YYWebImageOptionSetImageWithFadeAnimation
                                   manager:layout.roundImg?[CellHelper avatarImageManager]:nil //< 圆角头像manager，内置圆角处理
                                       progress:nil
                                      transform:nil
                                     completion:nil];
    }else{
        UIImage *img = [UIImage imageNamed:model.icon];
        _avatarView.image = layout.roundImg?[img imageByRoundCornerRadius:HUGE]:img;
    }
    
    if (layout.roundImg) {
        _avatarBorder.hidden = NO;
    }
    
    _arrawImg.centerY = self.height/2;
    _arrawImg.image = [UIImage imageNamed:@"iconCellArrow"];
    
    _nameLabel.centerY = layout.paddingTop + kCCTextFontSize / 2;
    _nameLabel.textLayout = layout.nameTextLayout;
    
    _dateLabel.centerY = _nameLabel.centerY;
    _dateLabel.textLayout = layout.dateTextLayout;
    
    if (layout.textLayout) {
        _textLabel.hidden = NO;
        _textLabel.top = layout.textTop;
        _textLabel.height = layout.textHeight;
        _textLabel.textLayout = layout.textLayout;
    } else {
        _textLabel.hidden = YES;
    }
}

- (void)setCell:(CommonCell *)cell {
    _cell = cell;
}
@end

@implementation CommonCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    _statusView = [CommonCellView new];
    _statusView.cell = self;
    
    [self.contentView addSubview:_statusView];
    
//    自定义点击效果使用这两行
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
//    自带点击效果用这两行，通常适用于选择态
    //    self.backgroundColor = [UIColor whiteColor];
    //    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    
    return self;
}

- (void)setLayout:(CommonCellLayout *)layout {
    _layout = layout;
    self.contentView.height = layout.height;
    _statusView.height = layout.height;
    [_statusView setWithLayout:layout];
}
@end
