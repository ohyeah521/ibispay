//
//  LoginForm.m
//  Action
//
//  Created by caokun on 16/1/7.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "LoginForm.h"
#import "SAMKeychain.h"
#import "RegisterForm.h"
#import "NBPhoneNumberUtil.h"

#define kCC @"CC"
#define kPhone @"phone"
#define kPwd @"pwd"
#define kBtnRegister @"btnRegister"
#define kBtnLogin @"btnLogin"

#define kRegisterSegue @"registerSegue"

@interface LoginForm ()

@end

@implementation LoginForm

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    if (isNullString(getUserPhoneNum) == NO) {
        [self.form formRowWithTag:kPhone].value = [getUserPhoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self updateFormRow:[self.form formRowWithTag:kPhone]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"鸟币";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if ([segue.identifier isEqualToString:kRegisterSegue]) {
        RegisterForm *rf = (RegisterForm *)segue.destinationViewController;
        @weakify(rf);
        rf.back = ^(BOOL autoLogin,NSString *pwd){
            @strongify(rf);
            [rf.navigationController popViewControllerAnimated:YES];
            
            if (autoLogin) {
                changeJuHuaText(@"创建成功", nil, self.navigationController.view);
                [self login:getUserPhoneCC phont:getUserPhoneNum pwd:pwd fromReigster:YES];
            }
        };
    }
}

-(void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"已有帐号"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCC rowType:XLFormRowDescriptorTypeSelectorPush title:@"国际区号"];
    row.required = YES;
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"中国 (CN)" displayText:@"中国 (CN)"];
    row.selectorOptions = [GlobalDefine CCArray];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfigForSelector[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfigForSelector[@"textLabel.font"] = [UIFont systemFontOfSize:15];
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
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kBtnLogin rowType:XLFormRowDescriptorTypeButton title:@"直接登录"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.action.formSelector = @selector(loginClick:);
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"初来乍到？"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kBtnRegister rowType:XLFormRowDescriptorTypeButton title:@"创建新帐号"];
    row.action.formSegueIdentifier = kRegisterSegue;
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfigForSelector[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfigForSelector[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.required = YES;
    [section addFormRow:row];
    
    self.form = form;
}

- (void)loginClick:(XLFormRowDescriptor *)sender{
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
    
    showJuHua(nil,self.navigationController.view);
    [self login:cc phont:finalNumberWithoutCC pwd:pwd fromReigster:NO];
}

- (void)login:(NSString *)cc phont:(NSString *)phone pwd:(NSString *)pwd fromReigster:(BOOL)fromReigster{
    NSDictionary *parameters = @{@"username":[NSString stringWithFormat:@"%@@%@",cc,phone], @"password":pwd};
    [AFNetworkHelper postUrlWithoutAuth:kLoginUrl bg:NO param:parameters succeed:^(id responseObject) {
        //存储token
        [SAMKeychain setPassword:pwd forService:kAppService account:getUserId];
        UserTokenModel *ut = [UserTokenModel modelWithJSON:responseObject];
        [UserTokenModel CacheUserToken:ut];
        
        UserModel *user = [UserModel GetUserData];
        if (isNull(user) || isNullString(user.userActivity)) {
            //如果没有user资料缓存，需要获取一次
            [AFNetworkHelper getUrl:kUserProfileUrl bg:NO param:nil succeed:^(id responseObject) {
                if (isNull([responseObject objectForKey:@"user"]) == NO) {
                    [UserModel CacheUserData:[responseObject objectForKey:@"user"]];
                }
                id ua = [responseObject objectForKey:@"userActivity"];
                if (isNull(ua) == NO) {
                    [[PINCache sharedCache] setObject:ua forKey:kUserActivityUrl];
                    UserActivityModel *uam = [UserActivityModel modelWithJSON:ua];
                    [rootDelegate refreshActivityNoRequest:uam];
                }
                
                [self loginSusseed:fromReigster];
            } fail:^{
                hideJuHua(self.navigationController.view);
            }];
        }else{
            [rootDelegate refreshActivity];
            [self loginSusseed:fromReigster];
        }
    } fail:^{
        hideJuHua(self.navigationController.view);
    }];
}
- (void)loginSusseed:(BOOL)fromReigster{
    //清空密码框
    [self.form formRowWithTag:kPwd].value = @"";
    [self updateFormRow:[self.form formRowWithTag:kPwd]];
    
    float delayTime = fromReigster?0.7:0.4;
    hideJuHuaDelay(delayTime,self.navigationController.view);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
        }];
        [rootDelegate login];
    });
}

@end
