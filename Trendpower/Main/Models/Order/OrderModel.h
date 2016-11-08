//
//  OrderModel.h
//  EcmallAPP
//
//  Created by zhanghongbo on 14-2-20.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

/** 订单id */
@property (nonatomic, copy) NSString * orderId;
/** 订单编号 */
@property (nonatomic, copy) NSString * orderSn;
/** 下单时间 */
@property (nonatomic, copy) NSString * orderTime;
/** 运费 */
@property (nonatomic, copy) NSString * shipCost;
/** 产品总价 */
@property (nonatomic, copy) NSString * goodsAmount;
/** 订单总价 */
@property (nonatomic, copy) NSString * orderAmount;

@property (nonatomic, copy) NSString * payAmount;

@property (nonatomic, copy) NSString * companyName;

/** 支付方式 */
@property (nonatomic, assign) NSInteger payType;

@property (nonatomic, copy) NSString * isPay;
/** 订单的类型 （空为全部  10货到付款  11等待买家付款 20买家已付款，等待卖家发货  30卖家已发货   40交易成功  0交易已取消 ） */
@property(nonatomic, assign) NSInteger status;

/** 订单商品模型数组 */
@property (nonatomic,strong) NSDictionary * expressDic;

/** 订单商品模型数组 */
@property (nonatomic,strong) NSArray * dataGoodsArray;

/** 是否是积分订单 */
@property (nonatomic, assign) BOOL isPointOrder;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;

- (instancetype) initWithShopCart:(NSArray *)attributes;

@end
