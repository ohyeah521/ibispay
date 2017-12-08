//
//  SkillDescEditorViewController.m
//  Action
//
//  Created by cooerson on 15/12/21.
//  Copyright © 2015年 xingdongpai. All rights reserved.
//

#import "SkillDescEditor.h"

@interface SkillDescEditor ()<YYTextViewDelegate, YYTextKeyboardObserver>

@property (nonatomic, assign) YYTextView *textView;

@end

@implementation SkillDescEditor

@synthesize rowDescriptor = _rowDescriptor;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"细节介绍："];
    if ([CommonFunction getChineseCount:self.desc] > 0) {
        text = [[NSMutableAttributedString alloc] initWithString:self.desc];
    }
//    text.font = set_font_tisa(16);
    text.font = kTextViewFont;
    
    YYTextView *textView = [YYTextView new];
    textView.size = self.view.size;
    textView.attributedText = text;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.delegate = self;
    textView.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    textView.scrollIndicatorInsets = textView.contentInset;
    textView.selectedRange = NSMakeRange(text.length, 0);
    [self.view addSubview:textView];
    self.textView = textView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textView becomeFirstResponder];
    });
    
    [[YYTextKeyboardManager defaultManager] addObserver:self];
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

- (void)textViewDidChange:(YYTextView *)textView{
    NSString *txt = get_trim(self.textView.text);
    //必须大于5个字
    if (isNullString(txt) == NO && [txt hasPrefix:@"细节介绍："] == YES && [CommonFunction getChineseCount:txt] > 5) {
        self.desc = [txt substringFromIndex:5];
    }else if(isNullString(txt) == NO && [txt hasPrefix:@"细节介绍："] == NO){
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

@end
