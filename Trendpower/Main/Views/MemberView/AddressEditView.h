//
//  AddressEditView.h
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextView.h"
#import <Masonry.h>
#import "AddressModel.h"

@protocol AddressEditViewDelegate <NSObject>

@optional
- (void)AddressEditViewClickedRegionArea;

- (void)AddressEditViewClickedButton:(UIButton *)btn consigneeField:(UITextField *)consigneeField mobphoneField:(UITextField *)mobphoneField regionNameField:(UITextField *)regionNameField addressView:(CustomTextView *)addressView regionId:(NSString *)regionid defaultBtn:(UIButton *)defaultBtn;

@end

@interface AddressEditView : UIView

@property (weak, nonatomic)  id<AddressEditViewDelegate>delegate;
/**
 *  是否新建地址
 */
@property (nonatomic, assign) BOOL isFromNewAddress;

/**
 *  模型
 */
@property (nonatomic, strong) AddressModel * addressModel;

- (void)setArea:(NSString *)area;

@end