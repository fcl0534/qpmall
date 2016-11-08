//
//  OrderGoodsListView.h
//  Trendpower
//
//  Created by trendpower on 15/5/15.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineThroughLabel.h"
#import <Masonry.h>

@interface OrderGoodsListView : UIView

/**
 *  商品图片
 */
@property (nonatomic, weak) UIImageView * imagesView;
/**
 *  商品名称
 */
@property (nonatomic, weak) UILabel * nameLabel;
///**
// *  商品规格
// */
//@property (nonatomic, weak) UILabel * specLabel;
///**
// *  商品原价
// */
//@property (nonatomic, weak) LineThroughLabel * priceLabel;
/**
 *  会员价
 */
@property (nonatomic, weak) UILabel * priceMemberLabel;
/**
 *  数量
 */
@property (nonatomic, weak) UILabel * subTotalLabel;
///**
// *  商品总价格
// */
//@property (nonatomic, weak) UILabel * priceTotalLabel;

/**
 *  头部线条
 */
@property (nonatomic, weak) UIView * lineTop;

/**
 *  底部线条
 */
@property (nonatomic, weak) UIView * lineBottom;



@end
