//
//  QPMPaymentSeparateModel.m
//  Trendpower
//
//  Created by 张帅 on 16/11/7.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "QPMPaymentSeparateModel.h"

@implementation QPMPaymentSeparateModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes; {

    if (self = [super init]) {

        self.sellerId = [[attributes objectForKey:@"sellerId"] integerValue];
        self.sellerCode = [attributes objectForKey:@"sellerCode"];
        self.cellphone = [attributes objectForKey:@"cellphone"];
        self.truename = [attributes objectForKey:@"truename"];
        self.companyName = [attributes objectForKey:@"companyName"];
        self.email = [attributes objectForKey:@"email"];
        self.companyShortName = [attributes objectForKey:@"companyShortName"];
        self.total_amount = [[attributes objectForKey:@"total_amount"] floatValue];
        self.total_quantity = [[attributes objectForKey:@"total_quantity"] integerValue];
    }

    return self;
}

@end
