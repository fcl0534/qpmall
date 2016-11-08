//
//  PointsPaymentVC.h
//  Trendpower
//
//  Created by 张帅 on 16/10/9.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "BaseViewController.h"

#import "PaymentListModel.h"

@interface PointsPaymentVC : BaseViewController

/**
 *  立即支付
 */
@property (nonatomic, assign) BOOL isDirectBuy;
/**
 *  购物车goodsId
 */
@property (nonatomic, copy) NSString * cartGoods;

@property (nonatomic, strong) PaymentListModel * payModel;

@end
