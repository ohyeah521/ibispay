//
//  AnimationHelper.m
//  AnimationHelper
//
//  Created by cooerson on 12-8-2.
//  Copyright (c) 2012年 Cooerson Inc. All rights reserved.
//

#import "AnimationHelper.h"

@implementation AnimationHelper

//透明度1-0

+ (void)hide:(CALayer *)layer onComplete:(void (^)(void))onComplete{
    CABasicAnimation* fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fade.fromValue = [NSNumber numberWithFloat:1];
    fade.toValue = [NSNumber numberWithFloat:0];
    fade.duration = kAHOpacityDuration;
    
    [layer addAnimation:fade forKey:@"hide"];
    
    if (onComplete!= nil) {
        [CATransaction setCompletionBlock: ^ {
            onComplete();
        }];
    }
}

+ (void)hide:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction onComplete:(void (^)(void))onComplete{
    CABasicAnimation* fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    fade.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    fade.fromValue = [NSNumber numberWithFloat:1];
    fade.toValue = [NSNumber numberWithFloat:0];
    fade.duration = duration;
    
    [layer addAnimation:fade forKey:@"hide"];
    
    if (onComplete!= nil) {
        [CATransaction setCompletionBlock: ^ {
            onComplete();
        }];
    }
}

+ (void)hide:(CALayer *)layer duration:(CFTimeInterval)duration fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha easingFunction:(NSString *)easingFunction onComplete:(void (^)(void))onComplete{
    CABasicAnimation* fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    fade.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    fade.fromValue = [NSNumber numberWithFloat:fromAlpha];
    fade.toValue = [NSNumber numberWithFloat:toAlpha];
    fade.duration = duration;
    
    [layer addAnimation:fade forKey:@"hide"];
    
    if (onComplete!= nil) {
        [CATransaction setCompletionBlock: ^ {
            onComplete();
        }];
    }
}


//透明度0-1

+ (void)show:(CALayer *)layer{
    CABasicAnimation* show = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    show.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    show.fromValue = [NSNumber numberWithFloat:0];
    show.toValue = [NSNumber numberWithFloat:1];
    show.duration = kAHOpacityDuration;
    
    [layer addAnimation:show forKey:@"show"];
}

+ (void)show:(CALayer *)layer easingFunction:(NSString *)easingFunction{
    CABasicAnimation* show = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    show.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    show.fromValue = [NSNumber numberWithFloat:0];
    show.toValue = [NSNumber numberWithFloat:1];
    show.duration = kAHOpacityDuration;
    
    [layer addAnimation:show forKey:@"show"];
}

+ (void)show:(CALayer *)layer duration:(CFTimeInterval)duration{
    CABasicAnimation* show = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    show.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    show.fromValue = [NSNumber numberWithFloat:0];
    show.toValue = [NSNumber numberWithFloat:1];
    show.duration = duration;
    
    [layer addAnimation:show forKey:@"show"];
}

+ (void)show:(CALayer *)layer duration:(CFTimeInterval)duration onComplete:(void (^)(void))onComplete{
    CABasicAnimation* show = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    show.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    show.fromValue = [NSNumber numberWithFloat:0];
    show.toValue = [NSNumber numberWithFloat:1];
    show.duration = duration;
    
    [layer addAnimation:show forKey:@"show"];
    
    if (onComplete!= nil) {
        [CATransaction setCompletionBlock: ^ {
            onComplete();
        }];
    }

}

+ (void)show:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction{
    CABasicAnimation* show = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    show.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    show.fromValue = [NSNumber numberWithFloat:0];
    show.toValue = [NSNumber numberWithFloat:1];
    show.duration = duration;
    
    [layer addAnimation:show forKey:@"show"];
}

+ (void)show:(CALayer *)layer duration:(CFTimeInterval)duration fromAlpha:(CGFloat)fromAlpha easingFunction:(NSString *)easingFunction{
    CABasicAnimation* show = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    show.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    show.fromValue = [NSNumber numberWithFloat:fromAlpha];
    show.toValue = [NSNumber numberWithFloat:1];
    show.duration = duration;
    
    [layer addAnimation:show forKey:@"show"];
}

+ (void)show:(CALayer *)layer duration:(CFTimeInterval)duration fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha easingFunction:(NSString *)easingFunction{
    CABasicAnimation* show = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    show.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    show.fromValue = [NSNumber numberWithFloat:fromAlpha];
    show.toValue = [NSNumber numberWithFloat:toAlpha];
    show.duration = duration;
    
    [layer addAnimation:show forKey:@"show"];
}


//移动动画
//move to bottom
+ (void)moveToBottom:(CALayer *)layer completion:(void (^)(void))completion{
    [self moveToBottom:layer duration:kAHMoveDuration easingFunction:kCAMediaTimingFunctionEaseInEaseOut completion:completion];
}

+ (void)moveToBottom:(CALayer *)layer easingFunction:(NSString *)easingFunction completion:(void (^)(void))completion{
    [self moveToBottom:layer duration:kAHMoveDuration easingFunction:easingFunction completion:completion];
}

+ (void)moveToBottom:(CALayer *)layer duration:(CFTimeInterval)duration completion:(void (^)(void))completioncompletion{
    [self moveToBottom:layer duration:duration easingFunction:kCAMediaTimingFunctionEaseInEaseOut completion:completioncompletion];
}

