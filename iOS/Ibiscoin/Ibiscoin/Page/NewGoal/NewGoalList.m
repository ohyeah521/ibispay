//
//  NewGoalList.m
//  Action
//
//  Created by 鸟神 on 2017/5/21.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "NewGoalList.h"
#import "NewNoteList.h"

#define kNewGoalToNewRoleSegue @"newGoalToNewRoleSegue"
#define kNewGoalToNewSkillSegue @"newGoalToNewSkillSegue"
#define kNewGoalToNewLoveSegue @"newGoalToNewLoveSegue"

@interface NewGoalList ()

@end

@implementation NewGoalList

- (instancetype)init{
    self=[super init];
    if(self){
        self.isPresented = YES;
        self.groupedStyle = YES;
        self.showFooter = YES;
        self.delegate = self;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isPresented = YES;
        self.showFooter = YES;
        self.groupedStyle = YES;
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建";
    self.lblFooter.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView clearSelectedRowsAnimated:NO];
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

#pragma mark - SuperTableViewDelegate

- (NSString *)setLocalJsonFile{
    return @"new_goal_ui.json";
}

- (NSString *)setCommonCellID{
    return [NSString stringWithFormat:@"cell_%@",[self className]];
}

- (void)push:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:kNewGoalToNewRoleSegue sender:self];
        }else if (indexPath.row == 1){
            [self performSegueWithIdentifier:kNewGoalToNewSkillSegue sender:self];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:kNewGoalToNewLoveSegue sender:self];
        }else if (indexPath.row == 1) {
            NewNoteList *newNoteList = [NewNoteList new];
            [self.navigationController pushViewController:newNoteList animated:YES];
        }
    }
}

@end
