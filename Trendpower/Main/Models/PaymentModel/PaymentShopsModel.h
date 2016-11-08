//
//  PaymentShopsModel.h
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CartGoodsModel.h"


@interface PaymentShopsModel : NSObject

@property (nonatomic, copy) NSString * companyName;
@property (nonatomic, copy) NSString * sellerId;
@property (nonatomic, copy) NSString * store_goods_total;
@property (nonatomic, copy) NSString * store_freight;

/** 购买商品的模型数组 */
@property (nonatomic, strong) NSMutableArray * goodsArray;

/** 配送费用数组 */
@property (nonatomic, strong) NSMutableArray * expressArray;

/**
 *  选中的配送方式, 普通0 加急1
 */
@property (nonatomic, assign) BOOL isDistributionTypeOne;//加急


- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
