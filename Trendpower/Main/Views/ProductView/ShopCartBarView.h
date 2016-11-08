//
//  ShopCartBarView.h
//  Trendpower
//
//  Created by HTC on 15/5/20.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShopCartBarViewDelegate <NSObject>

@optional
- (void) shopCartBarViewClickedCollectionBtn:(UIButton *)btn;
- (void) shopCartBarViewClickedShopCartBtn:(UIButton *)btn;
- (void) shopCartBarViewClickedPromptPaymentCartBtn:(UIButton *)btn;
@end


@interface ShopCartBarView : UIView

@property (nonatomic, weak) id<ShopCartBarViewDelegate> delegate;

@property (nonatomic, weak) UIButton * collectionBtn;

/** 没有任何经销商在卖, 按钮变灰色 */
@property (nonatomic, assign) BOOL isNoStores;

@end
