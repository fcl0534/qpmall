//
//  PaymentCouponListVC.h
//  ZZBMall
//
//  Created by trendpower on 15/12/2.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import "BaseViewController.h"
#import "PaymentListModel.h"

@interface PaymentCouponListVC : BaseViewController

/**
 *  购物车goodsId
 */
@property (nonatomic, copy) NSString * cartGoods;
/** 内容数据 */
@property (nonatomic, strong) PaymentListModel * payModel;

@end
