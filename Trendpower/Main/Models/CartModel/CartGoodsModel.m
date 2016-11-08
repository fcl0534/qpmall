//
//  CartGoodsModel.m
//  ZZBMall
//
//  Created by trendpower on 15/8/7.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "CartGoodsModel.h"

@implementation CartGoodsModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        
        self.cartId = [attributes valueForKey:@"cartId"];
        self.goodsAgentSku = [attributes valueForKey:@"goodsAgentSku"];
        self.goodsAgentStatus = [attributes valueForKey:@"goodsAgentStatus"];
        self.is_check = [[attributes valueForKey:@"is_check"] intValue];
        self.goodsId = [attributes valueForKey:@"goodsId"];
        self.goodsImage = [attributes valueForKey:@"goodsImage"];
        self.goodsName = [attributes valueForKey:@"goodsName"];
        self.overSku = [attributes valueForKey:@"overSku"];
        self.price = [attributes valueForKey:@"price"];
        self.quantity = [attributes valueForKey:@"quantity"];
        self.goodsIamge = [attributes valueForKey:@"goodsIamge"];
        self.isActivity = [[attributes valueForKey:@"isActivity"] integerValue];
        self.promotionType = [attributes valueForKey:@"promotionType"];
        self.promotionPrice = [attributes valueForKey:@"promotionPrice"];
        self.goodsStandardId = [[attributes valueForKey:@"goodsStandardId"] integerValue];

        self.point = [[attributes valueForKey:@"point"] integerValue];
    }
    return self;
}


@end
