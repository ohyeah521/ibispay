//
//  SuperTableView.h
//  Action
//
//  Created by 鸟神 on 2017/5/16.
//  Copyright © 2017年 xingdongpai.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewRoot.h"
#import "UITableView+BG.h"
#import "CommonCell.h"
#import "CommonCellLayout.h"
#import "CommonSectionModel.h"

#define kTopInsert 64
#define kFooterHeight 59
#define kPullToRefreshHeight 59//164*0.7236/2

//通用的cell类型
typedef NS_ENUM(NSUInteger, CommonCellType){
    CommonCellTypeCustom = 0,//自定义
    CommonCellType0 = 1,//大图片+文字+详情+时间+箭头
    CommonCellType1,//文字+时间+箭头
    CommonCellType2,//文字+详情+时间+箭头
    CommonCellType3,//文字+详情+时间+箭头 选择态
    CommonCellType4,//小图片+文字+详情+时间+箭头
};

@class SuperTableView;

@protocol SuperTableViewDelegate <NSObject>

@optional
- (void)dismissSelf:(SuperTableView *)superTableView;
- (void)setBG:(UITableView *)tableView withRowCount:(NSInteger)count;
- (void)addHeader;
- (void)addFooter;
- (void)push:(NSIndexPath *)indexPath;
//--使用自定义cell须实现--
- (void)loadLocalJsonData;
//--使用通用cell须实现--
- (NSString *)setLocalJsonFile;
- (NSString *)setCommonCellID;

@end

//tableView第一层：通用背景->通用设定、默认一个section->是否显示navbar标示->返回按钮->通用的pop或者dismiss->通用footer->通用header接口->加载本地数据->通用的cell
/**
 ！！若不使用通用cell，则必须在子类实现以下方法
//- (NSInteger)getNumOfRowsInSection:(NSInteger)section
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 */
@interface SuperTableView : UIViewController <UITableViewDelegate, UITableViewDataSource, CommonCellDelegate>

@property (nonatomic) BOOL isPresented;//是否是presented，默认否
@property (nonatomic) BOOL isClosed;//当前页面是否已经关闭或后退，默认否
@property (nonatomic) BOOL groupedStyle;//tableview的风格，默认否，plain风格
@property (nonatomic) BOOL showHeader;//是否显示自定义header，默认不显示
@property (nonatomic) BOOL showFooter;//是否显示通用footer，默认不显示
@property (nonatomic) BOOL showBackBtn;//是否显示自定义返回按钮，默认不显示
@property (nonatomic) BOOL navBarHidden;//是否隐藏了navbar的标识，但并不实际控制本页面的navbar显隐
@property (nonatomic) CommonCellType commonCellType;//通用cell的类型

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableArray *arrSections;//arrSections由1个或多个arrLayouts组成,layout是每个cell的排版
@property (nonatomic, weak) id<SuperTableViewDelegate> delegate;
@property (nonatomic, copy) void (^popBack)(SuperTableView *superTableView);

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) UILabel *lblFooter;

@end
