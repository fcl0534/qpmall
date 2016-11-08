//
//  RegisterView.m
//  Trendpower
//
//  Created by HTC on 15/5/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#define K_ToolBar_Height 44

#import "RegisterView.h"
#import "NetworkingUtil.h"
#import "HUDUtil.h"
#import "UserDefaultsUtils.h"
#import "Utility.h"
#import "RegionModelArray.h"
#import "AddressAgentModel.h"

@interface RegisterView()
{
    UIButton *_temBtn;
}

@property (weak, nonatomic)  UIScrollView *scrollView;

/** 商家信息Label */
@property (weak, nonatomic)  UILabel *shopInfoLabel;
/** 企业名UILabel */
@property (weak, nonatomic)  UILabel *realNameLabel;
/** 所在区域Label */
@property (weak, nonatomic)  UILabel *areaLabel;
/** 登录信息  */
@property (nonatomic, weak) UILabel * lgoinLabel;
/** 手机Label*/
@property (weak, nonatomic)  UILabel *phoneLabel;
/** 密码Label */
@property (weak, nonatomic)  UILabel *passwordLabel;
/** 重复密码Label */
@property (weak, nonatomic)  UILabel *rePwLabel;

/** 用户类别
 3普通经销商  1加盟经销商 */
@property (assign, nonatomic) NSUInteger userCate;
@property (weak, nonatomic)  UIButton * userCate1Btn;
@property (weak, nonatomic)  UIButton * userCate2Btn;

/** 企业名 */
@property (weak, nonatomic)  UITextField *realNameField;
/** 所在区域 */
@property (weak, nonatomic)  UITextField *areaField;
@property (nonatomic, weak) UIImageView * rightView;
/** 区域按钮 */
@property (weak, nonatomic)  UIButton * areaButton;
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


/** 同意按钮  */
@property (nonatomic, weak) UIButton * agreeBtn;
/** 协议按钮  */
@property (nonatomic, weak) UILabel * protocolLbl;


/** 注册按钮 */
@property (weak, nonatomic)  UIButton * registerButton;

/** 经销商view */
@property (nonatomic, strong) UIView *dealersView;

@property (nonatomic, strong) UIView *addLine2;

/** 登录信息 */
@property (nonatomic, strong) UIView *loginView;


/**  定时器*/
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentCountDown;

@property (nonatomic, strong) AddressAgentModel *chooseAgentModel;

@end

@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.alwaysBounceVertical = YES;
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        
        CGFloat cellH = 50;
        CGFloat cellW = frame.size.width;
        CGFloat lblW = 100;
        CGFloat lineH = 0.5;
        CGFloat spacingL = 10;
        CGFloat spacingR = 25;

        self.shopInfoLabel = [self getBgLbl:@"   商家信息" frame:CGRectMake(0, 0, cellW, cellH)];
//        UIView * line0 = [self getLine:CGRectMake(0, CGRectGetMaxY(self.shopInfoLabel.frame), cellW, lineH)];
//        self.userCate1Btn = [self getBtn:@" 门店/修理厂" image:[UIImage imageNamed:@"agree_protocol_no"] select:[UIImage imageNamed:@"agree_protocol_yes"] frame:CGRectMake(0, CGRectGetMaxY(line0.frame), cellW/4 +30, cellH)];
//        self.userCate1Btn.center = CGPointMake(cellW/3 -10, CGRectGetMaxY(line0.frame)+cellH/2);
//        self.userCate2Btn = [self getBtn:@" 经销商" image:[UIImage imageNamed:@"agree_protocol_no"] select:[UIImage imageNamed:@"agree_protocol_yes"] frame:CGRectMake(CGRectGetMaxX(line0.frame), CGRectGetMaxY(line0.frame), cellW/4, cellH)];
//        self.userCate2Btn.center = CGPointMake(cellW *2/3 +20, CGRectGetMaxY(line0.frame)+cellH/2);
        /** 用户类别
         3普通经销商  1加盟经销商 */
        // 默认
        self.userCate = 3;
