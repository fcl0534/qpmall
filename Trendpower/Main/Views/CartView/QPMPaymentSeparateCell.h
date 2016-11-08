//
//  QPMPaymentSeparateCell.h
//  Trendpower
//
//  Created by 张帅 on 16/11/7.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QPMPaymentSeparateModel;

@protocol QPMPaymentSeparateCellDelegate <NSObject>

- (void)toSettleAccounts:(NSInteger)sellerId;

@end

@interface QPMPaymentSeparateCell : UITableViewCell

@property (nonatomic, strong) QPMPaymentSeparateModel *model;

@property (nonatomic, weak) id<QPMPaymentSeparateCellDelegate> delegate;

@end
