//
//  ChatViewController.m
//  KVODemo
//
//  Created by 郭凯 on 2016/11/29.
//  Copyright © 2016年 guokai. All rights reserved.
//

#import "ChatViewController.h"

#import "Define.h"
#define kEmotionViewH 200

@interface ChatViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *emotionView;
@property (nonatomic, strong) UIView *toolView;

@end

@implementation ChatViewController
{
    BOOL _emotionViewIsSHow;
}

- (UIView *)emotionView {
    if (!_emotionView) {
        _emotionView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height, kScreenSize.width, kEmotionViewH)];
        _emotionView.backgroundColor = [UIColor lightGrayColor];
    }
    return _emotionView;
}

- (UIView *)toolView {
    if (!_toolView) {
        
    }
    return _toolView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBaseUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)setupBaseUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake((kScreenSize.width - 100)/2, 100, 100, 50)];
    view1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view1];
    
    [self.bgView addSubview:self.textView];
    [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.emotionView];
    
    UIButton *emotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emotionBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + 10, CGRectGetHeight(self.bgView.frame) - 30 - 8, 30, 30);
    [emotionBtn setBackgroundImage:[UIImage imageNamed:@"chat_btn_im_emotion_normal"] forState:UIControlStateNormal];
    [emotionBtn setBackgroundImage:[UIImage imageNamed:@"chat_btn_im_emotion_press"] forState:UIControlStateHighlighted];
    [emotionBtn addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:emotionBtn];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(CGRectGetMaxX(emotionBtn.frame) + 10, CGRectGetHeight(self.bgView.frame) - 30 - 8, 30, 30);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"chat_btn_message_add_n"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"chat_btn_message_add_h"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:addBtn];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kScreenSize.width - 100, 36)];
        _textView.backgroundColor = kSetRGBColor(251, 251, 251);
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5.0;
        _textView.font = [UIFont systemFontOfSize:15];
    }
    return _textView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 46, kScreenSize.width, 46)];
        _bgView.backgroundColor = kSetRGBColor(243, 243, 243);
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

- (void)kboardWillShow:(NSNotification *)note {
    
    CGRect beginRect = [[note.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = endRect.size.height;
    
    if (!(beginRect.size.height > 0 && (beginRect.origin.y - endRect.origin.y) > 0)) {
        return;
    }
    
    [UIView animateWithDuration:0.30 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenSize.height - kbHeight - CGRectGetHeight(self.bgView.frame), kScreenSize.width, CGRectGetHeight(self.bgView.frame));
    }];
}

- (void)kboardWillHiden:(NSNotification *)note {
    if (_emotionViewIsSHow) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.frame = CGRectMake(0, kScreenSize.height - CGRectGetHeight(self.bgView.frame) - kEmotionViewH, kScreenSize.width, CGRectGetHeight(self.bgView.frame));
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.frame = CGRectMake(0, kScreenSize.height - CGRectGetHeight(self.bgView.frame), kScreenSize.width, CGRectGetHeight(self.bgView.frame));
        }];
    }

}

//KVO监听textView高度的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentSize"] && object == self.textView) {
        CGSize contentSize = self.textView.contentSize;
        CGFloat maxH = 70;
        if (contentSize.height > maxH) {
            self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.bgView.frame) - maxH - 10, kScreenSize.width, maxH + 10);
            self.textView.frame = CGRectMake(10, 5, kScreenSize.width - 100, maxH);
        }else {
            CGSize contentSize = self.textView.contentSize;
            self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.bgView.frame) - contentSize.height - 10, kScreenSize.width, contentSize.height + 10);
            self.textView.frame = CGRectMake(10, 5, kScreenSize.width - 100, contentSize.height);
        }
    }
}

- (void)showEmotionView {
    _emotionViewIsSHow = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.emotionView.frame = CGRectMake(0, kScreenSize.height - kEmotionViewH, kScreenSize.width, kEmotionViewH);
        self.bgView.frame = CGRectMake(0, kScreenSize.height - kEmotionViewH - CGRectGetHeight(self.bgView.frame), kScreenSize.width, CGRectGetHeight(self.bgView.frame));
    }];
}

- (void)hidenEmotionView {
    _emotionViewIsSHow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.emotionView.frame = CGRectMake(0, kScreenSize.height, kScreenSize.width, kEmotionViewH);
    }];
}

#pragma mark -- 点击事件
- (void)emotionClick:(UIButton *)btn {
    if ([self.textView isFirstResponder]) {
        //显示view
        [self showEmotionView];
        [self.textView resignFirstResponder];
        
        
    }else {
        //显示键盘
        [self hidenEmotionView];
        [self.textView becomeFirstResponder];
    }
}

- (void)addClick:(UIButton *)btn {
    
}

//在当前的View上添加点击事件，收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.textView resignFirstResponder];
}

//销毁KVO
- (void)dealloc {
    
    [self.textView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
