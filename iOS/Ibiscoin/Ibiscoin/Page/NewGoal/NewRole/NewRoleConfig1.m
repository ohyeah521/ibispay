//
//  NewRoleConfig1.m
//  Action
//
//  Created by 鸟神 on 2017/4/24.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "NewRoleConfig1.h"

#define kName @"name"
#define kPower @"power"
#define kCity @"city"
#define kSex @"sex"
#define kPreview @"preview"
#define kCoinAlias @"coinAlias"

@interface NewRoleConfig1 ()

@end

@implementation NewRoleConfig1

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
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kName rowType:XLFormRowDescriptorTypeName title:@"角色名"];
    row.required = YES;
    [row.cellConfigAtConfigure setObject:@"10字内" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.cellConfig[@"textLabel.font"] = [UIFont boldSystemFontOfSize:16];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCity rowType:XLFormRowDescriptorTypeName title:@"所在地区"];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    [row.cellConfigAtConfigure setObject:@"10字内，如La La Land" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSex rowType:XLFormRowDescriptorTypeName title:@"心理性别"];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    [row.cellConfigAtConfigure setObject:@"10字内" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"专属鸟币"];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPreview rowType:XLFormRowDescriptorTypeText title:@"名称预览"];
    row.disabled = @YES;
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCoinAlias rowType:XLFormRowDescriptorTypeName title:@"鸟币名"];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row.cellConfigAtConfigure setObject:@"5字内，提交后不可更改" forKey:@"textField.placeholder"];
    row.cellConfig[@"textLabel.font"] = [UIFont boldSystemFontOfSize:16];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    row.required = YES;
    [section addFormRow:row];
    [form addFormSection:section];

    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"拥有的能力\n如：超人般的触觉、过人的意志力等"
                                             sectionOptions:XLFormSectionOptionCanReorder | XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete
                                          sectionInsertMode:XLFormSectionInsertModeButton];
    section.multivaluedAddButton.title = @"";
    // set up the row template
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeName];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:14];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:14];
    section.multivaluedRowTemplate = row;
    section.multivaluedTag = kPower;
    [form addFormSection:section];

    
    self.form = form;
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    
    if ([formRow.tag isEqualToString:kCoinAlias]) {
        if (isNullString(newValue) == NO && [CommonFunction getChineseCount:newValue] <= 5) {
            [self.form formRowWithTag:kPreview].value = [NSString stringWithFormat:@"%@币@%@",newValue,[self.form formRowWithTag:kName].value];
            [self updateFormRow:[self.form formRowWithTag:kPreview]];
        }else{
            [self.form formRowWithTag:kPreview].value = @"";
            [self updateFormRow:[self.form formRowWithTag:kPreview]];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"角色基本资料";
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
    if (isNullString([self.form formRowWithTag:kName].value) == NO) {
        NSString *strReturn = [NSString stringWithFormat:@"%@",[self.form formRowWithTag:kName].value];
        if (isNullString(get_trim(strReturn)) == NO) {
            rm.name = strReturn;
        }
    }
    if (isNullString([self.form formRowWithTag:kCity].value) == NO) {
        NSString *strReturn = [NSString stringWithFormat:@"%@",[self.form formRowWithTag:kCity].value];
        if (isNullString(get_trim(strReturn)) == NO) {
            rm.city = strReturn;
        }
    }
    if (isNullString([self.form formRowWithTag:kSex].value) == NO) {
        NSString *strReturn = [NSString stringWithFormat:@"%@",[self.form formRowWithTag:kSex].value];
        if (isNullString(get_trim(strReturn)) == NO) {
            rm.sex = strReturn;
        }
    }
    
    if (isNull([self.form.formValues objectForKey:kPower]) == NO) {
        NSArray *arrTags = (NSArray *)[self.form.formValues objectForKey:kPower];
        if(arrTags.count > 0){
            rm.power = [arrTags componentsJoinedByString:@","];
        }
    }
    
    if (isNullString([self.form formRowWithTag:kCoinAlias].value) == NO) {
        NSString *strReturn = [NSString stringWithFormat:@"%@",[self.form formRowWithTag:kCoinAlias].value];
        if (isNullString(get_trim(strReturn)) == NO) {
            rm.coinAlias = strReturn;
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
