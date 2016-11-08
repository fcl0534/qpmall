//
//  PointsDetailModel.h
//  Trendpower
//
//  Created by HTC on 16/4/26.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJExtension.h"

@class PointsDetail_Data,PointsDetail_Info,PointsDetail_Goods_Spec,PointsDetail_Img_List;
@interface PointsDetailModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) PointsDetail_Data *data;

@property (nonatomic, assign) NSInteger status;

@end
@interface PointsDetail_Data : NSObject

@property (nonatomic, strong) NSArray<PointsDetail_Goods_Spec *> *goods_spec;

@property (nonatomic, strong) NSArray<PointsDetail_Img_List *> *img_list;

@property (nonatomic, strong) PointsDetail_Info *info;

@property (nonatomic, assign) NSInteger can_use_coin;

@end

@interface PointsDetail_Info : NSObject

@property (nonatomic, copy) NSString *coin;

@property (nonatomic, copy) NSString *webDescription;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *is_free_shipping;

@property (nonatomic, copy) NSString *spec_name_2;

@property (nonatomic, copy) NSString *picture;

@property (nonatomic, copy) NSString *stock;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *market_price;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *cate_name;

@property (nonatomic, copy) NSString *spec_qty;

@property (nonatomic, copy) NSString *store_id;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *sort_order;

@property (nonatomic, copy) NSString *spec_name_1;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *cate_id;

@end

@interface PointsDetail_Goods_Spec : NSObject

@property (nonatomic, copy) NSString *stock;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *spec_2;

@property (nonatomic, copy) NSString *spec_id;

@property (nonatomic, copy) NSString *spec_photo;

@property (nonatomic, copy) NSString *spec_1;

@end

@interface PointsDetail_Img_List : NSObject

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *image_id;

@property (nonatomic, copy) NSString *image_url;

@property (nonatomic, copy) NSString *sort_order;

@property (nonatomic, copy) NSString *store_id;

@end