//        self.userCate1Btn.tag = 3;
//        self.userCate2Btn.tag = 1;
//        self.userCate1Btn.selected = YES;
//        [self.userCate1Btn addTarget:self action:@selector(clickedCateBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.userCate2Btn addTarget:self action:@selector(clickedCateBtn:) forControlEvents:UIControlEventTouchUpInside];

        UIView * line1 = [self getLine:CGRectMake(0, CGRectGetMaxY(self.shopInfoLabel.frame), cellW, lineH)];
        self.realNameLabel = [self getLbl:@"   企业名称" frame:CGRectMake(0, CGRectGetMaxY(line1.frame), lblW, cellH)];
        self.realNameField = [self getTextF:@"请填写" frame:CGRectMake(lblW, CGRectGetMaxY(line1.frame), cellW -CGRectGetMaxX(self.realNameLabel.frame) -spacingR, cellH)];

        UIView * line2 = [self getLine:CGRectMake(spacingL, CGRectGetMaxY(self.realNameLabel.frame), cellW, lineH)];
        self.areaLabel = [self getLbl:@"   所在区域" frame:CGRectMake(0, CGRectGetMaxY(line2.frame), lblW, cellH)];
        self.areaField = [self getTextF:@"请选择" frame:CGRectMake(lblW, CGRectGetMaxY(line2.frame), cellW -CGRectGetMaxX(self.areaLabel.frame) -spacingR, cellH)];
        self.areaField.userInteractionEnabled = NO;
        self.areaButton = [self getcodeBtnTitile:@"" frame:self.areaField.frame];
        [self.areaButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.areaButton addTarget:self action:@selector(clickedAreaBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = [self getImageView:CGRectMake(cellW -spacingR, CGRectGetMaxY(line2.frame)+(cellH -13)/2, 13, 13)];
        self.rightView.image = [UIImage imageNamed:@"arrow-right"];

        //所属经销商
        self.dealersView = [[UIView alloc] init];
        [self.scrollView addSubview:self.dealersView];

        UIView *addLine1 = [self getLine:self.dealersView rect:CGRectMake(spacingL, 0, cellW, lineH)];
        UILabel *dealersLbl = [self getLbl:self.dealersView title:@"   所属经销商" frame:CGRectMake(0, CGRectGetMaxY(addLine1.frame), lblW, cellH)];

        self.addLine2 = [self getLine:self.dealersView rect:CGRectMake(spacingL, CGRectGetMaxY(dealersLbl.frame), cellW, lineH)];

        self.dealersView.frame = CGRectMake(0, CGRectGetMaxY(self.areaLabel.frame), cellW, 0);

        //登录信息
        self.loginView = [[UIView alloc] init];
        [self.scrollView addSubview:self.loginView];

        UIView * line3 = [self getLine:self.loginView rect:CGRectMake(0, 0, cellW, lineH)];
        self.lgoinLabel = [self getBgLbl:self.loginView title:@"   登录信息" frame:CGRectMake(0, CGRectGetMaxY(line3.frame), cellW, cellH)];

        UIView * line4 = [self getLine:self.loginView rect:CGRectMake(0, CGRectGetMaxY(self.lgoinLabel.frame), cellW, lineH)];
        self.phoneLabel = [self getLbl:self.loginView title:@"  输入手机号" frame:CGRectMake(0, CGRectGetMaxY(line4.frame), lblW, cellH)];
        self.phoneField = [self getTextF:self.loginView placehold:@"请填写" frame:CGRectMake(lblW, CGRectGetMaxY(line4.frame), cellW -CGRectGetMaxX(self.phoneLabel.frame) -spacingR, cellH)];
        self.phoneField.keyboardType = UIKeyboardTypePhonePad;

        UIView * line5 = [self getLine:self.loginView rect:CGRectMake(spacingL, CGRectGetMaxY(self.phoneLabel.frame), cellW, lineH)];
        self.codeField = [self getTextF:self.loginView placehold:@"  请填写验证码" frame:CGRectMake(spacingL, CGRectGetMaxY(line5.frame) +8, cellW/2 , cellH -16)];
        self.codeField.keyboardType = UIKeyboardTypeNumberPad;
        self.codeField.textAlignment = NSTextAlignmentLeft;
        self.codeField.layer.borderColor = [UIColor colorWithWhite:0.751 alpha:1.000].CGColor;
        self.codeField.layer.borderWidth = 1.0;
        self.codeField.layer.cornerRadius = 5;
//        self.codeField.layer.masksToBounds = YES;

        self.captchaBtn = [self getcodeBtn:self.loginView title:@"获取验证码" frame:CGRectMake(CGRectGetMaxX(self.codeField.frame) +spacingL*3, CGRectGetMaxY(line5.frame) +5, cellW -(CGRectGetMaxX(self.codeField.frame) +spacingL*3 +spacingR), cellH -10)];
        [self.captchaBtn setBackgroundColor:[UIColor colorWithWhite:0.776 alpha:1.000]];
        [self.captchaBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        self.captchaBtn.enabled = NO;
        [self.captchaBtn addTarget:self action:@selector(clickedCodeBtn:) forControlEvents:UIControlEventTouchUpInside];

        UIView * line6 = [self getLine:self.loginView rect:CGRectMake(spacingL, CGRectGetMaxY(self.captchaBtn.frame) +5, cellW, lineH)];
        self.passwordLabel = [self getLbl:self.loginView title:@"   输入密码" frame:CGRectMake(0, CGRectGetMaxY(line6.frame), lblW, cellH)];
        self.passwordField = [self getTextF:self.loginView placehold:@"请填写" frame:CGRectMake(lblW, CGRectGetMaxY(line6.frame), cellW -CGRectGetMaxX(self.passwordLabel.frame) -spacingR, cellH)];
        self.passwordField.secureTextEntry = YES;

        UIView * line7 = [self getLine:self.loginView rect:CGRectMake(spacingL, CGRectGetMaxY(self.passwordLabel.frame), cellW, lineH)];
        self.rePwLabel = [self getLbl:self.loginView title:@"   确认密码" frame:CGRectMake(0, CGRectGetMaxY(line7.frame), lblW, cellH)];
        self.rePwField = [self getTextF:self.loginView placehold:@"请填写" frame:CGRectMake(lblW, CGRectGetMaxY(line7.frame), cellW -CGRectGetMaxX(self.rePwLabel.frame) -spacingR, cellH)];
        self.rePwField.secureTextEntry = YES;
        UIView * line8 = [self getLine:self.loginView rect:CGRectMake(0, CGRectGetMaxY(self.rePwLabel.frame), cellW, lineH)];
        
        self.agreeBtn = [self getBtn:self.loginView title:@"" image:[UIImage imageNamed:@"agree_protocol_no"] select:[UIImage imageNamed:@"agree_protocol_yes"] frame:CGRectMake(spacingL, CGRectGetMaxY(line8.frame), 30, cellH)];
        [self.agreeBtn addTarget:self action:@selector(clickedAgreeButton:) forControlEvents:UIControlEventTouchUpInside];
        self.agreeBtn.selected = YES;
        NSString * protocolStr = @"我同意“佳驰用户注册协议”";
        self.protocolLbl = [self  getLbl:self.loginView title:protocolStr frame:CGRectMake(spacingL +30, CGRectGetMaxY(line8.frame),  185, cellH)];
        self.protocolLbl.userInteractionEnabled = YES;
        //重点字
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:protocolStr attributes:attributes];
        [attributedString addAttribute:NSForegroundColorAttributeName value:K_MAIN_COLOR range:[attributedString.string rangeOfString:@"佳驰用户注册协议"]];
        self.protocolLbl.attributedText = attributedString;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedProtocolButton)];
        [self.protocolLbl addGestureRecognizer:tap];
        
        self.registerButton = [self getcodeBtn:self.loginView title:@"确定" frame:CGRectMake(spacingL, CGRectGetMaxY(self.agreeBtn.frame) +30, cellW -spacingL*2, cellH)];
        self.registerButton.enabled = NO;
        [self.registerButton addTarget:self action:@selector(clickedRegisterButton:) forControlEvents:UIControlEventTouchUpInside];

        self.loginView.frame = CGRectMake(0, CGRectGetMaxY(self.dealersView.frame), cellW, CGRectGetMaxY(self.registerButton.frame));
        
        scrollView.contentSize = CGSizeMake(cellW, CGRectGetMaxY(self.loginView.frame) +50);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (UIImageView *) getImageView:(CGRect)frame{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageView];
    return imageView;
}

