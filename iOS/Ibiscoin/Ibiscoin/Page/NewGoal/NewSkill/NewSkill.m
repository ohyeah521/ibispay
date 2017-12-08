//
//  SkillForm.m
//  Action
//
//  Created by 鸟神 on 2016/10/5.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "NewSkill.h"
#import "JGProgressHUD.h"
#import "SimpleRoleList.h"
#import "RoleModel.h"
#import "RoleListModel.h"
#import "SkillDescEditor.h"
#import "ImagePickerPreview.h"
#import "TZImageManager.h"
#import "SkillModel.h"
#import "SkillForm.h"


#define kName @"name"
#define kPrice @"price"
#define kPriceRMB @"priceRMB"
#define kHiddenSkill @"hiddenSkill"
#define kDesc @"desc"
#define kPhotos @"photos"
#define kRole @"role"

#define kNewSkillToRoleSelectorSegue @"newSkillToRoleSelectorSegue"
#define kNewSkillToSkillDescEditorSegue @"newSkillToSkillDescEditorSegue"
#define kNewSkillToSkillPhotosSelectorSegue @"newSkillToSkillPhotosSelectorSegue"

@interface SkillDescValueTrasformer : NSValueTransformer
@end

@implementation SkillDescValueTrasformer
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


@interface SkillPhotosValueTrasformer : NSValueTransformer
@end

@implementation SkillPhotosValueTrasformer
+ (Class)transformedValueClass{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation{
    return NO;
}

- (id)transformedValue:(id)value{
    if (!value) return nil;
    if ([value isKindOfClass:[NSArray class]]){
        NSArray *arr = (NSArray *)value;
        if (arr.count>0) {
            return [NSString stringWithFormat:@"%lu张",(unsigned long)arr.count];
        }
    }
    return nil;
}
@end


@interface NewSkill ()
@property (nonatomic) float rmbExr;
@property (nonatomic, copy) NSString *strDesc;
@property (nonatomic, strong) NSMutableArray *arrPhotos;//非原图用这个
@property (nonatomic, strong) NSMutableArray *arrAssets;//原图用这个
@property (nonatomic) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) RoleModel *role;
@property (nonatomic, strong) SimpleRoleList *roleSelector;
@property (nonatomic, strong) ImagePickerPreview *imgPickerPreview;
@property (nonatomic, strong) FBKVOController *KVOController;
@property (nonatomic, copy) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) JGProgressHUD *HUD;
@end

@implementation NewSkill

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}

