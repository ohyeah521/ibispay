//
//  RoleList.m
//  Action
//
//  Created by 鸟神 on 2017/5/30.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "RoleList.h"
#import "NewGoalList.h"
#import "HomeDetailList.h"

#define kRoleListHeaderHeight 114 // 64/0.5625
#define kRoleListFooterHeight 44

@interface RoleList ()

@end

@implementation RoleList

- (void)initFunc{
    self.delegate = self;
    self.slDelegate = self;
    self.canLoadMore = NO;
    self.showFooter = YES;
    self.isSyncMapping = YES;
    self.commonCellType = CommonCellTypeCustom;
    
    self.mappingQueue = dispatch_queue_create( "net.niaobi.RoleList.mappingQueue", DISPATCH_QUEUE_SERIAL );
    
    //config UI
    self.navigationItem.title = @"鸟币";//CYLTab Title
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newGoal)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.contentInset = UIEdgeInsetsMake(kTopInsert, 0, kRoleListFooterHeight, 0);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, kRoleCellContentLeftPadding, 0, 0);
    
    [self customHeader];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView clearSelectedRowsAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - SuperListDelegate

- (void)finishdRequesting{
    self.lblFooter.text = @"- 以上为随机推荐 -";
}

- (void)setBG:(UITableView *)tableView withRowCount:(NSInteger)count{
    if (self.arrData.count == 0) {
        self.lblFooter.text = @"";
    }
    [self.tableView tableEmptyBGImg:@"" title:@"暂无数据" txt:@"可能由于网络不佳或服务器维护，暂时无法获取首页数据" withRowCount:self.arrData.count];
}

- (NSString *)setRequestAttr:(int)skip{
    if (isUserLogin) {
        return [NSString stringWithFormat:@"%@", kGetRoleRandomListUrl];
    }
    return nil;
}

- (void)syncMapping:(id)responseObject isCachedData:(BOOL)cachedData done:(dispatch_block_t)done{
    dispatch_sync(self.mappingQueue, ^{
        RoleListModel *listModel = [RoleListModel modelWithJSON:responseObject];
        int skip = listModel.skip;
        
        NSMutableArray<RoleCellLayout *> *layouts = [[NSMutableArray alloc] init];
        for (RoleListDetailModel *rldm in listModel.list) {
            RoleCellLayout *layout = [[RoleCellLayout alloc] initWithRole:rldm.role user:rldm.user coin:rldm.coin];
            [layout layout];
            [layouts addObject:layout];
        }
        
        //检查arrSection最后一项section是否含有arrLayout
        BOOL lastIsRCLayoutType = NO;
        NSMutableArray *arrInLastSection = [[NSMutableArray alloc] initWithArray:self.arrSections.lastObject];
        if (arrInLastSection.count > 0) {
            if ([arrInLastSection[0] isKindOfClass:[RoleCellLayout class]]) {
                lastIsRCLayoutType = YES;
            }
        }
        if (isNull(layouts) == NO && layouts.count>0) {
            if (self.skip == 0) {
                self.arrData = [NSMutableArray arrayWithArray:listModel.list];

                if (lastIsRCLayoutType) {
                    [self.arrSections replaceObjectAtIndex:self.arrSections.count-1 withObject:layouts];
                }else{
                    [self.arrSections addObject:layouts];
                }
                [self.tableView reloadData];
            }else if(skip > 0 || skip == -1){
                //暂无加载更多的功能
                /**
                //indexpaths for insert
                NSMutableArray *indexPathsInsert = [[NSMutableArray alloc] init];
                for (int i=0; i<layouts.count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+layouts.count inSection:self.arrSections.count>0?self.arrSections.count-1:0];
                    [indexPathsInsert addObject: indexPath];
                }
                
                [self.arrData addObjectsFromArray:listModel.list];
                
                [arrInLastSection addObjectsFromArray:layouts];
                [self.arrSections replaceObjectAtIndex:self.arrSections.count-1 withObject:arrInLastSection];
                [self.tableView insertRowsAtIndexPaths:indexPathsInsert withRowAnimation:UITableViewRowAnimationAutomatic];
                 */
            }
        }
        
         self.skip = self.lastSkip = skip;
        
        dispatch_barrier_async(dispatch_get_main_queue(), done);
    });
}

