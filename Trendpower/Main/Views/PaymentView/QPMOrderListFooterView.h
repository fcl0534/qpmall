//
//  PaymentFooterView.h
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

//确认订单 section footer

#import "BaseView.h"

@class PaymentShopsModel, QPMGoodsGroupedModel;


@protocol PaymentFooterViewDelegate <NSObject>

@optional
- (void) paymentFooterViewDidSelectExpress:(PaymentShopsModel *)model inSection:(NSInteger)section;

- (void)promotionButtonClickWithGoodsGroupedModel:(QPMGoodsGroupedModel *)goodsGroupedModel;

@end

@interface QPMOrderListFooterView : BaseView

@property (nonatomic, weak) id<PaymentFooterViewDelegate> delegate;

/**
 *  当前Cell下标
 */
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) PaymentShopsModel * shopModel;
@property (nonatomic, strong) QPMGoodsGroupedModel *goodsGroupedModel;
@end
