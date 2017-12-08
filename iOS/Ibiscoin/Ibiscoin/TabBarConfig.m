//
//  TabBarConfig.m
//  Ibis
//
//  Created by 鸟神 on 2017/6/9.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import "TabBarConfig.h"
#import "RoleList.h"
#import "MyRoleList.h"

@interface BaseNavigationController : UINavigationController
@end

@implementation BaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end


@interface TabBarConfig ()<UITabBarControllerDelegate>

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation TabBarConfig


/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        /**
         * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
         * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
         * 更推荐后一种做法。
         */
        UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
        UIOffset titlePositionAdjustment = UIOffsetZero;//UIOffsetMake(0, MAXFLOAT);
        
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                                   tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                             imageInsets:imageInsets
                                                                                 titlePositionAdjustment:titlePositionAdjustment];
        
        [self customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

- (NSArray *)viewControllers {
//    CYLHomeViewController *firstViewController = [[CYLHomeViewController alloc] init];
//    UIViewController *firstNavigationController = [[BaseNavigationController alloc] initWithRootViewController:firstViewController];
//
//    CYLSameCityViewController *secondViewController = [[CYLSameCityViewController alloc] init];
//    UIViewController *secondNavigationController = [[BaseNavigationController alloc]
//                                                    initWithRootViewController:secondViewController];
//
//    CYLMessageViewController *thirdViewController = [[CYLMessageViewController alloc] init];
//    UIViewController *thirdNavigationController = [[BaseNavigationController alloc]
//                                                   initWithRootViewController:thirdViewController];
//
//    CYLMineViewController *fourthViewController = [[CYLMineViewController alloc] init];
//    UIViewController *fourthNavigationController = [[BaseNavigationController alloc]
//                                                    initWithRootViewController:fourthViewController];
//
//
//    NSArray *viewControllers = @[
//                                 firstNavigationController,
//                                 secondNavigationController,
//                                 thirdNavigationController,
//                                 fourthNavigationController
//                                 ];
//    return viewControllers;
    
    UIViewController *firstNavigationController = [[BaseNavigationController alloc] initWithRootViewController:[RoleList new]];
    UIViewController *firstNavigationController2 = [[BaseNavigationController alloc] initWithRootViewController:[MyRoleList new]];
    UIViewController *firstNavigationController3 = [[BaseNavigationController alloc] initWithRootViewController:[UIViewController new]];
    UIViewController *firstNavigationController4 = [[BaseNavigationController alloc] initWithRootViewController:[UIViewController new]];
    return @[firstNavigationController,firstNavigationController2,firstNavigationController3,firstNavigationController4];
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 //CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"tabIcon-home",
                                                 CYLTabBarItemSelectedImage : @"tabIcon-home-selected",
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  //CYLTabBarItemTitle : @"角色",
                                                  CYLTabBarItemImage : @"tabIcon-ibis",
                                                  CYLTabBarItemSelectedImage : @"tabIcon-ibis-selected",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 //CYLTabBarItemTitle : @"鸟币",
                                                 CYLTabBarItemImage : @"tabIcon-data",
                                                 CYLTabBarItemSelectedImage : @"tabIcon-data-selected",
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  //CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage : @"tabIcon-profile",
                                                  CYLTabBarItemSelectedImage : @"tabIcon-profile-selected"
                                                  };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    // Customize UITabBar height
    // 自定义 TabBar 高度
    tabBarController.tabBarHeight = 44.f;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
     [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:kViewBGColor];
//    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithHue:222.0/360 saturation:0.764 brightness:0.618 alpha:1.0]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar-top-line"]];
    
    // set the bar background image
    // 设置背景图片
    //     UITabBar *tabBarAppearance = [UITabBar appearance];
    //     [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tab_bar"]];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    //     [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
//    UITabBarController *tabBarController = [self cyl_tabBarController] ?: [[UITabBarController alloc] init];
    CGFloat tabBarHeight = 44;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
//    [tabBar setSelectionIndicatorImage:[[self class] imageWithColor:[UIColor colorWithHue:31.0/360.0 saturation:0.83 brightness:0.916 alpha:1.0] size:selectionIndicatorImageSize]];
//    [tabBar setSelectionIndicatorImage:[[self class] imageWithColor:[UIColor colorWithHue:222.0/360 saturation:0.764 brightness:0.618 alpha:1.0] size:selectionIndicatorImageSize]];
    [tabBar setSelectionIndicatorImage:[[self class] imageWithColor:kColorMainBlue size:selectionIndicatorImageSize]];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
