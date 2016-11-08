//
//  MyPointsModel.m
//  Trendpower
//
//  Created by 张帅 on 16/10/11.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "MyPointsModel.h"

@implementation MyPointsModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.userId = [[attributes valueForKey:@"userId"] integerValue];
        self.agentId = [[attributes valueForKey:@"agentId"] integerValue];
        self.agentCompanyName = [attributes valueForKey:@"agentCompanyName"];
        self.totalPoint = [[attributes valueForKey:@"totalPoint"] integerValue];
        self.balancePoint = [[attributes valueForKey:@"balancePoint"] integerValue];
        self.frozenPoint = [[attributes valueForKey:@"frozenPoint"] integerValue];
    }
    return self;
}

@end
