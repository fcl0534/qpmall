//
//  ProductNameView.h
//  Trendpower
//
//  Created by HTC on 15/5/9.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "ProductModel.h"


#import "TCStepperView.h"


@protocol ProductNameViewDelegate <NSObject>

@optional

- (void) productNameViewClickedCloseBtn:(UIButton *)btn productModel:(ProductModel *)productModel;

/** 点击规格按钮 */
- (void)chooseDifferentSpec:(NSInteger)specId;

@end


@interface ProductInfomationView : UIView

@property (nonatomic, weak) id<ProductNameViewDelegate> delegate;

/**
 *  数量编辑器
 */
@property (nonatomic, strong) TCStepperView * stepper;


/** 商品详情 model */
@property (nonatomic, strong) ProductModel *productModel;

@end
