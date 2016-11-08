//
//  ProductPropView.h
//  Trendpower
//
//  Created by trendpower on 15/5/20.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "ProductModel.h"

@protocol ProductPropViewDelegate <NSObject>

@optional

- (void) productPropViewClickedCloseBtn:(UIButton *)btn;
- (void) productPropViewClickedShopCartBtn:(UIButton *)btn specId:(NSString *)specId cartCounts:(NSInteger)cartCounts;
//提示信息
- (void) productPropViewShowError:(NSString *)error;

@end


@interface ProductPropView : UIView

@property (nonatomic, weak) id<ProductPropViewDelegate> delegate;

/** 头像图片 */
@property (nonatomic, weak) UIImageView * imageView;


@property (nonatomic, strong) ProductModel * productModel;

@end
