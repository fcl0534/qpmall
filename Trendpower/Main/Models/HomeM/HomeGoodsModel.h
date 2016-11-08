//
//  HomeGoodsModel.h
//  Trendpower
//
//  Created by HTC on 16/2/28.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeGoodsModel : NSObject


/** 产品ID */
@property (nonatomic, assign) NSInteger goodsId;
/** 产品名称 */
@property (nonatomic, copy) NSString *goodsName;
/** 默认图片url */
@property (nonatomic, copy) NSString * goodsImageUrl;
/** 价格 */
@property (nonatomic,copy) NSString * goodsPrice;

@property (nonatomic, assign) NSInteger is_activity;

/** 产品模型init */
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

/**
"file_name" = "http://assets.qpfww.com/goods/0000/0002/2703/22703/400/400/45721449126160.jpg";
"good_price" = "45.00";
"goods_code" = 4XW5X7X76;
"goods_no" = KC0100001;
id = 22703;
title = "\U5feb\U8f66\U9053\U73af\U4fdd\U96ea\U79cd 250g \U6c7d\U8f66\U7a7a\U8c03\U4e13\U7528\U5236\U51b7\U5236 \U51b7\U5a92 R134A \U6c1f\U5229\U6602 \U5feb\U8f66\U9053\U96ea\U79cd";
 */

@end
