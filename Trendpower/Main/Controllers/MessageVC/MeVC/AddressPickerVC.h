//
//  AddressPickerVC.h
//  Trendpower
//
//  Created by HTC on 16/1/24.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "BaseViewController.h"

@class AddressPickerVC;
@protocol AddressPickerVCDelegate <NSObject>

@optional
- (void)addressPickerVC:(AddressPickerVC *)addressPickerVC;
@end

typedef NS_ENUM(NSUInteger, AddressType) {
    AddressTypeProvince,
    AddressTypeCity,
    AddressTypeDistrict,
};
/**
 *  1:省 2:市 (县) 3:区(镇)
 */

@interface AddressPickerVC : BaseViewController

@property (weak, nonatomic)  id<AddressPickerVCDelegate> delegate;

@property (nonatomic, assign) AddressType addressType;
@property (nonatomic, strong) NSMutableDictionary * addressDic;

@end
