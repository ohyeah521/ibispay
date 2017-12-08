//
//  JGProgressHUD+Cooerson.m
//  Action
//
//  Created by caokun on 15/12/29.
//  Copyright © 2015年 xingdongpai. All rights reserved.
//

#import "JGProgressHUD+Cooerson.h"

@implementation JGProgressHUD (cooerson)

//coo mark
//1.显示JuHua
+ (JGProgressHUD *)showJuHua:(NSString *)tipStr view:(UIView *)view{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = tipStr;
    HUD.position = JGProgressHUDPositionCenter;
    [HUD showInView:view];
    return HUD;
}

+ (JGProgressHUD *)showDimJuHua:(NSString *)tipStr view:(UIView *)view{
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5625f];
    HUD.textLabel.text = tipStr;
    HUD.position = JGProgressHUDPositionCenter;
    [HUD showInView:view];
    return HUD;
}

+ (void)changeJuHuaText:(NSString *)tipStr detail:(NSString *)detailStr view:(UIView *)view{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([JGProgressHUD allProgressHUDsInView:view].count > 0) {
            JGProgressHUD *HUD = [[JGProgressHUD allProgressHUDsInView:view] objectAtIndex:0];
            HUD.textLabel.text = tipStr;
            if (isNullString(detailStr) == NO) {
                HUD.detailTextLabel.text = detailStr;
            }
        }
    });
}

+ (void)showPieJuHua:(NSString *)tipStr view:(UIView *)view HUD:(JGProgressHUD *)hud{
    JGProgressHUD *HUD;
    if (hud != nil) {
        HUD = hud;
    }else{
        HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    }
    
    HUD.textLabel.text = tipStr;
    HUD.position = JGProgressHUDPositionCenter;
    
    HUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:HUD.style];
    HUD.detailTextLabel.text = @"0%";
    HUD.layoutChangeAnimationDuration = 0.0;
    
    [HUD showInView:view];
}

+ (void)incrementHUD:(JGProgressHUD *)HUD progress:(int)progress{
    [HUD setProgress:progress/100.0f animated:NO];
    HUD.detailTextLabel.text = [NSString stringWithFormat:@"%d%%", progress];
}

//2.隐藏JuHua
+ (void)hideJuHua:(UIView *)view{
    [JGProgressHUD hideJuHua:0 view:view];
}
+(void)hideJuHua:(UIView *)view done:(void (^)(void))done{
    [JGProgressHUD hideJuHua:0 view:view done:done];
}

+ (void)hideJuHuaNoAnimation:(UIView *)view{
    [JGProgressHUD hideJuHuaNoAnimation:view done:nil];
}
+(void)hideJuHuaNoAnimation:(UIView *)view done:(void (^)(void))done{
    if ([JGProgressHUD allProgressHUDsInView:view].count > 0) {
        JGProgressHUD *HUD = [[JGProgressHUD allProgressHUDsInView:view] objectAtIndex:0];
        [HUD dismissAnimated:NO];
        if (done == nil) {
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            done();
        });
    }
}

+ (void)hideJuHua:(NSTimeInterval)delay view:(UIView *)view{
    [JGProgressHUD hideJuHua:delay view:view done:nil];
}
+(void)hideJuHua:(NSTimeInterval)delay view:(UIView *)view done:(void (^)(void))done{
    if ([JGProgressHUD allProgressHUDsInView:view].count > 0) {
        JGProgressHUD *HUD = [[JGProgressHUD allProgressHUDsInView:view] objectAtIndex:0];
        if (delay == 0) {
            [HUD dismissAnimated:YES];
            if (done == nil) {
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                done();
            });
        }else{
            [HUD dismissAfterDelay:delay];
            if (done == nil) {
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delay+0.25) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                done();
            });
        }
    }
}


//3.提示后隐藏JuHua
+ (void)showAndHideRightJuHua:(NSString *)tipStr view:(UIView *)view{
    [JGProgressHUD showAndHideRightJuHua:tipStr detail:nil view:view];
}
+(void)showAndHideRightJuHua:(NSString *)tipStr view:(UIView *)view done:(void (^)(void))done{
    [JGProgressHUD showAndHideRightJuHua:tipStr detail:nil view:view done:done];
}
+ (void)showAndHideRightJuHua:(NSString *)tipStr detail:(NSString *)detailStr view:(UIView *)view{
    [JGProgressHUD showAndHideRightJuHua:tipStr detail:detailStr view:view done:nil];
}
+(void)showAndHideRightJuHua:(NSString *)tipStr detail:(NSString *)detailStr view:(UIView *)view done:(void (^)(void))done{
    if ([JGProgressHUD allProgressHUDsInView:view].count > 0) {
        //已经有菊花,修改状态后隐藏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([JGProgressHUD allProgressHUDsInView:view].count > 0) {
                JGProgressHUD *HUD = [[JGProgressHUD allProgressHUDsInView:view] objectAtIndex:0];
                HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
                HUD.textLabel.text = tipStr;
                if (isNullString(detailStr) == NO) {
                    HUD.detailTextLabel.text = detailStr;
                }
                [HUD dismissAfterDelay:2.2];
                if (done == nil) {
                    return;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    done();
                });
            }
        });
    }else{
        //还没有菊花,先显示再隐藏
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        HUD.position = JGProgressHUDPositionCenter;
        HUD.textLabel.text = tipStr;
        if (isNullString(detailStr) == NO) {
            HUD.detailTextLabel.text = detailStr;
        }
        [HUD showInView:view];
        [HUD dismissAfterDelay:2.2];
        if (done == nil) {
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            done();
        });
    }
}

+ (void)showAndHideWrongJuHua:(NSString *)tipStr view:(UIView *)view{
    [JGProgressHUD showAndHideWrongJuHua:tipStr detail:nil view:view];
}
+(void)showAndHideWrongJuHua:(NSString *)tipStr view:(UIView *)view done:(void (^)(void))done{
    [JGProgressHUD showAndHideWrongJuHua:tipStr detail:nil view:view done:done];
}
+ (void)showAndHideWrongJuHua:(NSString *)tipStr detail:(NSString *)detailStr view:(UIView *)view{
    [JGProgressHUD showAndHideWrongJuHua:tipStr detail:detailStr view:view done:nil];
}
+ (void)showAndHideWrongJuHua:(NSString *)tipStr detail:(NSString *)detailStr view:(UIView *)view done:(void (^)(void))done{
    if ([JGProgressHUD allProgressHUDsInView:view].count > 0) {
        //已经有菊花,修改状态后隐藏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([JGProgressHUD allProgressHUDsInView:view].count > 0) {
                JGProgressHUD *HUD = [[JGProgressHUD allProgressHUDsInView:view] objectAtIndex:0];
                HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
                HUD.textLabel.text = tipStr;
                if (isNullString(detailStr) == NO) {
                    HUD.detailTextLabel.text = detailStr;
                }
                [HUD showInView:view];
                [HUD dismissAfterDelay:2.2];
                if (done == nil) {
                    return;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    done();
                });
            }
        });
    }else{
        //还没有菊花,先显示再隐藏
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        HUD.position = JGProgressHUDPositionCenter;
        HUD.textLabel.text = tipStr;
        if (isNullString(detailStr) == NO) {
            HUD.detailTextLabel.text = detailStr;
        }
        [HUD showInView:view];
        [HUD dismissAfterDelay:2.2];
        if (done == nil) {
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            done();
        });
    }
}


@end
