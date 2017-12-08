//
//  NewRole.m
//  Action
//
//  Created by 鸟神 on 2017/4/23.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "NewRole.h"
#import "NewRoleConfig1.h"
#import "NewRoleConfig2.h"
#import "RoleForm.h"
#import "UIImage+Resizing.h"

#define kTxtDefaultHeight 124.0

#define kRoleViewBGColor [UIColor colorWithHue:216.0/360.0 saturation:0.03 brightness:0.98 alpha:1.0]
#define kRoleBottomBGColor [UIColor colorWithHue:222.0/360.0 saturation:0.07 brightness:0.96 alpha:1.0]
#define kTxtFontColor [UIColor colorWithWhite:0.191 alpha:1.0]
#define kTipsColor [UIColor colorWithHue:222.0/360.0 saturation:0.85 brightness:0.38 alpha:1.0]
#define kImageBorderColor [UIColor colorWithHue:216.0/360.0 saturation:0.16 brightness:0.91 alpha:1.0]
#define kCellBtnTxtColor [UIColor colorWithHue:216.0/360.0 saturation:1.0 brightness:0.191 alpha:1.0]
#define kTxtYellow [UIColor colorWithHue:38.0/360.0 saturation:0.809 brightness:0.916 alpha:1.0]
#define kSwitchYellow [UIColor colorWithHue:44.0/360.0 saturation:0.5625 brightness:1.0 alpha:1.0]

#define kNewRoleToRoleConfig1Segue @"newRoleToRoleConfig1Segue"
#define kNewRoleToRoleConfig2Segue @"newRoleToRoleConfig2Segue"

@interface NewRole ()

@property (nonatomic) BOOL isTxtEditing;

@property (nonatomic, strong) FBKVOController *KVOController;
@property (nonatomic, strong) NewRoleConfig1 *roleConfig1;
@property (nonatomic, strong) NewRoleConfig2 *roleConfig2;
@property (nonatomic) BOOL isFormCamera;
@property (nonatomic, strong) UIImage *originalImage;//原图
@property (nonatomic, assign) NSInteger angle;
@property (nonatomic, assign) CGRect croppedFrame;

@property (nonatomic, strong) JGProgressHUD *HUD;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;
@property (weak, nonatomic) IBOutlet UIView *bottomBGView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblTextViewPreTxt;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UIButton *btnChoosePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UIButton *cellBtn1;
@property (weak, nonatomic) IBOutlet UIButton *cellBtn2;
@property (weak, nonatomic) IBOutlet UILabel *cellLbl1;
@property (weak, nonatomic) IBOutlet UILabel *cellLbl2;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end

@implementation NewRole

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateDoneBtn];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self updateDoneBtn];
}

