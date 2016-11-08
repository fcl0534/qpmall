//
//  ProductShopCarBarView.h
//  Trendpower
//
//  Created by HTC on 15/5/10.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductAddShopCarBarDelegate <NSObject>

@optional

- (void) productAddShop:(UIButton *)btn;
- (void) productCollectShop:(UIButton *)btn;

@end

@interface ProductShopCarBarView : UIView

@property (nonatomic, weak) id<ProductAddShopCarBarDelegate>delegate;

@end
