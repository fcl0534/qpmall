//
//  CartTableviewCell.h
//  ZZBMall
//
//  Created by trendpower on 15/8/7.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartGoodsModel;

@protocol CartTableViewCellDelegate <NSObject>

@optional
// 选择
-(void) shopCartCellClickedSelectButton:(UIButton *)btn shopCartModel:(CartGoodsModel * )shopCartModel indexPath:(NSIndexPath * )indexPath;

// 点击图片或文字
-(void) shopCartCellClickedImageViewOrGoodsNameWithShopCartModel:(CartGoodsModel * )shopCartModel indexPath:(NSIndexPath * )indexPath;

// 删除
-(void) shopCartCellClickedDeletcBtn:(UIButton *)btn shopCartModel:(CartGoodsModel * )shopCartModel indexPath:(NSIndexPath * )indexPath;

// 数值改变
-(void) shopCartCellStepperValueChanged:(NSInteger) currentValue;
-(void) shopCartCellStepperValueEqualMaxValue:(NSInteger) maxValue;
-(void) shopCartCellStepperValueChangIsAdd:(BOOL)isAdd countField:(UITextField*)counteField currentValue:(NSInteger) currentValue  shopCartModel:(CartGoodsModel * )shopCartModel indexPath:(NSIndexPath * )indexPath;

//文本框代理
- (void) shopCartCellStepperTextBeginEditing:(UITextField*)counteField shopCartModel:(CartGoodsModel * )shopCartModel indexPath:(NSIndexPath * )indexPath;
- (void) shopCartCellStepperTextDidEndEditing:(UITextField*)counteField oldText:(NSInteger)oldText shopCartModel:(CartGoodsModel * )shopCartModel indexPath:(NSIndexPath * )indexPath;
- (void) shopCartCellStepperTextDidChanged:(UITextField*)counteField shopCartModel:(CartGoodsModel * )shopCartModel indexPath:(NSIndexPath * )indexPath;
@end


@interface CartTableviewCell : UITableViewCell

@property (nonatomic, weak) id<CartTableViewCellDelegate>delegate;
/**
 *  商品模型
 */
@property (nonatomic, weak) CartGoodsModel * goodsModel;
/**
 *  当前Cell下标
 */
@property (nonatomic, strong) NSIndexPath * indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