+ (void)moveToBottom:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction completion:(void (^)(void))completion{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    [CATransaction setCompletionBlock: ^ {
        if (completion) {
            completion();
        }
    }];
    
    [layer addAnimation:animation forKey:@"fromBottom"];
}

//move to top
+ (void)moveToTop:(CALayer *)layer{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = kAHMoveDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [layer addAnimation:animation forKey:@"fromTop"];
}

+ (void)moveToTop:(CALayer *)layer easingFunction:(NSString *)easingFunction{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = kAHMoveDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    
    [layer addAnimation:animation forKey:@"fromTop"];
}

+ (void)moveToTop:(CALayer *)layer duration:(CFTimeInterval)duration{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [layer addAnimation:animation forKey:@"fromTop"];
}

+ (void)moveToTop:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    
    [layer addAnimation:animation forKey:@"fromTop"];
}

+ (void)moveToTop:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction onComplete:(void (^)(void))onComplete{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    [CATransaction setCompletionBlock: ^ {
        onComplete();
    }];
    
    [layer addAnimation:animation forKey:@"fromTop"];
}

//move to right
+ (void)moveToRight:(CALayer *)layer{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    animation.duration = kAHMoveDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [layer addAnimation:animation forKey:@"fromLeft"];
}

+ (void)moveToRight:(CALayer *)layer easingFunction:(NSString *)easingFunction{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    animation.duration = kAHMoveDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    
    [layer addAnimation:animation forKey:@"fromLeft"];
}

+ (void)moveToRight:(CALayer *)layer duration:(CFTimeInterval)duration{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [layer addAnimation:animation forKey:@"fromLeft"];
}

+ (void)moveToRight:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    
    [layer addAnimation:animation forKey:@"fromLeft"];
}

+ (void)moveToRight:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction onComplete:(void (^)(void))onComplete{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    [CATransaction setCompletionBlock: ^ {
        onComplete();
    }];
    
    [layer addAnimation:animation forKey:@"fromLeft"];
}

//move to left
+ (void)moveToLeft:(CALayer *)layer{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    animation.duration = kAHMoveDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [layer addAnimation:animation forKey:@"fromRight"];
}

+ (void)moveToLeft:(CALayer *)layer easingFunction:(NSString *)easingFunction{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    animation.duration = kAHMoveDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    
    [layer addAnimation:animation forKey:@"fromRight"];
}

+ (void)moveToLeft:(CALayer *)layer duration:(CFTimeInterval)duration{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [layer addAnimation:animation forKey:@"fromRight"];
}

+ (void)moveToLeft:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    
    [layer addAnimation:animation forKey:@"fromRight"];
}

+ (void)moveToLeft:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction onComplete:(void (^)(void))onComplete{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:easingFunction];
    [CATransaction setCompletionBlock: ^ {
        onComplete();
    }];
    
    [layer addAnimation:animation forKey:@"fromRight"];
}


//大小缩放动画
//scale to big
+ (void)scaleToBigSizeBounce:(CALayer *)layer{
    CAAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale" function:BounceEaseOut fromValue:0 toValue:1 keyframeCount:kAHScaleKeyframeCount];
    animation.duration = kAHScaleToBigDuration;
    [layer addAnimation:animation forKey:@"transform.scale"];
}

+ (void)scaleToBigSizeElastic:(CALayer *)layer{
    CAAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale" function:ElasticEaseOut fromValue:0 toValue:1 keyframeCount:kAHScaleKeyframeCount];
    animation.duration = kAHScaleToBigDuration;
    [layer addAnimation:animation forKey:@"transform.scale"];
}

+ (void)scaleToBigSizeCubic:(CALayer *)layer{
    CAAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale" function:CubicEaseOut fromValue:0 toValue:1 keyframeCount:kAHScaleKeyframeCount];
    animation.duration = kAHScaleToBigDuration2;
    [layer addAnimation:animation forKey:@"transform.scale"];
}

//scale to small
/**usage:
 [AnimationHelper scaleToSmallSizeCubic:self.view.layer];
 [UIView animateWithDuration:kAHScaleToSmallDuration animations:^{
    self.alpha = 0;
 } completion:^(BOOL finished) {
 if (self.superview != nil) {
    [self removeFromSuperview];
 }
 }];
 */
+ (void)scaleToSmallSizeCubic:(CALayer *)layer{
    [self scaleToSmallSizeCubic:layer duration:kAHScaleToSmallDuration];
}

+ (void)scaleToSmallSizeCubic:(CALayer *)layer duration:(CFTimeInterval)duration{
    CAAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale" function:CubicEaseInOut fromValue:1 toValue:0 keyframeCount:kAHScaleKeyframeCount];
    animation.duration = duration;
    [layer addAnimation:animation forKey:@"transform.scale"];
}


//shake animation
+ (void)shake:(CALayer *)layer completion:(void (^)(void))completion{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:-M_PI/36];
    animation.toValue   = [NSNumber numberWithFloat:+M_PI/36];
    animation.duration = kAHShakeDuration;
    animation.autoreverses = YES;
    animation.repeatCount = 3;
    
    CAAnimationBlockDelegate *d = [[CAAnimationBlockDelegate alloc] init];
    d.blockOnAnimationSucceeded = ^() {
        completion();
    }; 
    animation.delegate = (id)d;
    
    [layer addAnimation:animation forKey:@"shakeAnimation"];
}

@end





