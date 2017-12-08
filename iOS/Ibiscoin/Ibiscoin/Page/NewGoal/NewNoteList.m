//
//  NewNoteList.m
//  Ibiscoin
//
//  Created by 鸟神 on 2017/6/22.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import "NewNoteList.h"
//#import "NoteEditor.h"
//#import "NoteEditorMD.h"

@interface NewNoteList ()

@end

@implementation NewNoteList

- (instancetype)init{
    self=[super init];
    if(self){
        self.groupedStyle = YES;
        self.delegate = self;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.groupedStyle = YES;
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享干货";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView clearSelectedRowsAnimated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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

#pragma mark - SuperTableViewDelegate

- (NSString *)setLocalJsonFile{
    return @"new_note_ui.json";
}

- (NSString *)setCommonCellID{
    return [NSString stringWithFormat:@"cell_%@",[self className]];
}

- (void)push:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //            [self performSegueWithIdentifier:kNewGoalToNewRoleSegue sender:self];
        }else if (indexPath.row == 1){
            //            [self performSegueWithIdentifier:kNewGoalToNewSkillSegue sender:self];
        }else if (indexPath.row == 2){
            
        }
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //            [self performSegueWithIdentifier:kNewGoalToNewLoveSegue sender:self];
        }else if (indexPath.row == 1) {
            
        }else if (indexPath.row == 2) {
            //            NoteEditorMD *mdEditor = [NoteEditorMD sharedInstance];
            //            mdEditor.isPresented = NO;
            //            [self.navigationController jz_pushViewController:mdEditor animated:YES completion:^(UINavigationController *navigationController, BOOL finished) {
            //
            //            }];
        }
        /**
         //[UserService setDefaultEditor:YES];
         //if ([UserService isNormalEditor]) {
         NoteEditor *editor = [NoteEditor sharedInstance];
         editor.isPresented = NO;
         [self.navigationController jz_pushViewController:editor animated:YES completion:^(UINavigationController *navigationController, BOOL finished) {
         
         }];
         */
    }
}

@end
