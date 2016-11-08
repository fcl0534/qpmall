//
//  AddressListTableViewCell.h
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@protocol AddressListCellDelegete <NSObject>

@optional
- (void)clickedDefaultBtn:(UIButton *)btn addressModel:(AddressModel * )addressModel indexPath:(NSIndexPath * )indexPath;

- (void)clickedEditBtn:(UIButton *)btn addressModel:(AddressModel * )addressModel indexPath:(NSIndexPath * )indexPath;

- (void)clickedDeleteBtn:(UIButton *)btn addressModel:(AddressModel * )addressModel indexPath:(NSIndexPath * )indexPath;

@end


@interface AddressListTableViewCell : UITableViewCell


/**
 *  商品模型
 */
@property (nonatomic, strong) AddressModel * addressModel;
/**
 *  当前Cell下标
 */
@property (nonatomic, strong) NSIndexPath * indexPath;


@property (nonatomic, weak) id<AddressListCellDelegete>delegate;


+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end