-(void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    XLFormRowDescriptor * hiddenSkillRow;
    
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
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    section.title = @"";
    section.footerTitle = @"";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kName rowType:XLFormRowDescriptorTypeText title:@"技能名称"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row.cellConfigAtConfigure setObject:@"20字内" forKey:@"textField.placeholder"];
    row.cellConfig[@"textLabel.font"] = [UIFont boldSystemFontOfSize:16];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    row.required = YES;
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPrice rowType:XLFormRowDescriptorTypeInteger title:@"价值鸟币(每施展技能一次)"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"大于0的数" regex:@"^[1-9]{1}[\\d]*$"]];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"textField.font"] = [UIFont systemFontOfSize:15];
    row.required = YES;
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPriceRMB rowType:XLFormRowDescriptorTypeInfo title:@"约合人民币(预览)"];
    row.disabled = @YES;
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHiddenSkill rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"隐藏技能"];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.value = @0;
    row.required = YES;
    hiddenSkillRow = row;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    section.hidden = [NSString stringWithFormat:@"$hiddenSkill==1"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDesc rowType:XLFormRowDescriptorTypeSelectorPush title:@"技能描述"];
    row.action.formSegueIdentifier = kNewSkillToSkillDescEditorSegue;
    row.valueTransformer = [SkillDescValueTrasformer class];
    row.value = @"";
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPhotos rowType:XLFormRowDescriptorTypeSelectorPush title:@"相关图片(可选)"];
    row.valueTransformer = [SkillPhotosValueTrasformer class];
    row.value = [NSMutableArray array];
    row.cellConfig[@"textLabel.font"] = [UIFont systemFontOfSize:15];
    row.cellConfig[@"detailTextLabel.font"] = [UIFont systemFontOfSize:15];
    [section addFormRow:row];
    
    self.form = form;
    
    self.HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    
    if ([formRow.tag isEqualToString:kPrice]) {
        if (isNull(newValue) == NO && [newValue intValue] > 0) {
            int price = [newValue intValue];
            [self.form formRowWithTag:kPriceRMB].value = [NSString stringWithFormat:@"¥ %.2f",price*self.rmbExr];
            [self updateFormRow:[self.form formRowWithTag:kPriceRMB]];
        }
    }
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
    }
    if ([formRow.tag isEqualToString:kPhotos]){
        ImagePickerPreview *imgPickerPreview = self.imgPickerPreview;
        imgPickerPreview.saveBack = ^(NSMutableArray *selectedPhotos, NSMutableArray *selectedAssets, BOOL isSelectOriginalPhoto) {
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            _arrAssets = [NSMutableArray arrayWithArray:selectedAssets];
            _arrPhotos = [NSMutableArray arrayWithArray:selectedPhotos];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isNull(_arrPhotos) == NO && _arrPhotos.count>0) {
                    [self.form formRowWithTag:kPhotos].value = _arrPhotos;
                    [self updateFormRow:[self.form formRowWithTag:kPhotos]];
                }
            });
        };
        [self.navigationController pushViewController:imgPickerPreview animated:YES];
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
    
    //------config UI-------
    self.view.backgroundColor = kViewBGColor;
    self.title = @"新建技能";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(done)];
    if (self.isPresented) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(cancel)];
    }
    
    //------init vars--------
    self.strDesc = [[NSString alloc] init];
    self.arrPhotos = [[NSMutableArray alloc] init];
    self.roleSelector = [kMainSB instantiateViewControllerWithIdentifier:NSStringFromClass([SimpleRoleList class])];
    self.imgPickerPreview = [kMainSB instantiateViewControllerWithIdentifier:NSStringFromClass([ImagePickerPreview class])];
    //检查汇率值获取情况
    id ua = [[PINCache sharedCache] objectForKey:kUserActivityUrl];
    if (isNull(ua) == NO) {
        UserActivityModel *uam = [UserActivityModel modelWithJSON:ua];
        self.rmbExr = uam.rmbExr;
    }
    if (self.rmbExr == 0) {
        //没有汇率数据需要获取一下
        showJuHua(nil,self.view);
        [AFNetworkHelper getUrl:kRmbExrUrl bg:NO param:nil succeed:^(id responseObject) {
            if (isNull([responseObject objectForKey:@"rmbExr"]) == NO) {
                self.rmbExr = [[responseObject objectForKey:@"rmbExr"] floatValue];
            }
            hideJuHua(self.view);
        } fail:^{
            hideJuHua(self.view);
        }];
    }
    
    if (self.isFormSkillList == YES) {
        [self.form formRowWithTag:kHiddenSkill].value = @0;
        [self updateFormRow:[self.form formRowWithTag:kHiddenSkill]];
    }
    
    //------修改技能------
    if (self.isEdit == YES && isNull(self.skill) == NO) {
        self.title = @"修改技能";
    }
}

- (void)cancel{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kNewSkillToSkillDescEditorSegue]){
        SkillDescEditor *descVC = segue.destinationViewController;
        if (isNullString(self.strDesc) == NO) {
            [descVC setValue:self.strDesc forKey:@"desc"];
        }
        self.KVOController = [FBKVOController controllerWithObserver:self];
        [self.KVOController observe:descVC keyPath:@"desc" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            _strDesc = [NSString stringWithFormat:@"%@",change[NSKeyValueChangeNewKey]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.form formRowWithTag:kDesc].value = _strDesc;
                [self updateFormRow:[self.form formRowWithTag:kDesc]];
            });
        }];
    }
}

#pragma mark - private function

