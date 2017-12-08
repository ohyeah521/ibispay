//
//  RoleSelectList.m
//  Action
//
//  Created by 鸟神 on 2017/5/25.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "SimpleRoleList.h"

@interface SimpleRoleList ()

@end

@implementation SimpleRoleList

- (void)initFunc{
    self.delegate = self;
    self.slDelegate = self;
    self.canLoadMore = YES;
    self.showFooter = NO;
    self.commonCellType = CommonCellType0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择角色";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self autoSelectCell];
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


#pragma mark - SuperListDelegate

- (void)setBG:(UITableView *)tableView withRowCount:(NSInteger)count{
    [self.tableView tableEmptyBGImg:@"" title:@"先请添加一个角色" txt:@"" withRowCount:self.arrData.count];
}

- (NSString *)setRequestAttr:(int)skip{
    if (isUserLogin) {
        return [NSString stringWithFormat:@"%@/%@/%d", kGetMySimpleRoleListUrl, getUserId, skip];
    }
    return nil;
}

- (void)asyncMapping:(id)responseObject isCachedData:(BOOL)cachedData done:(void (^)(void))done{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SimpleRoleListModel *listModel = [SimpleRoleListModel modelWithJSON:responseObject];
        
        NSMutableArray *cellsModels = [NSMutableArray new];
        NSMutableArray *layouts = [NSMutableArray new];
        for (RoleModel *role in listModel.list) {
            CommonCellModel *cellModel = [CommonCellModel new];
            cellModel.icon = role.avatar.thumbnail.url.absoluteString;
            cellModel.name = role.name;
            cellModel.text = role.desc;
            [cellsModels addObject:cellModel];
            
            CommonCellLayout *layout = [CommonCellLayout new];
            layout.model = cellModel;//先layout，再修改参数
            layout.showTopLine = NO;
            layout.showArraw = NO;
            layout.webImage = YES;
            layout.roundImg = YES;
            [layouts addObject:layout];
        }
        CommonSectionModel *section = [CommonSectionModel new];
        section.cells = cellsModels;
        section.cellLayouts = layouts;
        
        if (self.skip == 0) {
            self.arrData = [NSMutableArray arrayWithArray:listModel.list];
            self.arrSections = [NSMutableArray arrayWithObject:section];
        }else if(listModel.skip > 0 || listModel.skip == -1){
            [self.arrData addObjectsFromArray:listModel.list];
            [self.arrSections addObject:section];
        }
        
        self.skip = self.lastSkip = listModel.skip;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (done) {
                done();
            }
        });
    });
}

- (void)finishdRequesting{
    [self.tableView reloadData];
    [self autoSelectCell];
}


#pragma mark - UITableView delegate

- (void)push:(NSIndexPath *)indexPath{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (self.isFormNewLove || self.isFormNewSkill) {
        self.tableView.userInteractionEnabled = NO;
        
        [self.tableView clearSelectedRowsAnimated:NO];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        RoleModel *r = [self.arrData objectAtIndex:indexPath.row];
        RoleModel *role = [RoleModel new];
        role.roleID = r.roleID;
        role.name = r.name;
        role.desc = r.desc;
        role.avatar = r.avatar;
        role.updateTimeAgo = r.updateTimeAgo;
        
        if (_saveBack) _saveBack(role, indexPath);
        
        self.tableView.userInteractionEnabled = YES;
    }
}

#pragma mark - private func

- (void)autoSelectCell{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isNull(self.selectedIndexPath) == NO && self.arrData.count >= self.selectedIndexPath.row) {
            [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    });
}

@end
