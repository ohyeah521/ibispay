//
//  NewLove.m
//  Action
//
//  Created by 鸟神 on 2017/2/15.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "NewLove.h"
#import "LoveForm.h"
#import "LoveLogEditor.h"
#import "SimpleRoleList.h"

#define kRole @"role"
#define kCode @"code"
#define kHeart @"heart"
#define kLog @"log"
#define kSecret @"secret"
#define kState @"state"
#define kVision @"vision"
#define kJoy @"joy"
#define kThanks @"thanks"
#define kPhoto @"photo"

#define kNewLoveToLoveLogSegue @"newLoveToLoveLogSegue"

@interface LoveLogValueTrasformer : NSValueTransformer
@end

@implementation LoveLogValueTrasformer
+ (Class)transformedValueClass{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation{
    return NO;
}

- (id)transformedValue:(id)value{
    if (!value) return nil;
    NSString *txt = (NSString *)value;
    if (isNullString(txt) == NO && [CommonFunction getChineseCount:txt] > 0) {
        return [NSString stringWithFormat:@"%d字",[CommonFunction getChineseCount:txt]];
    }else{
        return @"";
    }
}
@end

@interface NewLove ()

@property (nonatomic, strong) RoleModel *role;
@property (nonatomic, strong) SimpleRoleList *roleSelector;
@property (nonatomic, strong) NSArray *arrState;
@property (nonatomic, strong) NSString *strLog;
@property (nonatomic, strong) FBKVOController *KVOController;
@property (nonatomic, copy) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) JGProgressHUD *HUD;
@end

