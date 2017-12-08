//
//  HomeDetailList.m
//  Ibiscoin
//
//  Created by 鸟神 on 2017/8/1.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

#import "HomeDetailList.h"
#import "HomeDetailHeader.h"

#define kMaxTitleAlphaOffset 64
#define kMaxAvatarAlphaOffset 44
#define kProfilePaddingText 10
#define kProfileFontSize 16

@interface HomeDetailList ()

//table view
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnBack;
//table header
@property (nonatomic) BOOL imageLoaded;
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat lastScrollOffset;
@property (nonatomic, strong) UIView *headerContainer;
@property (weak, nonatomic) YYLabel *lblName;
@property (weak, nonatomic) YYLabel *lblCoin;
@property (weak, nonatomic) YYLabel *lblCredit;
@property (weak, nonatomic) YYLabel *lblProfile;
@property (weak, nonatomic) YYLabel *lblCity;
@property (nonatomic, assign) CGFloat profileTextHeight;
@property (nonatomic, strong) YYTextLayout *profileTextLayout;
@property (weak, nonatomic) IBOutlet HomeDetailHeader *tableHeader;

@end

@implementation HomeDetailList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setTableUI];
    [self customHeader:self.lastPageLayout.roleModel.image.large.url urlAvatar:self.lastPageLayout.roleModel.avatar.middle.url];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NULL;
}
                  
#pragma mark - private function