- (void)done{
    SkillForm *skillForm = [SkillForm new];
    //技能名称
    skillForm.title = [CommonFunction removeSpaceAndNewline:[self.form formRowWithTag:kName].value];//去掉空格和换行！
    if (isNull(get_trim(skillForm.title))) {
        showAndHideWrongJuHua(@"请填写技能名称",self.navigationController.view);
        return;
    }
    if ([CommonFunction getChineseCount:skillForm.title]>20) {
        showAndHideWrongJuHua(@"技能名称少于20个汉字",self.navigationController.view);
        return;
    }
    //技能价值
    skillForm.price = [[self.form formRowWithTag:kPrice].value integerValue];
    if (skillForm.price==0) {
        showAndHideWrongJuHua(@"请设定技能价值",self.navigationController.view);
        return;
    }
    //隐藏技能
    skillForm.hidden = [[self.form formRowWithTag:kHiddenSkill].value boolValue];
    
    BOOL checkNull = NO;
    if (skillForm.hidden == NO) {
        checkNull = YES;
    }
    //技能描述
    skillForm.desc = [RX(@"\\n{2,}") replace:get_trim(self.strDesc) with:@"\\\n\\\n"];
    if (checkNull && isNullString(skillForm.desc)) {
        showAndHideWrongJuHua(@"请填写技能描述",self.navigationController.view);
        return;
    }
    if (checkNull && [CommonFunction getChineseCount:skillForm.desc]>3000) {
        showAndHideWrongJuHua(@"描述请少于3000字",self.navigationController.view);
        return;
    }
    skillForm.roleID = self.role.roleID;
    if (checkNull && isNullString(skillForm.roleID) == YES) {
        showAndHideWrongJuHua(@"描述选择一个角色",self.navigationController.view);
        return;
    }
    
    
    NSDictionary *params = [skillForm modelToJSONObject];
    if (self.isEdit == NO) {
        //发布新技能
        NSMutableArray *arrPhotos = [self.form formRowWithTag:kPhotos].value;
        if (arrPhotos.count == 0) {
            //不带图片的请求
            showJuHua(nil, self.navigationController.view);
            [AFNetworkHelper postUrl:kNewSkillUrl bg:NO param:params succeed:^(id responseObject) {
                showAndHideRightJuHuaDone(@"添加成功",self.navigationController.view,^(){
                    if (self.isPresented || self.isFormSkillList) {
                        //所以技能返回时刷新个人主页
                        if (_saveBack)_saveBack(YES,1);
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
            } fail:^{
                hideJuHua(self.navigationController.view);
            }];
        }else{
            //带多张图片的请求
            self.HUD = showJuHua(nil,self.navigationController.view);
            showPieJuHua(nil, self.navigationController.view, self.HUD);
            
            //图片data
            NSMutableArray *arrImgData = [[NSMutableArray alloc] init];
            if (self.isSelectOriginalPhoto) {
                //原图
                for (PHAsset *asset in _arrAssets) {
                    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
                    options.synchronous = YES;
                    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(1920, 1920) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        [arrImgData addObject:UIImageJPEGRepresentation([result imageByNormalizingOrientation], 0.85)];
                    }];
                }
            }else{
                for (UIImage *img in _arrPhotos) {
                    [arrImgData addObject:UIImageJPEGRepresentation([img imageByNormalizingOrientation], 0.98)];
                }
            }
            
            [AFNetworkHelper postImagesToUrl:kNewSkillPicsUrl bg:NO params:params imgDatas:arrImgData uploadProgressBlock:^(NSProgress *uploadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ((int)uploadProgress.fractionCompleted == 1) {
                        incrementPieJuHua(self.HUD,(int)(uploadProgress.fractionCompleted*100));
                        self.HUD.textLabel.text = @"稍等片刻";
                    }else{
                        incrementPieJuHua(self.HUD,(int)(uploadProgress.fractionCompleted*100));
                    }
                });
            } succeed:^(id responseObject) {
                showAndHideRightJuHuaDone(@"添加成功",self.navigationController.view,^(){
                    if (self.isPresented || self.isFormSkillList) {
                        //所以技能返回时刷新个人主页
                        if (_saveBack)_saveBack(YES,1);
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
            } fail:^{
                hideJuHua(self.navigationController.view);
            }];
        }
    }else{
        //修改技能 //图片单独修改
    }
}


@end