@implementation NewLove

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
    NSArray *arrState = @[[XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"筹备中"],
                         [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"行动中"],
                         [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"梦想达成"],
                         [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"大梦初醒"]
                         ];
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    section.title = @"";
    section.footerTitle = @"";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kRole rowType:XLFormRowDescriptorTypeSelectorPush title:@"选择角色"];
    row.value = @"";
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kState rowType:XLFormRowDescriptorTypeSelectorPush title:@"行动状态"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfigForSelector[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfigForSelector[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.selectorOptions = arrState;
    row.value = arrState[0];
    [section addFormRow:row];
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    section.footerTitle = @"";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCode rowType:XLFormRowDescriptorTypeText title:@"行动代号"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row.cellConfigAtConfigure setObject:@"15字内" forKey:@"textField.placeholder"];
    row.cellConfig[@"textLabel.font"] = [UIFont boldSystemFontOfSize:16];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    row.required = YES;
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHeart rowType:XLFormRowDescriptorTypeText title:@"简介"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row.cellConfigAtConfigure setObject:@"一句话介绍，20字内" forKey:@"textField.placeholder"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    [section addFormRow:row];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPhoto rowType:XLFormRowDescriptorTypeImage title:@"封面(可选)"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.value = [UIImage imageNamed:@"imgDefaultAvatar"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kLog rowType:XLFormRowDescriptorTypeSelectorPush title:@"行动日志(选填)"];
    //    row.action.formSegueIdentifier = kNewLoveToLoveLogSegue;
    row.valueTransformer = [LoveLogValueTrasformer class];
    row.value = @"";
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"剧情"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kVision rowType:XLFormRowDescriptorTypeTextView title:@""];
    [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textView.textAlignment"];
//    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
//    row.cellConfig[@"textView.font"] = [UIFont systemFontOfSize:15];
    [row.cellConfigAtConfigure setObject:@"行动可以是目标、梦想或任何想做的事情，展示想象中的画面，2000字内。" forKey:@"textView.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"乐趣（选填）"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kJoy rowType:XLFormRowDescriptorTypeTextView title:@""];
    [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textView.textAlignment"];
//    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
//    row.cellConfig[@"textView.font"] = [UIFont systemFontOfSize:15];
    [row.cellConfigAtConfigure setObject:@"自己若能乐在其中，粉丝就会慕名而来！说说做这件事的乐趣，500字内。" forKey:@"textView.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"感谢（选填）"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kThanks rowType:XLFormRowDescriptorTypeTextView title:@""];
    [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textView.textAlignment"];
//    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
//    row.cellConfig[@"textView.font"] = [UIFont systemFontOfSize:15];
    [row.cellConfigAtConfigure setObject:@"感谢爱着你的粉丝，500字内～" forKey:@"textView.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    
    self.form = form;
    self.arrState = arrState;
    
    self.HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
}


- (void)didSelectFormRow:(XLFormRowDescriptor *)formRow{
    [super didSelectFormRow:formRow];
    
    if ([formRow.tag isEqualToString:kRole]) {
        SimpleRoleList *rs = self.roleSelector;
        rs.isFormNewSkill = YES;
        rs.selectedIndexPath = self.selectedIndexPath;
        rs.saveBack = ^(RoleModel *role, NSIndexPath *indexPath) {
            if (isNull(role) == NO) {
                _selectedIndexPath = indexPath;
                RoleModel *r = [RoleModel new];
                r.roleID = role.roleID;
                r.name = role.name;
                _role = r;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isNullString(_role.name) == NO) {
                    [self.form formRowWithTag:kRole].value = [NSString stringWithFormat:@"%@",_role.name];
                    [self updateFormRow:[self.form formRowWithTag:kRole]];
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        };
        [self.navigationController pushViewController:rs animated:YES];
    }else if ([formRow.tag isEqualToString:kLog]) {
        if (self.isEdit == YES && isNull(self.strLog) == YES) {
            NSString *url = [NSString stringWithFormat:@"%@/%@",kGetLoveLogUrl,self.loveModel.loveID];
            showJuHua(nil,self.view);
            [AFNetworkHelper getUrl:url bg:NO param:nil succeed:^(id responseObject) {
                if (isNull(responseObject) == NO) {
                    NSString *log = [responseObject valueForKey:@"log"];
                    if (isNullString(log) == NO) {
                        self.strLog = [NSString stringWithFormat:@"%@",log];
                    }
                    hideJuHua(self.view);
                    
                    [self performSegueWithIdentifier:kNewLoveToLoveLogSegue sender:self];
                }else{
                    showAndHideWrongJuHua(@"网络错误", self.view);
                    [super deselectFormRow:formRow];
                }
            } fail:^{
                hideJuHua(self.view);
                [super deselectFormRow:formRow];
            }];
        }else{
            [self performSegueWithIdentifier:kNewLoveToLoveLogSegue sender:self];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.roleSelector = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SimpleRoleList class])];
    
    //------config UI-------
    self.view.backgroundColor = kViewBGColor;
    self.title = _isEdit?@"编辑行动":@"新建行动";
    
    if (self.isPresented) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(cancel)];
    }
    
    if (self.isEdit) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更新"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(done)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(done)];
    }
    
    if (isNull(self.loveModel) == NO && self.isEdit) {
        [self.form formSectionAtIndex:1].title = @"";
        
        if (isNullString(self.loveModel.code) == NO) {
            [self.form formRowWithTag:kCode].value = self.loveModel.code;
            [self updateFormRow:[self.form formRowWithTag:kCode]];
        }
        
        if (isNullString(self.loveModel.heart) == NO) {
            [self.form formRowWithTag:kHeart].value = self.loveModel.heart;
            [self updateFormRow:[self.form formRowWithTag:kHeart]];
        }
    }
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
    if ([segue.identifier isEqualToString:kNewLoveToLoveLogSegue]) {
        LoveLogEditor *logVC = segue.destinationViewController;
        if (isNullString(self.strLog) == NO) {
            [logVC setValue:self.strLog forKey:@"desc"];
        }
        if (self.isEdit == YES && isNullString(self.loveModel.loveID) == NO) {
            [logVC setValue:self.loveModel.loveID forKey:@"loveID"];
            logVC.isEdit = YES;
        }
        self.KVOController = [FBKVOController controllerWithObserver:self];
        [self.KVOController observe:logVC keyPath:@"desc" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            _strLog = [NSString stringWithFormat:@"%@",change[NSKeyValueChangeNewKey]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.form formRowWithTag:kLog].value = _strLog;
                [self updateFormRow:[self.form formRowWithTag:kLog]];
            });
        }];
    }
}


#pragma mark - private function

