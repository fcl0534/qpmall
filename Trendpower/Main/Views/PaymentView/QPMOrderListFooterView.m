//
//  PaymentFooterView.m
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "QPMOrderListFooterView.h"

#import "PaymentShopsModel.h"
#import "QPMGoodsGroupedModel.h"

@interface QPMOrderListFooterView()

@property (nonatomic, weak) UILabel * shipTextLbl;
@property (nonatomic, weak) UILabel * nameLbl;
@property (nonatomic, weak) UILabel * priceLbl;
@property (nonatomic, weak) LineView * minLine;
@property (nonatomic, weak) UIView * bottomView;

@property (nonatomic, weak) UIButton * leftBtn;
@property (nonatomic, weak) UIButton * rightBtn;

/** 促销信息button */
@property (nonatomic, strong) UIButton *promotionButton;
/** 小计 */
@property (nonatomic, strong) UILabel *subtotalLabel;
/** 省多少钱显示 */
@property (nonatomic, strong) UILabel *privilegeLabel;

@end


@implementation QPMOrderListFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor whiteColor];

    self.shipTextLbl = [self getLabel];
    self.shipTextLbl.text = @"配送类别：";
    
    self.leftBtn = [self getBtnTitile:@"普通(包配送)" seleteImage:[UIImage imageNamed:@"butn_check_select"] normalImage:[UIImage imageNamed:@"butn_check_unselect"]];
    self.leftBtn.tag = 0;
    
    self.rightBtn = [self getBtnTitile:@"加急(包配送)" seleteImage:[UIImage imageNamed:@"butn_check_select"] normalImage:[UIImage imageNamed:@"butn_check_unselect"]];
    self.rightBtn.tag = 1;
    
    //促销显示 button
    self.promotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.promotionButton];
    [self.promotionButton setTitle:@"促销" forState:UIControlStateNormal];
    [self.promotionButton setFont:[UIFont systemFontOfSize:15]];
    self.promotionButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.promotionButton.layer.borderWidth = 0.5;
    [self.promotionButton setBackgroundColor:[UIColor colorWithRed:15/255.0 green:127/255.0 blue:18/255.0 alpha:1.0]];
    [self.promotionButton addTarget:self action:@selector(promotionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.privilegeLabel = [[UILabel alloc] init];
    [self addSubview:self.privilegeLabel];
    self.privilegeLabel.font = [UIFont systemFontOfSize:13.0];
    self.privilegeLabel.textColor = [UIColor lightGrayColor];
    
    self.subtotalLabel = [[UILabel alloc] init];
    [self addSubview:self.self.subtotalLabel];
    self.subtotalLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.subtotalLabel.textColor = [UIColor blackColor];
    
    self.minLine = [self getLineView];
    self.minLine.backgroundColor = [UIColor colorWithWhite:0.708 alpha:1.000];
    
    UIView * bottom = [[UIView alloc]init];
    bottom.backgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.000];
    [self addSubview:bottom];
    self.bottomView = bottom;
    [self addViewConstraints];
    
}

- (void)promotionButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(promotionButtonClickWithGoodsGroupedModel:)]) {
        [self.delegate promotionButtonClickWithGoodsGroupedModel:self.goodsGroupedModel];
    }
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.5f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor =[UIColor colorWithRed:0.259f green:0.259f blue:0.259f alpha:1.00f];
    [self addSubview:label];
    return label;
}


- (UIButton *) getBtnTitile:(NSString *)title seleteImage:(UIImage *)seleteImage normalImage:(UIImage *)normalImage {
    UIButton *btn = [[UIButton alloc]init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [btn setTitleColor:[UIColor colorWithWhite:0.469 alpha:1.000] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:seleteImage forState:UIControlStateSelected];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 0, 12, 0)];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btn addTarget:self action:@selector(clickedShopBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.titleLabel.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addSubview:btn];
    return btn;
}

- (void)setShopModel:(PaymentShopsModel *)shopModel{
    _shopModel = shopModel;
    
    if(!shopModel.isDistributionTypeOne){
        self.leftBtn.selected = YES;
        self.rightBtn.selected = NO;
    }else{
        self.leftBtn.selected = NO;
        self.rightBtn.selected = YES;
    }
    
    [self.shopModel.expressArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj objectForKey:@"distributionType"] integerValue] == 0 ) {
            if ([[obj objectForKey:@"isFree"] integerValue] == 1 ) {
                [self.leftBtn setTitle:@"普通(包配送)" forState:UIControlStateNormal];
            }else{
                [self.leftBtn setTitle:[NSString stringWithFormat:@"普通(￥%@)",[obj objectForKey:@"price"]] forState:UIControlStateNormal];
            }
            
        }else if([[obj objectForKey:@"distributionType"] integerValue] == 1 ) {
            if ([[obj objectForKey:@"isFree"] integerValue] == 1 ) {
                [self.rightBtn setTitle:@"加急(包配送)" forState:UIControlStateNormal];
            }else{
                [self.rightBtn setTitle:[NSString stringWithFormat:@"加急(￥%@)",[obj objectForKey:@"price"]] forState:UIControlStateNormal];
            }
        }
    }];
    
    if (self.goodsGroupedModel.isActivity == 1) {
        self.privilegeLabel.hidden = NO;
        self.promotionButton.hidden = NO;
        self.subtotalLabel.text = [NSString stringWithFormat:@"小计：￥%.2f", self.goodsGroupedModel.total_pay_price];
        self.privilegeLabel.text = [NSString stringWithFormat:@"省￥%.2f", self.goodsGroupedModel.privilegeAmount];
        
    } else {
        self.promotionButton.hidden = YES;
        self.privilegeLabel.hidden = YES;
    }
}


- (void) addViewConstraints{
    
    [self.shipTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(@75);
        make.height.mas_equalTo(@40);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.shipTextLbl.mas_right).offset(5);
        make.width.mas_equalTo(@110);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.leftBtn.mas_right).offset(5);
        make.width.mas_equalTo(@130);
        make.height.mas_equalTo(40);
    }];
    
    UIView *lineMiddle = [self getLineView];
    lineMiddle.backgroundColor = [UIColor colorWithWhite:0.708 alpha:1.000];
    [lineMiddle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shipTextLbl.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(0.7);
    }];
    
    [self.promotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineMiddle.mas_bottom).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [self.privilegeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineMiddle.mas_bottom).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        
    }];
    
    [self.subtotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.privilegeLabel);
        make.right.mas_equalTo(self.privilegeLabel.mas_left).offset(-5);
    }];
    
    [self.minLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.promotionButton.mas_bottom).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@0.7);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.minLine.mas_bottom);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
}

- (void)clickedShopBtn:(UIButton *)btn {
    
    if (!btn.isSelected) {
        btn.selected = YES;
        if (btn.tag == 0) {
            self.rightBtn.selected = NO;
            self.shopModel.isDistributionTypeOne = NO;
            
        }else if(btn.tag ==1){
            self.leftBtn.selected = NO;
            self.shopModel.isDistributionTypeOne = YES;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(paymentFooterViewDidSelectExpress:inSection:)]) {
            [self.delegate paymentFooterViewDidSelectExpress:self.shopModel inSection:self.section];
        }
    }
    
}

@end
