

//
//  PaymentShopsModel.m
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "PaymentShopsModel.h"

@implementation PaymentShopsModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {

        self.companyName = [attributes objectForKey:@"companyName"];
        self.store_goods_total = [attributes objectForKey:@"store_goods_total"];
        self.store_freight = [attributes objectForKey:@"stroe_freight"];
        
        NSArray * cartArray = [attributes valueForKey:@"goods_list"];
        if (attributes.count) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *tempData in cartArray){
                CartGoodsModel *model = [[CartGoodsModel alloc] initWithAttributes:tempData];
                [tempArray addObject:model];
            }
            
            self.goodsArray = [[NSMutableArray alloc]initWithArray:tempArray];
        }
    }
    
    return self;
}


@end
