//
//  OrderGoodsModel.h
//  EcmallAPP
//
//  Created by zhanghongbo on 14-2-20.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderGoodsModel : NSObject

@property (nonatomic) int64_t recId;
@property (nonatomic) int64_t userId;
@property (nonatomic) NSString *sessionId;
@property (nonatomic) int storeId;
@property (nonatomic) int64_t productId;
@property (nonatomic,strong) NSString *productName;

@property (nonatomic) int64_t specId;  //规格ID

@property (nonatomic, copy) NSString *specification; //规格描述

@property (nonatomic, copy) NSString * price; //单价

@property (nonatomic, copy) NSString * priceMember; //单价

@property (nonatomic, copy) NSString * subtotal; //小计

@property (nonatomic) int quantity; //购买数量

@property (nonatomic, copy) NSString *productImageURL; //产品图片

/** 产品是否存在 1、商品可购买  0、商品下架、买完、属性改变时  */
@property (nonatomic, assign) BOOL exist;

/** 商品积分 */
@property (nonatomic, assign) NSInteger goodsPoint;


/**
 *  另外赋值的外部属性
 */
//全部商品总价
@property (nonatomic, copy) NSString * totalPrice;
//全部商品数量
@property (nonatomic, copy) NSString * totalQuantity;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