- (void)setTableUI{
    //=====view=====
    self.view.backgroundColor = kViewBGColor;
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //=====tableView=====
    _tableView = [[TableViewRoot alloc] initWithFrame:screenBounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    //1.改变frame高度
    _tableView.frame = screenBounds;
    [_tableView setHeight:screenHeight];
    //2.scrollIndicatorInsets
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //3.默认全屏分割线
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    //4.自动调整cell高度、默认44
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    
    //=====backButton=====
    //最后添加返回按钮到页面最顶层
    _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(12, 32, 38, 38)];
    [_btnBack setImage:[UIImage imageNamed:@"btnBack"] forState:UIControlStateNormal];
    [_btnBack setImage:[UIImage imageNamed:@"btnBack-highlight"] forState:UIControlStateReserved];
    [_btnBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _btnBack.layer.cornerRadius = _btnBack.height/2;
    _btnBack.layer.backgroundColor = [UIColor colorWithWhite:0.236 alpha:0.945].CGColor;
    CALayer *backBorder = [CALayer layer];
    backBorder.frame = _btnBack.bounds;
    backBorder.borderWidth = CGFloatFromPixel(2.3);//2.3=6*0.382
    backBorder.borderColor = [UIColor colorWithWhite:0.945 alpha:0.945].CGColor;
    backBorder.cornerRadius = _btnBack.height/2;
    backBorder.shouldRasterize = YES;
    backBorder.rasterizationScale = kScreenScale;
    backBorder.allowsEdgeAntialiasing = YES;//反锯齿
    [_btnBack.layer addSublayer:backBorder];
    [self.view addSubview:_btnBack];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customHeader:(NSURL *)urlHeaderImg urlAvatar:(NSURL *)urlAvatar{
    CGFloat headerHeight = screenWidth/2;
    // Parallax Header
    [[NSBundle mainBundle] loadNibNamed:@"HomeDetailHeader" owner:self options:nil];
    self.tableView.parallaxHeader.view = self.tableHeader;
    self.tableView.parallaxHeader.height = headerHeight;
    self.tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.tableView.parallaxHeader.minimumHeight = 20;
    
    //view container
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth/2, headerHeight)];
    container.backgroundColor = [UIColor clearColor];
    [self.tableView.parallaxHeader.view addSubview:container];
    self.headerContainer = container;
    //头像
    UIImageView *imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 80, 80)];
    imgHeader.centerX = screenWidth/2;
    [container addSubview:imgHeader];
    [imgHeader setImageWithURL:urlAvatar
                   placeholder:nil
                       options:kNilOptions
                       manager:[CellHelper avatarImageManager]
                      progress:nil
                     transform:nil
                    completion:nil];
    CALayer *avatarBorder = [CALayer layer];
    avatarBorder.frame = imgHeader.bounds;
    avatarBorder.borderWidth = CGFloatFromPixel(6.0);
    avatarBorder.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    avatarBorder.cornerRadius = imgHeader.height / 2;
    avatarBorder.shouldRasterize = YES;
    avatarBorder.rasterizationScale = kScreenScale;
    avatarBorder.allowsEdgeAntialiasing = YES;//反锯齿
    [imgHeader.layer addSublayer:avatarBorder];
    //头像可点击
    YYControl *imageView = [YYControl new];
    imageView.frame = imgHeader.frame;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.exclusiveTouch = YES;
    imageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:view];
            if (CGRectContainsPoint(view.bounds, p)) {
                //                UserProfilePage *profile = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UserProfilePage class])];
                //                profile.user = self.layout.user;
                //                profile.isOthers = YES;
                //                [self.navigationController jz_pushViewController:profile animated:YES completion:^(UINavigationController *navigationController, BOOL finished) {
                //
                //                }];
            }
        }
    };
    [container addSubview:imageView];
    //认证标示
    UIImageView *imgVerify = [UIImageView new];
    imgVerify.size = CGSizeMake(31, 31);
    imgVerify.center = CGPointMake(imgHeader.right - 9, imgHeader.bottom - 10);
    imgVerify.contentMode = UIViewContentModeScaleAspectFit;
    imgVerify.image = [UIImage imageNamed:@"icon_verified_profile"];
    imgVerify.hidden = self.lastPageLayout.userModel.hasPhoto?NO:YES;
    [container addSubview:imgVerify];
    //昵称
    YYLabel *lblName = [YYLabel new];
    lblName.attributedText = [self layoutName:[UIColor blackColor]];
    lblName.top = imgHeader.bottom+25;
    lblName.width = screenWidth;
    lblName.height = 24;
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    lblName.displaysAsynchronously = YES;
    lblName.ignoreCommonProperties = NO;
    lblName.fadeOnAsynchronouslyDisplay = NO;
    lblName.fadeOnHighlight = NO;
    [container addSubview:lblName];
    self.lblName = lblName;
    //鸟币
    YYLabel *lblCoin = [YYLabel new];
    lblCoin.attributedText = [self layoutCoin:[UIColor colorWithWhite:0.0 alpha:0.5]];
    lblCoin.top = lblName.bottom-3;
    lblCoin.width = screenWidth;
    lblCoin.height = 24;
    lblCoin.textAlignment = NSTextAlignmentCenter;
    lblCoin.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    lblCoin.displaysAsynchronously = YES;
    lblCoin.ignoreCommonProperties = NO;
    lblCoin.fadeOnAsynchronouslyDisplay = NO;
    lblCoin.fadeOnHighlight = NO;
    [container addSubview:lblCoin];
    self.lblCoin = lblCoin;
    //鸟币信用
    YYLabel *lblCredit = [YYLabel new];
    lblCredit.size = CGSizeMake(screenWidth, 28);
    lblCredit.centerX = lblCoin.centerX;
    lblCredit.centerY = lblCoin.centerY+29;
    lblCredit.displaysAsynchronously = YES;
    lblCredit.ignoreCommonProperties = YES;
    lblCredit.fadeOnAsynchronouslyDisplay = NO;
    lblCredit.fadeOnHighlight = NO;
    lblCredit.lineBreakMode = NSLineBreakByClipping;
    lblCredit.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    lblCredit.textLayout = [self layoutCredit:NO];
    [container addSubview:lblCredit];
    self.lblCredit = lblCredit;
    //简介＋喜欢类型
    [self layoutProfile:NO];
    YYLabel *lblProfile = [YYLabel new];
    lblProfile.top = lblCoin.bottom+25;
    lblProfile.left = 8;
    lblProfile.width = screenWidth-16;
    lblProfile.height = self.profileTextHeight;
    lblProfile.textAlignment = NSTextAlignmentCenter;
    lblProfile.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    lblProfile.displaysAsynchronously = YES;
    lblProfile.ignoreCommonProperties = NO;
    lblProfile.fadeOnAsynchronouslyDisplay = NO;
    lblProfile.fadeOnHighlight = NO;
    lblProfile.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
    };
    lblProfile.textLayout = self.profileTextLayout;
    [container addSubview:lblProfile];
    self.lblProfile = lblProfile;
    //城市
    YYLabel *lblCity = [YYLabel new];
    lblCity.attributedText = [self layoutCity:[UIColor colorWithWhite:0.7236 alpha:1.0]];
    lblCity.top = lblProfile.bottom;
    lblCity.width = screenWidth;
    lblCity.height = 24;
    lblCity.textAlignment = NSTextAlignmentCenter;
    lblCity.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    lblCity.displaysAsynchronously = YES;
    lblCity.ignoreCommonProperties = NO;
    lblCity.fadeOnAsynchronouslyDisplay = NO;
    lblCity.fadeOnHighlight = NO;
    [container addSubview:lblCity];
    self.lblCity = lblCity;
    //header图片
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    UIImage *image = [cache getImageForKey:[[YYWebImageManager sharedManager] cacheKeyForURL:urlHeaderImg]];
    if (isNull(image) == YES) {
        //无缓存图片
        _imageLoaded = NO;
        self.tableHeader.viewOnTop.alpha = 1;
        //设置底层图片
        [self.tableHeader.imgHeader setImageWithURL:urlHeaderImg
         
                                        placeholder:nil
                                            options:YYWebImageOptionSetImageWithFadeAnimation
                                            manager:nil
                                           progress:nil
                                          transform:nil
                                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (isNull(image) == YES) {
                                                     _imageLoaded = NO;
                                                     return;
                                                 }
                                                 
                                                 _imageLoaded = YES;
                                                 //模糊效果层
                                                 _tableHeader.imgBlur.image = [image imageByBlurRadius:15.0 tintColor:[UIColor colorWithWhite:0.191 alpha:0.44] tintMode:kCGBlendModeNormal saturation:1.5 maskImage:nil];
                                                 [UIView animateWithDuration:0.2764 delay:0.136 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                     _tableHeader.viewOnTop.alpha = 0.0;
                                                     
                                                     //文字颜色改变
                                                     _lblName.attributedText =[self layoutName:[UIColor whiteColor]];
                                                     _lblCoin.attributedText = [self layoutCoin:[UIColor colorWithWhite:1.0 alpha:0.7236]];
                                                     [self layoutProfile:YES];
                                                     _lblCredit.textLayout = [self layoutCredit:YES];
                                                     _lblProfile.textLayout = self.profileTextLayout;
                                                     _lblCity.attributedText = [self layoutCity:[UIColor colorWithWhite:1.0 alpha:0.7236]];
                                                 } completion:^(BOOL finished) {
                                                     _tableHeader.viewOnTop.alpha = 0.0;
                                                     _tableHeader.viewOnTop.hidden = YES;
                                                 }];
                                             });
                                         }];
    }else{
        //有缓存图片
        _tableHeader.viewOnTop.alpha = 0;
        _tableHeader.viewOnTop.hidden = YES;
        _imageLoaded = YES;
        //底层图片
        [self.tableHeader.imgHeader setImage:image];
        //模糊效果层
        _tableHeader.imgBlur.image = [image imageByBlurRadius:15.0 tintColor:[UIColor colorWithWhite:0.191 alpha:0.44] tintMode:kCGBlendModeNormal saturation:1.5 maskImage:nil];
        //文字颜色改变
        _lblName.attributedText =[self layoutName:[UIColor whiteColor]];
        _lblCoin.attributedText = [self layoutCoin:[UIColor colorWithWhite:1.0 alpha:0.7236]];
        [self layoutProfile:YES];
        _lblCredit.textLayout = [self layoutCredit:YES];
        _lblProfile.textLayout = self.profileTextLayout;
        _lblCity.attributedText = [self layoutCity:[UIColor colorWithWhite:1.0 alpha:0.7236]];
    }
    
    
    headerHeight = lblCoin.bottom+self.profileTextHeight+lblCity.height+36;
    self.headerHeight = headerHeight;
    container.height = headerHeight;
    self.tableView.parallaxHeader.height = headerHeight;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"scrollView.contentOffset.y:%.3f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 0) {
        //移动
        self.headerContainer.centerY = 0-self.headerHeight/2-scrollView.contentOffset.y;
        //模糊
        if (self.imageLoaded) {
            CGFloat delta = fabs(MIN(-self.headerHeight, scrollView.contentOffset.y));
            self.tableHeader.imgBlur.alpha = 1-(delta-self.headerHeight)/kMaxAvatarAlphaOffset;
            self.headerContainer.alpha = 1-(delta-self.headerHeight)/kMaxTitleAlphaOffset;
        }
        //显示按钮
        if (self.btnBack.alpha == 0 && scrollView.contentOffset.y<10) {
            self.btnBack.alpha = 1;
        }
    }else{
        if (scrollView.contentOffset.y > self.lastScrollOffset) {
            //上划
            //隐藏返回按钮
            if (self.btnBack.alpha == 1) {
                [AnimationHelper hide:self.btnBack.layer duration:0.236 easingFunction:kCAMediaTimingFunctionEaseInEaseOut onComplete:^{
                    self.btnBack.alpha = 0;
                    self.headerContainer.alpha = 0;
                }];
            }
        }else{
            //NSLog(@"scrollView.contentSize.height:%.3f",scrollView.contentSize.height);
            //NSLog(@"scrollView.contentOffset.y:%.3f",scrollView.contentOffset.y);
            //NSLog(@"screenHeight:%.3f",screenHeight);
            //下划
            //显示返回按钮
            if (self.btnBack.alpha == 0 && scrollView.contentOffset.y<10) {
                [AnimationHelper show:self.btnBack.layer duration:0.191 onComplete:nil];
                self.btnBack.alpha = 1;
                self.headerContainer.alpha = 1;
            }
        }
    }
    
    self.lastScrollOffset = scrollView.contentOffset.y;
}
                      
