//
//  PaymentPayVC.h
//  Trendpower
//
//  Created by trendpower on 15/7/24.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "BaseViewController.h"

@interface PaymentPayVC : BaseViewController
@property (nonatomic, copy) NSString * orderAmount;
@property (nonatomic, copy) NSString * orderSn;
@property (nonatomic, copy) NSString * orderName;
@property (nonatomic, copy) NSString * paymentCode;
/**
 *  从会员中心的订单过来
 */
@property (nonatomic, assign) BOOL isFromMember;

@end
