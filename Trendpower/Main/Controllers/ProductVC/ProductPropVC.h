//
//  ProductPropVC.h
//  Trendpower
//
//  Created by HTC on 15/5/20.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"
#import "UIViewController+KNSemiModal.h"

@interface ProductPropVC : BaseViewController

/**
 *  是否立即付款
 */
@property (nonatomic, assign) BOOL isPaymentType;
@property (nonatomic, strong) ProductModel * productModel;

@end
