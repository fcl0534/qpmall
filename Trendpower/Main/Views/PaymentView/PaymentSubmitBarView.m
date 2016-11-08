//
//  PaymentSubmitBarView.m
//  ZZBMall
//
//  Created by HTC on 15/8/13.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "PaymentSubmitBarView.h"

@interface PaymentSubmitBarView()

@property (nonatomic, weak) LineView * topLine;
@property (nonatomic, weak) UILabel * nameLbl;
@property (nonatomic, weak) UILabel * shipLbl;
@property (nonatomic, weak) UIButton * submitBtn;


@end


@implementation PaymentSubmitBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.960];
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.25;
    
    self.topLine = [self getLineView];
    
    self.nameLbl = [self getLabel];
    self.nameLbl.text = @"合计:";
    
    self.priceLbl = [self getLabel];
    
    self.shipLbl = [self getLabel];
    self.shipLbl.text = @"(含运费)";
    self.shipLbl.font = [UIFont systemFontOfSize:10.5f];

    self.priceLbl = [self getLabel];
    self.priceLbl.font = [UIFont systemFontOfSize:23.5f];
    self.priceLbl.textColor = [UIColor colorWithRed:0.827 green:0.125 blue:0.079 alpha:1.000];
    //自动缩放字体
    self.priceLbl.adjustsFontSizeToFitWidth = YES;
    self.priceLbl.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
    
    UIButton * payBtn = [[UIButton alloc]init];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"btn_square_bg"] forState:UIControlStateNormal];
    [payBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.5f]];
    [payBtn addTarget:self action:@selector(clickedSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payBtn];
    self.submitBtn = payBtn;
    
    [self addViewConstraints];
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont boldSystemFontOfSize:14.5f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor =[UIColor colorWithRed:0.259f green:0.259f blue:0.259f alpha:1.00f];
    [self addSubview:label];
    return label;
}


- (void) addViewConstraints{
    
    float W = self.frame.size.width;
    float Wb = W*1/3;
    
    // 1.
    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(@0.7);
    }];
    
    [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLine.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(@(Wb));
    }];
    
    // 2.
    [self.nameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(@40);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.priceLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLine.mas_bottom).offset(0);
        make.left.mas_equalTo(self.nameLbl.mas_right).offset(5);
        make.right.mas_equalTo(self.submitBtn.mas_left).offset(-5);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.shipLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.right.mas_equalTo(self.submitBtn.mas_left).offset(-5);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}


- (void)clickedSubmitBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(paymentSubmitBarViewClickedSumbitBtn:)]){
        [self.delegate paymentSubmitBarViewClickedSumbitBtn:btn];
    }
}


@end
