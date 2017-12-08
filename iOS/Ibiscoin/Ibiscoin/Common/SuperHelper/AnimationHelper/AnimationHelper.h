//
//  AnimationHelper.h
//  AnimationHelper
//
//  Created by cooerson on 12-8-2.
//  Copyright (c) 2012年 Cooerson Inc. All rights reserved.
//

//AnimationHelper使用方法：导入AnimationHelper.h即可使用

#import <QuartzCore/QuartzCore.h>
#import "CAAnimationBlockDelegate.h"
#import "CAKeyframeAnimation+AHEasing.h"

#define kAHOpacityDuration 0.276f
#define kAHMoveDuration 1.276f

#define kAHScaleKeyframeCount 143 //每7毫秒重绘一次 1000/7=143
#define kAHScaleToBigDuration 0.809f
#define kAHScaleToBigDuration2 0.304f
#define kAHScaleToSmallDuration 0.276f

#define kAHShakeDuration 0.127 //0.127=0.382/3 晃动一下的时间

@interface AnimationHelper: NSObject

//透明度动画
//透明度1-0
+ (void)hide:(CALayer *)layer onComplete:(void (^)(void))onComplete;
+ (void)hide:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction  onComplete:(void (^)(void))onComplete;
+ (void)hide:(CALayer *)layer duration:(CFTimeInterval)duration fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha easingFunction:(NSString *)easingFunction onComplete:(void (^)(void))onComplete;
//透明度0-1
+ (void)show:(CALayer *)layer;
+ (void)show:(CALayer *)layer easingFunction:(NSString *)easingFunction;
+ (void)show:(CALayer *)layer duration:(CFTimeInterval)duration;
+ (void)show:(CALayer *)layer duration:(CFTimeInterval)duration onComplete:(void (^)(void))onComplete;
+ (void)show:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction;
+ (void)show:(CALayer *)layer duration:(CFTimeInterval)duration fromAlpha:(CGFloat)fromAlpha easingFunction:(NSString *)easingFunction;
+ (void)show:(CALayer *)layer duration:(CFTimeInterval)duration fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha easingFunction:(NSString *)easingFunction;

//位置动画
//move to bottom
+ (void)moveToBottom:(CALayer *)layer completion:(void (^)(void))completion;
+ (void)moveToBottom:(CALayer *)layer easingFunction:(NSString *)easingFunction completion:(void (^)(void))completion;
+ (void)moveToBottom:(CALayer *)layer duration:(CFTimeInterval)duration completion:(void (^)(void))completioncompletion;
+ (void)moveToBottom:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction completion:(void (^)(void))completion;
//move to top
+ (void)moveToTop:(CALayer *)layer;
+ (void)moveToTop:(CALayer *)layer easingFunction:(NSString *)easingFunction;
+ (void)moveToTop:(CALayer *)layer duration:(CFTimeInterval)duration;
+ (void)moveToTop:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction;
+ (void)moveToTop:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction onComplete:(void (^)(void))onComplete;
//move to right
+ (void)moveToRight:(CALayer *)layer;
+ (void)moveToRight:(CALayer *)layer easingFunction:(NSString *)easingFunction;
+ (void)moveToRight:(CALayer *)layer duration:(CFTimeInterval)duration;
+ (void)moveToRight:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction;
+ (void)moveToRight:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction onComplete:(void (^)(void))onComplete;
//move to left
+ (void)moveToLeft:(CALayer *)layer;
+ (void)moveToLeft:(CALayer *)layer easingFunction:(NSString *)easingFunction;
+ (void)moveToLeft:(CALayer *)layer duration:(CFTimeInterval)duration;
+ (void)moveToLeft:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction;
+ (void)moveToLeft:(CALayer *)layer duration:(CFTimeInterval)duration easingFunction:(NSString *)easingFunction onComplete:(void (^)(void))onComplete;


//大小缩放动画
//scale to big
+ (void)scaleToBigSizeBounce:(CALayer *)layer;
+ (void)scaleToBigSizeElastic:(CALayer *)layer;
+ (void)scaleToBigSizeCubic:(CALayer *)layer;

//scale to small
+ (void)scaleToSmallSizeCubic:(CALayer *)layer;
+ (void)scaleToSmallSizeCubic:(CALayer *)layer duration:(CFTimeInterval)duration;


//shake animation
+ (void)shake:(CALayer *)layer completion:(void (^)(void))completion;


@end
