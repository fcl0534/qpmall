//
//  ShipWayModel.m
//  EcmallAPP
//
//  Created by zhanghongbo on 13-12-31.
//  Copyright (c) 2013年 tendpower. All rights reserved.
//

#import "ShippingModel.h"

@implementation ShippingModel

-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.shipingId = [attributes valueForKey:@"shipping_id"];
        self.shippingName = [attributes valueForKey:@"shipping_name"];
        self.price = [attributes valueForKey:@"first_price"];
    }
    return self;
}

@end
