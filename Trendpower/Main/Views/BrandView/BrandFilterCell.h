//
//  BrandFilterCell.h
//  Trendpower
//
//  Created by HTC on 16/3/2.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandFilterCell : UITableViewCell

/** 选择 */
@property (nonatomic, weak) UIButton * selectBtn;
/** 名称 */
@property (nonatomic, weak) UILabel * nameLabel;
/** 图像 */
@property (nonatomic, weak) UIImageView * iconView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
