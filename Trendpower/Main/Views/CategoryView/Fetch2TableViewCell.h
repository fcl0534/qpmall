//
//  Fetch2TableViewCell.h
//  Trendpower
//
//  Created by HTC on 15/9/30.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Fetch2TableViewCell : UITableViewCell
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
