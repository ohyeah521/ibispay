//
//  ColorDefine.h
//  Ibis
//
//  Created by 鸟神 on 2017/6/11.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

//gray
#define kColorDarkGray0 [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0557 alpha:1.0]   //深灰色1
#define kColorDarkGray1 [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.136 alpha:1.0]    //深灰色2
#define kColorDarkGray2 [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.309 alpha:1.0]    //深灰色3，如文字主要颜色
#define kColorGray1 [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.5625 alpha:1.0]       //次要灰色1
#define kColorGray2 [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.70 alpha:1.0]         //次要灰色2
#define kColorGray3 [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.864 alpha:1.0]        //次要灰色3
#define kColorGray4 [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.96 alpha:1.0]         //次要灰色4，如图片未加载的颜色

//蓝色 204(最浅的蓝色) 222(360φ) 215(204~φ~222)
/**
 blue & yellow 蓝饱和度>0.9
 蓝黄搭配，一种晶莹的视错觉配色{0.618/0.764=0.809  0.809+(1-0.809)*0.5625=0.916   0.916*0.618=0.5666   360*0.56666=204 ≈ 360*0.5625=203}
 */
#define kColorMainBlue [UIColor colorWithHue:204/360.0 saturation:1.0 brightness:0.764 alpha:1.0]//深蓝1，如Nav的颜色、下方tab选中的颜色
#define kColorMainBlue2 [UIColor colorWithHue:204/360.0 saturation:0.96 brightness:0.68 alpha:1.0]//深蓝2，如上方Tab的颜色
#define kColorMainBlue3 [UIColor colorWithHue:204/360.0 saturation:0.916 brightness:0.236 alpha:1.0]//深蓝3，如按钮描边的颜色
#define kColorMainYellow [UIColor colorWithHue:31.0/360.0 saturation:0.83 brightness:0.916 alpha:1.0]//橘黄，如选中上方Tab的标示的颜色
#define kColorMainYellow2 [UIColor colorWithHue:48.0/360.0 saturation:0.916 brightness:1.0 alpha:1.0]//亮黄，如上传进度
#define kColorMainYellow3 [UIColor colorWithHue:48.0/360.0 saturation:0.618 brightness:0.916 alpha:1.0]//深黄，如接戏按钮颜色
#define kColorMainYellow4 [UIColor colorWithHue:48.0/360.0 saturation:0.12 brightness:0.916 alpha:1.0]//暗黄，如深色背景的列表文字颜色
/**
 navbar blue
 不带透明的原始效果1：[UIColor colorWithHue:222.0/360 saturation:0.62 brightness:0.62 alpha:1.0] //facebook
 需要设置成：[UIColor colorWithHue:222.0/360.0 saturation:0.81 brightness:0.56 alpha:1.0]
 不带透明的原始效果2：[UIColor colorWithHue:215.0/360 saturation:0.72 brightness:0.62 alpha:1.0]
 需要设置成：[UIColor colorWithHue:215.0/360.0 saturation:0.94 brightness:0.56 alpha:1.0]
 不带透明的原始效果3：[UIColor colorWithHue:222.0/360.0 saturation:0.61 brightness:0.72 alpha:1.0] //颜色效果和 kColorMainBlue 近似
 需要设置成：[UIColor colorWithHue:222.0/360.0 saturation:0.77 brightness:0.68 alpha:1.0]
 */
#define kNavbarColor [UIColor colorWithHue:222.0/360.0 saturation:0.77 brightness:0.68 alpha:1.0]
//view blue
#define kViewBGColor [UIColor colorWithHue:204.0/360.0 saturation:0.0557 brightness:0.99 alpha:1.0]

//red
#define kColorMainRed [UIColor colorWithHue:337.08/360.0 saturation:1.0 brightness:0.764 alpha:1.0]//大红，如Nav的颜色
#define kColorMainRed2 [UIColor colorWithHue:337.08/360.0 saturation:0.916 brightness:0.618 alpha:1.0]//暗红，如Tab的颜色
#define kColorMainRed3 [UIColor colorWithHue:345.84/360.0 saturation:1.0 brightness:1.0 alpha:1.0]//亮红，如FoldingBar颜色

//cell
#define kCellHighlightColor [UIColor colorWithWhite:0.000 alpha:0.034]
//avatar border
#define kAvatarDefaultBorderColor [UIColor colorWithWhite:0.89 alpha:1.0]

