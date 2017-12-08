//
//  RoleCell.m
//  Action
//
//  Created by 鸟神 on 2017/5/30.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "RoleCell.h"

@implementation RoleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _cellView = [RoleCellView new];
    _cellView.cell = self;
    _cellView.header.cell = self;
    [self.contentView addSubview:_cellView];
    return self;
}

- (void)setLayout:(RoleCellLayout *)layout {
    self.height = layout.height;
    self.contentView.height = layout.height;
    _cellView.layout = layout;
}

@end



@implementation RoleCellHeader{
    BOOL _trackingTouch;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = 70;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    @weakify(self);
    
    _imgAvatar = [UIImageView new];
    _imgAvatar.size = CGSizeMake(kRoleCellAvatarHeight, kRoleCellAvatarHeight);
    _imgAvatar.origin = CGPointMake(kRoleCellAvatarPadding, kRoleCellAvatarPadding);
    _imgAvatar.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imgAvatar];
    
    CALayer *avatarBorder = [CALayer layer];
    avatarBorder.frame = _imgAvatar.bounds;
    avatarBorder.width += 2*CGFloatFromPixel(kRoleCellAvatarBorderWidth);
    avatarBorder.centerX -= CGFloatFromPixel(kRoleCellAvatarBorderWidth);
    avatarBorder.height += 2*CGFloatFromPixel(kRoleCellAvatarBorderWidth);
    avatarBorder.centerY -= CGFloatFromPixel(kRoleCellAvatarBorderWidth);
    avatarBorder.borderWidth = 2*CGFloatFromPixel(kRoleCellAvatarBorderWidth);
    avatarBorder.borderColor = kRoleCellAvatarBorderColor;
    avatarBorder.cornerRadius = avatarBorder.width/2;
    avatarBorder.shouldRasterize = YES;
    avatarBorder.allowsEdgeAntialiasing = YES;
    avatarBorder.rasterizationScale = kScreenScale;
    [_imgAvatar.layer addSublayer:avatarBorder];
    
    _imgVerify = [UIImageView new];
    _imgVerify.size = CGSizeMake(kRoleCellVerifyImgWidth, kRoleCellVerifyImgWidth);
    _imgVerify.center = CGPointMake(_imgAvatar.right - kRoleCellVerifyImgWidth/2+kRoleCellAvatarBorderWidth, _imgAvatar.bottom - kRoleCellVerifyImgWidth/2+kRoleCellAvatarBorderWidth);
    _imgVerify.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imgVerify];
    
    _lblName = [YYLabel new];
    _lblName.size = CGSizeMake(kRoleCellNameWidth, kRoleCellCoinNameFontSize);
    _lblName.left = _imgAvatar.right + kRoleCellNamePaddingLeft;
    _lblName.top = _imgAvatar.top;
    _lblName.displaysAsynchronously = YES;
    _lblName.ignoreCommonProperties = YES;
    _lblName.fadeOnAsynchronouslyDisplay = NO;
    _lblName.fadeOnHighlight = NO;
    _lblName.lineBreakMode = NSLineBreakByClipping;
    _lblName.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self addSubview:_lblName];
    
    _lblTag = [YYLabel new];
    _lblTag.size = CGSizeMake(kRoleCellTagWidth, kRoleCellCoinNameFontSize);
    _lblTag.right = screenWidth-kRoleCellTagPaddingRight;
    _lblTag.top = _lblName.top-1.5;
    _lblTag.displaysAsynchronously = YES;
    _lblTag.ignoreCommonProperties = YES;
    _lblTag.fadeOnAsynchronouslyDisplay = NO;
    _lblTag.fadeOnHighlight = NO;
    _lblTag.lineBreakMode = NSLineBreakByClipping;
    _lblTag.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    _lblTag.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [self addSubview:_lblTag];
    
    return self;
}

- (void)setUserType:(UserType)userType{
    _userType = userType;
    if ((userType & UserTypeTruePhoto) == YES) {
        _imgVerify.hidden = NO;
        _imgVerify.image = [UIImage imageNamed:@"icon_verified"];
    }else{
        _imgVerify.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _trackingTouch = NO;
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView:_imgAvatar];
    if (CGRectContainsPoint(_imgAvatar.bounds, p)) {
        _trackingTouch = YES;
    }
    p = [t locationInView:_lblName];
    if (CGRectContainsPoint(_lblName.bounds, p) && _lblName.textLayout.textBoundingRect.size.width > p.x) {
        _trackingTouch = YES;
    }
    if (!_trackingTouch) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesEnded:touches withEvent:event];
    } else {
        if ([_cell.delegate respondsToSelector:@selector(cell:didClickUser:)]) {
            [_cell.delegate cell:_cell didClickUser:_cell.cellView.layout.userModel];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesCancelled:touches withEvent:event];
    }
}
@end


