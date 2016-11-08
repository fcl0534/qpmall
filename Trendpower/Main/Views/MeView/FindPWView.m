
//
//  FindPWView.m
//  Trendpower
//
//  Created by HTC on 16/1/24.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "FindPWView.h"



@interface FindPWView()

@property (weak, nonatomic)  UIScrollView *scrollView;

/** 手机*/
@property (weak, nonatomic)  UITextField *phoneField;
/** 验证码 */
@property (weak, nonatomic)  UITextField *codeField;
/** 发送验证码按钮  */
@property (nonatomic, weak) UIButton * captchaBtn;
/** 密码 */
@property (weak, nonatomic)  UITextField *passwordField;
/** 重复密码 */
@property (weak, nonatomic)  UITextField *rePwField;


/** 确认按钮 */
@property (weak, nonatomic)  UIButton * registerButton;

/**  定时器*/
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentCountDown;

@end


@implementation FindPWView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.alwaysBounceVertical = YES;
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        
        CGFloat cellH = 50;
        CGFloat cellW = frame.size.width;
        CGFloat lineH = 0.8;
        CGFloat headerH = 20;
        CGFloat spacing = 15;
        
        UIView * header = [self getBgView:CGRectMake(0, 0, cellW, headerH)];
        UIView * line1 = [self getLine:CGRectMake(0, CGRectGetMaxY(header.frame), cellW, lineH)];
        self.phoneField = [self getTextF:@"请输入手机号" frame:CGRectMake(spacing, CGRectGetMaxY(line1.frame), cellW -spacing*2, cellH)];
        self.phoneField.keyboardType = UIKeyboardTypePhonePad;
        UIView * line2 = [self getLine:CGRectMake(0, CGRectGetMaxY(self.phoneField.frame), cellW, lineH)];
        self.codeField = [self getTextF:@"请填写验证码" frame:CGRectMake(spacing, CGRectGetMaxY(line2.frame) +8, cellW/2 , cellH -16)];
        self.codeField.keyboardType = UIKeyboardTypeNumberPad;
