//
//  PaymentCouponCell.h
//  Trendpower
//
//  Created by HTC on 15/5/22.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentCouponModel.h"

@interface PaymentCouponCell : UITableViewCell

/**
 *  地址模型
 */
@property (nonatomic, strong) PaymentCouponModel * couponModel;
/**
 *  当前Cell下标
 */
@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic, assign) BOOL isSelectCoupon;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
