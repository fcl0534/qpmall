//
//  DeliverDateModel.m
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-2.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import "PaymentWayModel.h"

@implementation PaymentWayModel

@synthesize paymentId;
@synthesize paymentName;

-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    paymentId = [[attributes valueForKey:@"payment_id"] integerValue];
    paymentName = [attributes valueForKey:@"payment_name"];
    
    return self;
}


@end
