//
//  PaymentCouponModel.m
//  ZZBMall
//
//  Created by trendpower on 15/12/2.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import "PaymentCouponModel.h"

@implementation PaymentCouponModel
- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        
        self.coupon_id = [attributes objectForKey:@"id"];
        self.coupon_name = [attributes objectForKey:@"coupon_name"];
        self.start_time = [attributes objectForKey:@"start_time"];
        self.end_time = [attributes objectForKey:@"end_time"];

    }
    
    return self;
}


/**
 *  "add_time" = 1448886636;
 "coupon_id" = 10;
 "coupon_name" = "100-90";
 "coupon_sn" = B82000103381;
 "coupon_state" = 0;
 "coupon_value" = "90.00";
 "end_time" = 1449072000;
 id = 17;
 "if_issue" = 0;
 "member_id" = 3381;
 "min_amount" = "100.00";
 "order_amount" = "0.00";
 "order_id" = 0;
 "order_sn" = "";
 "pay_sn" = "";
 remark = "<null>";
 "send_type" = 1;
 "start_time" = 1448899200;
 state = 1;
 "used_time" = 0;
 value = "0.00";
 */

@end
