//
//  CoinListModel.m
//  Trendpower
//
//  Created by HTC on 16/4/25.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "CoinListModel.h"

@implementation CoinListModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.goodsCode = [attributes valueForKey:@"goodsCode"];
        self.agentId = [attributes valueForKey:@"agentId"];
        self.title = [attributes valueForKey:@"title"];
        self.goodsImage = [attributes valueForKey:@"goodsImage"];
        self.marketPrice = [[attributes valueForKey:@"marketPrice"] floatValue];
        self.point = [[attributes valueForKey:@"point"] integerValue];
    }
    return self;
}

@end
