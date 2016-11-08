//
//  OrderModel.m
//  EcmallAPP
//
//  Created by zhanghongbo on 14-2-20.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import "OrderModel.h"
#import "OrderGoodsModel.h"
#import "ShopCartModel.h"

@implementation OrderModel

-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.orderId = [attributes valueForKey:@"orderNo"];
        self.orderSn = [attributes valueForKey:@"orderNo"];
        self.orderTime = [attributes valueForKey:@"createdAt"];
        self.goodsAmount = [attributes valueForKey:@"amount"];
        self.orderAmount = [attributes valueForKey:@"amount"];
        self.shipCost = [attributes valueForKey:@"isPay"];
        self.status=[[attributes valueForKey:@"orderStatus"] integerValue];
        self.payAmount = [attributes valueForKey:@"payAmount"];
        self.companyName = [attributes valueForKey:@"companyName"];

        self.payType = [[attributes valueForKey:@"payType"] integerValue];

        self.isPointOrder = [[attributes objectForKey:@"isPointOrder"] boolValue];
        
        self.expressDic = [NSDictionary dictionaryWithDictionary:[attributes objectForKey:@"express"]];
        
        NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
        
        NSArray * orderGoods = [attributes valueForKey:@"orderGoods"];
        for (NSDictionary *goodsModel in orderGoods){
            OrderGoodsModel *model = [[OrderGoodsModel alloc] initWithAttributes:goodsModel];
            [mutilableData addObject:model];
        }
        
        self.dataGoodsArray = [[NSArray alloc] initWithArray:mutilableData];
    }
    return self;
}



/**
{
    "data": {
        "count": 41,
        "currentPage": "1",
        "orders": [
                   {
                       "amount": "9990.00",
                       "companyName": "dgfdgdgfdg",
                       "createdAt": "1457446783",
                       "express": {
                           "agentId": "24",
                           "distributionType": "1",
                           "isFree": "1",
                           "price": "0.00"
                       },
                       "isDeleted": "0",
                       "isPay": "0",
                       "orderNo": "201603081419436841",
                       "orderStatus": "6",
                       "payAmount": "9990.00",
                       "realAmount": "9990.00",
                       "recipient": "污蔑",
                       "recipientMobile": "18785558888",
                       "refundAmount": null,
                       "remark": null,
                       "sellerId": "24",
                       "sellerName": "余先生",
                       "sellerRemark": null,
                       "trueName": null,
                       "userId": "60",
                       "userPhone": "15820240405",
                       "userRemark": ""
                   },
                   {
                       "amount": "298.00",
                       "companyName": "泰兴隆",
                       "createdAt": "1457442220",
                       "express": {
                           "agentId": "10",
                           "distributionType": "0",
                           "isFree": "1",
                           "price": "0.00"
                       },
                       "isDeleted": "0",
                       "isPay": "0",
                       "orderGoods": [
                                      {
                                          "defaultImg": "http://assets.qpfww.com/goods/0000/0005/3163/53163/79891449111608.jpg",
                                          "goodsAmount": "298.00",
                                          "goodsCode": "885346T38",
                                          "goodsId": "53163",
                                          "goodsQuantity": "1",
                                          "goodsTitle": "欧司朗H3NBU夜行者第三代64151NBU 55W 12V PK22S 10X2 EN -AS欧司朗车灯 欧司朗夜行者",
                                          "goodsUnitPrice": "298.00",
                                          "payUnitPrice": "298.00"
                                      }
                                      ],
                       "orderNo": "201603081303403705",
                       "orderStatus": "1",
                       "payAmount": "298.00",
                       "realAmount": "298.00",
                       "recipient": "污蔑",
                       "recipientMobile": "18785558888",
                       "refundAmount": null,
                       "remark": null,
                       "sellerId": "10",
                       "sellerName": "泰兴隆",
                       "sellerRemark": null,
                       "trueName": null,
                       "userId": "60",
                       "userPhone": "15820240405",
                       "userRemark": ""
                   },
                   {
                       "amount": "1298.00",
                       "companyName": "泰兴隆",
                       "createdAt": "1457441830",
                       "express": {
                           "agentId": "10",
                           "distributionType": "1",
                           "isFree": "0",
                           "price": "18.00"
                       },
                       "isDeleted": "0",
                       "isPay": "0",
                       "orderGoods": [
                                      {
                                          "defaultImg": "http://assets.qpfww.com/goods/0000/0002/5093/25093/81801451462392.jpg",
                                          "goodsAmount": "1280.00",
                                          "goodsCode": "7537885X5",
                                          "goodsId": "25093",
                                          "goodsQuantity": "1",
                                          "goodsTitle": "壳牌轿车发动机油Helix Ultra （10W-60） 4L 全合成汽油机油 灰壳 法拉利赛车机油",
                                          "goodsUnitPrice": "1280.00",
                                          "payUnitPrice": "1280.00"
                                      }
                                      ],
                       "orderNo": "201603081257109972",
                       "orderStatus": "1",
                       "payAmount": "1298.00",
                       "realAmount": "1298.00",
                       "recipient": "污蔑",
                       "recipientMobile": "18785558888",
                       "refundAmount": null,
                       "remark": null,
                       "sellerId": "10",
                       "sellerName": "泰兴隆",
                       "sellerRemark": null,
                       "trueName": null,
                       "userId": "60",
                       "userPhone": "15820240405",
                       "userRemark": "没办呢"
                   },
                   {
                       "amount": "1298.00",
                       "companyName": "泰兴隆",
                       "createdAt": "1457441830",
                       "express": {
                           "agentId": "10",
                           "distributionType": "1",
                           "isFree": "0",
                           "price": "18.00"
                       },
                       "isDeleted": "0",
                       "isPay": "0",
                       "orderGoods": [
                                      {
                                          "defaultImg": "http://assets.qpfww.com/goods/0000/0002/5093/25093/81801451462392.jpg",
                                          "goodsAmount": "1280.00",
                                          "goodsCode": "7537885X5",
                                          "goodsId": "25093",
                                          "goodsQuantity": "1",
                                          "goodsTitle": "壳牌轿车发动机油Helix Ultra （10W-60） 4L 全合成汽油机油 灰壳 法拉利赛车机油",
                                          "goodsUnitPrice": "1280.00",
                                          "payUnitPrice": "1280.00"
                                      }
                                      ],
                       "orderNo": "201603081257109972",
                       "orderStatus": "1",
                       "payAmount": "1298.00",
                       "realAmount": "1298.00",
                       "recipient": "污蔑",
                       "recipientMobile": "18785558888",
                       "refundAmount": null,
                       "remark": null,
                       "sellerId": "10",
                       "sellerName": "泰兴隆",
                       "sellerRemark": null,
                       "trueName": null,
                       "userId": "60",
                       "userPhone": "15820240405",
                       "userRemark": "没办呢"
                   }
                   ],
        "totalPage": 9
    },
    "msg": "请求成功",
    "status": 1
}
 */
- (instancetype)initWithShopCart:(NSArray *)attributes
{
    if([super init])
    {
        NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
        
        for (ShopCartModel *goodsModel in attributes)
        {
            OrderGoodsModel *model = [[OrderGoodsModel alloc] init];
            model.productId = goodsModel.goodsId;
            model.productName = goodsModel.goodsName;
            model.productImageURL = goodsModel.goodsImgURL;
            model.quantity = goodsModel.quantity;
            model.specification = goodsModel.specification;
            model.price = goodsModel.price;
            
            [mutilableData addObject:model];
        }
        
        self.dataGoodsArray = [[NSArray alloc] initWithArray:mutilableData];
    }
    
    return self;
}

@end
