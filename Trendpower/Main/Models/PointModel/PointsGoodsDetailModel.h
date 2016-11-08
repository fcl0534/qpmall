//
//  PointsGoodsDetailModel.h
//  Trendpower
//
//  Created by 张帅 on 16/10/9.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointsGoodsDetailModel : NSObject

/** 商品id */
@property (nonatomic, assign) NSInteger goodsId;
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
/** 内容 */
@property (nonatomic, strong) NSString *content;

/** 模型init */
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
