//
//  PaymentModel.h
//  Trendpower
//
//  Created by HTC on 15/5/21.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"
#import "OrderGoodsModel.h"
#import "ShippingModel.h"
#import "CouponModel.h"

@interface PaymentModel : NSObject

/**
 *  订单类型
 */
@property (nonatomic, copy) NSString * flowType;
@property (nonatomic, copy) NSString * surplus;
@property (nonatomic, copy) NSString * useCoin;
@property (nonatomic, copy) NSString * coin;
@property (nonatomic, copy) NSString * coinMoney;

@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * coupon;
@property (nonatomic, copy) NSString * couponFee;
@property (nonatomic, copy) NSString * goodsAmount;
@property (nonatomic, copy) NSString * goodsPrice;
@property (nonatomic, copy) NSString * marketPrice;
@property (nonatomic, copy) NSString * quantity;
@property (nonatomic, copy) NSString * saveRate;
@property (nonatomic, copy) NSString * saving;


@property (nonatomic, assign) BOOL isUseCoin;
@property (nonatomic, assign) BOOL isUseCoupon;

/**
   运费
 */
@property (nonatomic, copy) NSString * shippingFee;

/**
 *  收货地址模型
 */
@property (nonatomic, strong) AddressModel * addressModel;
/**
 *  积分模型数组
 */
@property (nonatomic, strong) NSArray * dataCouponsArray;
/**
 *  产品模型数组
 */
@property (nonatomic, strong) NSArray * dataGoodslistArray;
/**
 *  运送方式模型数组
 */
@property (nonatomic, strong) NSArray * dataShippingArray;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
