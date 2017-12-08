//
//  MyRoleCellLayout.h
//  Action
//
//  Created by 鸟神 on 2017/5/31.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "RoleModel.h"
#import "UserModel.h"
#import "CoinModel.h"
#import "CellTextLinePositionModifier.h"

//16号字=29像素 0.618：11、18、29、47、76
#define kMyRoleCellPadding 13             //cell内边距
#define kMyRoleCellPaddingPic 2           //图片之间留白
#define kMyRoleCellPaddingText 10         //文本与其他元素间留白
#define kMyRoleCellPaddingLine 73         //分割线左边距
#define kMyRoleCellAvatarHeight 47        //头像大小
#define kMyRoleCellAvatarPadding 15       //头像左边距、上边距
#define kMyRoleCellAvatarBorderWidth 1    //头像的外描边 像素
#define kMyRoleCellAvatarBorderColor [UIColor colorWithWhite:0.89 alpha:1.0].CGColor //头像描边颜色
#define kMyRoleCellVerifyImgWidth 14      //有真人头像的标记图片的长宽
#define kMyRoleCellNameBottomHeight 27    //顶部到昵称底部高度(包括留白)
#define kMyRoleCellNamePaddingLeft 13     //昵称和头像之间距离
#define kMyRoleCellNameWidth (kScreenWidth - 74*2) //昵称最宽限制
#define kMyRoleCellNameFontSize 12        //昵称文字大小
#define kMyRoleCellCoinNameFontSize 15    //鸟币名称大小
#define kMyRoleCellTagPaddingRight 18     //tag距离右边的距离
#define kMyRoleCellTagFontSize 12         //tag字体大小
#define kMyRoleCellTagWidth (kMyRoleCellPaddingLine-kMyRoleCellPadding-kMyRoleCellTagPaddingRight) //tag宽度
#define kMyRoleCellContentLeftPadding 75  //描述左边距
#define kMyRoleCellContentRightPadding 15 //描述右边距
#define kMyRoleCellContentWidth (kScreenWidth - kMyRoleCellContentRightPadding - kMyRoleCellContentLeftPadding) //描述宽度
#define kMyRoleCellContentFontSize 16     //描述字体大小
#define kMyRoleCellAttrFontSize 12        //属性文字大小
#define kMyRoleCellTimeFontSize 12        //时间文字大小
#define kMyRoleCellBottomMargin 0         //cell下方留白


//cell的布局结果，在后台线程中完成
@interface MyRoleCellLayout : NSObject
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) RoleModel *roleModel;
@property (nonatomic, strong) CoinModel *coinModel;
//---排版结果---
@property (nonatomic, assign) CGFloat marginTop;// 顶部留白
                                                // header
@property (nonatomic, assign) CGFloat headerHeight; //header高度(包括留白)
@property (nonatomic, assign) CGFloat nameBottomHeight; //顶部到名称底部高度(包括留白)
@property (nonatomic, strong) YYTextLayout *nameTextLayout; //名称layout
@property (nonatomic, strong) YYTextLayout *tagTextLayout; //标签layout
                                                           //描述
@property (nonatomic, assign) CGFloat detailTextHeight;//描述高度，0为没内容
@property (nonatomic, strong) YYTextLayout *detailTextLayout; //描述layout
                                                              //图片
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;
//属性1
@property (nonatomic, assign) CGFloat attrHeight; //属性1高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *attrLayout; //属性1layout
//属性2
@property (nonatomic, assign) CGFloat attrHeight2; //属性2高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *attrLayout2; //属性2layout
//时间
@property (nonatomic, assign) CGFloat timeHeight; //时间高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *timeLayout; //时间layout
//底部留白
@property (nonatomic, assign) CGFloat marginBottom;
// 总高度
@property (nonatomic, assign) CGFloat height;

- (instancetype)initWithRole:(RoleModel *)role user:(UserModel *)user coin:(CoinModel *)coin;
- (void)layout;//计算布局
@end


