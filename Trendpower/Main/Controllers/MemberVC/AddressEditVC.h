//
//  AddressEditVC.h
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"

@protocol AddressEditVCDelegate <NSObject>
@optional

- (void) addressEditVCPaymentSaveSuccess;

@end

@interface AddressEditVC : BaseViewController

@property (nonatomic, weak) id<AddressEditVCDelegate> delegate;


@property (nonatomic, strong) AddressModel * addressModel;

@property (nonatomic, assign) BOOL isFromNewAddress;
// 购物车结算时，如果没有地址，就跳到新地址
@property (nonatomic, assign) BOOL isFromPayment;

@end
