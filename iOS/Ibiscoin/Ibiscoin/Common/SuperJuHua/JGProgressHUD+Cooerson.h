//
//  JGProgressHUD+Cooerson.h
//  Action
//
//  Created by caokun on 15/12/29.
//  Copyright © 2015年 xingdongpai. All rights reserved.
//

#import "JGProgressHUD.h"

//coo mark
//菊花
#define showJuHua(VAL,...) [JGProgressHUD showJuHua:VAL view:__VA_ARGS__]
#define showDimJuHua(VAL,...) [JGProgressHUD showDimJuHua:VAL view:__VA_ARGS__]
#define changeJuHuaText(VAL,VAL2,...) [JGProgressHUD changeJuHuaText:VAL detail:VAL2 view:__VA_ARGS__]
#define showPieJuHua(VAL,VAL2,...) [JGProgressHUD showPieJuHua:VAL view:VAL2 HUD:__VA_ARGS__]
/**
 //定时刷新Pie进度
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 incrementPieJuHua(_HUD,progress);
 });
 */
#define incrementPieJuHua(VAL,...) [JGProgressHUD incrementHUD:VAL progress:__VA_ARGS__]

/**
 done block
 hideJuHuaDone(self.navigationController.view,^(){
 });
 */
#define hideJuHua(VAL) [JGProgressHUD hideJuHua:VAL]
#define hideJuHuaDone(VAL,...) [JGProgressHUD hideJuHuaNoAnimation:VAL done:__VA_ARGS__]
#define hideJuHuaNoAnimation(VAL) [JGProgressHUD hideJuHuaNoAnimation:VAL]
#define hideJuHuaNoAnimationDone(VAL,...) [JGProgressHUD hideJuHuaNoAnimation:VAL done:__VA_ARGS__]
#define hideJuHuaDelay(VAL,...) [JGProgressHUD hideJuHua:VAL view:__VA_ARGS__]
#define hideJuHuaDelayDone(VAL,VAL2,...) [JGProgressHUD hideJuHua:VAL view:VAL2 done:__VA_ARGS__]

#define showAndHideRightJuHua(VAL,...) [JGProgressHUD showAndHideRightJuHua:VAL view:__VA_ARGS__]
#define showAndHideRightJuHuaDone(VAL,VAL2,...) [JGProgressHUD showAndHideRightJuHua:VAL view:VAL2 done:__VA_ARGS__]
#define showAndHideRightJuHua2(VAL,VAL2,...) [JGProgressHUD showAndHideRightJuHua:VAL detail:VAL2 view:__VA_ARGS__]
#define showAndHideRightJuHua2Done(VAL,VAL2,VAL3,...) [JGProgressHUD showAndHideRightJuHua:VAL detail:VAL2 view:VAL3 done:__VA_ARGS__]

#define showAndHideWrongJuHua(VAL,...) [JGProgressHUD showAndHideWrongJuHua:VAL view:__VA_ARGS__]
#define showAndHideWrongJuHuaDone(VAL,VAL2,...) [JGProgressHUD showAndHideWrongJuHua:VAL view:VAL2 done:__VA_ARGS__]
#define showAndHideWrongJuHua2(VAL,VAL2,...) [JGProgressHUD showAndHideWrongJuHua:VAL detail:VAL2 view:__VA_ARGS__]
#define showAndHideWrongJuHua2Done(VAL,VAL2,VAL3,...) [JGProgressHUD showAndHideWrongJuHua:VAL detail:VAL2 view:VAL3 done:__VA_ARGS__]


@interface JGProgressHUD (cooerson)

//coo mark
//JuHua for view
//1.显示JuHua
+ (JGProgressHUD *)showJuHua:(NSString *)tipStr view:(UIView *)view;
+ (JGProgressHUD *)showDimJuHua:(NSString *)tipStr view:(UIView *)view;
+ (void)changeJuHuaText:(NSString *)tipStr detail:(NSString *)detailStr view:(UIView *)view;
+ (void)showPieJuHua:(NSString *)tipStr view:(UIView *)view HUD:(JGProgressHUD *)hud;
+ (void)incrementHUD:(JGProgressHUD *)HUD progress:(int)progress;
//2.隐藏JuHua
+ (void)hideJuHua:(UIView *)view;
+ (void)hideJuHua:(UIView *)view done:(void (^)(void))done;
+ (void)hideJuHuaNoAnimation:(UIView *)view;
+ (void)hideJuHuaNoAnimation:(UIView *)view done:(void (^)(void))done;
+ (void)hideJuHua:(NSTimeInterval)delay view:(UIView *)view;
+ (void)hideJuHua:(NSTimeInterval)delay view:(UIView *)view done:(void (^)(void))done;
//3.提示后隐藏JuHua
+ (void)showAndHideRightJuHua:(NSString *)tipStr view:(UIView *)view;
+ (void)showAndHideRightJuHua:(NSString *)tipStr view:(UIView *)view done:(void (^)(void))done;
+ (void)showAndHideRightJuHua:(NSString *)tipStr detail:(NSString *)detailStr view:(UIView *)view;
+ (void)showAndHideRightJuHua:(NSString *)tipStr detail:(NSString *)detailStr view:(UIView *)view done:(void (^)(void))done;

+ (void)showAndHideWrongJuHua:(NSString *)tipStr view:(UIView *)view;
+ (void)showAndHideWrongJuHua:(NSString *)tipStr view:(UIView *)view done:(void (^)(void))done;
+ (void)showAndHideWrongJuHua:(NSString *)tipStr detail:(NSString *)detailStr view:(UIView *)view;
+ (void)showAndHideWrongJuHua:(NSString *)tipStr detail:(NSString *)detailStr view:(UIView *)view done:(void (^)(void))done;

@end