//        self.codeField.layer.borderColor = [UIColor colorWithWhite:0.751 alpha:1.000].CGColor;
//        self.codeField.layer.borderWidth = 1.0;
//        self.codeField.layer.cornerRadius = 5;
//        self.codeField.layer.masksToBounds = YES;
        self.captchaBtn = [self getcodeBtnTitile:@"获取验证码" frame:CGRectMake(CGRectGetMaxX(self.codeField.frame) +spacing*2, CGRectGetMaxY(line2.frame) +5, cellW -(CGRectGetMaxX(self.codeField.frame) +spacing*3), cellH -10)];
        [self.captchaBtn setBackgroundColor:[UIColor colorWithWhite:0.776 alpha:1.000]];
        [self.captchaBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        self.captchaBtn.enabled = NO;
        [self.captchaBtn addTarget:self action:@selector(clickedCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIView * line3 = [self getLine:CGRectMake(0, CGRectGetMaxY(self.captchaBtn.frame) +5, cellW, lineH)];
        self.passwordField = [self getTextF:@"请输入新密码" frame:CGRectMake(spacing, CGRectGetMaxY(line3.frame), cellW -spacing*2, cellH)];
        self.passwordField.secureTextEntry = YES;
        UIView * line4 = [self getLine:CGRectMake(0, CGRectGetMaxY(self.passwordField.frame), cellW, lineH)];
        self.rePwField = [self getTextF:@"请输入确认密码" frame:CGRectMake(spacing, CGRectGetMaxY(line4.frame), cellW -spacing*2, cellH)];
        self.rePwField.secureTextEntry = YES;
        UIView * line5 = [self getLine:CGRectMake(0, CGRectGetMaxY(self.rePwField.frame), cellW, lineH)];
        
//        UIView * footer = [self getBgView:CGRectMake(0, CGRectGetMaxY(line5.frame), cellW, frame.size.height)];
        
        self.registerButton = [self getcodeBtnTitile:@"确定" frame:CGRectMake(spacing, CGRectGetMaxY(line5.frame) +30, cellW -spacing*2, cellH)];
        self.registerButton.enabled = NO;
        [self.registerButton addTarget:self action:@selector(clickedRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
        
        scrollView.contentSize = CGSizeMake(cellW, CGRectGetMaxY(self.registerButton.frame) +50);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
    }
    
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


- (UITextField *)getTextF:(NSString *)placehold frame:(CGRect)frame{
    UITextField * filed = [[UITextField alloc]initWithFrame:frame];
    filed.textAlignment = NSTextAlignmentLeft;
    filed.clearButtonMode = UITextFieldViewModeWhileEditing;
    filed.textColor = [UIColor colorWithWhite:0.384 alpha:1.000];
    filed.font = [UIFont systemFontOfSize:14.5f];
    filed.tintColor = K_MAIN_COLOR;
    filed.placeholder = placehold;
    [self.scrollView addSubview:filed];
    return filed;
}


- (UIView *)getLine:(CGRect)frame{
    UIView * line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithWhite:0.784 alpha:1.000];
    [self.scrollView addSubview:line];
    return line;
}



- (UIView *)getBgView:(CGRect)frame{
    UIView * line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    [self.scrollView addSubview:line];
    return line;
}

- (UIButton *) getcodeBtnTitile:(NSString *)title frame:(CGRect)frame{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateDisabled];
    [btn setBackgroundImage:[UIImage imageNamed:@"back_red"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.5f]];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.scrollView addSubview:btn];
    return btn;
}


#pragma mark - TextFiledNotificationCenter
- (void)textFieldDidChange:(NSNotification *)info{
    
    if (info.object == self.phoneField && self.currentCountDown ==0 ) {
        if (self.phoneField.text.length == 11) {
            self.captchaBtn.enabled = YES;
            [self.captchaBtn setBackgroundColor:K_MAIN_COLOR];
        }else{
            self.captchaBtn.enabled = NO;
            [self.captchaBtn setBackgroundColor:[UIColor colorWithWhite:0.776 alpha:1.000]];
        }
    }
    
    [self checkLoginBtnEnable];
}


- (void)clickedCodeBtn:(UIButton *)btn{
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(findPWViewClickedCodeButton:phoneField:)]) {
        [self.delegate findPWViewClickedCodeButton:btn phoneField:self.phoneField];
    }
    
}


#pragma mark - 注册点击事件
- (void)clickedRegisterButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(findPWViewClickedSubmit:phoneField:pwField:rePwField:codeField:)]) {
        [self.delegate findPWViewClickedSubmit:btn phoneField:self.phoneField pwField:self.passwordField rePwField:self.rePwField codeField:self.codeField];
    }
}


#pragma makr - 检查注册按钮可以点击
- (void)checkLoginBtnEnable{
    if (self.phoneField.text.length == 11  && self.codeField.text.length == 6  && self.passwordField.text.length != 0  && self.rePwField.text.length != 0) {
        self.registerButton.enabled = YES;
    }else{
        self.registerButton.enabled = NO;
    }
}



#pragma mark - 倒计时
- (void)startCount
{
    /**
     *  添加定时器
     */
    self.currentCountDown = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self setCaptchaEnable:NO];
    [self.timer fire];
}

- (void)countDown{
    
    if (self.currentCountDown >0) {
        //设置界面的按钮显示 根据自己需求设置
        [self.captchaBtn setTitle:[NSString stringWithFormat:@"(%ld)重新获取",(long)self.currentCountDown] forState:UIControlStateNormal];
        //self.captchaBtn.enabled = NO;
        self.currentCountDown -= 1;
    }else{
        [self removeTimer];
    }
    
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    self.currentCountDown = 0;
    [self setCaptchaEnable:YES];
    [self.timer invalidate];
    self.timer = nil;
}




//因为iOS 7下 按钮 enabled= NO, 不能设置文字
#pragma mark - 设置按钮状态
- (void)setCaptchaEnable:(BOOL)enabled{
    //可以按
    if (enabled) {
        self.captchaBtn.userInteractionEnabled = YES;
        [self.captchaBtn setBackgroundColor:K_MAIN_COLOR];
        [self.captchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        self.captchaBtn.userInteractionEnabled = NO;
        [self.captchaBtn setBackgroundColor:[UIColor colorWithWhite:0.776 alpha:1.000]];
    }
}




@end
