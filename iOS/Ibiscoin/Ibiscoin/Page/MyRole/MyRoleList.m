//
//  MyRoleList.m
//  Ibiscoin
//
//  Created by 鸟神 on 2017/7/6.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import "MyRoleList.h"
#import "NewGoalList.h"

#define kRoleListHeaderHeight 84 // 64/0.764
#define kRoleListFooterHeight 44
#define kColorMyRoleListHeaderBlue [UIColor colorWithHue:222.0/360.0 saturation:0.07 brightness:0.96 alpha:1.0]
#define kColorMyRoleListHeaderSelectedBlue [UIColor colorWithHue:216.0/360.0 saturation:0.16 brightness:0.9 alpha:1.0]
#define kColorMyRoleListHeaderTitle [UIColor colorWithHue:222.0/360.0 saturation:0.86 brightness:0.38 alpha:1.0]
#define kColorMyRoleListHeaderSubTitle [UIColor colorWithHue:226.0/360.0 saturation:0.21 brightness:0.7236 alpha:1.0]

@interface MyRoleList ()

@end

@implementation MyRoleList

- (void)initFunc{
    self.delegate = self;
    self.slDelegate = self;
    self.canLoadMore = NO;
    self.showFooter = YES;
    self.isSyncMapping = YES;
    self.commonCellType = CommonCellTypeCustom;
    
    self.mappingQueue = dispatch_queue_create( "net.niaobi.MyRoleList.mappingQueue", DISPATCH_QUEUE_SERIAL );
    
    //config UI
    self.navigationItem.title = @"我的角色";//CYLTab Title
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newGoal)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.contentInset = UIEdgeInsetsMake(kTopInsert, 0, kRoleListFooterHeight, 0);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, kMyRoleCellContentLeftPadding, 0, 0);
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)finishdRequesting{
    self.lblFooter.text = @"- 已全部加载 -";
}

- (void)setBG:(UITableView *)tableView withRowCount:(NSInteger)count{
    if (self.arrData.count == 0) {
        self.lblFooter.text = @"";
    }
    [self.tableView tableEmptyBGImg:@"" title:@"先请添加一个角色" txt:@"" withRowCount:self.arrData.count];
}

- (NSString *)setRequestAttr:(int)skip{
    if (isUserLogin) {
        return [NSString stringWithFormat:@"%@/%@/%d", kGetMyRoleListUrl, getUserId, skip];
    }
    return nil;
}

