//
//  PaymentSubmitView.m
//  Trendpower
//
//  Created by trendpower on 15/5/25.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "PaymentSubmitView.h"
#import <masonry.h>

@interface PaymentSubmitView()


@end

@implementation PaymentSubmitView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 1.
        self.orderPriceLabel = [self getLabel];
        self.orderPriceLabel.font = [UIFont systemFontOfSize:23.0];
        self.orderPriceLabel.textColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
        self.orderNameLabel = [self getLabel];
        self.orderNameLabel.text = @"支付金额:";
        
        // 2.
        self.orderIdLabel = [self getLabel];
        
        // 3.
        self.line = [self getLineView];
        
        // 4.
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"alipay_logo"];
        [self addSubview:imageView];
        self.imagesView = imageView;
        
        // 5.
        UIButton * submitBtn = [[UIButton alloc]init];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_square_bg"] forState:UIControlStateNormal];
        [submitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [submitBtn addTarget:self action:@selector(paymentSubmitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn.layer setCornerRadius:5.0];
        [submitBtn.layer setMasksToBounds:YES];
        
        [self addSubview:submitBtn];
        self.submitBtn = submitBtn;
        
        [self addViewConstraints];
    }
    
    return self;
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    [self addSubview:label];
    return label;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    [self addSubview:line];
    return line;
}


#pragma mark - 添加约束 【每次重新更新】
-(void) addViewConstraints{
    
    float top = 20;
    float spacing = 10;
    
    // 1.
    [self.orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(top);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@20);
    }];
    
    
    [self.orderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.orderIdLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(@65);
        make.height.mas_equalTo(@45);
    }];
    
    // 2.
    [self.orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderNameLabel.mas_right).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(spacing);
        make.top.mas_equalTo(self.orderIdLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@45);
    }];
    
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.orderPriceLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    float imageWH = 120;
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.mas_bottom).offset(spacing *4);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(@(imageWH));
        make.height.mas_equalTo(@(imageWH));
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imagesView.mas_bottom).offset(100);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(@250);
        make.height.mas_equalTo(@40);
    }];
    
}

#pragma mark - 点击view
- (void)paymentSubmitBtnClicked:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(paymentSubmitViewBtnClicked:)])
    {
        [self.delegate paymentSubmitViewBtnClicked:btn];
    }
}




@end