-(void)viewWillDisappear:(BOOL)animated {
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //---------config UI-----------
    self.HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    
    UIEdgeInsets e = self.scrollView.scrollIndicatorInsets;
    e.right -= 1.5;
    e.bottom += 88;
    [self.scrollView setScrollIndicatorInsets:e];
    
    self.view.backgroundColor = kRoleViewBGColor;
    self.bottomBGView.backgroundColor = kRoleBottomBGColor;
    
    self.txtView.textColor = kTxtFontColor;
    self.lblTitle.textColor = kTipsColor;
    self.lblTitle2.textColor = kTipsColor;
    self.cellLbl1.textColor = kColorDarkGray2;//kTxtYellow;
    self.cellLbl2.textColor = kColorDarkGray2;//kTxtYellow;
    self.switchBtn.onTintColor = kSwitchYellow;
    
    self.imgPhoto.layer.masksToBounds = YES;
    self.imgPhoto.layer.cornerRadius = self.imgPhoto.frame.size.width/2;
    self.imgPhoto.layer.borderWidth = 1;
    self.imgPhoto.layer.borderColor = kImageBorderColor.CGColor;
    self.imgPhoto.hidden = YES;
    
    [self.btnChoosePhoto setTitleColor:kTxtYellow forState:UIControlStateNormal];
    [self.cellBtn1 setTitleColor:kCellBtnTxtColor forState:UIControlStateNormal];
    [self.cellBtn2 setTitleColor:kCellBtnTxtColor forState:UIControlStateNormal];
    
    self.btnDone.enabled = NO;
    self.btnDone.title = @"确定";
    
    if (self.isPresented) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(cancel)];
    }
    
    if (self.isEdit) {
        self.title = @"编辑角色";
        
//        self.lblTitle2.text = @"更换头像";
//        [self.btnChoosePhoto setTitle:@"选取" forState:UIControlStateNormal];
//        [self.imgPhoto setImageWithURL:self.role.photo.thumbnail.url placeholder:nil options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//            self.imgPhoto.hidden = NO;
//        }];
//
//        
//                self.txtView.text = self.role.desc;
//                self.lblTextViewPreTxt.hidden = YES;
        //        self.cellLbl1.text = self.dream.strKind;
        //        self.cellLbl2.text = [NSString stringWithFormat:@"%ld项技能",(long)self.dream.skillNum];
        //        self.noteID =self.dream.passionID;
        //        self.dreamType = self.dream.strKind;
        //
        ////        self.detailFormVC.passion = self.script.passionDetail;
        ////        self.detailFormVC.filmType = self.script.type;
        //
        //        ScriptForm *sf = [ScriptForm new];
        //        sf.script = self.script.script;
        //        sf.type = self.script.type;
        //        sf.partner = self.script.partner;
        //        sf.price = self.script.price;
        //        if (self.script.price == 0) {
        //            self.script.superCoin = YES;
        //        }
        //        sf.superCoin = self.script.superCoin;
        //        sf.passion = self.script.passion;
        //        sf.pay = self.script.pay;
        //        self.partnerFormVC.sf = sf;
        //        self.partnerFormVC.isEdit = YES;
        //        
        //        self.partnerDetail = sf;
        //        
        //        self.btnDone.title = @"更新";
        //        [self performSelector:@selector(changeHeight) afterDelay:0.2];
        
    }
    //---------config UI-----------
    
    
    if (isNull(self.role)) {
        self.role = [RoleModel new];
    }
    self.roleConfig1 = [kMainSB instantiateViewControllerWithIdentifier:NSStringFromClass([NewRoleConfig1 class])];
    self.roleConfig2 = [kMainSB instantiateViewControllerWithIdentifier:NSStringFromClass([NewRoleConfig2 class])];
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
}
- (void)changeHeight{
    [self changeTxtViewHeight:self.txtView];
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        UIEdgeInsets currentInsets = self.scrollView.contentInset;
        self.scrollView.contentInset = (UIEdgeInsets){
            .top = self.topLayoutGuide.length-64,
            .bottom = currentInsets.bottom,
            .left = currentInsets.left,
            .right = currentInsets.right
        };
    }
    
    [self changeTxtViewHeight:self.txtView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navgation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}

#pragma mark - IBAction

- (void)cancel{
    if (isNullString(get_trim(self.txtView.text)) == NO) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:_isEdit?@"是否放弃修改？":@"是否舍弃"
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"取消"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:_isEdit?@"是的":@"舍弃"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissSelf];
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self dismissSelf];
    }
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnConfig1Click:(id)sender {
    [self.KVOController observe:self.roleConfig1 keyPath:@"role" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        RoleModel *config1RoleModel = change[NSKeyValueChangeNewKey];
        
        if (isNull(config1RoleModel) == YES) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isNullString(config1RoleModel.name)==YES || isNullString(config1RoleModel.city)==YES || isNullString(config1RoleModel.sex)==YES || isNullString(config1RoleModel.power) == YES || isNullString(config1RoleModel.coinAlias)==YES) {
                _cellLbl1.text = @"未填写完整";
            }else{
                _cellLbl1.text = @"已填写";
                _role.name = config1RoleModel.name;
                _role.city = config1RoleModel.city;
                _role.sex = config1RoleModel.sex;
                _role.power = config1RoleModel.power;
                _role.coinAlias = config1RoleModel.coinAlias;
            }
        });
    }];
    [self.navigationController pushViewController:self.roleConfig1 animated:YES];
}

- (IBAction)btnConfig2Click:(id)sender {
    [self.KVOController observe:self.roleConfig2 keyPath:@"role" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        RoleModel *config2RoleModel = change[NSKeyValueChangeNewKey];
        
        if (isNull(config2RoleModel) == YES) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
                int i = 0;
                if (isNullString(config2RoleModel.alias)==NO) {
                    _role.alias = config2RoleModel.alias;
                    i+=1;
                }
                if (isNullString(config2RoleModel.signal)==NO) {
                    _role.signal = config2RoleModel.signal;
                    i+=1;
                }
                if (isNullString(config2RoleModel.belief)==NO) {
                    _role.belief = config2RoleModel.belief;
                    i+=1;
                }
                if (config2RoleModel.birthday != 0) {
                    _role.birthday = config2RoleModel.birthday;
                    i+=1;
                }
                if (isNullString(config2RoleModel.passion)==NO) {
                    _role.passion = config2RoleModel.passion;
                    i+=1;
                }
                if (isNullString(config2RoleModel.mate)==NO) {
                    _role.mate = config2RoleModel.mate;
                    i+=1;
                }
                if (isNullString(config2RoleModel.team)==NO) {
                    _role.team = config2RoleModel.team;
                    i+=1;
                }
                _cellLbl2.text = [NSString stringWithFormat:@"已填写 %d/7",i];
        });
    }];
    [self.navigationController pushViewController:self.roleConfig2 animated:YES];
}