- (void)syncMapping:(id)responseObject isCachedData:(BOOL)cachedData done:(dispatch_block_t)done{
    dispatch_sync(self.mappingQueue, ^{
        MyRoleListModel *listModel = [MyRoleListModel modelWithJSON:responseObject];
        int skip = listModel.skip;
        
        NSMutableArray<MyRoleCellLayout *> *layouts = [[NSMutableArray alloc] init];
        for (MyRoleListDetailModel *rldm in listModel.list) {
            MyRoleCellLayout *layout = [[MyRoleCellLayout alloc] initWithRole:rldm.role user:listModel.user coin:rldm.coin];
            [layout layout];
            [layouts addObject:layout];
        }
        
        //检查arrSection最后一项section是否含有arrLayout
        BOOL lastIsRCLayoutType = NO;
        NSMutableArray *arrInLastSection = [[NSMutableArray alloc] initWithArray:self.arrSections.lastObject];
        if (arrInLastSection.count > 0) {
            if ([arrInLastSection[0] isKindOfClass:[MyRoleCellLayout class]]) {
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

- (void)push:(NSIndexPath *)indexPath{
    //    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //    if (self.isFormNewLove || self.isFormNewSkill) {
    //        self.tableView.userInteractionEnabled = NO;
    //
    //        [self.tableView clearSelectedRowsAnimated:NO];
    //        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    //
    //        RoleModel *r = [self.arrData objectAtIndex:indexPath.row];
    //        RoleModel *role = [RoleModel new];
    //        role.roleID = r.roleID;
    //        role.name = r.name;
    //        role.desc = r.desc;
    //        role.avatar = r.avatar;
    //        role.updateTimeAgo = r.updateTimeAgo;
    //
    //        if (_saveBack) _saveBack(role, indexPath);
    //
    //        self.tableView.userInteractionEnabled = YES;
    //    }
}

- (NSInteger)getNumOfRowsInSection:(NSInteger)section{
    if (section == self.arrSections.count-1) {
        return self.arrData.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrSections.count > 0) {
        //判断是角色cell还是其他比如custom header
        if([self.arrSections[indexPath.section][indexPath.row] isKindOfClass:[MyRoleCellLayout class]]){
            NSString *cellID = @"my_role_list_cell_id";
            MyRoleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[MyRoleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.delegate = self;
            }
            MyRoleCellLayout *layout = self.arrSections[indexPath.section][indexPath.row];
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
        MyRoleCellLayout *layout = self.arrSections[indexPath.section][indexPath.row];
        return layout.height;
    }
    return 0;
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
    header.backgroundColor = kColorMyRoleListHeaderSelectedBlue;
    UIButton *btnLeft = [self addHeader:@"icon_coin" title:@"赞助收入" numIn:@"26180" strSponsor:@"588人支持"];
    UIButton *btnRight = [self addHeader:@"icon_coin2" title:@"赞助支出" numIn:@"2764" strSponsor:@"支持了98人"];
    btnRight.left = CGFloatPixelRound(screenWidth / 2.0)+1;
    [header addSubview:btnLeft];
    [header addSubview:btnRight];
    
    self.tableView.tableHeaderView = header;
}

- (UIButton *)addHeader:(NSString *)imgName title:(NSString *)title numIn:(NSString *)strNumIn strSponsor:(NSString *)strSponsor{
    //btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = YES;
    btn.size = CGSizeMake(CGFloatPixelRound(screenWidth / 2.0), kRoleListHeaderHeight);
    [btn setBackgroundImage:[UIImage imageWithColor:kColorMyRoleListHeaderBlue] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:kColorMyRoleListHeaderSelectedBlue] forState:UIControlStateHighlighted];
    //icon
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    img.left = 13;
    img.centerY = btn.centerY;
    [btn addSubview:img];
    //iconCellArrow
    UIImageView *imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconCellArrow"]];
    imgArrow.left = CGFloatPixelRound(screenWidth / 2.0)-20;
    imgArrow.centerY = btn.centerY;
    [btn addSubview:imgArrow];
    //lbl
    NSMutableAttributedString *strIn = [[NSMutableAttributedString alloc] initWithString:title];
    strIn.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightBold];
    strIn.color = kColorMyRoleListHeaderTitle;
    strIn.alignment = NSTextAlignmentLeft;
    YYLabel *lblIn = [YYLabel new];
    lblIn.attributedText = strIn;
    lblIn.top = 45/2;
    lblIn.left = 52;//52/84=0.618
    lblIn.width = screenWidth / 4.0;
    lblIn.height = 15;
    lblIn.textAlignment = NSTextAlignmentLeft;
    lblIn.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    lblIn.displaysAsynchronously = YES;
    lblIn.ignoreCommonProperties = NO;
    lblIn.fadeOnAsynchronouslyDisplay = NO;
    lblIn.fadeOnHighlight = NO;
    lblIn.userInteractionEnabled = NO;
    [btn addSubview:lblIn];
    
    NSMutableAttributedString *numIn = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@鸟币/月",strNumIn]];
    numIn.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightBold];
    numIn.color = kColorMyRoleListHeaderSubTitle;
    numIn.alignment = NSTextAlignmentLeft;
    YYLabel *lblNumIn = [YYLabel new];
    lblNumIn.attributedText = numIn;
    lblNumIn.top = kRoleListHeaderHeight/2;
    lblNumIn.left = 52;//52/84=0.618
    lblNumIn.width = screenWidth / 4.0;
    lblNumIn.height = 12;
    lblNumIn.textAlignment = NSTextAlignmentLeft;
    lblNumIn.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    lblNumIn.displaysAsynchronously = YES;
    lblNumIn.ignoreCommonProperties = NO;
    lblNumIn.fadeOnAsynchronouslyDisplay = NO;
    lblNumIn.fadeOnHighlight = NO;
    lblNumIn.userInteractionEnabled = NO;
    [btn addSubview:lblNumIn];
    
    NSMutableAttributedString *numSponsor = [[NSMutableAttributedString alloc] initWithString:strSponsor];
    numSponsor.font = [UIFont systemFontOfSize:9.0 weight:UIFontWeightRegular];
    numSponsor.color = kColorMyRoleListHeaderSubTitle;
    numSponsor.alignment = NSTextAlignmentLeft;
    YYLabel *lblSponsor = [YYLabel new];
    lblSponsor.attributedText = numSponsor;
    lblSponsor.top = lblNumIn.bottom+2;
    lblSponsor.left = 52;//52/84=0.618
    lblSponsor.width = screenWidth / 2.0-52-10;
    lblSponsor.height = 9;
    lblSponsor.textAlignment = NSTextAlignmentLeft;
    lblSponsor.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    lblSponsor.displaysAsynchronously = YES;
    lblSponsor.ignoreCommonProperties = NO;
    lblSponsor.fadeOnAsynchronouslyDisplay = NO;
    lblSponsor.fadeOnHighlight = NO;
    lblSponsor.userInteractionEnabled = NO;
    [btn addSubview:lblSponsor];
    
    return btn;
}

@end
