//
//  GoodsListVC.h
//  Trendpower
//
//  Created by HTC on 16/1/26.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, GoodsListCellType){
    GoodsListCellTypeRow, //行对齐
    GoodsListCellTypeCol // 有列对齐
};

typedef NS_ENUM(NSUInteger, CarTypeFindStep) {
    CarTypeFindStepO = 0,
    CarTypeFindStep1,
    CarTypeFindStep2,
    CarTypeFindStep3,
    CarTypeFindStep4,
};

typedef NS_ENUM(NSUInteger, GoodsFilterType) {
    GoodsFilterTypeNone = 0,  // 没有
    GoodsFilterTypeCategory,  // 商品分类
    GoodsFilterTypeBrand,     // 商品品牌
    GoodsFilterTypeCarSeries, // 车型的惟一号
    GoodsFilterTypeVinCode, // VIN码
    GoodsFilterTypeGoodsName, // 搜索名字
    GoodsFilterTypeCarBrand,  // 车型的id
    GoodsFilterTypeCarModel,  // 车型名称
    GoodsFilterTypeEmssion,   // 车排量
    GoodsFilterTypeYear,      // 车年份
};

@interface GoodsListViewController : BaseViewController

@property (nonatomic, assign) BOOL isUnShowFilterName;
/** 进来的筛选名字 */
@property (nonatomic, copy) NSString * filterName;
/** 进来的筛选类型 */
@property (nonatomic, assign) GoodsFilterType filterType;

/** 分类Id */
@property (nonatomic, copy) NSString * cateId;
/** 品牌id（多个用,分割） */
@property (nonatomic, copy) NSString * brandIds;
/** 车型id */
@property (nonatomic, copy) NSString * carSeriesId;
/** 车型id */
@property (nonatomic, copy) NSString * vinCode;
/** 搜索的商品名称 */
@property (nonatomic, copy) NSString * goodsName;

/** 车型查找的时候必须存在
 1=车型品牌 2=车型 3=排量 4=年份 */
@property (nonatomic, assign) CarTypeFindStep step;
/** 车型品牌id 如：9 */
@property (nonatomic, copy) NSString * carBrandId;
/** 车型名称 如：3系 */
@property (nonatomic, copy) NSString * carModel;
/** 排量 如：2.5l */
@property (nonatomic, copy) NSString * carEmssion;
/** 年份 如：2008 */
@property (nonatomic, copy) NSString * carYear;





@property(nonatomic, assign) GoodsListCellType cellType;

@end