#pragma mark - UITableView delegate

- (NSInteger)getNumOfRowsInSection:(NSInteger)section{
    if (section == self.arrSections.count-1) {
        return self.arrData.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrSections.count > 0) {
        //判断是角色cell还是其他比如custom header
        if([self.arrSections[indexPath.section][indexPath.row] isKindOfClass:[RoleCellLayout class]]){
            NSString *cellID = @"role_list_cell_id";
            RoleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[RoleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.delegate = self;
            }
            RoleCellLayout *layout = self.arrSections[indexPath.section][indexPath.row];
            [cell setLayout:layout];
            return cell;
        }else{
            //custom header
        }
        
    }
    return NULL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.arrSections.count - 1) {
        RoleCellLayout *layout = self.arrSections[indexPath.section][indexPath.row];
        return layout.height;
    }
    return 0;
}

#pragma mark - RoleCellDelegate

- (void)cellDidClick:(RoleCell *)cell{
    RoleCellLayout *layout = cell.cellView.layout;
    HomeDetailList *hdl = [HomeDetailList new];
    hdl.lastPageLayout = layout;
    [self.navigationController pushViewController:hdl animated:YES];
}

#pragma mark - private func

- (void)newGoal{
    [SimpleAudioPlayer playFile:kNewPostSoundFileName volume:0.05 loops:0 withCompletionBlock:nil];
    
    UINavigationController *navGoal = [kMainSB instantiateViewControllerWithIdentifier:kSBNewGoalNavID];
    [self.navigationController presentViewController:navGoal animated:YES completion:^{
        
    }];
}

- (void)customHeader{
    //custom table header
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRoleListHeaderHeight)];
    
    UIButton *btnQRCode = [self addHeader:@"btn_qrcode" title:@"扫码"];
    [header addSubview:btnQRCode];
    UIButton *btnGive = [self addHeader:@"btn_rose" title:@"赠送"];
    btnGive.left = screenWidth/4;
    [header addSubview:btnGive];
    UIButton *btnTrade = [self addHeader:@"btn_trade" title:@"交换"];
    btnTrade.left = screenWidth/2;
    [header addSubview:btnTrade];
    UIButton *btnCashOut = [self addHeader:@"btn_cashout" title:@"兑现"];
    btnCashOut.left = screenWidth/4*3;
    [header addSubview:btnCashOut];
    
    self.tableView.tableHeaderView = header;
}

- (UIButton *)addHeader:(NSString *)imgName title:(NSString *)title{
    //btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = YES;
    btn.size = CGSizeMake(CGFloatPixelRound(screenWidth / 4.0), kRoleListHeaderHeight);
    [btn setBackgroundImage:[UIImage imageWithColor:kColorMainBlue] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:kColorMainBlue2] forState:UIControlStateHighlighted];
    //icon
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    img.top = 25;
    img.centerX = btn.centerX;
    [btn addSubview:img];
    //lbl
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
    text.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    text.color = [UIColor whiteColor];
    text.alignment = NSTextAlignmentCenter;
    YYLabel *lbl = [YYLabel new];
    lbl.attributedText = text;
    lbl.top = img.bottom+20;
    lbl.width = screenWidth / 4.0;
    lbl.height = 24;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    lbl.displaysAsynchronously = YES;
    lbl.ignoreCommonProperties = NO;
    lbl.fadeOnAsynchronouslyDisplay = NO;
    lbl.fadeOnHighlight = NO;
    lbl.userInteractionEnabled = NO;
    [btn addSubview:lbl];
    return btn;
}

@end
