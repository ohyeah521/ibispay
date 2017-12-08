//
//  LanuchAdConfig.m
//  Ibiscoin
//
//  Created by 鸟神 on 2017/6/14.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import "LanuchAdConfig.h"
#import "XHLaunchAd.h"


@implementation LanuchAdConfig

+ (void)load{
    [self shareManager];
}
+ (LanuchAdConfig *)shareManager{
    static LanuchAdConfig *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[LanuchAdConfig alloc] init];
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        //在UIApplicationDidFinishLaunching时初始化开屏广告
        //也可以直接在AppDelegate didFinishLaunchingWithOptions中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            //初始化启动画面广告
            [self setupXHLaunchAd];
        }];
    }
    return self;
}
- (void)setupXHLaunchAd{
    //使用默认配置
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    imageAdconfiguration.duration = 3.33;
    imageAdconfiguration.skipButtonType = SkipTypeNone;
    //图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    if (iPhone5Screen) {
        imageAdconfiguration.imageNameOrURLString = @"launchAd-640x1136.png";
    } else if (iPhone6Screen){
        imageAdconfiguration.imageNameOrURLString = @"launchAd-750x1334.png";
    } else if (iPhone6pScreen){
        imageAdconfiguration.imageNameOrURLString = @"launchAd-2208x1240.png";
    }
    
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

- (void)xhLaunchShowFinish:(XHLaunchAd *)launchAd{
    //登录
    if (isUserLogin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            //进入app
            [rootDelegate login];
        });
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            //进入登录
            [rootDelegate showLoginForm];
        });
    }
}

@end
