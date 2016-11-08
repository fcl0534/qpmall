//
//  PaymentPayTypeCell.h
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PaymentPayTypeCellDelegate <NSObject>

@optional
- (void) paymentPayTypeCellClickedBtn:(UIButton *)btn withIndexPath:(NSIndexPath *)indexPath;

@end

@interface PaymentPayTypeCell : UITableViewCell

@property (nonatomic, weak) id<PaymentPayTypeCellDelegate> delegate;

@property (nonatomic, weak) UIImageView * imageRight;
@property (nonatomic, weak) UIImageView * imageLeft;
@property (nonatomic, weak) UILabel * nameLbl;

@property (nonatomic, strong) NSIndexPath * indexPath;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
