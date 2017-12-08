//
//  CAAnimationBlockDelegate.h
//  AnimationHelper
//
//  Created by cooerson on 13-1-22.
//  Copyright (c) 2013年 Cooerson Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimationBlockDelegate : NSObject

@property (nonatomic, copy) void(^blockOnAnimationStarted)(void);
@property (nonatomic, copy) void(^blockOnAnimationSucceeded)(void);
@property (nonatomic, copy) void(^blockOnAnimationFailed)(void);

- (void)animationDidStart:(CAAnimation *)theAnimation;
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;

@end