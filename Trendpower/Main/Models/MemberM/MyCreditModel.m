//
//  MyCreditModel.m
//  Trendpower
//
//  Created by HTC on 16/2/27.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "MyCreditModel.h"

@implementation MyCreditModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        
        self.balanceCredit = [attributes valueForKey:@"balanceCredit"];
        self.creditLimit = [attributes valueForKey:@"creditLimit"];
        self.creditTime = [attributes valueForKey:@"creditTime"];
        self.sellerTrueName = [attributes valueForKey:@"sellerTrueName"];
    }
    return self;
}

/**
 *
balanceCredit = "13769.03";
createdAt = 1450943240;
creditId = 1;
creditLimit = "10000.00";
creditTime = 60;
sellerCompanyName = jy;
sellerId = 22;
sellerTrueName = "景悦";
updatedAt = 1452071113;
userId = 8;
 */
@end