- (UILabel *)getBgLbl:(NSString *)title frame:(CGRect)frame{
    UILabel * lbl = [[UILabel alloc]initWithFrame:frame];
    lbl.backgroundColor = [UIColor colorWithWhite:0.945 alpha:1.000];
    lbl.textColor = [UIColor colorWithWhite:0.376 alpha:1.000];
    lbl.text = title;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [UIFont boldSystemFontOfSize:15.5f];
    [self.scrollView addSubview:lbl];
    return lbl;
}

- (UILabel *)getBgLbl:(UIView *)superView title:(NSString *)title frame:(CGRect)frame{
    UILabel * lbl = [[UILabel alloc]initWithFrame:frame];
    lbl.backgroundColor = [UIColor colorWithWhite:0.945 alpha:1.000];
    lbl.textColor = [UIColor colorWithWhite:0.376 alpha:1.000];
    lbl.text = title;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [UIFont boldSystemFontOfSize:15.5f];
    [superView addSubview:lbl];
    return lbl;
}


- (UILabel *)getLbl:(NSString *)title frame:(CGRect)frame{
    UILabel * lbl = [[UILabel alloc]initWithFrame:frame];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.textColor = [UIColor colorWithWhite:0.369 alpha:1.000];
    lbl.text = title;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [UIFont systemFontOfSize:14.5f];
    [self.scrollView addSubview:lbl];
    return lbl;
}

