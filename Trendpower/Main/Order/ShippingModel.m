//
//  ShipWayModel.m
//  EcmallAPP
//
//  Created by zhanghongbo on 13-12-31.
//  Copyright (c) 2013年 tendpower. All rights reserved.
//

#import "ShippingModel.h"

@implementation ShippingModel
@synthesize shipingId;
@synthesize shippingName;
@synthesize price;
-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    shipingId = [[attributes valueForKey:@"shipping_id"] integerValue];
    shippingName = [attributes valueForKey:@"shipping_name"];
    price = [[attributes valueForKey:@"first_price"] floatValue];
    return self;
}


@end
