//
//  PaymentModel.m
//  Trendpower
//
//  Created by HTC on 15/5/21.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "PaymentModel.h"

@implementation PaymentModel

-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        //1.产品详情
        NSDictionary *data=[attributes objectForKey:@"data"];
        self.flowType = [data valueForKey:@"flow_type"];
        self.surplus = [data valueForKey:@"surplus"];
        self.useCoin = [data valueForKey:@"use_coin"];
        self.coin = [data valueForKey:@"coin"];
        self.coinMoney = [data valueForKey:@"coin_money"];
        
        // 2.total
        NSDictionary * totalDic = [data objectForKey:@"total"];
        self.amount = [totalDic valueForKey:@"amount"];
        self.coupon = [totalDic valueForKey:@"coupon"];
        self.couponFee = [totalDic valueForKey:@"coupon_fee"];
        self.goodsAmount = [totalDic valueForKey:@"goods_amount"];
        self.goodsPrice = [totalDic valueForKey:@"goods_price"];
        self.marketPrice = [totalDic valueForKey:@"market_price"];
        self.quantity = [totalDic valueForKey:@"quantity"];
        self.saveRate = [totalDic valueForKey:@"save_rate"];
        self.saving = [totalDic valueForKey:@"saving"];
        self.shippingFee = [totalDic valueForKey:@"shipping_fee"];
        
        
        
        // 3.address
        NSDictionary *addDic = [data valueForKey:@"address"];
        self.addressModel = [[AddressModel alloc]initWithAttributes:addDic];
        
        
        // 4.goods_list
        NSArray *goodsArray = [data valueForKey:@"goods_list"];
        if([goodsArray count] != 0){
            NSMutableArray *goodsListArray = [[NSMutableArray alloc] init];
            for (NSDictionary *goodsDic in goodsArray){
                OrderGoodsModel *goodsModel = [[OrderGoodsModel alloc] initWithAttributes:goodsDic];
                goodsModel.totalPrice = self.amount;
                goodsModel.totalQuantity = self.quantity;
                [goodsListArray addObject:goodsModel];
            }
            self.dataGoodslistArray = [[NSArray alloc] initWithArray:goodsListArray];
        }
        
        // 5.shipping
        NSArray *shippingArray = [data valueForKey:@"shipping"];
        if([shippingArray count] != 0){
            NSMutableArray *shippingListArray = [[NSMutableArray alloc] init];
            for (NSDictionary *shippingDic in shippingArray){
                ShippingModel *shippingModel = [[ShippingModel alloc] initWithAttributes:shippingDic];
                [shippingListArray addObject:shippingModel];
            }
            self.dataShippingArray = [[NSArray alloc] initWithArray:shippingListArray];
        }
        
        // 6.coupons
        NSArray *couponsArray = [data valueForKey:@"coupons"];
        if([couponsArray count] != 0){
            NSMutableArray *couponsListArray = [[NSMutableArray alloc] init];
            for (NSDictionary *couponsDic in couponsArray){
                CouponModel*couponModel = [[CouponModel alloc] initWithAttributes:couponsDic];
                [couponsListArray addObject:couponModel];
            }
            self.dataCouponsArray = [[NSArray alloc] initWithArray:couponsListArray];
        }
        
    }
    return self;
}

@end

/**
 *    {
            "data": {
                     "address": {
                                     "addr_id": "2933",
                                     "address": "你们是怎么想怎么做才好",
                                     "consignee": "做人",
                                     "identity_card": "",
                                     "is_default": "N",
                                     "phone_mob": "18707737396",
                                     "phone_tel": "",
                                     "region_id": "1969",
                                     "region_name": "广州天河区上上路",
                                     "session_id": "87pqg23rjhvp7nub9gmktejq74",
                                     "store_id": "81",
                                     "user_id": "32153",
                                     "zipcode": "0"
                                 },
                   "goods_list": [
                                  {
                                         "add_time": "1432126285",
                                         "buy_price": 35,
                                         "exist": 1,
                                         "extension_param": "",
                                         "fenxiao_price": "38.00",
                                         "goods_id": "3447833",
                                         "goods_img": "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/555073930dc7e.jpg",
                                         "goods_name": "可兰素净兰 车用尿素溶液 柴油车专用尾气净化剂 国V国Ⅳ排放 10L装",
                                         "is_shipping": "1",
                                         "last_update": "1432134561",
                                         "market_price": "30.00",
                                         "memo": "",
                                         "price": "45.00",
                                         "quantity": "2",
                                         "session_id": "aoceui8sb694ltsv6rpqiuq6o2",
                                         "shopping_id": "6283",
                                         "spec_id": "0",
                                         "specification": "",
                                         "store_id": "81",
                                         "subtotal": "70.00",
                                         "type": "0",
                                         "user_id": "32153",
                                         "volume": "0",
                                         "weight": "0",
                                         "wholesale_price": "35.00"
                                    },
                                    {
                                         "add_time": "1431517326",
                                         "buy_price": 65,
                                         "exist": 1,
                                         "extension_param": "",
                                         "fenxiao_price": "0.00",
                                         "goods_id": "54183",
                                         "goods_img": "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/5549dc38604ca.jpg",
                                         "goods_name": "ZF Fluid Steering 采埃孚波箱油 变速箱油",
                                         "is_shipping": "1",
                                         "last_update": "1431518100",
                                         "market_price": "46.00",
                                         "memo": "",
                                         "price": "78.00",
                                         "quantity": "1",
                                         "session_id": "u74b2ofhltiq1k41rvbmgiq8v1",
                                         "shopping_id": "5083",
                                         "spec_id": "0",
                                         "specification": "",
                                         "store_id": "81",
                                         "subtotal": "65.00",
                                         "type": "0",
                                         "user_id": "32153",
                                         "volume": "0",
                                         "weight": "0",
                                         "wholesale_price": "65.00"
                                    }
                                ],
                     "shipping": [
                                   {
                                         "continue_price": "0.00",
                                         "continue_unit": "1",
                                         "def_fee": "Y",
                                         "description": "",
                                         "first_price": "0.00",
                                         "first_unit": "1",
                                         "setting": "unify",
                                         "shipping_code": "sf",
                                         "shipping_id": "313",
                                         "shipping_name": "测试用的",
                                         "sort_order": "255",
                                         "status": "N",
                                         "store_id": "81"
                                 },
                                 {
                                         "continue_price": "10.00",
                                         "continue_unit": "1",
                                         "def_fee": "Y",
                                         "description": "",
                                         "first_price": "10.00",
                                         "first_unit": "1",
                                         "setting": "unify",
                                         "shipping_code": "yto",
                                         "shipping_id": "303",
                                         "shipping_name": "圆通",
                                         "sort_order": "255",
                                         "status": "Y",
                                         "store_id": "81"
                                 }
                              ],

                     "total": {
                                     "amount": 135,
                                     "coin": 0,
                                     "coin_money": 0,
                                     "coupon": 0,
                                     "coupon_fee": 0,
                                     "goods_amount": 135,
                                     "goods_price": 135,
                                     "market_price": 0,
                                     "quantity": 3,
                                     "save_rate": 0,
                                     "saving": 0,
                                     "shipping_fee": 0,
                                     "surplus": 0,
                                     "total_net_turnover": 205
                                 },
                 "surplus": 0,
                 "use_coin": 0
                 "coin": 0,
                 "coin_money": 0,
                 "coupons": [
                              ],
                },
        "msg": "成功",
        "status": 1
    }
 */



