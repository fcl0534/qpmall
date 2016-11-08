//
//  ShopCartModel.h
//  EcmallAPP
//
//  Created by zhanghongbo on 13-12-28.
//  Copyright (c) 2013年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartModel : NSObject
/** 订单的惟一标记ID */
@property (nonatomic) int64_t shoppingId;
/**  商品ID */
@property (nonatomic) int64_t goodsId;
/**  商品名称*/
@property (nonatomic,strong) NSString *goodsName;
/** 用户ID */
@property (nonatomic) int64_t userId;
/** 规格ID */
@property (nonatomic) int64_t specId;
/** 规格描述 */
@property (nonatomic,strong) NSString *specification;
/** 原价 */
@property (nonatomic, copy) NSString * price;
/** 会员价 */
@property (nonatomic, copy) NSString * priceMember;
/** 总价 */
@property (nonatomic, copy) NSString * priceTotal;
/** 购买数量 */
@property (nonatomic) int quantity;
/** 产品图片 */
@property (nonatomic,strong) NSString *goodsImgURL;

/** 产品是否存在 1、商品可购买  0、商品下架、买完、属性改变时  */
@property (nonatomic, assign) BOOL exist;


-(instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