- (void)cancel{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)done{
    LoveForm *loveForm = [LoveForm new];
    
    loveForm.roleID = self.role.roleID;
    if (isNullString(loveForm.roleID) == YES) {
        showAndHideWrongJuHua(@"请选择一个角色",self.navigationController.view);
        return;
    }
    
    if (isNull([self.form formRowWithTag:kState].value) == NO) {
        NSNumber *state = [(XLFormOptionsObject *)[self.form formRowWithTag:kState].value formValue];
        loveForm.state = [state integerValue];
    }else{
        showAndHideWrongJuHua(@"请选择行动状态",self.navigationController.view);
        return;
    }
    
    loveForm.code = get_trim([self.form formRowWithTag:kCode].value);
    if (isNull(loveForm.code)) {
        showAndHideWrongJuHua(@"请填写行动代号",self.navigationController.view);
        return;
    }
    
    loveForm.heart = get_trim([self.form formRowWithTag:kHeart].value);
    if (isNull(loveForm.heart)) {
        showAndHideWrongJuHua(@"请填写简介",self.navigationController.view);
        return;
    }
    
    loveForm.vision = get_trim([self.form formRowWithTag:kVision].value);
    if (isNull(loveForm.vision)) {
        showAndHideWrongJuHua(@"请填写行动剧情",self.navigationController.view);
        return;
    }
    
    loveForm.heart = get_trim([self.form formRowWithTag:kHeart].value);
    if ([CommonFunction getChineseCount:loveForm.heart]>20) {
        showAndHideWrongJuHua(@"一句话介绍小于20字",self.navigationController.view);
        return;
    }
    
    if ([CommonFunction getChineseCount:loveForm.code]>15) {
        showAndHideWrongJuHua(@"行动代号请小于15字",self.navigationController.view);
        return;
    }
    
    loveForm.vision = get_trim([self.form formRowWithTag:kVision].value);
    if ([CommonFunction getChineseCount:loveForm.vision]>2000) {
        showAndHideWrongJuHua(@"行动剧情小于2000字",self.navigationController.view);
        return;
    }
    loveForm.joy = get_trim([self.form formRowWithTag:kJoy].value);
    if ([CommonFunction getChineseCount:loveForm.joy]>500) {
        showAndHideWrongJuHua(@"乐趣请小于500字",self.navigationController.view);
        return;
    }
    loveForm.thanks = get_trim([self.form formRowWithTag:kThanks].value);
    if ([CommonFunction getChineseCount:loveForm.thanks]>500) {
        showAndHideWrongJuHua(@"感谢请小于500字",self.navigationController.view);
        return;
    }
    
    //仅在新建时带上log参数
    if (self.isEdit == NO && isNullString(self.strLog) == NO) {
        loveForm.log = get_trim(self.strLog);
        loveForm.words = [CommonFunction getChineseCount:loveForm.log];
    }
    
    UIImage *photo = [self.form formRowWithTag:kPhoto].value;
    
    
    NSDictionary *params = [loveForm modelToJSONObject];
    if (self.isEdit == NO) {
        //上传数据
        if (isNull(photo) == YES) {
            showJuHua(nil, self.navigationController.view);
            [AFNetworkHelper postUrl:kNewLoveUrl bg:NO param:params succeed:^(id responseObject) {
                showAndHideRightJuHuaDone(@"发布成功",self.navigationController.view,^(){
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } fail:^{
                hideJuHua(self.navigationController.view);
            }];
        }else{
            //带图片的请求
            self.HUD = showJuHua(nil,self.navigationController.view);
            showPieJuHua(nil, self.navigationController.view, self.HUD);
            
            //图片data
            NSMutableArray *arrImgData = [[NSMutableArray alloc] initWithObjects:UIImageJPEGRepresentation(photo, 0.85), nil];
            [AFNetworkHelper postImagesToUrl:kNewLovePicUrl bg:NO params:params imgDatas:arrImgData uploadProgressBlock:^(NSProgress *uploadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ((int)uploadProgress.fractionCompleted == 1) {
                        incrementPieJuHua(self.HUD,(int)(uploadProgress.fractionCompleted*100));
                        self.HUD.textLabel.text = @"稍等片刻";
                    }else{
                        incrementPieJuHua(self.HUD,(int)(uploadProgress.fractionCompleted*100));
                    }
                });
            } succeed:^(id responseObject) {
                showAndHideRightJuHuaDone(@"新建成功",self.navigationController.view,^(){
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } fail:^{
                hideJuHua(self.navigationController.view);
            }];
        }
    }else{
        //修改
        showJuHua(nil, self.navigationController.view);
        [AFNetworkHelper putUrl:[NSString stringWithFormat:@"%@/%@",kUpdateLoveUrl,self.loveModel.loveID] bg:NO param:params succeed:^(id responseObject) {
            //更新成功
            showAndHideRightJuHuaDone(NSLocalizedString(@"Saved", @""),self.navigationController.view,^(){
                if (_saveBack) {
                    _saveBack(YES,0);
                }
            });
        } fail:^{
            hideJuHua(self.navigationController.view);
        }];

    }
}

@end