- (NSMutableAttributedString *)layoutName:(UIColor *)color{
    NSString *strName = [NSString stringWithFormat:@"%@",self.lastPageLayout.roleModel.name];
    NSMutableAttributedString *textName = [[NSMutableAttributedString alloc] initWithString:strName];
    textName.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightBold];
    textName.color = color;
    textName.alignment = NSTextAlignmentCenter;
    return textName;
}
- (NSMutableAttributedString *)layoutCoin:(UIColor *)color{
    NSString *strCoin = [NSString stringWithFormat:@"%@币",self.lastPageLayout.coinModel.alias];
    NSMutableAttributedString *textCoin = [[NSMutableAttributedString alloc] initWithString:strCoin];
    textCoin.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
    textCoin.color = color;
    textCoin.alignment = NSTextAlignmentCenter;
    return textCoin;
}

//credit
- (YYTextLayout *)layoutCredit:(BOOL)imageLoaded{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"鸟币信用：%@",self.lastPageLayout.coinModel.creditLevel]];
    text.font = [UIFont systemFontOfSize:13 weight:UIFontWeightUltraLight];
    text.color = imageLoaded?[UIColor colorWithWhite:0.97 alpha:0.89]:[UIColor colorWithWhite:0.0 alpha:0.618];
    text.kern = [NSNumber numberWithFloat:0.4];
    text.alignment = NSTextAlignmentCenter;
    
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-4, -6, -4, -6);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = imageLoaded?[UIColor colorWithWhite:0.97 alpha:0.191]:[UIColor colorWithWhite:0.0 alpha:0.1];
    text.textBorder = highlightBorder;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(screenWidth, 999);
    container.maximumNumberOfRows = 1;
    YYTextLayout *creditLayout = [YYTextLayout layoutWithContainer:container text:text];
    return creditLayout;
}

