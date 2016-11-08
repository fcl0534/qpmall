//
//  QPMPaymentSeparateView.h
//  Trendpower
//
//  Created by 张帅 on 16/11/7.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QPMPaymentSeparateViewDelegate <NSObject>

- (void)toSettleAccounts:(NSInteger)sellerId;

@end

@interface QPMPaymentSeparateView : UIView

@property (nonatomic, strong) NSMutableArray *models;

@property (nonatomic, weak) id<QPMPaymentSeparateViewDelegate> delegate;

- (void)show;

- (void)hide;

@end