- (IBAction)btnChoosePhotoClick:(id)sender {
    [self.view endEditing:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"角色头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES){
            self.isFormCamera = YES;
            UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
            cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
            cameraUI.allowsEditing = YES;
            cameraUI.delegate = self;
            [self presentViewController:cameraUI animated:YES completion:nil];
        }else{
            showAndHideWrongJuHua(NSLocalizedString(@"camera is not available",nil),self.view);
        }
    }];
    UIAlertAction *selectAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.isFormCamera = NO;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.modalPresentationStyle = UIModalPresentationPopover;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"CANCEL!");
    }];
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"移除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        self.imgPhoto.image = nil;
        self.imgPhoto.hidden = YES;
    }];
    
    [alert addAction:photoAction];
    [alert addAction:selectAction];
    [alert addAction:cancelAction];
    [alert setModalPresentationStyle:UIModalPresentationPopover];
    
    if (self.imgPhoto.hidden == NO && self.isEdit == NO) {
        [alert addAction:destructiveAction];
    }
    
    [self presentViewController:alert animated:YES completion:^{ }];
}

- (IBAction)btnDoneClick:(id)sender {
    [self.view endEditing:YES];
    
    if (isNullString(self.role.coinAlias) == YES) {
        showAndHideWrongJuHua(@"请填写鸟币名称",self.view);
        return;
    }
    
    if ([CommonFunction getChineseCount:self.role.coinAlias]>5) {
        showAndHideWrongJuHua(@"鸟币名称请少于5字",self.view);
        return;
    }
    
    if ([CommonFunction includeSpecialCharact:self.role.coinAlias]) {
        showAndHideWrongJuHua(@"鸟币名称不能带特殊字符",self.navigationController.view);
        return;
    }
    
    if ([CommonFunction stringContainsEmoji:self.role.coinAlias]) {
        showAndHideWrongJuHua(@"鸟币名称不能带表情符号",self.navigationController.view);
        return;
    }
    
    if (isNullString(self.role.name) == YES) {
        showAndHideWrongJuHua(@"请填写角色名称",self.view);
        return;
    }
    if (isNullString(self.role.city) == YES) {
        showAndHideWrongJuHua(@"请填写角色所在城市",self.view);
        return;
    }
    if (isNullString(self.role.sex) == YES) {
        showAndHideWrongJuHua(@"请填写角色性别",self.view);
        return;
    }
    if (isNull(self.imgPhoto.image) == YES || self.imgPhoto.hidden == YES) {
        showAndHideWrongJuHua(@"请添加角色头像",self.view);
        return;
    }
    if (isNullString(get_trim(self.txtView.text))) {
        showAndHideWrongJuHua(@"请输入角色描述",self.view);
        return;
    }
    
    if ([CommonFunction getChineseCount:self.role.name]>10) {
        showAndHideWrongJuHua(@"角色名称请小于10字",self.view);
        return;
    }
    
    if ([CommonFunction getChineseCount:self.role.city]>10) {
        showAndHideWrongJuHua(@"所在城市请小于10字",self.view);
        return;
    }

    if ([CommonFunction getChineseCount:self.role.city]>10) {
        showAndHideWrongJuHua(@"性别请小于10字",self.view);
        return;
    }
    
    if ([CommonFunction getChineseCount:get_trim(self.txtView.text)]>300) {
        showAndHideWrongJuHua(@"角色描述请小于300字",self.view);
        return;
    }
    
    if ([CommonFunction getChineseCount:self.role.alias]>10) {
        showAndHideWrongJuHua(@"角色别名请小于10字",self.view);
        return;
    }
    
    if ([CommonFunction getChineseCount:self.role.signal]>200) {
        showAndHideWrongJuHua(@"唤醒方法请小于200字",self.view);
        return;
    }
    
    if ([CommonFunction getChineseCount:self.role.belief]>200) {
        showAndHideWrongJuHua(@"角色信念请小于200字",self.view);
        return;
    }
    

    [self postNewDream];
}

