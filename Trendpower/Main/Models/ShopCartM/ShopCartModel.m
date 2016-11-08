//
//  ShopCartModel.m
//  EcmallAPP
//
//  Created by zhanghongbo on 13-12-28.
//  Copyright (c) 2013年 tendpower. All rights reserved.
//

#import "ShopCartModel.h"

@implementation ShopCartModel

-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.shoppingId = [[attributes valueForKey:@"shopping_id"] longLongValue];
        self.userId = [[attributes valueForKey:@"userId"] longLongValue];
        self.goodsId = [[attributes valueForKey:@"goods_id"] longLongValue];
        self.goodsName = [attributes valueForKey:@"goods_name"];
        self.specId = [[attributes valueForKey:@"spec_id"] longLongValue];
        self.specification = [attributes valueForKey:@"specification"];
        self.price = [attributes valueForKey:@"price"];
        self.priceMember = [attributes valueForKey:@"buy_price"];
        self.priceTotal = [attributes valueForKey:@"subtotal"];
        self.quantity = [[attributes valueForKey:@"quantity"] intValue];
        self.goodsImgURL = [attributes valueForKey:@"goods_img"];
        self.exist = [[attributes valueForKey:@"exist"] intValue];
    }
    return self;
}

/**
 *
	"goods_list": [
                     {
                     "add_time": "1430204624",
                     "buy_price": "450.00",（商品会员价）
                     "exist": 1,(产品是否存在)
                     "extension_param": "",
                     "goods_id": "50323",
                     "goods_img": "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/553af5f756c30.jpg",
                     "goods_name": "嘉乐驰（绿牌）55B24L细(S/T大) , 6-QW-45（45Ah）",
                     "is_shipping": "1",
                     "last_update": "1431434725",
                     "market_price": "308.00",
                     "price": "450.00",（商品原价）
                     "quantity": "6",
                     "session_id": "",
                     "shopping_id": "3613",
                     "spec_id": "0",
                     "specification": "",
                     "store_id": "81",
                     "subtotal": "2,700.00",
                     "type": "0",
                     "user_id": "32153",
                     "volume": "0",
                     "weight": "0"
                     }
                   ],
 
 */

@end
