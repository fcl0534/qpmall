//
//  QPMGoodsGroupedModel.m
//  Trendpower
//
//  Created by hjz on 16/5/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "QPMGoodsGroupedModel.h"

@implementation QPMGoodsGroupedModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.isActivity = [[attributes valueForKey:@"isActivity"] integerValue];
        self.privilegeAmount = [[attributes valueForKey:@"privilegeAmount"] floatValue];
        self.total_pay_price = [[attributes valueForKey:@"total_pay_price"] floatValue];
        self.promotions = [attributes valueForKey:@"promotions"];
    }
    return self;
}

@end
