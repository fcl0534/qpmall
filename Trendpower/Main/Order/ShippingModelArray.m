//
//  ShippingModelArray.m
//  EcmallAPP
//
//  Created by zhanghongbo on 13-12-31.
//  Copyright (c) 2013年 tendpower. All rights reserved.
//

#import "ShippingModelArray.h"
#import "ShippingModel.h"

@implementation ShippingModelArray

@synthesize data;

- (instancetype)initWithAttributes:(NSArray *)attributes
{
    
    NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *shippingModel in attributes)
    {
        ShippingModel *model = [[ShippingModel alloc] initWithAttributes:shippingModel];
        
        [mutilableData addObject:model];
    }
    
    data = [[NSArray alloc] initWithArray:mutilableData];
    
    return self;
}

@end
