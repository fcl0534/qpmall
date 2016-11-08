//
//  CartGoodsModel.h
//  ZZBMall
//
//  Created by trendpower on 15/8/7.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartGoodsModel : NSObject

@property (nonatomic, copy) NSString * cartId;
@property (nonatomic, copy) NSNumber * goodsAgentSku;
@property (nonatomic, copy) NSNumber * goodsAgentStatus;
@property (nonatomic, assign) BOOL is_check;
@property (nonatomic, copy) NSString * goodsId;
@property (nonatomic, copy) NSString * goodsImage;
@property (nonatomic, copy) NSString * goodsName;
@property (nonatomic, copy) NSNumber * overSku;
/** 原价 */
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * quantity;

/** 商品 icon */
@property (nonatomic, copy) NSString * goodsIamge;

/** 是否参加促销活动 */
@property (nonatomic, assign) NSInteger isActivity;
/** 促销描述 */
@property (nonatomic, copy) NSString *promotionType;
/** 促销价格 */
@property (nonatomic, copy) NSString *promotionPrice;

/** 规格id */
@property (nonatomic, assign) NSInteger goodsStandardId;

// 父级赋值
@property (nonatomic, copy) NSString * companyName;
@property (nonatomic, copy) NSString * sellerId;
@property (nonatomic, copy) NSString * userId;

//积分
@property (nonatomic, assign) NSInteger point;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

 /**
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
 }
 */


@end
