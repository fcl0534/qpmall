//
//  GoodsListModel.h
//
//  QPMGoodsModel.h
//  Trendpower
//
//  Created by hjz on 16/5/8.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPMGoodsModel : NSObject

/** 产品ID */
@property (nonatomic, assign) NSInteger goodsId;
/** 产品名称 */
@property (nonatomic, copy) NSString *title;
/** 默认图片url */
@property (nonatomic, copy) NSString * file_name;
/** 价格 */
@property (nonatomic,copy) NSString * good_price;
/** 是否参加促销活动 */
@property (nonatomic, assign) BOOL isActivity;

/** 商品是否经销 */
@property (nonatomic, copy) NSString *is_sell;

/** 产品模型init */
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

/**
    "check_status": "0",
    "company_name": "泰兴隆",
    "file_name": "http://assets.qpfww.com/goods/0000/0002/6013/26013/83091449040625.jpg",
    "goods_brand_title": "方牌",
    "goods_code": "4N83TCA45",
    "goods_no": "FPCH10075",
    "goods_status": "1",
    "id": "26013",
    "is_source": "2",
    "relation_goods_ids": null,
    "sku": "50000",
    "source_id": "10",
    "title": "方牌机油滤清器CH10075进口宝马530i 宝马X3 xDrive 28i",
    "warning_sku": "0"
 */

@end