@implementation RoleCellView{
    BOOL _touchDetailView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    @weakify(self);
    
    _contentView = [UIView new];
    _contentView.width = kScreenWidth;
    _contentView.height = 1;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _header = [RoleCellHeader new];
    [_contentView addSubview:_header];
    
    _lblDetail = [YYLabel new];
    _lblDetail.left = kRoleCellContentLeftPadding;
    _lblDetail.width = kRoleCellContentWidth;
    _lblDetail.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _lblDetail.displaysAsynchronously = YES;
    _lblDetail.ignoreCommonProperties = YES;
    _lblDetail.fadeOnAsynchronouslyDisplay = NO;
    _lblDetail.fadeOnHighlight = NO;
    _lblDetail.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_lblDetail];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.layer.borderColor = kColorMainBlue.CGColor;
    _button.layer.cornerRadius = 3.5;
    _button.layer.borderWidth = 1.0;
    _button.exclusiveTouch = YES;
    _button.left = screenWidth-48-16;//3个字：screenWidth-48-16  4个字：screenWidth-64-16
    _button.size = CGSizeMake(48, 26);//3个字：CGSizeMake(48, 26)  4个字：CGSizeMake(64, 26)
    _button.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [_button setTitleColor:kColorMainBlue forState:UIControlStateNormal];
    [_button setTitle:@"赞助Ta" forState:UIControlStateNormal];
    [_button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cellDidClickBuy:)]) {
            [weak_self.cell.delegate cellDidClickBuy:weak_self.cell];
        }
    }];
    [_contentView addSubview:_button];
    
    _lblAttr1 = [YYLabel new];
    _lblAttr1.left = kRoleCellContentLeftPadding;
    _lblAttr1.width = kRoleCellContentWidth;
    _lblAttr1.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _lblAttr1.displaysAsynchronously = YES;
    _lblAttr1.ignoreCommonProperties = YES;
    _lblAttr1.fadeOnAsynchronouslyDisplay = NO;
    _lblAttr1.fadeOnHighlight = NO;
    _lblAttr1.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_lblAttr1];
    
    _lblAttr2 = [YYLabel new];
    _lblAttr2.left = kRoleCellContentLeftPadding;
    _lblAttr2.width = kRoleCellContentWidth-_button.width;
    _lblAttr2.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _lblAttr2.displaysAsynchronously = YES;
    _lblAttr2.ignoreCommonProperties = YES;
    _lblAttr2.fadeOnAsynchronouslyDisplay = NO;
    _lblAttr2.fadeOnHighlight = NO;
    _lblAttr2.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_lblAttr2];
    
    _lblTime = [YYLabel new];
    _lblTime.left = kRoleCellContentLeftPadding;
    _lblTime.width = kRoleCellContentWidth-_button.width;
    _lblTime.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _lblTime.displaysAsynchronously = YES;
    _lblTime.ignoreCommonProperties = YES;
    _lblTime.fadeOnAsynchronouslyDisplay = NO;
    _lblTime.fadeOnHighlight = NO;
    [_contentView addSubview:_lblTime];
    
    _picBGView = [UIView new];
    _picBGView.width = kRoleCellContentWidth;
    _picBGView.backgroundColor = kColorGray4;
    _picBGView.x = kRoleCellContentLeftPadding;
    _picBGView.layer.cornerRadius = 5.0f;
    _picBGView.clipsToBounds = YES;
    [_contentView addSubview:_picBGView];
    
    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        YYControl *imageView = [YYControl new];
        imageView.size = CGSizeMake(100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = kColorGray4;
        imageView.exclusiveTouch = YES;
        imageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            if (![weak_self.cell.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:)]) return;
            if (state == YYGestureRecognizerStateBegan) {
                _isTouchMoving = NO;
            }
            if (state == YYGestureRecognizerStateMoved) {
                _isTouchMoving = YES;
            }
            if (state == YYGestureRecognizerStateEnded && _isTouchMoving == NO) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [weak_self.cell.delegate cell:weak_self.cell didClickImageAtIndex:i];
                }
            }
        };
        
        [picViews addObject:imageView];
        [_picBGView addSubview:imageView];
    }
    _picViews = picViews;
    
    return self;
}

