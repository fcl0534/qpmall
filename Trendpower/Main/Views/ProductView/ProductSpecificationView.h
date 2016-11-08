//
//  ProductSpecificationView.h
//  Trendpower
//
//  Created by HTC on 15/5/9.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface ProductSpecificationView : UIView
/**
 *  创建商品详情页面  商品规格视图
 */
- (instancetype) initWithFrame:(CGRect)frame productModel:(ProductModel *)productModel;

@end