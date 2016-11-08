//
//  MeHeaderView.m
//  EcoDuo
//
//  Created by trendpower on 15/11/9.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import "MeHeaderView.h"


#import <Masonry.h> //autoLayout

#import "TopImageButton.h"

@interface MeHeaderView()

/**
 *  背影图片
 */
@property (nonatomic, weak) UIImageView * bgView;
/**
 *  黑色半透明背影
 */
@property (nonatomic, weak) UIView * blackView;
/**
 *  登陆视图
 */
@property (nonatomic, weak) UIView * loginView;
/** 用户登陆按钮 */
@property (nonatomic, weak) MeHeaderButton * userBtn;
@property (nonatomic, weak) UILabel * logoutLbl;

/**
 *  用户视图
 */
@property (nonatomic, weak) UIView * logoutView;
@property (nonatomic, weak) UIButton * edintBtn;

/**
 *  导航视图
 */
@property (nonatomic, weak) UIButton * leftBtn;
@property (nonatomic, weak) UIButton * rightBtn;
@property (nonatomic, weak) UILabel * titileLbl;

/**
 *  底部固定视图
 */

@property (nonatomic, weak) UIView * line1;
@property (nonatomic, weak) UIView * line2;

/**
 *  底部灰色间隔视图
 */
@property (nonatomic, weak) UIView * bottomView;


@property (nonatomic, assign) CGFloat ImageHeight;

@end

@implementation MeHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.bgView = [self getImageViewForm:self];
    self.bgView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgView.image = [UIImage imageNamed:@"background"];
    
    // 1.登陆后的视图
    [self initLoginViews];
    
    // 2.未登陆的视图
    [self initLogoutViews];
    
    // 3.底部视图
    [self initBottomViews];
    
    [self initNavis];
    
    [self addViewConstraints];
}

