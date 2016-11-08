//
//  CateTableViewCell.h
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, CateTableCellType) {
    CateTableCellTypeCate,
    CateTableCellTypeBrand,
    CateTableCellTypeCars,
};



@interface CateTableViewCell : UITableViewCell
/** 名称 */
@property (nonatomic, weak) UILabel * nameLabel;
/** 图像 */
@property (nonatomic, weak) UIImageView * iconView;

@property (nonatomic, assign) CateTableCellType cellType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
