//
//  ShopCartModelArray.m
//  EcmallAPP
//
//  Created by zhanghongbo on 13-12-28.
//  Copyright (c) 2013年 tendpower. All rights reserved.
//

#import "ShopCartModelArray.h"
#import "ShopCartModel.h"

@implementation ShopCartModelArray


- (instancetype)initWithAttributes:(NSDictionary *)attributes
{

    NSArray *dataFromServer = [attributes valueForKey:@"goods_list"];
    
    NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *shopCartDic in dataFromServer)
    {
        ShopCartModel *model = [[ShopCartModel alloc] initWithAttributes:shopCartDic];
        [mutilableData addObject:model];
    }
    self.dataShopCartArray = [[NSArray alloc] initWithArray:mutilableData];
    
    //删除成功，如果还有商品，则为1
    if ([[attributes objectForKey:@"status"] intValue] == 1) {
        NSDictionary *totalDic = [attributes valueForKey:@"total"];
        self.priceAmount = [totalDic valueForKey:@"goods_amount"];
        self.priceOriginal = [totalDic valueForKey:@"goods_price"];
        self.priceSaving = [totalDic valueForKey:@"saving"];
        self.quantity = [totalDic valueForKey:@"quantity"];
    }
    return self;
}

/**  删除商品时,如果没有商品时 返回
 *  {
         date = {
                     "goods_list" = (
                                       );
                     msg = "\U8d2d\U7269\U8f66\U4e3a\U7a7a";
                     status = 0;
                     total =  (
                             );
                     };
         msg = "\U5220\U9664\U6210\U529f";
         status = 1;
     }
 */

/**
 *
 {
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
	"msg": "获取成功",
	"status": 1,
	"total": {
                 "coin": 0,
                 "coin_money": 0,
                 "coupon": 0,
                 "goods_amount": 2700,（商品实际总价）
                 "goods_price": 2700,（商品原总价）
                 "market_price": 0,
                 "quantity": 6,
                 "save_rate": 0,
                 "saving": 0,(商品节省总价)
                 "shipping_fee": 0,
                 "surplus": 0,
                 "total_net_turnover": 2700
            }
 }
 */

@end
