//
//  AddressAgentModelArray.m
//  Trendpower
//
//  Created by 张帅 on 16/7/19.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "AddressAgentModelArray.h"
#import "AddressAgentModel.h"

@implementation AddressAgentModelArray

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    NSArray *dataFromServer = [attributes valueForKey:@"data"];

    NSMutableArray *mutilableData = [[NSMutableArray alloc] init];

    for (NSDictionary *dic in dataFromServer)
    {
        AddressAgentModel *model = [[AddressAgentModel alloc] initWithAttributes:dic];

        [mutilableData addObject:model];
    }

    self.agents = [[NSArray alloc] initWithArray:mutilableData];

    return self;
}

@end
