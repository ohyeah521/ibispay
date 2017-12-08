//
//  AppDelegate.h
//  Ibiscoin
//
//  Created by 鸟神 on 2017/6/13.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) UIViewController *topViewController;

//全局方法
- (void)showLoginForm;
- (void)login;
- (void)logout;
- (void)logoutWithMsg:(NSString *)msg;//登出并且带提示
//刷新动态
- (void)refreshActivity;
- (void)refreshActivityNoRequest:(UserActivityModel *)uam;
//刷新页面
- (void)refreshHomeList;
- (void)refreshProfilePage;

@end

