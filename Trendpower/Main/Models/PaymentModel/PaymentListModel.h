//
//  PaymentListModel.h
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PaymentShopsModel.h"
#import "PaymentCouponModel.h"

@interface PaymentListModel : NSObject

@property (nonatomic, copy) NSString * price;
/** 折后应付价 */
@property (nonatomic, copy) NSString *pay_price;

// 地址
@property (nonatomic, copy) NSString * address_name;
@property (nonatomic, copy) NSString * address_id;
@property (nonatomic, copy) NSString * add_area_info;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * add_provinceId;
@property (nonatomic, copy) NSString * add_area_id;
@property (nonatomic, copy) NSString * add_city_id;
@property (nonatomic, assign) BOOL add_is_default;
@property (nonatomic, copy) NSString * add_member_id;
@property (nonatomic, copy) NSString * add_mob_phone;


/** 购买的店铺的模型数组 */
@property (nonatomic, strong) NSMutableArray * shopArray;

@property (nonatomic, strong) NSArray * paywayArray;
@property (nonatomic, strong) NSArray * usedPaywayArry;


/** 判断有可用红包 */
@property (nonatomic, assign) NSInteger hasCoupon;
/** 当前使用的红包模型 */
@property (nonatomic, strong) PaymentCouponModel * selectedCoupon;
/** 可用红包的模型数组 */
@property (nonatomic, strong) NSMutableArray * couponArray;

/** 一个商户商品组合的集合 */
@property (nonatomic, strong) NSMutableArray *cartGoods;



- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
