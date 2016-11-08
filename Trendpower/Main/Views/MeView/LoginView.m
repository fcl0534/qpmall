//
//  LoginView.m
//  Trendpower
//
//  Created by HTC on 15/5/10.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#define customCell_Height 44

#import "LoginView.h"

#import <Masonry.h>




#define textFiled_H  50

@interface LoginView()

/** 背景 */
@property (weak, nonatomic)  UIImageView * bgImageView;
/** 背景 */
@property (weak, nonatomic)  UIImageView * logoImageView;
/** 三角 */
@property (weak, nonatomic)  UIImageView * triangleView;
/** 返回按钮 */
@property (weak, nonatomic)  UIButton *backBtn;
/** 登陆Lable */
@property (weak, nonatomic)  UIButton *loginLbl;
/** 注册按钮 */
@property (weak, nonatomic)  UIButton *registerBtn;
/** 密码 */
@property (weak, nonatomic)  UITextField *pwF;
/** 登陆按钮 */
@property (weak, nonatomic)  UIButton *loginBtn;

/** 找回密码按钮 */
@property (weak, nonatomic)  UIButton * findPwBtn;


@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.969 alpha:1.000];
        
        UIImageView * bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
        self.bgImageView = bgImage;
        [self addSubview:bgImage];
        
        UIImageView * logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_logo"]];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        self.logoImageView = logo;
        [self addSubview:logo];
        
        UIButton * loginLbl = [[UIButton alloc]init];
        [loginLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginLbl setTitle:@"登录" forState:UIControlStateNormal];
        [loginLbl.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        loginLbl.userInteractionEnabled = NO;
        [self addSubview:loginLbl];
        self.loginLbl = loginLbl;
        
        UIButton * registerButton = [[UIButton alloc]init];
        [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [registerButton addTarget:self action:@selector(clickedRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [registerButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [self addSubview:registerButton];
        self.registerBtn = registerButton;
        
        UIButton * naviLeftItem = [[UIButton alloc]init];
        [naviLeftItem setImage:[UIImage imageNamed:@"navi_backBtn"] forState:UIControlStateNormal];
        [naviLeftItem addTarget:self action:@selector(clickedBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:naviLeftItem];
        self.backBtn = naviLeftItem;
        
        self.userF = [self getTextFieldPlaceholder:@"请输入手机号码" image:[UIImage imageNamed:@"username_normal"]];
        self.userF.keyboardType = UIKeyboardTypePhonePad;
        self.pwF = [self getTextFieldPlaceholder:@"请输入密码" image:[UIImage imageNamed:@"password_normal"]];
        self.pwF.secureTextEntry = YES;
        
//        [self.userF addTarget:self  action:@selector(textFieldDidChanged)  forControlEvents:UIControlEventAllEditingEvents];
//        [self.pwF addTarget:self  action:@selector(textFieldDidChanged)  forControlEvents:UIControlEventAllEditingEvents];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
//      [[NSNotificationCenter defaultCenter] addObserver:self.pwF selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
        
        UIImageView * triangleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"triangle"]];
        self.triangleView = triangleView;
        [self addSubview:triangleView];
        
        UIButton * findBtn = [[UIButton alloc]init];
        [findBtn setTitleColor:[UIColor colorWithWhite:0.400 alpha:1.000] forState:UIControlStateNormal];
        [findBtn addTarget:self action:@selector(clickedFindPwButton:) forControlEvents:UIControlEventTouchUpInside];
        [findBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [findBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [self addSubview:findBtn];
        self.findPwBtn = findBtn;
        
        UIButton * loginButton = [[UIButton alloc]init];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateDisabled];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"btn_square_bg"] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(clickedLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        loginButton.enabled = NO;
        [self addSubview:loginButton];
        self.loginBtn = loginButton;
        
        [self addViewConstraints];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (UITextField *)getTextFieldPlaceholder:(NSString *)placeholder image:(UIImage *)image{
    CGFloat W = 22;
    CGFloat H = textFiled_H;
    UITextField * textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.tintColor = K_MAIN_COLOR;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:14.0f];
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake((H-W)/2, (H-W)/2, W, W)];
    userImage.image = image;
    UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, H, H)];
    [imageView addSubview:userImage];
    textField.leftView = imageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = K_LINEBD_COLOR.CGColor;
    textField.layer.borderWidth = 1;
    
    
    [self addSubview:textField];
    return textField;
}


#pragma mark - 添加约束
-(void) addViewConstraints{
    
    CGFloat spacing = 10;
    CGFloat F_H = textFiled_H;
    
    // 1.
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(spacing*2);
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.30);
    }];
    
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.bgImageView.mas_centerY);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.4);
        make.height.mas_equalTo(self.bgImageView.mas_height).multipliedBy(0.50);
    }];
    
    [self.loginLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_centerX).offset(-30);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(36);
    }];
    
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(1);
        make.centerX.mas_equalTo(self.loginLbl.mas_centerX).offset(0);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(5);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_centerX).offset(30);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(36);
    }];
    
    [self.userF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(-1);
        make.right.mas_equalTo(self.mas_right).offset(1);
        make.height.mas_equalTo(F_H);
    }];
    
    [self.pwF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userF.mas_bottom).offset(-1);
        make.left.mas_equalTo(self.mas_left).offset(-1);
        make.right.mas_equalTo(self.mas_right).offset(1);
        make.height.mas_equalTo(F_H);
    }];
    
    [self.findPwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwF.mas_bottom).offset(spacing*1.5);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwF.mas_bottom).offset(spacing*5);
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(F_H);
    }];
    
}



#pragma mark - TextFiledNotificationCenter
- (void)textFieldDidChanged{
    
    [self checkLogiBtnEnabel];
}

- (void)checkLogiBtnEnabel{
    
    if (self.userF.text.length != 0 && self.pwF.text.length != 0 ) {
        self.loginBtn.enabled = YES;
    }else{
        self.loginBtn.enabled = NO;
    }
}



#pragma mark - 登陆点击事件
- (void)clickedLoginBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(loginViewClickedButton:userField:pwField:)]) {
        [self.delegate loginViewClickedButton:btn userField:self.userF pwField:self.pwF];
    }
}

#pragma mark - 点击注册
- (void)clickedRegisterButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(loginViewClickedRegisterButton)]) {
        [self.delegate loginViewClickedRegisterButton];
    }
}

#pragma mark - 点击返回
- (void)clickedBackButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(loginViewClickedBackButton)]) {
        [self.delegate loginViewClickedBackButton];
    }
}

#pragma mark - 点击找回密码
- (void)clickedFindPwButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(loginViewClickedFindPwButton)]) {
        [self.delegate loginViewClickedFindPwButton];
    }
}

@end
