//
//  MemberHeaderView.m
//  Trendpower
//
//  Created by trendpower on 15/5/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "MemberHeaderView.h"
#import <Masonry.h>

@interface MemberHeaderView()

// 背影图片
@property (nonatomic, weak) UIImageView * backImageView;
@property (nonatomic, weak) UILabel * editLabel;

//灰色间隔
@property (nonatomic, weak) UIView * spacingView;


@property (nonatomic, weak) UIButton * allOrderBgBtn;
@property (nonatomic, weak) UIButton * allOrderLeftBtn;
@property (nonatomic, weak) UILabel * allOrderRightLabel;
@property (nonatomic, weak) UIImageView * allOrderArrowView;

@property (nonatomic, weak) UIView * midLineView;

/**
 待付款 、 待发货 、 已发货 、 已完成
 */

@property (nonatomic, weak) UIButton * obligationBtn;
@property (nonatomic, weak) UIButton * dispatchBtn;
@property (nonatomic, weak) UIButton * deliveredBtn;
@property (nonatomic, weak) UIButton * completedBtn;

@property (nonatomic, weak) UIImageView * obligationImage;
@property (nonatomic, weak) UIImageView * dispatchImage;
@property (nonatomic, weak) UIImageView * deliveredImage;
@property (nonatomic, weak) UIImageView * completedImage;

@property (nonatomic, weak) UILabel * obligationLable;
@property (nonatomic, weak) UILabel * dispatchLable;
@property (nonatomic, weak) UILabel * deliveredLable;
@property (nonatomic, weak) UILabel * completedLable;

@property (nonatomic, weak) UIView * bottomLineView;

@property (nonatomic, weak) UIView * bottomView;

@end


