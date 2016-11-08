//
//  CartShopModel.h
//  ZZBMall
//
//  Created by HTC on 15/8/10.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CartGoodsModel.h"

@interface CartShopModel : NSObject

@property (nonatomic, copy) NSString * companyName;
@property (nonatomic, copy) NSString * sellerId;
@property (nonatomic, copy) NSString * userId;

/** 模型数组 */
@property (nonatomic, strong) NSMutableArray * goodsArray;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

/**
{
				"companyName": "dgfdgdgfdg",
				"goods": [
                          {
                              "cartId": "308",
                              "goodsAgentSku": 1460,
                              "goodsAgentStatus": 1,
                              "goodsId": "27933",
                              "goodsImage": "http://assets.qpfww.com/goods/0000/0002/7933/27933/92111449307385.jpg",
                              "goodsName": "嘉乐驰（绿牌）L2-400 ,（60Ah）嘉乐驰绿牌蓄电池 嘉乐驰蓄电池 嘉乐驰电池",
                              "is_check": 1,
                              "overSku": 0,
                              "price": "999.00",
                              "quantity": "2"
                          },
                          {
                              "cartId": "310",
                              "goodsAgentSku": 514,
                              "goodsAgentStatus": 1,
                              "goodsId": "22703",
                              "goodsImage": "http://assets.qpfww.com/goods/0000/0002/2703/22703/45721449126160.jpg",
                              "goodsName": "快车道环保雪种 250g 汽车空调专用制冷制 冷媒 R134A 氟利昂 快车道雪种",
                              "is_check": 1,
                              "overSku": 0,
                              "price": "666.00",
                              "quantity": "36"
                          }
                          ],
				"sellerId": "24",
				"userId": "60"
},
 */
@end
