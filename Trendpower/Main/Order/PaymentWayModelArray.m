//
//  PaymentWayModelArray.m
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-2.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import "PaymentWayModelArray.h"
#import "PaymentWayModel.h"

@implementation PaymentWayModelArray

@synthesize data;

- (instancetype)initWithAttributes:(NSArray *)attributes
{
    
    NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *shippingModel in attributes)
    {
        PaymentWayModel *model = [[PaymentWayModel alloc] initWithAttributes:shippingModel];
        
        [mutilableData addObject:model];
    }
    
    data = [[NSArray alloc] initWithArray:mutilableData];
    
    return self;
}
@end
