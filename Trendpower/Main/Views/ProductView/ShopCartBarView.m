//
//  ShopCartBarView.m
//  Trendpower
//
//  Created by HTC on 15/5/20.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "ShopCartBarView.h"
#import <Masonry.h>

@interface ShopCartBarView()

@property (nonatomic, weak) UIButton * shopcartBtn;

@property (nonatomic, weak) UIButton * paymentBtn;

@property (nonatomic, weak) UIView * topLine;

@end

@implementation ShopCartBarView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 0.
        self.topLine = [self getLineView];
        
        // 1.
        self.collectionBtn = [self getBtnTitile:nil seleteImage:[UIImage imageNamed:@"shopcart_collection_selected"] normalImage:[UIImage imageNamed:@"shopcart_collection_normol"]];
        [self.collectionBtn addTarget:self action:@selector(clickedCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        // 2.
        self.shopcartBtn = [self getBtnTitile:@"加入购物车" seleteImage:nil normalImage:nil];
        [self.shopcartBtn setBackgroundColor:[UIColor colorWithRed:1.000 green:0.633 blue:0.125 alpha:1.000]];
        [self.shopcartBtn addTarget:self action:@selector(clickedShopcartBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        // 3.
        self.paymentBtn = [self getBtnTitile:@"立即购买" seleteImage:nil normalImage:nil];
        [self.paymentBtn setBackgroundColor:[UIColor colorWithRed:0.949 green:0.310 blue:0.175 alpha:1.000]];
        [self.paymentBtn addTarget:self action:@selector(clickedPaymentBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addViewConstraints];
    }
    return self;
}

- (UIButton *) getBtnTitile:(NSString *)title seleteImage:(UIImage *)seleteImage normalImage:(UIImage *)normalImage {
    UIButton *btn = [[UIButton alloc]init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:seleteImage forState:UIControlStateSelected];
    [btn setImage:normalImage forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(clickedGenderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.792 alpha:1.000];
    [self addSubview:line];
    return line;
}


- (void)setIsNoStores:(BOOL)isNoStores{
    _isNoStores = isNoStores;
    
    if (isNoStores) {
        [self.shopcartBtn setBackgroundColor:[UIColor colorWithWhite:0.527 alpha:1.000]];
        [self.paymentBtn setBackgroundColor:[UIColor colorWithWhite:0.306 alpha:1.000]];
    } else {
        [self.shopcartBtn setBackgroundColor:[UIColor colorWithRed:1.000 green:0.633 blue:0.125 alpha:1.000]];
        [self.paymentBtn setBackgroundColor:[UIColor colorWithRed:0.949 green:0.310 blue:0.175 alpha:1.000]];
    }
}


#pragma mark - 添加约束
-(void) addViewConstraints{
    
    //float spacing = 10;
    
    NSNumber * collW = [NSNumber numberWithFloat:self.frame.size.height*2];
    // 1.
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    // 2.
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.topLine.mas_bottom).offset(0);
        make.width.mas_equalTo(collW);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    CGFloat screendW = [UIScreen mainScreen].bounds.size.width;
    CGFloat bntW = (screendW -[collW floatValue])/2;
    
    // 3.
    [self.shopcartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.collectionBtn.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(bntW);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    // 4.
    [self.paymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopcartBtn.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(self.mas_height);
    }];
}


#pragma mark - 代理
- (void)clickedCollectionBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(shopCartBarViewClickedCollectionBtn:)]){
        [self.delegate shopCartBarViewClickedCollectionBtn:btn];
    }
}

- (void)clickedShopcartBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(shopCartBarViewClickedShopCartBtn:)]){
        [self.delegate shopCartBarViewClickedShopCartBtn:btn];
    }
}


- (void)clickedPaymentBtn:(UIButton *)btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shopCartBarViewClickedPromptPaymentCartBtn:)]){
        [self.delegate shopCartBarViewClickedPromptPaymentCartBtn:btn];
    }
}

@end
