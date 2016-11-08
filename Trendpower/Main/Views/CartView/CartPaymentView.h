//
//  CartPaymentView.h
//  ZZBMall
//
//  Created by trendpower on 15/8/11.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "BaseView.h"

@protocol CartPaymentViewDelegate <NSObject>

@optional
- (void) cartPaymentViewClickedSelectBtn:(UIButton *)btn;
- (void) cartPaymentViewClickedSumbitBtn:(UIButton *)btn;

@end


@interface CartPaymentView : UIView

@property (nonatomic, weak) id<CartPaymentViewDelegate> delegate;

@property (nonatomic, copy) NSString * price;

@property (nonatomic, weak) UIButton *selectBtn;

@property (nonatomic, weak) UIButton *payBtn;

@end
