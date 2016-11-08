//
//  ShopCartModelArray.h
//  EcmallAPP
//
//  Created by zhanghongbo on 13-12-28.
//  Copyright (c) 2013年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartModelArray : NSObject

/** 商品实际总价 */
@property (nonatomic, copy) NSString * priceAmount;
/** 商品原总价 */
@property (nonatomic, copy) NSString * priceOriginal;
/** 商品节省总价 */
@property (nonatomic, copy) NSString * priceSaving;
/** 商品节省总价 */
@property (nonatomic, copy) NSString * quantity;
/** 商品列表模型 */
@property (nonatomic, strong) NSArray *dataShopCartArray;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
