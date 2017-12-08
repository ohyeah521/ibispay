//
//  ImagePickerPreview.h
//  Ibiscoin
//
//  Created by 鸟神 on 2017/6/27.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerPreview : UIViewController

@property (nonatomic, copy) void (^saveBack)(NSMutableArray *selectedPhotos, NSMutableArray *selectedAssets, BOOL isSelectOriginalPhoto);

@end
