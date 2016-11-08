//
//  ProductSpecification.h
//  TabBarNavigationDemo
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProductSpecificationModel : NSObject

@property (nonatomic, copy) NSString * seller_id;   //规格编号seller_id
/** 商品 id */
@property (nonatomic, copy) NSString * goods_id;
/** 商品title */
@property (nonatomic, copy) NSString * title;
/** 经销商名称 */
@property (nonatomic, copy) NSString * company_name;   //规格名称
@property (nonatomic, copy) NSString * specName2;
/** 产品价格 */
@property (nonatomic, copy) NSString * good_price;
@property (nonatomic, copy) NSString * price;
/**
 *  当前属性的照片
 */
@property (nonatomic, copy) NSString * specPhotoURL;

/**  当前属性的库存 */
@property (nonatomic, copy) NSString * sku;
/**  当前属性的库存 */
@property (nonatomic, copy) NSString * sales_volumn;

@property (nonatomic, copy) NSString *credit;
@property (nonatomic, copy) NSString *credit_time;
@property (nonatomic, copy) NSString *goods_code;

/** 促销信息， begindate, enddate, rule, title */
@property (nonatomic, copy) NSDictionary *goodsPromotions;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;

/**

 {
 "company_name" = "\U6cf0\U5174\U9686";
 credit = "40000.00";
 "credit_time" = 2592000;
 "good_price" = "1228.00";
 goodsPromotions =                 {
 begindate = "2016-04-18";
 enddate = "2016-05-30";
 rule = "8.5\U6298";
 title = "\U4e94\U4e00\U4f73\U9a70\U84c4\U7535\U6c60\U4fc3\U950085\U6298";
 };
 "goods_code" = 6T8457XU3;
 "goods_id" = 28163;
 "goods_price" = "1228.00";
 orderDiscountPromotions =                 (
 );
 orderGiftPromotions =                 (
 );
 orderPricePromotions =                 (
 );
 qq = "";
 "sales_volumn" = 23;
 "seller_id" = 10;
 sku = 977;
 tel = "";
 title = "\U5609\U4e50\U9a70\Uff08\U7eff\U724c\Uff096-QW-200 , N200\Uff08200Ah\Uff09\U5609\U4e50\U9a70\U7eff\U724c\U84c4\U7535\U6c60 \U5609\U4e50\U9a70\U84c4\U7535\U6c60 \U5609\U4e50\U9a70\U7535\U6c60";
 "unit_title" = "\U53ea";
 volumn = 5483;
 },
 
 
 */

@end
