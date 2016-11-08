//
//  QPMPaymentSubmitViewController.h
//  Trendpower
//
//  Created by 张帅 on 16/11/7.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, QPMPaymentSubmitSource) {
    QPMPaymentSubmitSourceCart = 1,     //从购物车页面支付
    QPMPaymentSubmitSourceOrder = 2,    //从订单页面支付
};

@interface QPMPaymentSubmitViewController : BaseViewController

@property (nonatomic, strong) NSMutableDictionary *infoDic;

@property (nonatomic, assign) QPMPaymentSubmitSource paymentSubmitSource;

@end
