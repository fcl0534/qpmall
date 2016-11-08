//
//  PaymentListVC.h
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

//确认订单页

#import "BaseViewController.h"
#import "PaymentListModel.h"

@interface QPMOrderConfirmViewController : BaseViewController

/**
 *  立即支付
 */
@property (nonatomic, assign) BOOL isDirectBuy;
/**
 *  购物车goodsId
 */
@property (nonatomic, copy) NSString * cartGoods;

@property (nonatomic, strong) PaymentListModel * payModel;

/** 经销商id */
@property (nonatomic, assign) NSInteger sellerId;

@end
