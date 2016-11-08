//
//  HomeModel.h
//  Trendpower
//
//  Created by trendpower on 15/5/13.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "AdvertiseModel.h"
#import "HomeCategoryModel.h"
#import "HomeGoodsModel.h"
#import "BrandModel.h"

@interface HomeModel : NSObject

//@property (nonatomic, strong) NSMutableArray * countArray;//相同下标下 存储相同模型的个数
/** 类型判断: 
         0、广告  ads_1
         1、分类  cate_list
         2、精品专区 ads_2
         3、热门品牌  hot_brand
         4、广告位   ads_3
         5、广告位   ads_4
         6、广告位   ads_5
         7、热销商品推荐   recommend_list
 */
@property (nonatomic, strong) NSMutableArray * typeArray;//存储有数据的各种模型
@property (nonatomic, strong) NSMutableArray * dataHomeMedelArray;//存储有数据的各种模型

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
