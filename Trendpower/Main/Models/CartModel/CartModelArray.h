//
//  CartModelArray.h
//  ZZBMall
//
//  Created by HTC on 15/8/10.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CartShopModel.h"

@interface CartModelArray : NSObject

@property (nonatomic, copy) NSNumber * selectTotal;
@property (nonatomic, copy) NSNumber * selectTotalPrice;
@property (nonatomic, copy) NSNumber * total;
@property (nonatomic, copy) NSNumber * totalPrice;


/** 模型数组 */
@property (nonatomic, strong) NSMutableArray * shopArray;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

/**
{
    data =     {
        agentList =         (
                             {
                                 companyName = dgfdgdgfdg;
                                 goods =                 (
                                                          {
                                                              cartId = 308;
                                                              goodsAgentSku = 1460;
                                                              goodsAgentStatus = 1;
                                                              goodsId = 27933;
                                                              goodsImage = "http://assets.qpfww.com/goods/0000/0002/7933/27933/92111449307385.jpg";
                                                              goodsName = "嘉乐驰（绿牌）L2-400 ,（60Ah）嘉乐驰绿牌蓄电池 嘉乐驰蓄电池 嘉乐驰电池";
                                                              "is_check" = 1;
                                                              overSku = 0;
                                                              price = "999.00";
                                                              quantity = 2;
                                                          },
                                                          {
                                                              cartId = 310;
                                                              goodsAgentSku = 514;
                                                              goodsAgentStatus = 1;
                                                              goodsId = 22703;
                                                              goodsImage = "http://assets.qpfww.com/goods/0000/0002/2703/22703/45721449126160.jpg";
                                                              goodsName = "快车道环保雪种 250g 汽车空调专用制冷制 冷媒 R134A 氟利昂 快车道雪种";
                                                              "is_check" = 1;
                                                              overSku = 0;
                                                              price = "666.00";
                                                              quantity = 36;
                                                          }
                                                          );
                                 sellerId = 24;
                                 userId = 60;
                             },
                             {
                                 companyName = "泰兴隆";
                                 goods =                 (
                                                          {
                                                              cartId = 309;
                                                              goodsAgentSku = 8000;
                                                              goodsAgentStatus = 1;
                                                              goodsId = 3558703;
                                                              goodsImage = "http://assets.qpfww.com/goods/0000/0355/8703/3558703/27111449126545.jpg";
                                                              goodsName = "快车道高级制动液 DOT4刹车油离合器刹车液 合成型800g 快车道刹车油 快车道制动液";
                                                              "is_check" = 1;
                                                              overSku = 0;
                                                              price = "128.00";
                                                              quantity = 1;
                                                          },
                                                          {
                                                              cartId = 315;
                                                              goodsAgentSku = 79996;
                                                              goodsAgentStatus = 1;
                                                              goodsId = 3553513;
                                                              goodsImage = "http://assets.qpfww.com/goods/0000/0355/3513/3553513/41651449115104.jpg";
                                                              goodsName = "快车道 -25℃防冻液 绿色 4kg 快车道防冻液-25度绿色4KG 快车道防冻冷却液";
                                                              "is_check" = 1;
                                                              overSku = 0;
                                                              price = "118.00";
                                                              quantity = 1;
                                                          },
                                                          {
                                                              cartId = 316;
                                                              goodsAgentSku = 800000;
                                                              goodsAgentStatus = 1;
                                                              goodsId = 29573;
                                                              goodsImage = "http://assets.qpfww.com/goods/0000/0002/9573/29573/28431451725627.jpg";
                                                              goodsName = "方牌铱铂金火花塞XP5503-8 傲特利火花塞";
                                                              "is_check" = 1;
                                                              overSku = 0;
                                                              price = "128.00";
                                                              quantity = 1;
                                                          },
                                                          {
                                                              cartId = 317;
                                                              goodsAgentSku = 9999;
                                                              goodsAgentStatus = 1;
                                                              goodsId = 30903;
                                                              goodsImage = "http://assets.qpfww.com/goods/0000/0003/0903/30903/67591449651973.jpg";
                                                              goodsName = "WE0100015瓦尔塔（银标）H8-100L-T2H,100-20 , (100Ah)瓦尔塔蓄电池 瓦尔塔蓝标 瓦尔塔电池";
                                                              "is_check" = 1;
                                                              overSku = 0;
                                                              price = "1980.00";
                                                              quantity = 4;
                                                          }
                                                          );
                                 sellerId = 10;
                                 userId = 60;
                             }
                             );
        selectTotal = 45;
        selectTotalPrice = 34268;
        total = 45;
        totalPrice = 34268;
    };
    msg = "请求成功";
    status = 1;
}
 */

@end
