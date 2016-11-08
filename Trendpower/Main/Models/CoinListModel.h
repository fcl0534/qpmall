//
//  CoinListModel.h
//  Trendpower
//
//  Created by HTC on 16/4/25.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoinListModel : NSObject

/** 商品code */
@property (nonatomic, strong) NSString *goodsCode;
/** 经销商id */
@property (nonatomic, strong) NSString *agentId;
/** 商品名 */
@property (nonatomic, strong) NSString *title;
/** 商品图片 */
@property (nonatomic, strong) NSString *goodsImage;
/** 市场价格 */
@property (nonatomic, assign) float marketPrice;
/** 所需积分 */
@property (nonatomic, assign) NSInteger point;

/** 模型init */
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