//profile
- (void)layoutProfile:(BOOL)imageLoaded{
    _profileTextHeight = 0;
    _profileTextLayout = nil;
    
    NSString *strDetail = [NSString stringWithFormat:@"%@",self.lastPageLayout.roleModel.desc];
    NSArray *arrOpenTypes = [self.lastPageLayout.roleModel.power componentsSeparatedByString:@","];
    for (NSString *type in arrOpenTypes) {
        strDetail = [strDetail stringByAppendingString:[NSString stringWithFormat:@" #%@",type]];
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:strDetail];
    text.font = [UIFont systemFontOfSize:kProfileFontSize weight:UIFontWeightRegular];
    text.color = imageLoaded?[UIColor colorWithWhite:1.0 alpha:0.89]:[UIColor colorWithWhite:0.3 alpha:1.0];
    text.kern = [NSNumber numberWithFloat:0.4];
    text.alignment = NSTextAlignmentCenter;
    
    if (text.length == 0) return;
    
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-3, -2, -3, -2);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor colorWithWhite:1.0 alpha:0.276];
    
    // 匹配 ＃标签
    NSArray *tagResults = [RX(@"[#@]\\w\\S*\\b") matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    for (NSTextCheckingResult *tag in tagResults) {
        if (tag.range.location == NSNotFound && tag.range.length <= 1) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:tag.range.location] == nil) {
            [text setColor:imageLoaded?[UIColor colorWithHue:212/360.0 saturation:0.276 brightness:0.94 alpha:1.0]:[UIColor colorWithWhite:0.382 alpha:1.0]  range:tag.range];
            [text setFont:[UIFont systemFontOfSize:kProfileFontSize weight:UIFontWeightLight] range:tag.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            //            highlight.userInfo = @{kWBLinkAtName : [text.string substringWithRange:NSMakeRange(tag.range.location + 1, tag.range.length - 1)]};
            [text setTextHighlight:highlight range:tag.range];
        }
    }
    
    
    CellTextLinePositionModifier *modifier = [CellTextLinePositionModifier new];
    modifier.font = [UIFont systemFontOfSize:kRoleCellContentFontSize weight:UIFontWeightRegular];
    modifier.paddingTop = kProfilePaddingText;
    modifier.paddingBottom = kProfilePaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(screenWidth-16, HUGE);
    container.linePositionModifier = modifier;
    
    _profileTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_profileTextLayout) return;
    
    _profileTextHeight = [modifier heightForLineCount:_profileTextLayout.lines.count];
}

- (NSMutableAttributedString *)layoutCity:(UIColor *)color{
    NSString *strCity = [NSString stringWithFormat:@"%@",self.lastPageLayout.roleModel.city];
    if ([strCity hasSuffix:@"市"]) {
        strCity = [strCity substringToIndex:strCity.length-1];
    }
    NSMutableAttributedString *textCity = [[NSMutableAttributedString alloc] initWithString:strCity];
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(10 * (CGFloat)M_PI / 180), 1, 0, 0);
    UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:[UIFont systemFontOfSize:15.0 weight:UIFontWeightUltraLight].fontName matrix:matrix];
    UIFont *font = [UIFont fontWithDescriptor:desc size:15];
    textCity.font = font;//斜体中文
    textCity.color = color;
    textCity.alignment = NSTextAlignmentCenter;
    return textCity;
}

                      
@end
