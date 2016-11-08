//
//  PaymentListModel.m
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "PaymentListModel.h"
#import "QPMGoodsGroupedModel.h"

@implementation PaymentListModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        
        NSDictionary * data = [attributes objectForKey:@"data"];
        
        NSArray * cartGoods = [data objectForKey:@"cartGoods"];
        
        self.cartGoods = [NSMutableArray array];
        if (cartGoods.count > 0) {
            for (NSDictionary *dic in cartGoods) {
                QPMGoodsGroupedModel *goodsGroupedModel = [[QPMGoodsGroupedModel alloc] initWithAttributes:dic];
                [self.cartGoods addObject:goodsGroupedModel];
            }
        }
        
        if (cartGoods.count) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *tempData in cartGoods) {
                
                NSArray * carts = [tempData valueForKey:@"carts"];
                NSDictionary * extraData = [tempData valueForKey:@"extraData"];
                NSArray * express = [extraData valueForKey:@"express"];
                
                NSDictionary * agentInfo = [tempData valueForKey:@"agentInfo"];
                PaymentShopsModel *model = [[PaymentShopsModel alloc] init];
                model.companyName = [agentInfo objectForKey:@"companyName"];
                model.sellerId = [agentInfo objectForKey:@"sellerId"];
                model.expressArray = [[NSMutableArray alloc]initWithArray:express];
                
                if (carts.count) {
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    for (NSDictionary *tempData in carts){
                        CartGoodsModel *model = [[CartGoodsModel alloc] initWithAttributes:tempData];
                        [tempArray addObject:model];
                    }
                    
                    model.goodsArray = [[NSMutableArray alloc]initWithArray:tempArray];
                }
                
                [tempArray addObject:model];
            }
            self.shopArray = [[NSMutableArray alloc]initWithArray:tempArray];
        }
        
        NSDictionary * total = [data objectForKey:@"total"];
        self.price = [[total objectForKey:@"price"] stringValue];
        self.pay_price = [total objectForKey:@"pay_price"];
        
        NSDictionary * addDic = [data valueForKey:@"userAddresses"];
        if (addDic.count) {
            self.address_name = [addDic objectForKey:@"recipient"];
            self.address_id = [addDic objectForKey:@"addressId"];
            self.add_area_info = [addDic objectForKey:@"pcdName"];
            self.address = [addDic objectForKey:@"address"];
            self.add_provinceId = [addDic objectForKey:@"provinceId"];
            self.add_area_id = [addDic objectForKey:@"districtId"];
            self.add_city_id = [addDic objectForKey:@"cityId"];
            self.add_is_default = [[addDic objectForKey:@"isDefault"] integerValue];
            self.add_member_id = [addDic objectForKey:@"userId"];
            self.add_mob_phone = [addDic objectForKey:@"recipientMobile"];
        }
     
        NSDictionary * payDic = [data objectForKey:@"gateways"];
        NSArray * payArray = payDic.allValues;
        self.paywayArray = [NSArray arrayWithArray:payArray];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *tempData in payArray){
            if ([[tempData objectForKey:@"is_abled"] integerValue] ==1) {
                [tempArray addObject:tempData];
            }
        }
        self.usedPaywayArry = [[NSArray alloc]initWithArray:tempArray];
        
        
        // 3.红包
        self.hasCoupon = 0;

    }
    
    return self;
}