- (void)setLayout:(RoleCellLayout *)layout {
    _layout = layout;
    
    self.height = layout.height;
    _contentView.top = layout.marginTop;
    _contentView.height = layout.height - layout.marginTop - layout.marginBottom;
    
    CGFloat top = 0;
    /// 圆角头像
    [_header.imgAvatar setImageWithURL:layout.roleModel.avatar.thumbnail.url
                                placeholder:nil
                                    options:YYWebImageOptionSetImageWithFadeAnimation
                                    manager:[CellHelper avatarImageManager] //< 圆角头像manager，内置圆角处理
                                   progress:nil
                                  transform:nil
                                 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                     
                                 }];
    
    _header.lblName.textLayout = layout.nameTextLayout;
    _header.lblTag.textLayout = layout.tagTextLayout;
    
    UserType ut = UserTypeNormal;
    if (layout.userModel.hasPhoto) {
        ut |= UserTypeTruePhoto;
    }
    if (layout.roleModel.sponsor) {
        ut |= UserTypeSponsor;
    }
    if (layout.userModel.founder) {
        ut |= UserTypeFounder;
    }
    _header.userType = ut;
    _header.height = layout.headerHeight;
    _header.top = top;
    top+=layout.nameBottomHeight;//昵称底部的高度
    
    _lblDetail.top = top;
    _lblDetail.height = layout.detailTextHeight;
    _lblDetail.textLayout = layout.detailTextLayout;
    top += layout.detailTextHeight-4;
    
    _lblAttr1.top = top;
    _lblAttr1.height = layout.attrHeight;
    _lblAttr1.textLayout = layout.attrLayout;
    top += layout.attrHeight;
    
    _lblAttr2.top = top;
    _lblAttr2.height = layout.attrHeight2;
    _lblAttr2.textLayout = layout.attrLayout2;
    top += layout.attrHeight2;
    
    _lblTime.top = top;
    _lblTime.height = layout.timeHeight;
    _lblTime.textLayout = layout.timeLayout;
    top += layout.timeHeight;
    
    _button.top = _lblAttr2.bottom-15;
    
    _picBGView.hidden = YES;
    if (layout.picHeight == 0) {
        [self _hideImageViews];
    }else{
        [self _setImageViewWithTop:_lblTime.bottom];
    }
}


- (void)_hideImageViews {
    for (UIImageView *imageView in _picViews) {
        imageView.hidden = YES;
    }
}

- (void)_setImageViewWithTop:(CGFloat)imageTop {
    CGSize picSize = _layout.picSize;
    NSArray *pics =[NSArray arrayWithObject:_layout.coinModel.qrCode];
    int picsCount = (int)pics.count;
    
    //只显示1、2、4、9四种图片排列
    if (picsCount == 3) {
        picsCount = 2;
    }else if(picsCount > 4 && picsCount <9){
        picsCount = 4;
    }
    
    _picBGView.height = _layout.picHeight;
    _picBGView.y = imageTop;
    _picBGView.hidden = NO;
    
    for (int i = 0; i < 9; i++) {
        YYControl *imageView = _picViews[i];
        if (i >= picsCount) {
            [imageView.layer cancelCurrentImageRequest];
            imageView.hidden = YES;
        } else {
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    origin.x = 0;
                    origin.y = 0;
                    picSize.width = kRoleCellContentWidth;
                } break;
                case 2:  case 4:{
                    origin.x = (i % 2) * (picSize.width + kRoleCellPaddingPic);
                    origin.y = (int)(i / 2) * (picSize.height + kRoleCellPaddingPic);
                } break;
                default: {
                    origin.x = (i % 3) * (picSize.width + kRoleCellPaddingPic);
                    origin.y = (int)(i / 3) * (picSize.height + kRoleCellPaddingPic);
                } break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            
            Pic *pic = pics[i];
            
            @weakify(imageView);
            [imageView.layer setImageWithURL:picsCount>1?pic.thumbnail.url:pic.middle.url
                                 placeholder:[UIImage imageWithColor:kColorGray4]
                                     options:YYWebImageOptionSetImageWithFadeAnimation
                                     manager:nil
                                    progress:nil
                                   transform:nil
                                  completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                      @strongify(imageView);
                                      if (!imageView) return;
                                      if (image && stage == YYWebImageStageFinished) {
                                          int width = picsCount>1?pic.thumbnail.width:pic.middle.width;
                                          int height = picsCount>1?pic.thumbnail.height:pic.middle.height;
                                          CGFloat scale = (height / width) / (imageView.height / imageView.width);
                                          if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                                              imageView.contentMode = UIViewContentModeScaleAspectFill;
                                              imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                          } else { // 高图只保留顶部
                                              imageView.contentMode = UIViewContentModeScaleAspectFill;
                                              imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                                          }
                                          imageView.image = image;
                                          if (from != YYWebImageFromMemoryCacheFast) {
                                              CATransition *transition = [CATransition animation];
                                              transition.duration = 0.15;
                                              transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                              transition.type = kCATransitionFade;
                                              [imageView.layer addAnimation:transition forKey:@"contents"];
                                          }
                                      }
                                  }];
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [(_contentView) performSelector:@selector(setBackgroundColor:) withObject:kColorGray4 afterDelay:0.1];
    _isTouchMoving = NO;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchesRestoreBackgroundColor];
    _isTouchMoving = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
    
    if (_isTouchMoving == NO) {
        if ([_cell.delegate respondsToSelector:@selector(cellDidClick:)]) {
            [_cell.delegate cellDidClick:_cell];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
    [NSObject cancelPreviousPerformRequestsWithTarget:_contentView selector:@selector(setBackgroundColor:) object:kColorGray4];
    
    _contentView.backgroundColor = [UIColor whiteColor];
}

@end
