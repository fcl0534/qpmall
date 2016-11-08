//
//  ProductShopCarBarView.m
//  Trendpower
//
//  Created by HTC on 15/5/10.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "ProductShopCarBarView.h"

@implementation ProductShopCarBarView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        float BtnH = 40;
        float spacingH = (frame.size.height - BtnH)/2;
        float spacingBoth = 10;
        float spacingMiddle = 35;
        float BtnW = (frame.size.width - spacingBoth*2 - spacingMiddle)/2;
        
        //加入购物车
        UIButton * cartBtn = [[UIButton alloc]initWithFrame:CGRectMake(spacingBoth, spacingH,BtnW, BtnH)];
        [cartBtn setBackgroundImage:[UIImage imageNamed:@"add_cart"] forState:UIControlStateNormal];
        [cartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [self addSubview:cartBtn];
        [cartBtn addTarget:self action:@selector(shopcartAdd:) forControlEvents:UIControlEventTouchUpInside];
        
        //加入收藏
        UIButton * collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cartBtn.frame) +spacingMiddle, spacingH,BtnW, BtnH)];
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"add_favorite"] forState:UIControlStateNormal];
        [collectBtn setTitle:@"加入收藏" forState:UIControlStateNormal];
        [self addSubview:collectBtn];
        [collectBtn addTarget:self action:@selector(shopcartCollect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) shopcartAdd:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(productAddShop:)])
    {
        [self.delegate productAddShop:btn];
    }
}

- (void) shopcartCollect:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(productCollectShop:)])
    {
        [self.delegate productCollectShop:btn];
    }
}

@end
