//
//  PaymentOrderVC.h
//  Trendpower
//
//  Created by HTC on 15/5/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

//订单列表页

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, OrderOprationType) {
    OrderOprationTypeCancel = 6,
    OrderOprationTypeConfirm = 4,
    OrderOprationTypeReturn = 201,
    OrderOprationTypeExchange = 301
};

@interface QPMOrderListViewController : BaseViewController

/**
  *  当前选中的标签
 */
@property (nonatomic, assign) NSInteger selectIndex;

@end
