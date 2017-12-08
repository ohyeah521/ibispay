//
//  TableViewRoot.m
//  Action
//
//  Created by 鸟神 on 2017/5/17.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "TableViewRoot.h"

@implementation TableViewRoot

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    self.delaysContentTouches = NO;
    
    // Remove touch delay (since iOS 8)
    UIView *wrapView = self.subviews.firstObject;
    // UITableViewWrapperView
    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
            // UIScrollViewDelayedTouchesBeganGestureRecognizer
            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                gesture.enabled = NO;
                break;
            }
        }
    }
    
    /**
     //iOS 8 解决Button延迟高亮
     for (id view in self.subviews) {
     if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"]) {
     if ([view isKindOfClass:[UIScrollView class]]) {
     UIScrollView *scrollView = (UIScrollView *) view;
     scrollView.delaysContentTouches = NO;
     }
     break;
     }
     }
     */
    
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

/**
//iOS 8 解决Button延迟高亮
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}
 */

@end
