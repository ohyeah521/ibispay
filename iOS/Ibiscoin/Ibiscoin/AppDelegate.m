//
//  AppDelegate.m
//  Ibiscoin
//
//  Created by 鸟神 on 2017/6/13.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarConfig.h"
#import "LoginForm.h"

#define tabPressSoundLine @"tabPressSoundBGLine"

@interface AppDelegate ()<UITabBarControllerDelegate, CYLTabBarControllerDelegate>
@property (nonatomic) BOOL authFailedShowing;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //tab
    TabBarConfig *tabConfig = [[TabBarConfig alloc] init];
    [self.window setRootViewController:tabConfig.tabBarController];
    tabConfig.tabBarController.delegate = self;
    [self.window makeKeyAndVisible];
    
    //main style
    [self customizeInterface];
    
    //=======检查token是否过期=======
    if (isUserLogin) {
        [self checkTokenExpire];
    }
    return YES;
}

- (void)customizeInterface {
    //navbar
    [self setUpNavigationBarAppearance];
    //cell选中颜色
    UIView *cellBGView = [UIView new];
    cellBGView.backgroundColor = kCellHighlightColor;
    [[UITableViewCell appearance] setSelectedBackgroundView:cellBGView];
    //防止锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)setUpNavigationBarAppearance {
    UINavigationBar *navAppearance = [UINavigationBar appearance];
    
//    UIImage *backgroundImage = [UIImage imageNamed:@"navbar-bg-tall"];
//    NSDictionary *textAttributes = @{NSFontAttributeName : kNavBarTitleFont, NSForegroundColorAttributeName : [UIColor blackColor]};
//    [navAppearance setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
//    [navAppearance setTitleTextAttributes:textAttributes];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [navAppearance setBackgroundColor:kColorMainBlue];
//    [navAppearance setBackgroundImage:[backgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forBarMetrics:UIBarMetricsDefault];
    [navAppearance setBarStyle:UIBarStyleBlack];
    [navAppearance setBarTintColor:kNavbarColor];
    [navAppearance setTintColor:[UIColor whiteColor]];
    [navAppearance setTitleTextAttributes:@{NSFontAttributeName : kNavBarTitleFont, NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    //移除底部横线，会影响top insert！！
//    [navAppearance setTranslucent:NO];
//    [navAppearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [navAppearance setShadowImage:[[UIImage alloc] init]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if (isUserLogin) {
        [self checkTokenExpire];
        [self refreshActivity];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - CYLTabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SimpleAudioPlayer playFile:kTabPressSoundFileName volume:0.06 loops:0 withCompletionBlock:nil];
    });
    
    UIView *animationView;
    NSString *button = [NSString stringWithFormat:@"UIT%@arB%@", @"abB", @"utton"];
    // 如果 PlusButton 也添加了点击事件，那么点击 PlusButton 后不会触发该代理方法。
    if ([control isKindOfClass:[CYLExternPlusButton class]]) {
        UIButton *button = CYLExternPlusButton;
        animationView = button.imageView;
        
    } else if ([control isKindOfClass:NSClassFromString(button)]) {
        NSString *imageView = [NSString stringWithFormat:@"UITabB%@pp%@", @"arSwa", @"ableImageView"];
        for (UIView *subView in control.subviews) {
            if ([subView isKindOfClass:NSClassFromString(imageView)]) {
                animationView = subView;
            }
        }
    }
    /*
     [self addScaleAnimationOnView:animationView];
     [self addRotateAnimationOnView:animationView];
     */
}


#pragma mark - public func

//弹出登录页面
- (void)showLoginForm{
    LoginForm *lf = [kMainSB instantiateViewControllerWithIdentifier:NSStringFromClass([LoginForm class])];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lf];
    [self.topViewController presentViewController:nav animated:YES completion:^{
        
    }];
}

//登录
- (void)login{
    //    [self refreshHomeList];//1.mainTab为空则不刷新，会自动在didload中刷新
    //    [self selectTabMain];//2.再切换到mainTab
    //    [self refreshProfilePage];//3.再刷新profilePage
}
//登出
- (void)logout{
    showJuHua(nil,[self topViewController].view);
    dispatch_async(dispatch_get_main_queue(), ^{
        //移除消息显示数目
        //        [self.mainTab removeNewsNum];
        //移除用户缓存
        [UserModel RemoveUserBasicWithOutPhone];
        //移除token缓存
        [UserTokenModel RemoveUserToken];
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
            // progress
        } endBlock:^(BOOL error) {
            [[PINCache sharedCache] removeAllObjects:^(PINCache * _Nonnull cache) {
                hideJuHuaDelay(0.3, [self topViewController].view);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showLoginForm];//切换到登陆界面
                });
            }];
        }];
    });
}
//登出带提示
- (void)logoutWithMsg:(NSString *)msg{
    if (self.authFailedShowing == YES) {
        return;
    }
    self.authFailedShowing = YES;
    NSString *strMsg;
    if ([msg isEqualToString:@"not authorized"]) {
        strMsg = @"认证失败，请重新登录";
    }else if([msg isEqualToString:@"token expired"]){
        strMsg = @"认证已过期，请重新登录";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.authFailedShowing = NO;
        [rootDelegate logout];
    }];
    [alert addAction:okAction];
    [[self topViewController] presentViewController:alert animated:YES completion:^{ }];
}

//刷新用户动态信息，带网络请求
- (void)refreshActivity{
//    if (isNull(self.mainTab) == NO) {
//        [self.mainTab refreshActivity];
//    }
}
//刷新用户动态信息，不带网络请求
- (void)refreshActivityNoRequest:(UserActivityModel *)uam{
//    if (isNull(self.mainTab) == NO) {
//        [self.mainTab refreshActivityNoRequest:uam];
//    }
}

//刷新首页
- (void)refreshHomeList{
//    if (isNull(self.mainTab) == NO) {
//        [self.mainTab refreshHomeList];
//    }
}
//刷新个人页
- (void)refreshProfilePage{
//    if (isNull(self.mainTab) == NO) {
//        [self.mainTab refreshProfilePage];
//    }
}

//------获取topViewController--------
- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
- (UIViewController *)topViewController:(UIViewController *)rootViewController{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}


#pragma mark - private func

//检查token
- (void)checkTokenExpire{
    if (isNullString(getUserToken) == NO) {
        //uct to nsdate
        NSString *expire = getUserTokenExpire;
        NSDate *expireDate = [expire dateFromRFC3339String];
        //token未过期,但过期时间小于7天
        if ([[NSDate date] isEarlierThan:expireDate] && [[[NSDate date] dateByAddingHours:isDebugMode?20:7*24] isLaterThanDate:expireDate]) {
            //刷新token
            [self refreshToken];
        }
    }
}
//刷新token
- (void)refreshToken{
    [AFNetworkHelper getUrl:kRefreshTokenUrl bg:YES param:nil succeed:^(id responseObject) {
        UserTokenModel *tokenModel = [UserTokenModel modelWithJSON:responseObject];
        [UserTokenModel CacheUserToken:tokenModel];
        [self refreshActivity];
    } fail:^{
        
    }];
}


//tab item scale animation
- (void)addScaleAnimationOnView:(UIView *)animationView {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//tab item rotate animation
- (void)addRotateAnimationOnView:(UIView *)animationView {
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}


@end
