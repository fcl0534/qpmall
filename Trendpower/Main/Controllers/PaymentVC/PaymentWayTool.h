//
//  PaymentWayTool.h
//  ZZBMall
//
//  Created by trendpower on 15/9/15.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// alipay
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

// weixin
#import "WXApiObject.h"
#import "WXApi.h"
//APP端签名相关头文件
#import "payRequsestHandler.h"


@interface PaymentWayTool : NSObject

+ (void)aliPayOrder_name:(NSString *)name order_price:(NSString *)price orderno:(NSString *)orderSn;

+ (void)aliPayOrder_name:(NSString *)name order_price:(NSString *)price orderno:(NSString *)orderSn partner:(NSString *)partner seller:(NSString *)seller notifyURL:(NSString *)notifyURL;

+ (void)wxPayOrder_name:(NSString *)name order_price:(NSString *)price orderno:(NSString *)orderSn;

/*! @brief 支付宝支付
 *
 *
 */
- (void)aliPay:(UIView *)view url:(NSString *)url params:(NSDictionary *)params;

/*! @brief 微信支付
 *
 *
 */
- (void)wxPay:(UIView *)view url:(NSString *)url params:(NSDictionary *)params;

@end
