//
//  LogEditor.m
//  Action
//
//  Created by 鸟神 on 2017/2/15.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "LoveLogEditor.h"
#import "LoveForm.h"

@interface LoveLogEditor ()<YYTextViewDelegate, YYTextKeyboardObserver>

@property (nonatomic, assign) YYTextView *textView;

@end

@implementation LoveLogEditor

@synthesize rowDescriptor = _rowDescriptor;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initFunction];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    //检测是否为返回pop
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        NSLog(@"pop");
    }
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isEdit == YES) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(done)];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initFunction{
    self.view.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1.0];

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"行动日志："];
    if ([CommonFunction getChineseCount:self.desc] > 0) {
        text = [[NSMutableAttributedString alloc] initWithString:self.desc];
    }
    text.font = set_font_tisa(14);
    
    
    YYTextView *textView = [YYTextView new];
    textView.size = self.view.size;
    textView.attributedText = text;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.delegate = self;
    textView.textColor = [UIColor colorWithWhite:0.13 alpha:1.0];
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.scrollIndicatorInsets = textView.contentInset;
    textView.selectedRange = NSMakeRange(text.length, 0);
    [self.view addSubview:textView];
    self.textView = textView;
    
    NSMutableArray *buttons = NSMutableArray.array;
    RFToolbarButton *btnDate = [RFToolbarButton buttonWithTitle:@"日期"];
    [btnDate addEventHandler:^{
        NSDate * date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        //设置时间输出格式：
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy年MM月dd日"];
        NSString * na = [NSString stringWithFormat:@"\n\n%@\n",[df stringFromDate:currentDate]];
        
        [_textView insertText:na];
    } forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:btnDate];
    
    RFToolbarButton *btnInspiration = [RFToolbarButton buttonWithTitle:@"✻灵感"];//🌀🦄♨
    [btnInspiration addEventHandler:^{
        [_textView insertText:@"✻ "];
    } forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:btnInspiration];
    RFToolbarButton *btnList = [RFToolbarButton buttonWithTitle:@"•列表"];//•
    [btnList addEventHandler:^{
        [_textView insertText:@"\n• "];
    } forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:btnList];
    RFToolbarButton *btnDone = [RFToolbarButton buttonWithTitle:@"✔︎完成"];//✔️✅√
    [btnDone addEventHandler:^{
        [_textView insertText:@" ✔︎"];
    } forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:btnDone];
    RFToolbarButton *btnMilestone = [RFToolbarButton buttonWithTitle:@"⚑里程碑"];//🍭⚐⚑☀︎☼
    [btnMilestone addEventHandler:^{
        [_textView insertText:@" ⚑"];
    } forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:btnMilestone];
    
    RFToolbarButton *btnLine = [RFToolbarButton buttonWithTitle:@"分割线"];
    [btnLine addEventHandler:^{
        [_textView insertText:@"------------"];
    } forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:btnLine];
    _textView.inputAccessoryView = [RFKeyboardToolbar toolbarWithButtons:buttons];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textView becomeFirstResponder];
    });
    
    [[YYTextKeyboardManager defaultManager] addObserver:self];

}

- (void)textViewDidChange:(YYTextView *)textView{
    NSString *txt = get_trim(self.textView.text);
    if(isNullString(txt) == NO){
        self.desc = txt;
    }else{
        self.desc = [[NSString alloc] init];
    }
    
    if (isNullString(txt) == NO && [txt hasPrefix:@"行动日志："] == YES && [CommonFunction getChineseCount:txt] > 7) {
        self.desc = [txt substringFromIndex:7];
    }else if(isNullString(txt) == NO && [txt hasPrefix:@"行动日志："] == NO){
        self.desc = txt;
    }else{
        self.desc = [[NSString alloc] init];
    }
}

#pragma mark - keyboard

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    if (_textView.isVerticalForm && transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            CGRect textFrame = self.view.bounds;
            textFrame.size.height -= rect.size.height;
            _textView.frame = textFrame;
            clipped = YES;
        }
    }
    
    if (!clipped) {
        _textView.frame = self.view.bounds;
    }
}


#pragma mark - private func

- (void)done{
    LoveForm *loveForm = [LoveForm new];
    //仅在新建时带上log参数
    if (self.isEdit == YES && isNullString(self.desc) == NO) {
        loveForm.log = get_trim(self.desc);
    }
    
    NSDictionary *params = [loveForm modelToJSONObject];
    if (self.isEdit == YES) {
        [self.view endEditing:YES];
        //修改日志
        showJuHua(nil, self.navigationController.view);
        [AFNetworkHelper putUrl:[NSString stringWithFormat:@"%@/%@",kUpdateLoveLogUrl,self.loveID] bg:NO param:params succeed:^(id responseObject) {
            showAndHideRightJuHua(NSLocalizedString(@"Saved", @""),self.navigationController.view);
        } fail:^{
            hideJuHua(self.navigationController.view);
        }];
        
    }
}

@end