- (void)initLogoutViews{
    self.logoutView = [self getView];
    
    self.logoutLbl = [self getLabelForm:self.logoutView];
    self.logoutLbl.textAlignment = NSTextAlignmentCenter;
    self.logoutLbl.text = @"您还没有登录哦！";
    self.logoutLbl.font = [UIFont boldSystemFontOfSize:14.5f];
    
    MeHeaderButton * btn = [[MeHeaderButton alloc]init];
    btn.tag = 100;//登陆
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_black"] forState:UIControlStateHighlighted];
    [btn setTitle:@"点击登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0.224 green:0.220 blue:0.224 alpha:1.000] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    btn.backgroundColor = [UIColor colorWithWhite:0.865 alpha:1.000];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [self.logoutView addSubview:btn];
    self.userBtn = btn;
    
}

- (void)initLoginViews{
    self.loginView = [self getView];
    self.loginView.hidden = YES;// 默认隐藏
    
    self.portraitView = [self getImageViewForm:self.loginView];
    self.portraitView.backgroundColor = [UIColor whiteColor];
    self.portraitView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.portraitView.layer.borderWidth = 2.0f;
    self.portraitView.layer.masksToBounds = YES;
    self.portraitView.image = [UIImage imageNamed:@"placeholderImage"];
    [self addTapGesture:self.portraitView];
    
    self.nameLbl = [self getLabelForm:self.loginView];
    [self addTapGesture:self.nameLbl];
    self.detailLbl = [self getLabelForm:self.loginView];
    self.detailLbl.font = [UIFont systemFontOfSize:13.0f];
    [self addTapGesture:self.detailLbl];

    
    self.edintBtn = [self getButton:@"账户管理 >" image:nil form:self.loginView];
    self.edintBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.edintBtn addTarget:self action:@selector(clickedEdit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initNavis{
    
    self.titileLbl = [self getLabelForm:self];
    self.titileLbl.textAlignment = NSTextAlignmentCenter;
    self.titileLbl.text = @"我的汽配猫";
    self.titileLbl.font = [UIFont systemFontOfSize:17.5f];
    
    self.leftBtn = [self getButton:nil image:[UIImage imageNamed:@"navi_set_icon"] form:self];
    self.leftBtn.tag = 1;
    [self.leftBtn addTarget:self action:@selector(clickedNaviBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = [self getButton:nil image:[UIImage imageNamed:@"navi_message_normal"] form:self];
    self.rightBtn.tag = 2;
    [self.rightBtn addTarget:self action:@selector(clickedNaviBarBtn:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)addTapGesture:(UIView*)target{
    target.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedEdit)];
    [target addGestureRecognizer:tap];
}


- (void)initBottomViews{
    
    UIView * blackView = [[UIView alloc]init];
    blackView.backgroundColor = [UIColor whiteColor];
    blackView.layer.borderColor = [UIColor colorWithRed:0.816 green:0.808 blue:0.824 alpha:1.000].CGColor;
    blackView.layer.borderWidth = 0.60f;
    [self addSubview:blackView];
    self.blackView = blackView;
    
    self.button0 = [self getButton:@"我的收藏" tag:0];
    self.button1 = [self getButton:@"优惠券" tag:1];
    self.button2 = [self getButton:@"我的信用" tag:2];
    
    self.line1 = [self getLineView];
    self.line2 = [self getLineView];
    
    UIView * bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = K_LINEBG_COLOR;
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
}

#pragma mark - getView
- (UIView *) getView{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    return view;
}


- (UIImageView *) getImageViewForm:(id)target{
    UIImageView * imageView = [[UIImageView alloc]init];
    [target addSubview:imageView];
    return imageView;
}

- (UILabel *) getLabelForm:(id)target{
    UILabel *label = [[UILabel alloc]init];
    label.font =  [UIFont boldSystemFontOfSize:18.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    [target addSubview:label];
    return label;
}

- (UIView*) getLineView{
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.903 alpha:1.000];
    [self.blackView addSubview:line];
    return line;
}

- (MeHeaderButton *) getButton:(NSString *)title tag:(NSInteger)tag{
    MeHeaderButton * btn = [[MeHeaderButton alloc]init];
    btn.tag = tag;
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_black"] forState:UIControlStateHighlighted];
    btn.topText = @"0";
    btn.bottomText = title;
    btn.topLabel.textColor = K_MAIN_COLOR;
    btn.topLabel.font = [UIFont systemFontOfSize:18.0f];
    btn.bottomLabel.textColor = [UIColor colorWithWhite:0.500 alpha:1.000];
    btn.bottomLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn addTarget:self action:@selector(clickedLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.blackView addSubview:btn];
    
    return btn;
}

- (UIButton *) getButton:(NSString *)title image:(UIImage *)image form:(id)target{
    UIButton * btn = [[UIButton alloc]init];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [target addSubview:btn];
    return btn;
}

#pragma mark - constraints
- (void) addViewConstraints{
    
    CGFloat space = 10;
    
    // 导航视图
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(space*2);
        make.left.mas_equalTo(self.mas_left).offset(space);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
    
    [self.titileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(space*2);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@50);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(space*2);
        make.right.mas_equalTo(self.mas_right).offset(-space);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
    
    
    // 背景视图
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.blackView.mas_top).offset(0);
    }];
    
    // 未登陆视图约束
    [self.logoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.blackView.mas_top).offset(0);
    }];
    
    [self.logoutLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.logoutView.mas_centerX);
        make.bottom.mas_equalTo(self.userBtn.mas_top).offset(-5);
        make.width.mas_equalTo(@180);
        make.height.mas_equalTo(@30);
    }];
    
    [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.logoutView.mas_centerX);
        make.bottom.mas_equalTo(self.logoutView.mas_bottom).offset(-30);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@30);
    }];
    
    
    // 登陆视图约束
    CGFloat portrait_WH = 65;
    self.portraitView.layer.cornerRadius = portrait_WH/2;
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.blackView.mas_top).offset(0);
    }];
    
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.loginView.mas_centerY).offset(15);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.width.mas_equalTo(portrait_WH);
        make.height.mas_equalTo(portrait_WH);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.portraitView.mas_top).offset(10);
        make.left.mas_equalTo(self.portraitView.mas_right).offset(space);
        make.right.mas_equalTo(self.mas_right).offset(-space);
        make.height.mas_equalTo(@20);
    }];
    
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLbl.mas_bottom).offset(space);
        make.left.mas_equalTo(self.portraitView.mas_right).offset(space);
        make.right.mas_equalTo(self.mas_right).offset(-space);
        make.height.mas_equalTo(@15);
    }];
    
    [self.edintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.portraitView.mas_bottom);
        make.right.mas_equalTo(self.loginView.mas_right).offset(-space);
        make.width.mas_equalTo(@150);
        make.bottom.mas_equalTo(self.loginView.mas_bottom);
    }];
    
    
    
    /**
     *  底部视图约束
     */
    CGFloat lineWidth = 0.8;
    CGFloat bottomH = 64;
    CGFloat bottomW = self.frame.size.width/3;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomH);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [self.button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.blackView.mas_left).offset(-1);
        make.height.mas_equalTo(@(bottomH));
        make.width.mas_equalTo(@(bottomW));
        make.bottom.mas_equalTo(self.blackView.mas_bottom);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.button0.mas_right).offset(0);
        make.bottom.mas_equalTo(self.blackView.mas_bottom).offset(-10);
        make.height.mas_equalTo(self.blackView.mas_height).offset(-20);
        make.width.mas_equalTo(lineWidth);
    }];
    
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line1.mas_right).offset(0);
        make.bottom.mas_equalTo(self.blackView.mas_bottom);
        make.height.mas_equalTo(@(bottomH));
        make.width.mas_equalTo(@(bottomW));
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.button1.mas_right).offset(0);
        make.bottom.mas_equalTo(self.blackView.mas_bottom).offset(-10);
        make.height.mas_equalTo(self.blackView.mas_height).offset(-20);
        make.width.mas_equalTo(lineWidth);
    }];
    
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line2.mas_right).offset(+1);
        make.bottom.mas_equalTo(self.blackView.mas_bottom);
        make.height.mas_equalTo(@(bottomH));
        make.width.mas_equalTo(@(bottomW));
    }];
}

