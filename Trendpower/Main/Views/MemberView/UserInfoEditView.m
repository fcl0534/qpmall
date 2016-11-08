//
//  UserInfoEditView.m
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "UserInfoEditView.h"


@interface UserInfoEditView()

@property (nonatomic, weak) UIView * line1;
@property (nonatomic, weak) UIView * line2;
@property (nonatomic, weak) UIView * line3;
@property (nonatomic, weak) UIView * line4;
@property (nonatomic, weak) UIView * line5;
@property (nonatomic, weak) UIView * line6;
@property (nonatomic, weak) UIView * line7;

// gender 性别（0保密 1男 2女）
@property (nonatomic, copy) NSString * genderType;

//性别
@property (nonatomic, weak) UIButton * manBtn;
@property (nonatomic, weak) UIButton * womanBtn;
@property (nonatomic, weak) UIButton * privaryBtn;

@property (nonatomic, weak) UIButton * phoneBtn;
@property (nonatomic, weak) UIButton * areaBtn;

@end


@implementation UserInfoEditView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        [self initBaseView];
    }
    
    return self;
}

- (void)initBaseView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 1.
    self.line1 = [self getLineView];
    self.line2 = [self getLineView];
    self.line3 = [self getLineView];
    self.line4 = [self getLineView];
    self.line5 = [self getLineView];
    self.line6 = [self getLineView];
    self.line7 = [self getLineView];
    
    // 2.
    self.imageLabel = [self getLabel:@"头像"];
    self.phoneLabel = [self getLabel:@"手机号码："];
    self.realNameLabel = [self getLabel:@"真实姓名："];
    self.companyNameLabel = [self getLabel:@"企业名称："];
    self.areaNameLabel = [self getLabel:@"所在城市："];
    self.emailLabel = [self getLabel:@"邮箱："];
    self.genderLabel = [self getLabel:@"性别"];
    
    // 3.
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"user_image"];
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    self.imageView = imageView;
    //添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedImageView:)];
    [imageView addGestureRecognizer:tap];
    
    // 4.
    self.phoneField = [self getTextField:@"手机号码"];
    self.phoneField.enabled = NO;
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.realNameField = [self getTextField:@"真实姓名"];
    self.companyNameField = [self getTextField:@"企业名称"];
    self.areaNameField = [self getTextField:@"名字"];
    self.areaNameField.enabled = NO;
    self.emailField = [self getTextField:@"邮箱"];
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    // 5. gender 性别（0保密 1男 2女）
    self.privaryBtn = [self getBtnTitile:@"保密" seleteImage:[UIImage imageNamed:@"flight_butn_check_select"] normalImage:[UIImage imageNamed:@"flight_butn_check_unselect"]];
    self.privaryBtn.tag = 0;
    self.manBtn = [self getBtnTitile:@"男" seleteImage:[UIImage imageNamed:@"flight_butn_check_select"] normalImage:[UIImage imageNamed:@"flight_butn_check_unselect"]];
    self.manBtn.tag = 1;
    self.womanBtn = [self getBtnTitile:@"女" seleteImage:[UIImage imageNamed:@"flight_butn_check_select"] normalImage:[UIImage imageNamed:@"flight_butn_check_unselect"]];
    self.womanBtn.tag = 2;
    
    self.genderLabel.hidden = YES;
    self.privaryBtn.hidden = YES;
    self.manBtn.hidden = YES;
    self.womanBtn.hidden = YES;
    self.line6.hidden = YES;

    // 6.
    UIButton * confirmButton = [[UIButton alloc]init];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"back_red"] forState:UIControlStateNormal];
    [confirmButton setTitle:@"保存" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(clickedConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    self.confirmButton = confirmButton;
    
    
    self.phoneBtn = [self getTapBtn:1];
    self.areaBtn = [self getTapBtn:2];
    
    
    [self addViewConstraints];
}

#pragma mark -  init view 方法
- (UILabel *) getLabel:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithWhite:0.315 alpha:1.000];
    label.tintColor = [UIColor colorWithRed:0.949 green:0.280 blue:0.226 alpha:1.000];
    [self addSubview:label];
    return label;
}

- (UITextField *) getTextField:(NSString *)placeholder{
    UITextField *field = [[UITextField alloc]init];
    field.placeholder = placeholder;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.font = [UIFont systemFontOfSize:16.0f];
    field.textAlignment = NSTextAlignmentRight;
    field.textColor = [UIColor colorWithWhite:0.141 alpha:1.000];
    field.tintColor = [UIColor colorWithRed:0.949 green:0.280 blue:0.226 alpha:1.000];
    [self addSubview:field];
    return field;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.882 alpha:1.000];
    [self addSubview:line];
    return line;
}

