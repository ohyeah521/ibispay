//
//  SuperTableView.m
//  Action
//
//  Created by 鸟神 on 2017/5/16.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import "SuperTableView.h"

#define kSectionHeaderHeight 59//164*0.7236/2
#define kSectionFooterHeight 0.01//解决header无法设定的系统bug

@interface SuperTableView ()

@end

@implementation SuperTableView

- (instancetype)init{
    self=[super init];
    if(self){
       [self initFunc];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initFunc];
    }
    return self;
}
- (void)initFunc{
    //根据需要在子类的init中重写下面的参数,并且设置delegata为子类
    //第一级父类
    _isPresented = NO;
    _isClosed = NO;
    _groupedStyle = NO;
    _showHeader = NO;
    _showFooter = NO;
    _showBackBtn = NO;
    _navBarHidden = NO;
    _commonCellType = CommonCellType0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //---------init vars---------
    _arrData = [NSMutableArray new];
    _arrSections = [NSMutableArray new];
    
    //---------set UI----------
    [self setSuperTableUI];
    
    //---------load local json data----------
    [self loadLocalJson];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isClosed = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isClosed = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //处理空背景
    if ([self.delegate respondsToSelector:@selector(setBG:withRowCount:)]) {
        [self.delegate setBG:tableView withRowCount:_arrSections.count];
    }else{
        [tableView tableEmptyBGImg:nil title:@"暂无数据" txt:@"" withRowCount:_arrSections.count];
    }
    
    return _arrSections.count>0?_arrSections.count:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getNumOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.groupedStyle == YES) {
        return kSectionHeaderHeight;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.groupedStyle == YES) {
        return kSectionFooterHeight;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell右边箭头按下后触发
    if ([self.delegate respondsToSelector:@selector(push:)]) {
        [self.delegate push:indexPath];
    }
}

