//
//  PintsChangeBarView.h
//  Trendpower
//
//  Created by HTC on 16/4/26.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Masonry.h>

#import "PointsGoodsDetailModel.h"

@interface PintsChangeBarView : UIView

typedef void(^PintsChangeBarViewBlock)(NSInteger counts);

@property (nonatomic, copy, nullable) PintsChangeBarViewBlock clickedChangedBlock;

@property (nonatomic, strong) PointsGoodsDetailModel *pointModel;

@end
