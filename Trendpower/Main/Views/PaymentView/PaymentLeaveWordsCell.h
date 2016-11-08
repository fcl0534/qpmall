//
//  PaymentLeaveWordsView.h
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTextView.h"

@interface PaymentLeaveWordsCell : UITableViewCell

@property (nonatomic, weak) CustomTextView * leaveWordsView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