//======若不使用通用cell，则“必须”在子类重新实现以下方法======
- (NSInteger)getNumOfRowsInSection:(NSInteger)section{
    if (self.commonCellType == CommonCellType0 && _arrSections.count > 0) {
        CommonSectionModel *oneSection = _arrSections[section];
        return oneSection.cellLayouts.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.commonCellType == CommonCellType0 && _arrSections.count > 0) {
        NSString *cellID = @"super_cell";
        if ([self.delegate respondsToSelector:@selector(setCommonCellID)]) {
            cellID = [self.delegate setCommonCellID];
        }
        
        CommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[CommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.indexPath = indexPath;
            cell.delegate = self;
        }
        CommonSectionModel *oneSection = _arrSections[indexPath.section];
        CommonCellLayout *layout = oneSection.cellLayouts[indexPath.row];
        [cell setLayout:layout];
        return cell;
    }else{
        return NULL;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.commonCellType == CommonCellType0 && _arrSections.count > 0) {
        CommonSectionModel *oneSection = _arrSections[section];
        if (oneSection.cells.count == 0 || isNullString(oneSection.header)) {
            return @"";
        }
        return [NSString stringWithFormat:@"    %@",oneSection.header];
    }else{
        return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (self.commonCellType == CommonCellType0 && _arrSections.count > 0) {
        CommonSectionModel *oneSection = _arrSections[section];
        if (oneSection.cells.count == 0 || isNullString(oneSection.footer)) {
            return @"";
        }
        return [NSString stringWithFormat:@"    %@",oneSection.footer];
    }else{
        return @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.commonCellType == CommonCellType0 && _arrSections.count > 0) {
        CommonSectionModel *oneSection = _arrSections[indexPath.section];
        CommonCellLayout *layout = oneSection.cellLayouts[indexPath.row];
        return layout.height;
    }else{
        return 0;
    }
}
//=====================================================

#pragma mark - CommonCellDelegate

- (void)cell:(CommonCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    
}

- (void)cell:(CommonCell *)cell didClickAvatarWithLongPress:(BOOL)longPress {
    [self pushFromCommonCell:cell];
}

- (void)cell:(CommonCell *)cell didClickContentWithLongPress:(BOOL)longPress {
    [self pushFromCommonCell:cell];
}

- (void)pushFromCommonCell:(CommonCell *)cell{
    if ([self.delegate respondsToSelector:@selector(push:)]) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.delegate push:cell.indexPath];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private func

- (void)setSuperTableUI{
    //=====view=====
    self.view.backgroundColor = kViewBGColor;
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //=====tableView=====
    _tableView = [[TableViewRoot alloc] initWithFrame:screenBounds style:_groupedStyle?UITableViewStyleGrouped:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    //---子类常用的重写：---
    //1.改变frame高度
    _tableView.frame = screenBounds;
    [_tableView setHeight:screenHeight];
    //2.scrollIndicatorInsets
    _tableView.contentInset = UIEdgeInsetsMake(kTopInsert, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    //3.默认全屏分割线
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    //4.自动调整cell高度、默认44
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    //5.footer
    if (_showFooter) {
        if ([self.delegate respondsToSelector:@selector(addFooter)]) {
            [self.delegate addFooter];
        }else{
            _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, kFooterHeight)];
            _lblFooter = [UILabel new];
            _lblFooter.text = @"— 始于热爱 成于行动 —";
            _lblFooter.font = [UIFont systemFontOfSize:14 weight:UIFontWeightUltraLight];
            _lblFooter.textColor = kColorGray2;
            _lblFooter.textAlignment = NSTextAlignmentCenter;
            _lblFooter.frame = CGRectMake(0, 0, screenWidth, 14);
            _lblFooter.centerY = _tableView.tableFooterView.centerY;
            [self.tableView.tableFooterView addSubview:_lblFooter];
        }
    }
    //6.header
    if (_showHeader) {
        if ([self.delegate respondsToSelector:@selector(addHeader)]) {
            [self.delegate addHeader];
        }
    }
    [self.view addSubview:_tableView];
    
    //=====backButton=====
    //最后添加返回按钮到页面最顶层
    if (_showBackBtn) {
        _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(12, 32, 38, 38)];
        [_btnBack setImage:[UIImage imageNamed:@"btnBack"] forState:UIControlStateNormal];
        [_btnBack setImage:[UIImage imageNamed:@"btnBack-highlight"] forState:UIControlStateSelected];
        _btnBack.layer.cornerRadius = _btnBack.height/2;
        _btnBack.layer.backgroundColor = [UIColor colorWithWhite:0.236 alpha:0.945].CGColor;
        CALayer *backBorder = [CALayer layer];
        backBorder.frame = _btnBack.bounds;
        backBorder.borderWidth = CGFloatFromPixel(2.3);//2.3=6*0.382
        backBorder.borderColor = [UIColor colorWithWhite:0.945 alpha:0.945].CGColor;
        backBorder.cornerRadius = _btnBack.height/2;
        backBorder.shouldRasterize = YES;
        backBorder.rasterizationScale = kScreenScale;
        backBorder.allowsEdgeAntialiasing = YES;//反锯齿
        [_btnBack.layer addSublayer:backBorder];
        [self.view addSubview:_btnBack];
    }
    
    //=====返回使用pop或dismiss页面=====
    if (_isPresented) {
        //dismiss
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(cancelClick)];
    }
}
- (void)cancelClick{
    if ([self.delegate respondsToSelector:@selector(dismissSelf:)]) {
        [self.delegate dismissSelf:self];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

//冷启动
- (void)loadLocalJson{
    if ([self.delegate respondsToSelector:@selector(loadLocalJsonData)]) {
        [self.delegate loadLocalJsonData];
    }else{
        //加载本地文件
        if ([self.delegate respondsToSelector:@selector(setLocalJsonFile)]) {
            NSString *localJsonFileName;
            localJsonFileName = [self.delegate setLocalJsonFile];
            if (isNullString(localJsonFileName)) {
                showAndHideWrongJuHua(@"本地json文件错误", self.view);
                return;
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataNamed:localJsonFileName];
                id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
                NSMutableArray *sections = [NSMutableArray new];
                //---使用默认的通用cell---
                if (self.commonCellType == CommonCellType0) {
                    for (NSDictionary *section in dic) {
                        CommonSectionModel *sectionModel = [CommonSectionModel modelWithJSON:section];
                        
                        NSMutableArray *layouts = [NSMutableArray new];
                        for (CommonCellModel *cellModel in sectionModel.cells) {
                            CommonCellLayout *layout = [CommonCellLayout new];
                            layout.model = cellModel;//先layout，再修改参数
                            layout.showTopLine = NO;
                            layout.showArraw = YES;
                            [layouts addObject:layout];
                        }
                        sectionModel.cellLayouts = layouts;
                        [sections addObject:sectionModel];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _arrSections = sections;
                    [_tableView reloadData];
                });
            });
        }
    }
}


@end
