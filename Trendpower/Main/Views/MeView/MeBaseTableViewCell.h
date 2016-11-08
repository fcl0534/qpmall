//
//  MeBaseTableViewCell.h
//  EcoDuo
//
//  Created by trendpower on 15/11/7.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeBaseTableViewCell : UITableViewCell

@property (nonatomic, weak) UIImageView * leftImageView;
@property (nonatomic, weak) UILabel * nameLbl;
@property (nonatomic, weak) UILabel * detailLbl;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