#pragma - mark setHidden
- (void)setIsLogin:(BOOL)isLogin{
    _isLogin = isLogin;
    
    if (isLogin) {
        self.logoutView.hidden = YES;
        self.loginView.hidden = NO;
    }else{
        self.logoutView.hidden = NO;
        self.loginView.hidden = YES;
        self.button0.topText = @"0";
        self.button1.topText = @"0";
        self.button2.topText = @"0";
    }
}

- (void)setBGImageOffset:(CGFloat)offset{
    CGFloat ImageWidth = self.frame.size.width;
    self.ImageHeight = self.ImageHeight ? self.ImageHeight : CGRectGetHeight(self.bgView.frame);
    CGFloat ImageHeight = self.ImageHeight;

    if (offset < 0) {
        float multiple = 2.0 * offset;
        CGFloat factor = ((ABS(multiple)+ImageHeight)*ImageWidth)/ImageHeight;
        CGRect f = CGRectMake(-(factor-ImageWidth)/2, multiple, factor, ImageHeight+ABS(multiple));
        self.bgView.frame = f;
    } else {
        
    }
}

#pragma - mark 代理
- (void)clickedLoginBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(meHeaderViewClickedLoginButton:)]){
        [self.delegate meHeaderViewClickedLoginButton:btn];
    }
}

- (void)clickedEdit{
    if([self.delegate respondsToSelector:@selector(meHeaderViewclickedEdit)]){
        [self.delegate meHeaderViewclickedEdit];
    }
}

- (void)clickedNaviBarBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(meHeaderViewClickedNaviBarButton:)]){
        [self.delegate meHeaderViewClickedNaviBarButton:btn];
    }
}

@end
