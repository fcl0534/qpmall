//
//  AddressAgentModel.m
//  Trendpower
//
//  Created by 张帅 on 16/7/19.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "AddressAgentModel.h"

@implementation AddressAgentModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if ([super init]) {
        self.agentId = [[attributes valueForKey:@"id"] integerValue];
        self.user_code = [attributes valueForKey:@"user_code"];
        self.cellphone = [attributes valueForKey:@"cellphone"];
        self.company_name = [attributes valueForKey:@"company_name"];
        self.company_short_name = [attributes valueForKey:@"company_short_name"];
    }

    return self;
}

@end
