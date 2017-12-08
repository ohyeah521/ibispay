//
//  NewRoleConfig2.m
//  Action
//
//  Created by 鸟神 on 2017/4/24.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "NewRoleConfig2.h"
#import "FloatLabeledTextFieldCell.h"

#define kAlias @"alias"
#define kSignal @"signal"
#define kBelief @"belief"
#define kBirthday @"birthday"
#define kPassion @"passion"
#define kMate @"mate"
#define kTeam @"team"

@interface NewRoleConfig2 ()

@end

@implementation NewRoleConfig2

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAlias rowType:XLFormRowDescriptorTypeFloatLabeledTextField title:@"角色别名，少于10字"];
//    row.cellConfig[@"floatLabeledTextField.font"] = [UIFont boldSystemFontOfSize:16];
//    row.required = YES;
//    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAlias rowType:XLFormRowDescriptorTypeName title:@"重要别名"];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.cellConfig[@"textLabel.font"] = [UIFont boldSystemFontOfSize:16];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    [row.cellConfigAtConfigure setObject:@"10字内" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kBirthday rowType:XLFormRowDescriptorTypeDate title:@"诞生日期"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.value = [NSDate dateWithYear:1999 month:1 day:1];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"主要热情，每行一个"
                                             sectionOptions:XLFormSectionOptionCanReorder | XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete
                                          sectionInsertMode:XLFormSectionInsertModeButton];
    section.multivaluedAddButton.title = @"";
    // set up the row template
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeName];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    section.multivaluedRowTemplate = row;
    section.multivaluedTag = kPassion;
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"重要伙伴，每行一个"
                                             sectionOptions:XLFormSectionOptionCanReorder | XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete
                                          sectionInsertMode:XLFormSectionInsertModeButton];
    section.multivaluedAddButton.title = @"";
    // set up the row template
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeName];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    section.multivaluedRowTemplate = row;
    section.multivaluedTag = kMate;
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"所属团队，每行一个"
                                             sectionOptions:XLFormSectionOptionCanReorder | XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete
                                          sectionInsertMode:XLFormSectionInsertModeButton];
    section.multivaluedAddButton.title = @"";
    // set up the row template
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeName];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    section.multivaluedRowTemplate = row;
    section.multivaluedTag = kTeam;
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"我相信："];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kBelief rowType:XLFormRowDescriptorTypeTextView title:@""];
    [row.cellConfigAtConfigure setObject:@"'信'以为真，相信什么什么就会变成真的！200字内" forKey:@"textView.placeholder"];
    [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textView.textAlignment"];
    //textview字体大小修改后有bug
//    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
//    row.cellConfig[@"textView.font"] = [UIFont systemFontOfSize:15];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"唤醒角色的方法："];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSignal rowType:XLFormRowDescriptorTypeTextView title:@""];
    [row.cellConfigAtConfigure setObject:@"进入自己真正的角色所需要的环境、信物、咒语等，200字内" forKey:@"textView.placeholder"];
    [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textView.textAlignment"];
    //textview字体大小修改后有bug
    //    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    //    row.cellConfig[@"textView.font"] = [UIFont systemFontOfSize:15];
    row.required = YES;
    [section addFormRow:row];
    
    self.form = form;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"角色详细档案";
}

-(void)viewWillDisappear:(BOOL)animated {
    //检测是否为返回pop
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        NSLog(@"pop");
        
        [self updateModel];
    }
    [super viewWillDisappear:animated];
}

- (void)updateModel{
    RoleModel *rm = [RoleModel new];
    if (isNullString([self.form formRowWithTag:kAlias].value) == NO) {
        NSString *strReturn = [NSString stringWithFormat:@"%@",[self.form formRowWithTag:kAlias].value];
        if (isNullString(get_trim(strReturn)) == NO) {
            rm.alias = strReturn;
        }
    }
    if (isNullString([self.form formRowWithTag:kSignal].value) == NO) {
        NSString *strReturn = [NSString stringWithFormat:@"%@",[self.form formRowWithTag:kSignal].value];
        if (isNullString(get_trim(strReturn)) == NO) {
            rm.signal = strReturn;
        }
    }
    if (isNullString([self.form formRowWithTag:kBelief].value) == NO) {
        NSString *strReturn = [NSString stringWithFormat:@"%@",[self.form formRowWithTag:kBelief].value];
        if (isNullString(get_trim(strReturn)) == NO) {
            rm.belief = strReturn;
        }
    }
    
    if (isNull([self.form formRowWithTag:kBirthday].value) == NO) {
        NSDate *birthday = (NSDate *)[self.form formRowWithTag:kBirthday].value;
        rm.birthday = [birthday timeIntervalSince1970];
    }
    
    
    if (isNull([self.form.formValues objectForKey:kPassion]) == NO) {
        NSArray *arrTags = (NSArray *)[self.form.formValues objectForKey:kPassion];
        if(arrTags.count > 0){
            rm.passion = [arrTags componentsJoinedByString:@","];
        }
    }
    if (isNull([self.form.formValues objectForKey:kMate]) == NO) {
        NSArray *arrTags = (NSArray *)[self.form.formValues objectForKey:kMate];
        if(arrTags.count > 0){
            rm.mate = [arrTags componentsJoinedByString:@","];
        }
    }
    if (isNull([self.form.formValues objectForKey:kTeam]) == NO) {
        NSArray *arrTags = (NSArray *)[self.form.formValues objectForKey:kTeam];
        if(arrTags.count > 0){
            rm.team = [arrTags componentsJoinedByString:@","];
        }
    }
    self.role = rm;
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

@end
