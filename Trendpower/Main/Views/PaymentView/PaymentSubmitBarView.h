//
//  PaymentSubmitBarView.h
//  ZZBMall
//
//  Created by HTC on 15/8/13.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "BaseView.h"


@protocol PaymentSubmitBarViewDelegate <NSObject>

@optional
- (void) paymentSubmitBarViewClickedSumbitBtn:(UIButton *)btn;

@end


@interface PaymentSubmitBarView : BaseView

@property (nonatomic, weak) id<PaymentSubmitBarViewDelegate> delegate;


@property (nonatomic, weak) UILabel * priceLbl;

@end