@implementation MemberHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 1.
        UIImageView * backgroundView = [[UIImageView alloc]init];
        backgroundView.image = [UIImage imageNamed:@"manager_bg"];
        [self addSubview:backgroundView];
        self.backImageView = backgroundView;
        backgroundView.userInteractionEnabled = YES;
        //添加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedBackgroundView:)];
        [backgroundView addGestureRecognizer:tap];
        
        // 2.
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"user_image"];
        imageView.layer.cornerRadius = 40;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1;
        [self addSubview:imageView];
        self.userIamgeView = imageView;
        imageView.userInteractionEnabled = YES;
        //添加手势
        UITapGestureRecognizer * headerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedUserIamgeView:)];
        [imageView addGestureRecognizer:headerTap];
        
        
        // 3.
        UILabel * nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:20.0];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.userInteractionEnabled = NO;
        [self addSubview:nameLabel];
        self.userNameLbel = nameLabel;
        
        UILabel * coinLabel = [[UILabel alloc]init];
        coinLabel.textColor = [UIColor whiteColor];
        coinLabel.font = [UIFont systemFontOfSize:16.0];
        coinLabel.textAlignment = NSTextAlignmentLeft;
        coinLabel.userInteractionEnabled = NO;
        [self addSubview:coinLabel];
        self.coinTotalLbel = coinLabel;
        
        // 4.
        UILabel * editLabel = [[UILabel alloc]init];
        editLabel.text = @"账号管理 >";
        editLabel.textColor = [UIColor whiteColor];
        editLabel.font = [UIFont systemFontOfSize:14.0];
        editLabel.textAlignment = NSTextAlignmentRight;
        editLabel.userInteractionEnabled = NO;
        [self addSubview:editLabel];
        self.editLabel = editLabel;
        
        // 5.
        self.spacingView = [self getLineView];
        self.spacingView.backgroundColor =  [UIColor colorWithRed:0.937f green:0.937f blue:0.957f alpha:1.00f];
        self.spacingView.layer.borderColor = [UIColor colorWithWhite:0.902 alpha:1.000].CGColor;
        self.spacingView.layer.borderWidth = 0.5;
        
        // 6.
        // 6.1
        self.allOrderLeftBtn = [self getButton:@" 我的订单" image:[UIImage imageNamed:@"member_orders"]];
        self.allOrderLeftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 0);
        
        
        self.allOrderRightLabel = [self getLabel];
        self.allOrderRightLabel.backgroundColor = [UIColor whiteColor];
        self.allOrderRightLabel.text = @"查看全部订单        .";
        self.allOrderRightLabel.textAlignment = NSTextAlignmentRight;
        
        UIImageView *allOrderArrowView = [[UIImageView alloc]init];
        allOrderArrowView.image = [UIImage imageNamed:@"addressView_arrow"];
        [self addSubview:allOrderArrowView];
        self.allOrderArrowView = allOrderArrowView;
        
        
        self.allOrderBgBtn = [self getButton:@"" image:[UIImage imageNamed:nil]];
        self.allOrderBgBtn.backgroundColor = [UIColor clearColor];
        self.allOrderBgBtn.tag = 0;
        [self.allOrderBgBtn addTarget:self action:@selector(clickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.midLineView = [self getLineView];
        
        // 7.
        // 7.1
        self.obligationBtn = [self getButton:nil image:nil];
        [self.obligationBtn addTarget:self action:@selector(clickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.obligationBtn.tag = 1;
        
        
        self.dispatchBtn = [self getButton:nil image:nil];
        [self.dispatchBtn addTarget:self action:@selector(clickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.dispatchBtn.tag = 2;
        
        self.deliveredBtn = [self getButton:nil image:nil];
        [self.deliveredBtn addTarget:self action:@selector(clickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.deliveredBtn.tag = 3;
        
        self.completedBtn = [self getButton:nil image:nil];
        [self.completedBtn addTarget:self action:@selector(clickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.completedBtn.tag = 4;
        
        // 7.2
        //空为全部 11 等待买家付款 20买家已付款，等待卖家发货  30卖家已发货   40交易成功   0交易已取消
        self.obligationLable = [self getLabel];
        self.obligationLable.text = @"待付款";
        
        self.dispatchLable = [self getLabel];
        self.dispatchLable.text = @"待发货";
        
        self.deliveredLable = [self getLabel];
        self.deliveredLable.text = @"待收货";
        
        self.completedLable = [self getLabel];
        self.completedLable.text = @"已完成";
        
        // 7.3
        
        self.obligationImage = [self getImageView:[UIImage imageNamed:@"order_wait_for_payment"]];
        
        self.dispatchImage = [self getImageView:[UIImage imageNamed:@"order_wait_sign_in"]];
        
        self.deliveredImage = [self getImageView:[UIImage imageNamed:@"order_receiver_goods"]];
        
        self.completedImage = [self getImageView:[UIImage imageNamed:@"order_finish"]];
        
        // 8.
        self.bottomLineView = [self getLineView];
        self.bottomView = [self getLineView];
        self.bottomView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        
        [self addViewConstraints];
        
    }
    return self;
}


- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:0.391 alpha:1.000];
    [self addSubview:label];
    return label;
}

- (UIImageView *)getImageView:(UIImage *)image{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = image;
    [self addSubview:imageView];
    return imageView;
}


- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.882 alpha:1.000];
    [self addSubview:line];
    return line;
}

- (UIButton *) getButton:(NSString *)title image:(UIImage *)image{
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor whiteColor];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [btn setTitleColor:[UIColor colorWithWhite:0.469 alpha:1.000] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [self addSubview:btn];
    return btn;
}


- (void)setUserModel:(UserInfoModel *)userModel{
    
    _userModel = userModel;
//    self.userNameLbel.text = userModel.userName;
//    NSString * titleText = [NSString stringWithFormat:@"积分:%@",userModel.coinTotal];
//    //重点字
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleText attributes:attributes];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.457 blue:0.128 alpha:1.000] range:[attributedString.string rangeOfString:userModel.coinTotal]];
//    self.coinTotalLbel.attributedText = attributedString;
}



#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 10;
    NSNumber * backImageHeight = @120;
    NSNumber * userIamgeWH = @80;
    
    // 1.
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(backImageHeight);
    }];
    
    [self.userIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.centerY.mas_equalTo(self.backImageView.mas_centerY);
        make.width.mas_equalTo(userIamgeWH);
        make.height.mas_equalTo(userIamgeWH);
    }];
    
    [self.userNameLbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userIamgeView.mas_right).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.userIamgeView.mas_top).offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    [self.coinTotalLbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userIamgeView.mas_right).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.userNameLbel.mas_bottom).offset(5);
        make.height.mas_equalTo(@30);
    }];
    
    [self.editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userIamgeView.mas_right).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.bottom.mas_equalTo(self.userIamgeView.mas_bottom).offset(0);
        make.height.mas_equalTo(@20);
    }];
    
    [self.spacingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.backImageView.mas_bottom).offset(0);
        make.height.mas_equalTo(@20);
    }];
    
    // 2.订单
    [self.allOrderLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(@150);
        make.top.mas_equalTo(self.spacingView.mas_bottom).offset(0);
        make.height.mas_equalTo(@44);
    }];
    
    [self.allOrderArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.centerY.mas_equalTo(self.allOrderLeftBtn.mas_centerY).offset(0);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo(@10);
    }];
    
    [self.allOrderRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(10);
        make.top.mas_equalTo(self.spacingView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.allOrderLeftBtn.mas_right).offset(0);
        make.height.mas_equalTo(@44);
    }];
    
    [self.allOrderBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(self.mas_width);
        make.top.mas_equalTo(self.spacingView.mas_bottom).offset(0);
        make.height.mas_equalTo(@44);
    }];
    
    [self.midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.allOrderBgBtn.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    NSNumber * imageWH = @(22);
    NSNumber * btnW = @(self.frame.size.width/4);
    NSNumber * btnH = @(70);
    // 3.1
    [self.obligationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.midLineView.mas_bottom).offset(10);
        make.height.mas_equalTo(imageWH);
        make.width.mas_equalTo(imageWH);
        make.centerX.mas_equalTo(self.obligationLable.mas_centerX);
    }];
    
    [self.dispatchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.midLineView.mas_bottom).offset(10);
        make.height.mas_equalTo(imageWH);
        make.width.mas_equalTo(imageWH);
        make.centerX.mas_equalTo(self.dispatchLable.mas_centerX);
    }];
    
    [self.deliveredImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.midLineView.mas_bottom).offset(10);
        make.height.mas_equalTo(imageWH);
        make.width.mas_equalTo(imageWH);
        make.centerX.mas_equalTo(self.deliveredLable.mas_centerX);
    }];
    
    [self.completedImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.midLineView.mas_bottom).offset(10);
        make.height.mas_equalTo(imageWH);
        make.width.mas_equalTo(imageWH);
        make.centerX.mas_equalTo(self.completedLable.mas_centerX);
    }];
    
    // 3.2
    [self.obligationLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.obligationImage.mas_bottom).offset(5);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(btnW);
    }];
    
    [self.dispatchLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.obligationLable.mas_right).offset(0);
        make.top.mas_equalTo(self.obligationImage.mas_bottom).offset(5);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(btnW);
    }];
    
    [self.deliveredLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dispatchLable.mas_right).offset(0);
        make.top.mas_equalTo(self.obligationImage.mas_bottom).offset(5);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(btnW);
    }];
    
    [self.completedLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deliveredLable.mas_right).offset(0);
        make.top.mas_equalTo(self.obligationImage.mas_bottom).offset(5);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(btnW);
    }];
    
    // 3.3
    [self.obligationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.midLineView.mas_bottom).offset(0);
        make.height.mas_equalTo(btnH);
        make.width.mas_equalTo(btnW);
    }];
    
    [self.dispatchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.obligationBtn.mas_right).offset(0);
        make.top.mas_equalTo(self.midLineView.mas_bottom).offset(0);
        make.height.mas_equalTo(btnH);
        make.width.mas_equalTo(btnW);
    }];
    
    [self.deliveredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dispatchBtn.mas_right).offset(0);
        make.top.mas_equalTo(self.midLineView.mas_bottom).offset(0);
        make.height.mas_equalTo(btnH);
        make.width.mas_equalTo(btnW);
    }];
    
    [self.completedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deliveredBtn.mas_right).offset(0);
        make.top.mas_equalTo(self.midLineView.mas_bottom).offset(0);
        make.height.mas_equalTo(btnH);
        make.width.mas_equalTo(btnW);
    }];
    
    
    // 4.
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.obligationBtn.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.bottomLineView.mas_bottom).offset(0);
        make.height.mas_equalTo(@20);
    }];
}

#pragma mark - 点击背景
- (void)clickedBackgroundView:(UIGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(MemberHeaderViewClickedBackgroundView)]) {
        [self.delegate MemberHeaderViewClickedBackgroundView];
    }
}

#pragma mark - 点击头像
- (void)clickedUserIamgeView:(UIGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(MemberHeaderViewClickedUserIamgeView)]) {
        [self.delegate MemberHeaderViewClickedUserIamgeView];
    }
}

#pragma mark - 点击订单
- (void)clickedOrderBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(MemberHeaderViewClickedOrderBtn:)]) {
        [self.delegate MemberHeaderViewClickedOrderBtn:btn];
    }
}


@end