- (UILabel *)getLbl:(UIView *)superView title:(NSString *)title frame:(CGRect)frame{
    UILabel * lbl = [[UILabel alloc]initWithFrame:frame];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.textColor = [UIColor colorWithWhite:0.369 alpha:1.000];
    lbl.text = title;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [UIFont systemFontOfSize:14.5f];
    [superView addSubview:lbl];
    return lbl;
}


- (UITextField *)getTextF:(NSString *)placehold frame:(CGRect)frame{
    UITextField * filed = [[UITextField alloc]initWithFrame:frame];
    filed.textAlignment = NSTextAlignmentRight;
    //filed.clearButtonMode = UITextFieldViewModeWhileEditing;
    filed.textColor = [UIColor colorWithWhite:0.384 alpha:1.000];
    filed.font = [UIFont systemFontOfSize:14.5f];
    filed.tintColor = K_MAIN_COLOR;
    filed.placeholder = placehold;
    [self.scrollView addSubview:filed];
    return filed;
}

- (UITextField *)getTextF:(UIView *)superView placehold:(NSString *)placehold frame:(CGRect)frame{
    UITextField * filed = [[UITextField alloc]initWithFrame:frame];
    filed.textAlignment = NSTextAlignmentRight;
    //filed.clearButtonMode = UITextFieldViewModeWhileEditing;
    filed.textColor = [UIColor colorWithWhite:0.384 alpha:1.000];
    filed.font = [UIFont systemFontOfSize:14.5f];
    filed.tintColor = K_MAIN_COLOR;
    filed.placeholder = placehold;
    [superView addSubview:filed];
    return filed;
}

- (UIView *)getLine:(CGRect)frame{
    UIView * line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithWhite:0.879 alpha:1.000];
    [self.scrollView addSubview:line];
    return line;
}

- (UIView *)getLine:(UIView *)superView rect:(CGRect)frame{
    UIView * line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithWhite:0.879 alpha:1.000];
    [superView addSubview:line];
    return line;
}

- (UIButton *)getBtn:(NSString *)title image:(UIImage *)image select:(UIImage *)select frame:(CGRect)frame{
    UIButton * btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:select forState:UIControlStateSelected];
    [btn setTitleColor: [UIColor colorWithWhite:0.635 alpha:1.000] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.5f]];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.scrollView addSubview:btn];
    return btn;
}

- (UIButton *)getBtn:(UIView *)superView title:(NSString *)title image:(UIImage *)image select:(UIImage *)select frame:(CGRect)frame{
    UIButton * btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:select forState:UIControlStateSelected];
    [btn setTitleColor: [UIColor colorWithWhite:0.635 alpha:1.000] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.5f]];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [superView addSubview:btn];
    return btn;
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

- (UIButton *) getcodeBtn:(UIView *)superView title:(NSString *)title frame:(CGRect)frame{
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
    [superView addSubview:btn];
    return btn;
}


- (void)setArea:(NSString *)area{
    self.areaField.text = area;
    
    [self checkLoginBtnEnable];
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



#pragma mark - Event response
- (void)clickedAreaBtn:(UIButton *)btn{
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(registerViewClickedArea)]) {
        [self.delegate registerViewClickedArea];
    }
}


- (void)clickedCodeBtn:(UIButton *)btn{
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(registerViewClickedCodeButton:phoneField:)]) {
        [self.delegate registerViewClickedCodeButton:btn phoneField:self.phoneField];
    }

}

