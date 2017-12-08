//
//  SuperList.h
//  Action
//
//  Created by 鸟神 on 2017/5/19.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "SuperTableView.h"
#import "DGActivityIndicatorView.h"

@protocol SuperListDelegate <SuperTableViewDelegate>

- (NSString *)setRequestAttr:(int)skip;//如:return [NSString stringWithFormat:@"%@/%d",kGetFeedRecommendedListUrl,skip]
@optional
- (void)addPullToRefreshUI;
- (void)addLoadMoreUI;
- (void)loadCachedData;
- (void)loadHttpData;//只适用于默认的pullToRefresh
//以下两个方法必须实现一个
- (void)asyncMapping:(id)responseObject isCachedData:(BOOL)cachedData done:(void (^)(void))done;
- (void)syncMapping:(id)responseObject isCachedData:(BOOL)cachedData done:(dispatch_block_t)done;
//完成请求后调用
- (void)finishdRequesting;

@end

//带网络请求的tableview的父类
//tableView第二层：->通用的网络数据获取动画->通用的数据加载
@interface SuperList : SuperTableView

@property (nonatomic) BOOL isSyncMapping;//默认否、异步处理数据，拥有比较复杂顺序的请求页面比如：首页，使用同步
@property (nonatomic) BOOL canLoadMore;//是否支持加载更多，默认支持
@property (nonatomic, weak) id<SuperListDelegate> slDelegate;

@property (nonatomic) int skip;
@property (nonatomic) int lastSkip;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, copy) NSString *dataSHA1;
@property (nonatomic) dispatch_queue_t mappingQueue;
@property (nonatomic, strong) NSString *firstPageKey;//url
@property (nonatomic, strong) NSString *requestUrl;

@property (nonatomic, strong) DGActivityIndicatorView *loadMoreHUD;

- (void)getFirstPageData;
- (void)getFirstPageDataWithJuhua;
- (void)getFirstPageDataWithGlobalJuhua;

@end
