//
//  SuperList.m
//  Action
//
//  Created by 鸟神 on 2017/5/19.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "SuperList.h"

@interface SuperList ()

@end

@implementation SuperList

- (void)initFunc{
    //根据需要在子类的initFunc中重写下面的参数,并且设置slDelegata为子类
    _canLoadMore = YES;
    _isSyncMapping = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //---------init vars---------
    self.skip = 0;
    if ([self.slDelegate respondsToSelector:@selector(setRequestAttr:)]) {
        _firstPageKey = [[self.slDelegate setRequestAttr:0] stringByAppendingString:[NSString stringWithFormat:@"_%@",kApiVersion]];
    }else{
        NSLog(@"no url");
        return;
    }
    
    //---------set UI----------
    [self setSuperListUI];
    
    //---------load cached data----------
    if ([self.slDelegate respondsToSelector:@selector(loadCachedData)]) {
        [self.slDelegate loadCachedData];
    }else{
        [self getCacheData];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //检测是否为返回pop
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {        
        [self finishedRequesting];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate{
    if (_canLoadMore) {
        //load more data
        if (self.skip != -1) {
            CGPoint offset = aScrollView.contentOffset;
            if (offset.y < 0) {
                //下拉时不触发
                return;
            }
            CGRect bounds = aScrollView.bounds;
            CGSize size = aScrollView.contentSize;
            UIEdgeInsets inset = aScrollView.contentInset;
            float y = offset.y + bounds.size.height - inset.bottom;
            float h = size.height;
            
            float reload_distance = -kFooterHeight;
            if(y > h + reload_distance) {
                __weak typeof(self) weakSelf = self;
                [CommonFunction runAfterTime:1 run:^{
                    [weakSelf getData:NO juhuaView:nil];
                }];
            }
        }
    }
}

#pragma mark - private function

- (void)setSuperListUI{
    //---------pull to refresh--------
    if ([self.slDelegate respondsToSelector:@selector(addPullToRefreshUI)]) {
        [self.slDelegate addPullToRefreshUI];
    }else{
        __weak typeof(self) weakSelf = self;
        [self.tableView ins_addPullToRefreshWithHeight:kPullToRefreshHeight handler:^(UIScrollView *scrollView) {
            [CommonFunction runAfterTime:1 run:^{
                if ([weakSelf.slDelegate respondsToSelector:@selector(loadHttpData)]) {
                    [weakSelf.slDelegate loadHttpData];
                }else{
                    [weakSelf getFirstPageData];
                }
            }];
        }];
        
        CGRect defaultFrame = CGRectMake(0, 0, 24, 24);
        UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [[INSVinePullToRefresh alloc] initWithFrame:defaultFrame];
        
        self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
        [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
    }
    
    if (_canLoadMore) {
        if ([self.slDelegate respondsToSelector:@selector(addLoadMoreUI)]) {
            [self.slDelegate addLoadMoreUI];
        }else{
            DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScale tintColor:kColorDarkGray2 size:20.0f];
            activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, kFooterHeight, kFooterHeight);
            activityIndicatorView.centerX = screenWidth/2;
            [self.tableView.tableFooterView addSubview:activityIndicatorView];
            _loadMoreHUD = activityIndicatorView;
        }
    }
}

- (void)getCacheData{
    NSData *jsonData = (NSData *)[[[PINCache sharedCache] diskCache] objectForKey:_firstPageKey];
    if (isNull(jsonData) == NO) {
        self.dataSHA1 = [jsonData SHA1String];
        NSError *err;
        id cachedObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
        if (isNull(err) == NO) {
            [self performSelector:@selector(getFirstPageDataWithJuhua) withObject:nil afterDelay:0.2];
            return;
        }
        
        if (_isSyncMapping) {
            if ([self.slDelegate respondsToSelector:@selector(syncMapping:isCachedData:done:)]) {
                [self.slDelegate syncMapping:cachedObject isCachedData:YES done:^{
                    [self.tableView reloadData];
                    [self finishedRequesting];
                    [self getFirstPageData];
                }];
            }else{
                [self performSelector:@selector(getFirstPageDataWithJuhua) withObject:nil afterDelay:0.2];
                return;
            }
            
        }else{
            if ([self.slDelegate respondsToSelector:@selector(asyncMapping:isCachedData:done:)]) {
                [self.slDelegate asyncMapping:cachedObject isCachedData:YES done:^{
                    [self.tableView reloadData];
                    [self finishedRequesting];
                    [self getFirstPageData];
                }];
            }else{
                [self performSelector:@selector(getFirstPageDataWithJuhua) withObject:nil afterDelay:0.2];
                return;
            }
        }
    }else{
        [self performSelector:@selector(getFirstPageDataWithJuhua) withObject:nil afterDelay:0.2];
    }
}

//无菊花
- (void)getFirstPageData{
    self.skip = 0;
    [self getData:NO juhuaView:nil];
}
//有菊花
- (void)getFirstPageDataWithJuhua{
    self.skip = 0;
    [self getData:YES juhuaView:self.view.superview];
}
//全局菊花
- (void)getFirstPageDataWithGlobalJuhua{
    self.skip = 0;
    [self getData:YES juhuaView:[rootDelegate topViewController].view];
}

- (void)getData:(BOOL)showJuHua juhuaView:(UIView *)juhuaView{
    if (self.isClosed) {
        return;
    }
    
    _requestUrl = [self.slDelegate setRequestAttr:self.skip];
    if (_requestUrl == nil) {
        NSLog(@"no url");
        return;
    }
    
    if (self.isLoading == YES || self.skip == -1) {
        return;
    }
    self.isLoading = YES;
    
    //全局菊花
    if (self.arrData.count == 0 || showJuHua == YES) {
        showJuHua(nil, juhuaView);
    }
    //底部菊花
    if (self.skip > 0 && self.arrData.count >0) {
        self.lblFooter.hidden = YES;
        [_loadMoreHUD startAnimating];
    }
    
    [AFNetworkHelper getUrl:_requestUrl bg:!showJuHua param:nil succeed:^(id responseObject) {
        if (self.isClosed) {
            hideJuHuaNoAnimation(juhuaView);
            return;
        }
        if (isNull(responseObject) == NO) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            if (self.skip == 0) {
                NSString *SHA1 = [jsonData SHA1String];
                if ([self.dataSHA1 isEqualToString:SHA1]) {
                    self.skip = self.lastSkip;
                    hideJuHua(juhuaView);
                    [self finishedRequesting];
                    return;
                }
                self.dataSHA1 = SHA1;
                
                [[[PINCache sharedCache] diskCache] setObject:jsonData forKey:self.firstPageKey block:nil];
            }
            
            if (_isSyncMapping) {
                if ([self.slDelegate respondsToSelector:@selector(syncMapping:isCachedData:done:)]) {
                    [self.slDelegate syncMapping:responseObject isCachedData:NO done:^{
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [SimpleAudioPlayer playFile:kNewItemSoundFileName volume:1.0 loops:0 withCompletionBlock:nil];
                        });
                        hideJuHua(juhuaView);
                        [self finishedRequesting];
                    }];
                }else{
                    showAndHideWrongJuHua(@"未实现解析方法", juhuaView);
                    [self finishedRequesting:YES];
                }
                
            }else{
                if ([self.slDelegate respondsToSelector:@selector(asyncMapping:isCachedData:done:)]) {
                    [self.slDelegate asyncMapping:responseObject isCachedData:NO done:^{
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [SimpleAudioPlayer playFile:kNewItemSoundFileName volume:1.0 loops:0 withCompletionBlock:nil];
                        });
                        hideJuHua(juhuaView);
                        [self finishedRequesting];
                    }];
                }else{
                    showAndHideWrongJuHua(@"未实现解析方法", juhuaView);
                    [self finishedRequesting:YES];
                }
            }
        }else{
            showAndHideWrongJuHua(@"网络错误", juhuaView);
            [self finishedRequesting:YES];
        }
    } fail:^{
        if (self.isClosed) {
            hideJuHuaNoAnimation(juhuaView);
            return;
        }
        hideJuHua(juhuaView);
        [self finishedRequesting:YES];
    }];
}

- (void)finishedRequesting{
    [self finishedRequesting:NO];
}
- (void)finishedRequesting:(BOOL)fail{
    [self.tableView ins_endPullToRefresh];
    [_loadMoreHUD stopAnimating];
    self.isLoading = NO;
    
    if (fail) {
        if (isNull(self.dataSHA1) == NO) {
            self.lblFooter.hidden = NO;
            self.lblFooter.text = @"- 以上为缓存 -";
        }else{
            self.lblFooter.hidden = YES;
        }
        return;
    }
    
    if (self.skip == -1 && self.arrData.count >0) {
        self.lblFooter.hidden = NO;
        self.lblFooter.text = @"- 已全部加载 -";
    }else if(self.skip != -1){
        self.lblFooter.hidden = NO;
        self.lblFooter.text = @"上滑加载更多";
    }else{
        if (isNull(self.dataSHA1) == NO) {
            self.lblFooter.hidden = NO;
            self.lblFooter.text = @"- 以上为缓存 -";
        }else{
            self.lblFooter.hidden = YES;
        }
    }
    
    if ([self.slDelegate respondsToSelector:@selector(finishdRequesting)]) {
        [self.slDelegate finishdRequesting];
    }
}

@end