- (UIButton *) getBtnTitile:(NSString *)title seleteImage:(UIImage *)seleteImage normalImage:(UIImage *)normalImage {
    UIButton *btn = [[UIButton alloc]init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [btn setTitleColor:[UIColor colorWithWhite:0.469 alpha:1.000] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:seleteImage forState:UIControlStateSelected];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedGenderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (UIButton *) getTapBtn:(NSInteger)tag{
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = tag;
    [btn addTarget:self action:@selector(clickedTapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 10;
    float spacingR = 15;
    
    NSNumber * labelWidth = @85;
    NSNumber * labelHeight = @55;
    NSNumber * imageWH = @60;
    
    // 1.
    [self.imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(@80);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-spacingR);
        make.centerY.mas_equalTo(self.imageLabel.mas_centerY);
        make.width.mas_equalTo(imageWH);
        make.height.mas_equalTo(imageWH);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.imageLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    // 2.
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(0);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacingR);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    // 4.
    [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.line3.mas_bottom).offset(0);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.realNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.realNameLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.line3.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacingR);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.realNameLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    // 4.
    [self.companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.line4.mas_bottom).offset(0);
        make.width.mas_equalTo(@130);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.companyNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyNameLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.line4.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacingR);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.companyNameLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    // 5.
    [self.areaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(0);
        make.width.mas_equalTo(@130);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.areaNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.areaNameLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacingR);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.areaNameLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    // 6.
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.line7.mas_bottom).offset(0);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.emailLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.line7.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacingR);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.emailLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    // 4.
    [self.genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.line5.mas_bottom).offset(0);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(labelHeight);
    }];
    
    NSNumber * BntW = @55;
    NSNumber * BtnH = @35;
    
    //从右往左排 
    [self.womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-spacingR);
        make.centerY.mas_equalTo(self.genderLabel.mas_centerY);
        make.width.mas_equalTo(BntW);
        make.height.mas_equalTo(BtnH);
    }];
    
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.womanBtn.mas_left).offset(-spacingR);
        make.centerY.mas_equalTo(self.genderLabel.mas_centerY);
        make.width.mas_equalTo(BntW);
        make.height.mas_equalTo(BtnH);
    }];
    
    [self.privaryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.manBtn.mas_left).offset(-spacingR);
        make.centerY.mas_equalTo(self.genderLabel.mas_centerY);
        make.width.mas_equalTo(BntW);
        make.height.mas_equalTo(BtnH);
    }];
    
    [self.line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.genderLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    // 5.
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.height.mas_equalTo(@44);
    }];
    
    
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneField.mas_left).offset(0);
        make.right.mas_equalTo(self.phoneField.mas_right).offset(0);
        make.top.mas_equalTo(self.phoneField.mas_top).offset(0);
        make.bottom.mas_equalTo(self.phoneField.mas_bottom).offset(0);
    }];
    
    [self.areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.areaNameField.mas_left).offset(0);
        make.right.mas_equalTo(self.areaNameField.mas_right).offset(0);
        make.top.mas_equalTo(self.areaNameField.mas_top).offset(0);
        make.bottom.mas_equalTo(self.areaNameField.mas_bottom).offset(0);
    }];
    
}

#pragma mark - 赋值
- (void)setUserModel:(UserInfoModel *)userModel{
    _userModel = userModel;
    
    self.phoneField.text = userModel.userPhone;
    self.realNameField.text = userModel.userRealname;
    self.companyNameField.text = userModel.companyName;
    self.areaNameField.text = [NSString stringWithFormat:@"%@ %@ %@",userModel.provinceName, userModel.cityName, userModel.districtName];
    self.emailField.text = userModel.userEmail;
    
    [self setGenderBtnType:userModel.userGender];
}

#pragma mark - 切换性别
// gender 性别（0保密 1男 2女）
- (void) clickedGenderBtn:(UIButton *)btn{
    
    btn.selected = YES;
    
    switch (btn.tag) {
        case 0:
            self.genderType = @"0";
            self.manBtn.selected = NO;
            self.womanBtn.selected = NO;
            break;
        case 1:
            self.genderType = @"1";
            self.privaryBtn.selected = NO;
            self.womanBtn.selected = NO;
            break;
        case 2:
            self.genderType = @"2";
            self.manBtn.selected = NO;
            self.privaryBtn.selected = NO;
            break;
        default:
            break;
    }
}

#pragma mark - 判断性别类型
- (void) setGenderBtnType:(NSString *)type{
    
    self.genderType = type;
    
    switch ([type intValue]) {
        case 0:
            self.privaryBtn.selected = YES;
            break;
        case 1:
            self.manBtn.selected = YES;
            break;
        case 2:
             self.womanBtn.selected = YES;
            break;
        default:
            break;
    }
}


#pragma mark - 代理

- (void)clickedTapBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(userInfoEditViewClickedTapIndex:)]) {
        [self.delegate userInfoEditViewClickedTapIndex:btn.tag];
    }
    
}


- (void) clickedImageView:(UIGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(userInfoEditViewClickedIamgeView:)]) {
        [self.delegate userInfoEditViewClickedIamgeView:self.imageView];
    }
}

- (void) clickedConfirmButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(userInfoEditViewClickedButton:phoneField:realNameField:companyNameField:areaNameField:emailField:genderType:)]) {
        [self.delegate userInfoEditViewClickedButton:btn phoneField:self.phoneField realNameField:self.realNameField companyNameField:self.companyNameField areaNameField:self.areaNameField emailField:self.emailField genderType:self.genderType];
    }
}

@end