- (IBAction)imgPhotoTap:(id)sender {
    //When tapping the image view, restore the image to the previous cropping state
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:self.originalImage];
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
    cropController.rotateClockwiseButtonHidden = YES;
    cropController.delegate = self;
    CGRect viewFrame = [self.view convertRect:self.imgPhoto.frame toView:self.navigationController.view];
    [cropController presentAnimatedFromParentViewController:self
                                                  fromImage:self.imgPhoto.image
                                                   fromView:nil
                                                  fromFrame:viewFrame
                                                      angle:self.angle
                                               toImageFrame:self.croppedFrame
                                                      setup:^{
                                                          self.imgPhoto.hidden = YES;
                                                      }
                                                 completion:^{
//                                                     if (self.angle == 90) {
//                                                         [cropController.cropView rotateImageNinetyDegreesAnimated:NO];
//                                                         [cropController.cropView rotateImageNinetyDegreesAnimated:NO];
//                                                     }
                                                 }];
    
}

#pragma mark - delegate

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@""] == YES) {
        self.lblTextViewPreTxt.hidden = NO;
        [self updateDoneBtn];
        return;
    }
    
    if (self.lblTextViewPreTxt.hidden == NO) {
        self.lblTextViewPreTxt.hidden = YES;
    }
    
    [self updateDoneBtn];
    
    [self changeTxtViewHeight:textView];
}
- (void)changeTxtViewHeight:(UITextView *)textView{
    CGFloat height = [CommonFunction measureHeightOfUITextView:textView lineHeight:0];
    if (height>kTxtDefaultHeight) {
        self.txtViewHeightConstraint.constant = height;
    }else{
        self.txtViewHeightConstraint.constant = kTxtDefaultHeight;
    }
    
    float addHeight = self.txtViewHeightConstraint.constant-kTxtDefaultHeight;
    [self.scrollView setContentSize:CGSizeMake(screenWidth, screenHeight+addHeight+2)];
    if (self.isTxtEditing && self.txtView.selectedRange.location == self.txtView.text.length){//todo: 检测最后一行而不是最后一个字符
        if((iPhone6Screen || iPhone6pScreen) && addHeight > kTxtDefaultHeight){
            [self.scrollView setContentOffset:CGPointMake(0, addHeight)];
        }
        if (iPhone5Screen && addHeight > kTxtDefaultHeight/2-22){
            [self.scrollView setContentOffset:CGPointMake(0, addHeight+22)];
        }
        if (iPhone4Screen && addHeight > (kTxtDefaultHeight/2-88)){
            [self.scrollView setContentOffset:CGPointMake(0, addHeight+88)];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.isTxtEditing = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.isTxtEditing = NO;
    
    if ([get_trim(self.txtView.text) isEqualToString:@""]) {
        self.txtView.text = @"";
        self.lblTextViewPreTxt.hidden = NO;
    }
    
    [self updateDoneBtn];
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (self.isFormCamera) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        self.originalImage = image;
        
        [picker dismissViewControllerAnimated:YES completion:^{
            self.imgPhoto.image = image;
            self.imgPhoto.hidden = NO;
        }];
    }else{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.originalImage = image;
        
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:image];
        cropController.delegate = self;
        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        cropController.rotateClockwiseButtonHidden = YES;
        [picker pushViewController:cropController animated:YES];
    }
}

#pragma mark - Cropper Delegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.croppedFrame = cropRect;
    self.angle = angle;
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.croppedFrame = cropRect;
    self.angle = angle;
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    self.imgPhoto.hidden = YES;
    
    [cropViewController dismissAnimatedFromParentViewController:cropViewController withCroppedImage:image toView:self.imgPhoto toFrame:CGRectZero setup:^{
    } completion:^{
        self.imgPhoto.image = image;
        self.imgPhoto.hidden = NO;
    }];
}


#pragma mark - private func

- (void)updateDoneBtn{
    if ((get_trim(self.txtView.text)).length > 0 && isNullString(self.cellLbl1.text) == NO) {
        self.btnDone.enabled = YES;
    }else{
        self.btnDone.enabled = NO;
    }
}

