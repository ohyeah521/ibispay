//
//  RegisterForm.m
//  Action
//
//  Created by caokun on 16/1/8.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "RegisterForm.h"
#import "SAMKeychain.h"
#import "NBPhoneNumberUtil.h"

#define kCC          @"CC"
#define kPhone       @"phone"
#define kPwd         @"pwd"
#define kBtnRegister @"btnRegister"

@interface RegisterForm ()

@end

@implementation RegisterForm

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"新账号";
}

/** 自定义返回按钮
- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btnBack"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btnBack-highlight"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeForm{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"请填写自己的手机号，才能找回密码"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCC rowType:XLFormRowDescriptorTypeSelectorPush title:@"国际区号"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfigForSelector[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfigForSelector[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"中国 (CN)" displayText:@"中国 (CN)"];
    row.selectorOptions = [GlobalDefine CCArray];
    row.required = YES;
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPhone rowType:XLFormRowDescriptorTypePhone title:@"手机号"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    row.required = YES;
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPwd rowType:XLFormRowDescriptorTypePassword title:@"密码"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kBtnRegister rowType:XLFormRowDescriptorTypeButton title:@"立即创建"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.action.formSelector = @selector(registerClick:);
    row.required = YES;
    [section addFormRow:row];
    
    
    self.form = form;
}

- (void)registerClick:(XLFormRowDescriptor *)sender{
    [self deselectFormRow:sender];
    
    [self.view endEditing:YES];
    
    NSString *cc = get_trim([(XLFormOptionsObject *)[self.form formRowWithTag:kCC].value formValue]);
    NSString *phone = get_trim([self.form formRowWithTag:kPhone].value);
    NSString *pwd = get_trim([self.form formRowWithTag:kPwd].value);
    
    //=======check======
    if (isNullString(cc)) {
        showAndHideWrongJuHua(@"请选择国际区号",self.navigationController.view);
        return;
    }
    if (isNullString(phone)) {
        showAndHideWrongJuHua(@"请填写手机号",self.navigationController.view);
        return;
    }
    if (isNullString(pwd)) {
        showAndHideWrongJuHua(@"请填写密码",self.navigationController.view);
        return;
    }
    
    cc = [cc substringFromIndex:cc.length-3];
    cc = [cc substringToIndex:cc.length-1];
    
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSNumber *ccNum = [phoneUtil getCountryCodeForRegion:cc];
    
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:phone defaultRegion:cc error:&anError];
    if (anError != nil) {
        showAndHideWrongJuHua(@"手机号格式不对",self.navigationController.view);
        return;
    }
    
    if ([phoneUtil isPossibleNumber:myNumber] == NO) {
        showAndHideWrongJuHua(@"手机号格式不对",self.navigationController.view);
        return;
    }
    //无论输入是什么格式，都先合并成统一格式，再分离出不带区号的手机号
    NSString *phoneNum = [phoneUtil format:myNumber numberFormat:NBEPhoneNumberFormatE164 error:nil];
    NSString *finalNumberWithoutCC = nil;
    NSNumber *ccNumber = [phoneUtil extractCountryCode:phoneNum nationalNumber:&finalNumberWithoutCC];
    if ([ccNum isEqualToValue:ccNumber] == NO) {
        showAndHideWrongJuHua(@"区号不对",self.navigationController.view);
        return;
    }
    //=======check done======
    
    NSDictionary *parameters = @{@"phoneCC":cc, @"phone":finalNumberWithoutCC, @"pwd":pwd};
    showJuHua(nil,self.navigationController.view);
    [AFNetworkHelper postUrlWithoutAuth:kRegisterUrl bg:NO param:parameters succeed:^(id responseObject) {
        [UserModel CacheUserData:responseObject];
        [SAMKeychain setPassword:pwd forService:kAppService account:getUserId];
        
        //返回登录界面自动登录
        if (_back) _back(YES,pwd);
    } fail:^{
        hideJuHua(self.navigationController.view);
    }];
}

@end