- (void)clickedCateBtn:(UIButton *)btn{
    
    self.userCate = btn.tag;
    btn.selected = YES;
    
    switch (btn.tag) {
        case 1:
            self.userCate1Btn.selected = NO;
            break;
        case 3:
            self.userCate2Btn.selected = NO;
            break;
        default:
            break;
    }
    
    [self checkLoginBtnEnable];
}


- (void)clickedAgreeButton:(UIButton *)btn{
    [self endEditing:YES];
    btn.selected = !btn.isSelected;
    
    [self checkLoginBtnEnable];
}

- (void)clickedProtocolButton{
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(registerViewClickedProtocol)]) {
        [self.delegate registerViewClickedProtocol];
    }
}

- (void)clickedDealerBtn:(UIButton *)button {
    //设置
    if(_temBtn == button) {
        //不做处理
        _temBtn.selected = !_temBtn.isSelected;

    } else {
        button.selected = YES;

        _temBtn.selected = NO;
    }

    _temBtn = button;

    if (_temBtn.isSelected) {
        self.chooseAgentModel = self.dealers[button.tag - 100];
    } else {
        self.chooseAgentModel = nil;
    }
}

#pragma mark - 注册点击事件
- (void)clickedRegisterButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(registerViewClickedRegisterButton:phoneField:pwField:rePwField:realNameField:areaField:codeField:agreeBtn:userCate:agentId:)]) {
        [self.delegate registerViewClickedRegisterButton:btn phoneField:self.phoneField pwField:self.passwordField rePwField:self.rePwField realNameField:self.realNameField areaField:self.areaField codeField:self.codeField agreeBtn:self.agreeBtn userCate:self.userCate agentId:self.chooseAgentModel.agentId];
    }
}


#pragma makr - 检查注册按钮可以点击
- (void)checkLoginBtnEnable{

    if (self.userCate !=0 && self.realNameField.text.length != 0 && self.areaField.text.length != 0  && self.phoneField.text.length == 11  && self.codeField.text.length == 6  && self.passwordField.text.length != 0  && self.rePwField.text.length != 0 && self.agreeBtn.selected ) {
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

#pragma mark - setter and getter
- (void)setDealers:(NSArray *)dealers {

    //清除，防止切换城市时之前的还存着导致文字重叠
    for (UIView *view in self.dealersView.subviews) {

        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }

    if (dealers.count <=0 ) {

        self.dealersView.frame = CGRectMake(0, CGRectGetMaxY(self.areaLabel.frame), self.frame.size.width, 0);

        self.loginView.frame = CGRectMake(0, CGRectGetMaxY(self.dealersView.frame), self.frame.size.width, CGRectGetMaxY(self.registerButton.frame));

        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.loginView.frame) +50);

        return;
    }

    CGFloat cellWidth = self.frame.size.width;

    CGFloat marginLeft = 20;

    CGFloat xOffset = marginLeft;

    CGFloat yOffset = CGRectGetMaxY(self.addLine2.frame);

    CGFloat xNextOffset = marginLeft;

    CGFloat itemWidth = cellWidth-marginLeft;

    NSInteger lineCount = 1;

    UIButton *chooseDealer;

    for (NSInteger i = 0; i < dealers.count; i++) {

        AddressAgentModel *agentModel = dealers[i];

        chooseDealer = [self getBtn:self.dealersView title:agentModel.company_name image:[UIImage imageNamed:@"agree_protocol_no"] select:[UIImage imageNamed:@"agree_protocol_yes"] frame:CGRectZero];
        chooseDealer.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        xNextOffset += itemWidth;

        if (xNextOffset > cellWidth) {

            xOffset = marginLeft;

            xNextOffset = itemWidth + marginLeft;

            yOffset += 50;

            lineCount += 1;

        } else {

            xOffset = xNextOffset - itemWidth;
        }

        chooseDealer.frame = CGRectMake(xOffset, yOffset, itemWidth, 50);

        chooseDealer.tag = 100+i;

        [chooseDealer addTarget:self action:@selector(clickedDealerBtn:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.dealersView.frame = CGRectMake(0, CGRectGetMaxY(self.areaLabel.frame), cellWidth, CGRectGetMaxY(chooseDealer.frame));

    self.loginView.frame = CGRectMake(0, CGRectGetMaxY(self.dealersView.frame), cellWidth, CGRectGetMaxY(self.registerButton.frame));

    self.scrollView.contentSize = CGSizeMake(cellWidth, CGRectGetMaxY(self.loginView.frame) +50);
}

@end
