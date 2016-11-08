//
//  ProductSpecification.m
//  TabBarNavigationDemo
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "ProductSpecificationModel.h"

@implementation ProductSpecificationModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{

    if([super init])
    {
        self.company_name = [attributes valueForKey:@"company_name"];
        self.goods_id = [attributes valueForKey:@"goods_id"];
        self.sales_volumn = [attributes valueForKey:@"sales_volumn"];
        self.seller_id = [attributes valueForKey:@"seller_id"];
        self.sku = [attributes valueForKey:@"sku"];
        self.title = [attributes valueForKey:@"title"];
        self.good_price = [attributes valueForKey:@"good_price"];
        
        self.goodsPromotions = [attributes valueForKey:@"goodsPromotions"];
        
    }
    return self;
}

/**
 {
 "company_name": "泰兴隆",
 "goods_code": "4XW5X7X76",
 "goods_id": "22703",
 "id": "10",
 "sales_volumn": "486",
 "seller_id": "10",
 "sku": "9512",
 "title": "快车道环保雪种 250g 汽车空调专用制冷制 冷媒 R134A 氟利昂 快车道雪种",
 "unit_title": "瓶",
 "vip_price": "13.80",
 "volumn": "4766"
 },
 */

@end
