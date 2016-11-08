//
//  PaymentAddressView.h
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "PaymentListModel.h"

@protocol PaymentAddressViewDelegate <NSObject>

@optional
- (void) paymentAddressViewClicked;

@end


@interface PaymentAddressCell : UITableViewCell

@property (nonatomic, weak) id<PaymentAddressViewDelegate> delegate;

/** 地址模型 */
@property (nonatomic, strong) PaymentListModel * paymentListModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end