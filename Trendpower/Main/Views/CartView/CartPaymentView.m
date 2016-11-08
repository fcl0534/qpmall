//
//  CartPaymentView.m
//  ZZBMall
//
//  Created by trendpower on 15/8/11.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "CartPaymentView.h"



@interface CartPaymentView()

@property (nonatomic, weak) UIView * priceView;


@property (nonatomic, weak) UILabel *priceLabel;

@end



@implementation CartPaymentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.4;
        
        // 1.
        UIView * priceView = [[UIView alloc]init];
        priceView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.960];
        [self addSubview:priceView];
        self.priceView = priceView;
        
        // 2.
        UIButton * selectBtn = [[UIButton alloc]init];
        selectBtn.imageEdgeInsets = UIEdgeInsetsMake(16, 0, 16, 0);
        selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        selectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [selectBtn setImage:[UIImage imageNamed:@"agree_protocol_no"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"agree_protocol_yes"] forState:UIControlStateSelected];
        [selectBtn setTitle:@"全选" forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [selectBtn addTarget:self action:@selector(clickedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectBtn];
        self.selectBtn = selectBtn;
        
        // 3.
        self.priceLabel = [self getLabel];
        //自动缩放字体
        self.priceLabel.adjustsFontSizeToFitWidth = YES;
        self.priceLabel.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
        
        // 4.
        UIButton * payBtn = [[UIButton alloc]init];
        [payBtn setBackgroundImage:[UIImage imageNamed:@"btn_square_bg"] forState:UIControlStateNormal];
        [payBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.5f]];
        [payBtn addTarget:self action:@selector(clickedSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:payBtn];
        self.payBtn = payBtn;
        
        [self addViewConstraints];
        
    }
    
    return self;
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont boldSystemFontOfSize:16.5f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    return label;
}


- (void)setPrice:(NSString *)price{
    _price = price;
    
    [self setLbl:self.priceLabel text:[NSString stringWithFormat:@"合计:￥%0.2f",[price floatValue]] boldString:[NSString stringWithFormat:@"￥%0.2f",[price floatValue]]];
}

- (void) setLbl:(UILabel *)lbl text:(NSString *)titleText boldString:(NSString *)boldText{
    
    if (!titleText.length) {
        return;
    }
    if (!boldText.length) {
        lbl.text = titleText;
        return;
    }
    
    //重点字
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleText attributes:attributes];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.5] range:[attributedString.string rangeOfString:boldText]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:K_MAIN_COLOR range:[attributedString.string rangeOfString:boldText]];
    lbl.attributedText = attributedString;
}

- (void) addViewConstraints{
    
    float W = self.frame.size.width;
    float Wp = W*2/3;
    
    // 1.
    [self.priceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(@(Wp));
        make.height.mas_equalTo(self.mas_height);
    }];
    
    [self.payBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceView.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    // 2.
    [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(@70);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY).offset(0);
        make.right.mas_equalTo(self.payBtn.mas_left).offset(-5);
        make.height.mas_equalTo(self.mas_height);
    }];
}


#pragma mark - 代理
- (void)clickedSelectBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(cartPaymentViewClickedSelectBtn:)]){
        [self.delegate cartPaymentViewClickedSelectBtn:btn];
    }
}

- (void)clickedSubmitBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(cartPaymentViewClickedSumbitBtn:)]){
        [self.delegate cartPaymentViewClickedSumbitBtn:btn];
    }
}


@end