/**
{
    data =     {
        cartGoods =         (
                             {
                                 agentInfo =                 {
                                     cellphone = 13800138000;
                                     companyName = "\U6cf0\U5174\U9686";
                                     email = "123@123.com";
                                     sellerCode = 465K537O7;
                                     sellerId = 10;
                                     truename = "\U6cf0\U5174\U9686";
                                 };
                                 cartIds =                 (
                                                            904,
                                                            906
                                                            );
                                 carts =                 (
                                                          {
                                                              cartId = 904;
                                                              createdAt = "2016-05-16 13:22:46";
                                                              goodsCode = 5374V4434;
                                                              goodsIamge = "http://assets.qpfww.com/goods/0000/0355/8703/3558703/400/400/27111449126545.jpg";
                                                              goodsId = 3558703;
                                                              goodsName = "\U5feb\U8f66\U9053\U9ad8\U7ea7\U5236\U52a8\U6db2 DOT4\U5239\U8f66\U6cb9\U79bb\U5408\U5668\U5239\U8f66\U6db2 \U5408\U6210\U578b800g \U5feb\U8f66\U9053\U5239\U8f66\U6cb9 \U5feb\U8f66\U9053\U5236\U52a8\U6db2";
                                                              isActivity = 1;
                                                              isCheck = 1;
                                                              price = "128.00";
                                                              privilegeAmount = "12.80";
                                                              promotionBeginDate = "2016-04-03";
                                                              promotionEndDate = "2016-05-30";
                                                              promotionPrice = "115.20";
                                                              promotionRule = "0.9\U6298";
                                                              promotionTitle = "\U4e94\U4e00\U5feb\U8f66\U9053\U5546\U54c1\U6ee15\U4ef6\U62539\U6298";
                                                              promotionType = "\U6ee1\U4ef6\U6253\U6298";
                                                              quantity = 13;
                                                              sellerId = 10;
                                                              updatedAt = "2016-05-16 15:38:32";
                                                              userCode = 384W3N5Y7;
                                                              userId = 17;
                                                          },
                                                          {
                                                              cartId = 906;
                                                              createdAt = "2016-05-16 15:30:13";
                                                              goodsCode = C5387KY57;
                                                              goodsIamge = "http://assets.qpfww.com/goods/0000/0002/8133/28133/400/400/35601449022413.jpg";
                                                              goodsId = 28133;
                                                              goodsName = "\U5609\U4e50\U9a70\Uff08\U7eff\U724c\Uff096-QW-150 ,\Uff08100Ah\Uff09\U5609\U4e50\U9a70\U7eff\U724c\U84c4\U7535\U6c60 \U5609\U4e50\U9a70\U84c4\U7535\U6c60 \U5609\U4e50\U9a70\U7535\U6c6015";
                                                              isActivity = 1;
                                                              isCheck = 1;
                                                              price = "995.00";
                                                              privilegeAmount = "149.25";
                                                              promotionBeginDate = "2016-04-18";
                                                              promotionEndDate = "2016-05-30";
                                                              promotionPrice = "845.75";
                                                              promotionRule = "0.85\U6298";
                                                              promotionTitle = "\U4e94\U4e00\U4f73\U9a70\U84c4\U7535\U6c60\U4fc3\U950085\U6298";
                                                              promotionType = "\U76f4\U63a5\U6253\U6298";
                                                              quantity = 8;
                                                              sellerId = 10;
                                                              updatedAt = "2016-05-16 15:38:58";
                                                              userCode = 384W3N5Y7;
                                                              userId = 17;
                                                          }
                                                          );
                                 extraData =                 {
                                     balanceCredit = "40000.00";
                                     express =                     (
                                                                    {
                                                                        agentId = 10;
                                                                        distributionType = 1;
                                                                        expressId = 15;
                                                                        isFree = 0;
                                                                        price = "18.00";
                                                                    },
                                                                    {
                                                                        agentId = 10;
                                                                        distributionType = 0;
                                                                        expressId = 16;
                                                                        isFree = 1;
                                                                        price = "0.00";
                                                                    }
                                                                    );
                                 };
                                 isActivity = 1;
                                 privilegeAmount = "-64648.4";
                                 promotions =                 (
                                                               {
                                                                   privilegeAmount = "-66108.80";
                                                                   promotionBeginDate = "2016-05-14";
                                                                   promotionEndDate = "2016-05-19";
                                                                   promotionRule = "9\U6298";
                                                                   promotionTitle = "\U6253\U6298\U4fc3\U9500";
                                                                   promotionType = "\U6ee1\U989d\U6253\U6298";
                                                               },
                                                               {
                                                                   privilegeAmount = "100.00";
                                                                   promotionBeginDate = "2016-05-14";
                                                                   promotionEndDate = "2016-05-19";
                                                                   promotionRule = "100\U5143";
                                                                   promotionTitle = "\U6d4b\U8bd5";
                                                                   promotionType = "\U6ee1\U989d\U7acb\U51cf";
                                                               }
                                                               );
                                 "total_amount" = 9624;
                                 "total_pay_price" = "74272.39999999999";
                                 "total_quantity" = 21;
                             },
                             {
                                 agentInfo =                 {
                                     cellphone = 18392450694;
                                     companyName = xz;
                                     email = "616969659@qq.com";
                                     sellerCode = 8A77T44TV;
                                     sellerId = 16;
                                     truename = "\U666f\U60a6";
                                 };
                                 cartIds =                 (
                                                            905
                                                            );
                                 carts =                 (
                                                          {
                                                              cartId = 905;
                                                              createdAt = "2016-05-16 15:29:42";
                                                              goodsCode = C5387KY57;
                                                              goodsIamge = "http://assets.qpfww.com/goods/0000/0002/8133/28133/400/400/35601449022413.jpg";
                                                              goodsId = 28133;
                                                              goodsName = "\U5609\U4e50\U9a70\Uff08\U7eff\U724c\Uff096-QW-150 ,\Uff08100Ah\Uff09\U5609\U4e50\U9a70\U7eff\U724c\U84c4\U7535\U6c60 \U5609\U4e50\U9a70\U84c4\U7535\U6c60 \U5609\U4e50\U9a70\U7535\U6c6015";
                                                              isActivity = 1;
                                                              isCheck = 1;
                                                              price = "575.00";
                                                              privilegeAmount = "115.00";
                                                              promotionBeginDate = "2016-04-03";
                                                              promotionEndDate = "2016-05-30";
                                                              promotionPrice = "460.00";
                                                              promotionRule = "0.8\U6298";
                                                              promotionTitle = "\U4e94\U4e00\U4f73\U9a70\U84c4\U7535\U6c60\U4fc3\U95008\U6298";
                                                              promotionType = "\U76f4\U63a5\U6253\U6298";
                                                              quantity = 1;
                                                              sellerId = 16;
                                                              updatedAt = "2016-05-16 15:29:42";
                                                              userCode = 384W3N5Y7;
                                                              userId = 17;
                                                          }
                                                          );
                                 extraData =                 {
                                     balanceCredit = "<null>";
                                     express =                     (
                                                                    {
                                                                        agentId = 16;
                                                                        distributionType = 1;
                                                                        expressId = 11;
                                                                        isFree = 0;
                                                                        price = "300.00";
                                                                    },
                                                                    {
                                                                        agentId = 16;
                                                                        distributionType = 0;
                                                                        expressId = 12;
                                                                        isFree = 1;
                                                                        price = "0.00";
                                                                    }
                                                                    );
                                 };
                                 isActivity = 0;
                                 privilegeAmount = 115;
                                 promotions =                 (
                                 );
                                 "total_amount" = 575;
                                 "total_pay_price" = 460;
                                 "total_quantity" = 1;
                             }
                             );
        gateways =         {
            alipay =             {
                "input_charset" = "utf-8";
                "is_abled" = 0;
                key = lrful664c2ne1r70x17sqwbysnagze1f;
                mainname = "\U4e0a\U6d77\U4f73\U9a70\U7ecf\U5408\U80fd\U6e90\U79d1\U6280\U6709\U9650\U516c\U53f8";
                "notify_url" = "http://www.qpfww.com/payment/alipay/mobilenotify";
                partner = 2088121298452356;
                "pay_code" = alipay;
                "pay_name" = "\U652f\U4ed8\U5b9d";
                "pay_type" = 1;
                "seller_email" = "zu.wu@jchp.cn";
                "show_url" = "";
                "sign_type" = RSA;
                transport = http;
            };
            offlinepay =             {
                "is_abled" = 1;
                "pay_code" = offlinepay;
                "pay_name" = "\U8d27\U5230\U4ed8\U6b3e";
                "pay_type" = 7;
            };
            wxpay =             {
                appid = wx7bddfb3acc8e5343;
                appsecret = 01c6d59a3f9024db6336662ac95c8e74;
                "curl_proxy_host" = "0.0.0.0";
                "curl_proxy_port" = 0;
                "is_abled" = 0;
                key = dd149fb87dd7ee858e9c631a422329e3;
                mchid = 1289870101;
                "notify_url" = "/payment/wxpay/notify";
                "pay_code" = wxpay;
                "pay_name" = "\U5fae\U4fe1\U652f\U4ed8";
                "pay_type" = 5;
                "report_level" = 1;
            };
        };
        isDirectBuy = 0;
        total =         {
            cartIds =             (
                                   904,
                                   905,
                                   906
                                   );
            num = 22;
            "pay_price" = "74732.39999999999";
            price = 10199;
        };
        userAddresses =         {
            address = "\U9ed8\U9ed8\U9ed8";
            addressId = 41;
            cityId = 64;
            districtId = 620;
            fixedTel = "<null>";
            fullAddress = "\U7518\U8083 \U5b9a\U897f \U6e2d\U6e90\U53bf \U9ed8\U9ed8\U9ed8";
            isDefault = 0;
            isDeleted = 0;
            pcdName = "\U7518\U8083 \U5b9a\U897f \U6e2d\U6e90\U53bf";
            postcode = "<null>";
            provinceId = 5;
            recipient = "\U4f60\U9ed8\U9ed8";
            recipientMobile = 15820240405;
            userId = 17;
        };
    };
    msg = "";
    status = 1;
}
*/

@end
