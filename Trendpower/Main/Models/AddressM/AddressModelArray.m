//
//  AddressModelArray.m
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-2.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import "AddressModelArray.h"
#import "AddressModel.h"

@implementation AddressModelArray


- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *addressModel in attributes)
    {
        AddressModel *model = [[AddressModel alloc] initWithAttributes:addressModel];
        
        [mutilableData addObject:model];
    }
    
    self.dataAddressArray = [[NSArray alloc] initWithArray:mutilableData];
    
    return self;
}

@end
