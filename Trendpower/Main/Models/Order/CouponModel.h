//
//  CouponModel.h
//  Trendpower
//
//  Created by trendpower on 15/5/22.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject

@property (nonatomic,copy) NSString * couponTypeId;
@property (nonatomic,copy) NSString * couponName;
@property (nonatomic,copy) NSString * couponValue;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;

@end

/**
 *  "coupons": [
                 {
                     "coupon_id": "23",
                     "coupon_name": "ccecececec",
                     "coupon_sn": "1000002046",
                     "coupon_type_id": "33",
                     "coupon_value": "20.00",
                     "emailed": "N",
                     "end_time": "1432742400",
                     "if_issue": "1",
                     "min_goods_order": "0.00",
                     "order_id": "0",
                     "order_sn": "",
                     "start_time": "1432051200",
                     "store_id": "81",
                     "use_times": "0",
                     "used_time": "0",
                     "user_id": "32153"
                 },
                 {
                     "coupon_id": "13",
                     "coupon_name": "测测测测测1",
                     "coupon_sn": "1000009123",
                     "coupon_type_id": "23",
                     "coupon_value": "10.00",
                     "emailed": "N",
                     "end_time": "1432742400",
                     "if_issue": "1",
                     "min_goods_order": "0.00",
                     "order_id": "0",
                     "order_sn": "",
                     "start_time": "1432051200",
                     "store_id": "81",
                     "use_times": "0",
                     "used_time": "0",
                     "user_id": "32153"
                 }
            ],

 */

