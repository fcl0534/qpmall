//
//  FetchTableViewCell.h
//  Trendpower
//
//  Created by trendpower on 15/9/29.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FetchTableViewCell : UITableViewCell
/**
 *  图片
 */
@property (nonatomic, weak) UIImageView * logoView;
/**
 *  一级
 */
@property (nonatomic, weak) UILabel * nameLabel;
/**
 *  二级
 */
@property (nonatomic, weak) UILabel * detailLabel;

@property (nonatomic, weak) UIButton * rightBtn;

@property (nonatomic, weak) UIImageView * rightImage;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
