//
//  CartModelArray.m
//  ZZBMall
//
//  Created by HTC on 15/8/10.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "CartModelArray.h"

@implementation CartModelArray

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        
        
        NSDictionary * data = [attributes objectForKey:@"data"];
        
        // 1.
        self.selectTotal = [data valueForKey:@"selectTotal"];
        self.selectTotalPrice = [data valueForKey:@"selectTotalPrice"];
        self.total = [data valueForKey:@"total"];
        self.totalPrice = [data valueForKey:@"totalPrice"];
        
        NSArray * cartArray = [data valueForKey:@"agentList"];
        if (cartArray.count) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *tempData in cartArray){
                CartShopModel *model = [[CartShopModel alloc] initWithAttributes:tempData];
                [tempArray addObject:model];
            }
            self.shopArray = [[NSMutableArray alloc]initWithArray:tempArray];
        }
    }
    
    return self;
}
@end
