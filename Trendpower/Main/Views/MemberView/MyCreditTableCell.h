//
//  MyCreditCell.h
//  Trendpower
//
//  Created by HTC on 16/2/27.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyCreditModel.h"

@interface MyCreditTableCell : UITableViewCell

/**
 *  模型
 */
@property (nonatomic, strong) MyCreditModel * myCreditModel;
/**
 *  当前Cell下标
 */
@property (nonatomic, strong) NSIndexPath * indexPath;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
