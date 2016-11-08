//
//  PointsInfoModel.h
//  Trendpower
//
//  Created by 张帅 on 16/10/24.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PointsInfoModel : NSObject

@property (nonatomic, assign) CGFloat totalPoint;

@property (nonatomic, assign) CGFloat totalBalancePoint;

@property (nonatomic, strong) NSArray *myPoints;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
