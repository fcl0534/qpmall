//
//  Goods.h
//  TabBarNavigationDemo
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ProductImageModel.h"
#import "ProductSpecificationModel.h"
#import "ProductStandardMdoel.h"

@interface ProductModel : NSObject
/** 产品ID */
@property (nonatomic, copy) NSString * productId;
/** 商家id */
@property (nonatomic, copy) NSString *seller_id;
/** 产品单位 */
@property (nonatomic, copy) NSString * unit_title;
/** 产品名称 */
@property (nonatomic, copy) NSString * title;
/** 产品描述 */
@property (nonatomic, copy) NSString * descriptions;
/** 产品图片详情wap url */
@property (nonatomic, copy) NSString * detail_images;
/** 品牌名 */
@property (nonatomic, copy) NSString * brand_title;
/** 销量 */
@property (nonatomic, copy) NSString * sales_volumn;
/** 产品总的库存量 */
@property (nonatomic, copy) NSString *sku;

/** 没有任何经销商在卖 */
@property (nonatomic, assign) BOOL isNoStores;

/** 是否已收藏这个产品 */
@property (nonatomic, assign) BOOL isCollection;

/** 购物车商品数量 */
@property (nonatomic,copy) NSString * cartCounts;


/** 规格种类数量 0 、1 、2种 规格  * */
@property (nonatomic, assign) NSInteger specCount;
/** 规格名称1 */
@property (nonatomic, copy) NSString *specName1;
/** 规格名称2 */
@property (nonatomic,copy) NSString *specName2;
/** 规格名称1 字典 用 Key:NSNumber - Value:名称 */
@property (nonatomic,copy) NSDictionary *specNameDic;
/** 规格名称2 字典 */
@property (nonatomic,copy) NSDictionary *specName2Dic;



/**
 *  有两种属性时，用字典存储
 */
/** 规格1对应全部2的 字典 */
@property (nonatomic,copy) NSDictionary *dataSpec1Dic;
/** 规格2对应全部1的 字典 */
@property (nonatomic,copy) NSDictionary *dataSpec2Dic;
/** 规格名称1 数组 */
@property (nonatomic,copy) NSArray *spec1NameArray;
/** 规格名称2 数组 */
@property (nonatomic,copy) NSArray *spec2NameArray;


/** 默认图片url */
@property (nonatomic,copy) NSString * defaultImageUrl;

/** 原价 */
@property (nonatomic,copy) NSString * price;
/** 会员价格 */
@property (nonatomic,copy) NSString * good_price;


/** 产品图片url数据模型数据 */
@property (nonatomic,copy) NSArray *goods_images;
/** 产品经销商规格属性模型数组 */
@property (nonatomic,copy) NSArray *goods_stores;


/** 产品规格 */
@property (nonatomic, strong) NSArray *goods_standards;

/** 产品模型init */
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

/**

 {
 data =     {
 "detail_images" = "<img src=\"http://assets.qpfww.com/editor/goods/0000/0002/8163/28163/68841449022577.jpg\" alt=\"\" /><img src=\"http://assets.qpfww.com/editor/goods/0000/0002/8163/28163/88651449022583.jpg\" alt=\"\" /><img src=\"http://assets.qpfww.com/editor/goods/0000/0002/8163/28163/24371449022589.jpg\" alt=\"\" /><img src=\"http://assets.qpfww.com/editor/goods/0000/0002/8163/28163/39721449022591.jpg\" alt=\"\" /><img src=\"http://assets.qpfww.com/editor/goods/0000/0002/8163/28163/31711449022593.jpg\" alt=\"\" /><img src=\"http://assets.qpfww.com/editor/goods/0000/0002/8163/28163/56611449022595.jpg\" alt=\"\" /><img src=\"http://assets.qpfww.com/editor/goods/0000/0002/8163/28163/72251449022597.jpg\" alt=\"\" /><img src=\"http://assets.qpfww.com/editor/goods/0000/0002/8163/28163/46771449022600.jpg\" alt=\"\" /><img src=\"http://assets.qpfww.com/editor/goods/0000/0002/8163/28163/59301449022605.jpg\" alt=\"\" /><img src=\"http://assets.qpfww.com/editor/goods/0000/0002/8163/28163/73031449022611.jpg\" alt=\"\" />";
 
 
 "goods_images" =         (
     {
     "created_at" = "2016-03-29 03:27:33";
     "deleted_at" = 0;
     "file_name" = "http://assets.qpfww.com/goods/0000/0002/8163/28163/400/400/72581449022566.jpg";
     "file_type" = 1;
     "goods_id" = 28163;
     id = 4433;
     "is_default" = 1;
     "is_deleted" = 0;
     sort = 0;
     "updated_at" = "2016-03-29 03:27:33";
     }
     );
 
 "goods_info" =         {
     "brand_title" = "\U5609\U4e50\U9a70";
     "car_part_id" = 0;
     "goods_code" = 6T8457XU3;
     "goods_no" = JL0100026;
     id = 28163;
     publicity = "\U6052\U4e45\U52a8\U529b \U4e50\U4eab\U9a70\U9a8b";
     title = "\U5609\U4e50\U9a70\Uff08\U7eff\U724c\Uff096-QW-200 , N200\Uff08200Ah\Uff09\U5609\U4e50\U9a70\U7eff\U724c\U84c4\U7535\U6c60 \U5609\U4e50\U9a70\U84c4\U7535\U6c60 \U5609\U4e50\U9a70\U7535\U6c60";
     "unit_title" = "\U53ea";
     };
 
 "goods_stores" =         (
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
         {
         "company_name" = xz;
         credit = 0;
         "credit_time" = 0;
         "good_price" = "943.00";
         goodsPromotions =                 {
         begindate = "2016-04-03";
         enddate = "2016-05-30";
         rule = "8\U6298";
         title = "\U4e94\U4e00\U4f73\U9a70\U84c4\U7535\U6c60\U4fc3\U95008\U6298";
         };
         "goods_code" = 6T8457XU3;
         "goods_id" = 28163;
         "goods_price" = "943.00";
         orderDiscountPromotions =                 (
         );
         orderGiftPromotions =                 (
         );
         orderPricePromotions =                 (
         );
         qq = 616969659;
         "sales_volumn" = 23;
         "seller_id" = 16;
         sku = 9977;
         tel = "";
         title = "\U5609\U4e50\U9a70\Uff08\U7eff\U724c\Uff096-QW-200 , N200\Uff08200Ah\Uff09\U5609\U4e50\U9a70\U7eff\U724c\U84c4\U7535\U6c60 \U5609\U4e50\U9a70\U84c4\U7535\U6c60 \U5609\U4e50\U9a70\U7535\U6c60";
         "unit_title" = "\U53ea";
         volumn = 23;
         }
         );
 
 isActivity = 1;
 isCollection = 0;
 };
 
 msg = "\U8bf7\U6c42\U6210\U529f";
 status = 1;
 }

  */
@end
