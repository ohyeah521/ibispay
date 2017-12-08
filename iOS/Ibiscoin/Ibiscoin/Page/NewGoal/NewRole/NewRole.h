//
//  NewRole.h
//  Action
//
//  Created by 鸟神 on 2017/4/23.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "RoleModel.h"
#import "TOCropViewController.h"

@interface NewRole : UIViewController <UIScrollViewDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate>

@property (nonatomic) BOOL isPresented;
@property (nonatomic) BOOL isEdit;

@property (nonatomic, strong) RoleModel *role;
@property (nonatomic, copy) void (^saveBack)(BOOL refresh);

- (IBAction)btnChoosePhotoClick:(id)sender;
- (IBAction)btnDoneClick:(id)sender;


@end
