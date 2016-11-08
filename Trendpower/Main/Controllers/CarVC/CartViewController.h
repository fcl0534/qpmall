//
//  CartVC.h
//  ZZBMall
//
//  Created by trendpower on 15/7/27.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "BaseViewController.h"

@interface CartViewController : BaseViewController
//只要不是从会员中心进来的，加上这个
@property (nonatomic, assign) BOOL isFromProduct;

@end
