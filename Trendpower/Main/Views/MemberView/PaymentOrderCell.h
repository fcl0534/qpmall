//
//  PaymentOrderCell.h
//  Trendpower
//
//  Created by trendpower on 15/5/15.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "OrderGoodsModel.h"
#import "OrderGoodsListView.h"


#define K_Cell_Goods_Height 115
#define K_Cell_Other_Height   125

@protocol PaymentOrderCellDelegate <NSObject>

@optional
/**
 *  点击显示全部箭头
 */
- (void) paymentOrderCellClickedArrowBtn:(UIButton *)arrowBtn indexPath:(NSIndexPath *)indexPath;

- (void) paymentOrderCellClickedCancelBtn:(UIButton *)butoon  indexPath:(NSIndexPath *)indexPath;

- (void) paymentOrderCellClickedPayBtn:(UIButton *)butoon indexPath:(NSIndexPath *)indexPath;

- (void)paymentOrderCellClickedConfirmBtn:(UIButton *)butoon indexPath:(NSIndexPath *)indexPath;

@end

@interface PaymentOrderCell : UITableViewCell

/**
 *  是否显示全部商品 判断是否显示全部商品
 */
@property (nonatomic, assign) BOOL isShowAllGoods;
/**
 *  商品模型
 */
@property (nonatomic, strong) OrderModel * orderModel;
/**
 *  当前Cell下标
 */
@property (nonatomic, strong) NSIndexPath * indexPath;


@property (nonatomic, weak) id<PaymentOrderCellDelegate>delegate;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
