//
//  QPMOrderListCell.h
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartGoodsModel;

@interface QPMOrderListCell : UITableViewCell
/**
 *  商品模型
 */
@property (nonatomic, weak) CartGoodsModel * goodsModel;
/**
 *  当前Cell下标
 */
@property (nonatomic, strong) NSIndexPath * indexPath;

//+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
