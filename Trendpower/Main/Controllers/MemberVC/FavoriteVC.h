//
//  FavoriteVC.h
//  Trendpower
//
//  Created by trendpower on 15/5/14.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "BaseViewController.h"

#import "UserInfoModel.h"

typedef NS_ENUM(NSInteger, ProductDisplayType){
    DisplayTypeRow,
    DisplayTypeCol
};

@interface FavoriteVC : BaseViewController

@property (nonatomic, strong) UserInfoModel * userModel;

@property(nonatomic) ProductDisplayType displayType;

@end