- (void)postNewDream{
    NSString *str = get_trim(self.txtView.text);
    NSString *desc = [RX(@"\\n{2,}") replace:str with:@"\\\n\\\n"];
    
    RoleForm *df = [RoleForm new];
    df.coinAlias = self.role.coinAlias;
    df.name = self.role.name;
    df.desc = desc;
    df.city = self.role.city;
    df.sex = self.role.sex;
    df.power = self.role.power;
    df.alias = self.role.alias;
    df.signal = self.role.signal;
    df.belief = self.role.belief;
    df.birthday = self.role.birthday;
    df.passion = self.role.passion;
    df.mate = self.role.mate;
    df.team = self.role.team;
    NSDictionary *params = [df modelToJSONObject];
    
    if (self.isEdit == YES) {
        //        //更新
        //        showJuHua(nil, self.navigationController.view);
        //        NSString *requestUrl = [NSString stringWithFormat:@"%@%@/%@",kServerUri2,kUpdateScriptUri,self.script._id];
        //        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters error:nil];
        //        request.timeoutInterval = 10;
        //        [request setValue:getAuthString forHTTPHeaderField:kAuth];
        //
        //        AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        //        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        //        [[sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        //            if (isNull(error) == NO) {
        //                NSLog(@"Error:%@",error);
        //                if (isNull(responseObject)) {
        //                    showAndHideWrongJuHua(error.localizedDescription,self.navigationController.view);
        //                }else{
        //                    showAndHideWrongJuHua(NSLocalizedString([responseObject objectForKey:@"status"],nil),self.navigationController.view);
        //                }
        //                return;
        //            }
        //
        //            if (isNull(responseObject) == NO) {
        //                showAndHideRightJuHua(nil,self.navigationController.view);
        //
        //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //                    if (_saveBack) _saveBack(YES);
        //                });
        //            }else{
        //                showAndHideWrongJuHua(@"出错了", self.navigationController.view);
        //            }
        //
        //        }] resume];
    }else{
        //带图片的请求
        self.HUD = showJuHua(nil,self.navigationController.view);
        showPieJuHua(nil, self.navigationController.view, self.HUD);
        
        //圆形头像
        UIImage *finalImg = [self.imgPhoto.image imageByNormalizingOrientation];
        if (finalImg.size.height > 1920 || finalImg.size.width > 1920) {
            finalImg = [finalImg scaleToFitSize:CGSizeMake(1920, 1920)];
        }
        
        //方形原图
        UIImage *originalImg = [self.originalImage imageByNormalizingOrientation];
        if (originalImg.size.height > 1920 || originalImg.size.width > 1920) {
            originalImg = [originalImg scaleToFitSize:CGSizeMake(1920, 1920)];
        }
        
        //图片data
        NSMutableArray *arrImgData = [[NSMutableArray alloc] initWithObjects:UIImageJPEGRepresentation(finalImg, 0.85),UIImageJPEGRepresentation(originalImg, 0.85), nil];
        [AFNetworkHelper postImagesToUrl:kNewRoleUrl bg:NO params:params imgDatas:arrImgData uploadProgressBlock:^(NSProgress *uploadProgress) {
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
}

- (void)updatePic{
    //    self.HUD = showJuHua(nil,self.navigationController.view);
    //    showPieJuHua(nil, self.navigationController.view, self.HUD);
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        NSString *requestUrl = [NSString stringWithFormat:@"%@%@/%@", kServerUri2, kUpdateScriptPicUri,self.script._id];
    //        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //            [formData appendPartWithFileData:UIImageJPEGRepresentation(self.imgPhoto.image, 0.85) name:@"files" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    //        } error:nil];
    //        [request setValue:getAuthString forHTTPHeaderField:kAuth];
    //
    //        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //        [[manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                //Update the progress view
    //                if ((int)uploadProgress.fractionCompleted == 1) {
    //                    incrementPieJuHua(self.HUD,(int)(uploadProgress.fractionCompleted*100));
    //                    self.HUD.textLabel.text = @"处理中..";
    //                }else{
    //                    incrementPieJuHua(self.HUD,(int)(uploadProgress.fractionCompleted*100));
    //                }
    //            });
    //        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    //            if (isNull(error) == NO) {
    //                NSLog(@"Error:%@",error);
    //                if (isNull(responseObject)) {
    //                    showAndHideWrongJuHua(error.localizedDescription,self.navigationController.view);
    //                }else{
    //                    showAndHideWrongJuHua(NSLocalizedString([responseObject objectForKey:@"status"],nil),self.navigationController.view);
    //                }
    //                return;
    //            }
    //
    //            if (isNull(responseObject) == NO) {
    //                showAndHideRightJuHua(@"图片更新成功",self.navigationController.view);
    //            }else{
    //                showAndHideWrongJuHua(@"出错了", self.navigationController.view);
    //            }
    //        }] resume];
    //    });
}


@end
