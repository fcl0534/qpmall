//
//  CartShopModel.m
//  ZZBMall
//
//  Created by HTC on 15/8/10.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "CartShopModel.h"

@implementation CartShopModel
- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        // 1.
        self.companyName = [attributes objectForKey:@"companyName"];
        self.sellerId = [attributes objectForKey:@"sellerId"];
        self.userId = [attributes objectForKey:@"userId"];
        
        
        NSArray * goodsArray = [attributes objectForKey:@"goods"];
        if (goodsArray.count) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *tempData in goodsArray){
                CartGoodsModel *model = [[CartGoodsModel alloc] initWithAttributes:tempData];
                model.companyName = [attributes objectForKey:@"companyName"];
                model.sellerId = [attributes objectForKey:@"sellerId"];
                model.userId = [attributes objectForKey:@"userId"];
                [tempArray addObject:model];
            }
            self.goodsArray = [[NSMutableArray alloc]initWithArray:tempArray];
        }
    }
    
    return self;
}


@end
