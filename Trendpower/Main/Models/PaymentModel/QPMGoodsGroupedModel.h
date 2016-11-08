//
//  QPMGoodsGroupedModel.h
//  Trendpower
//
//  Created by hjz on 16/5/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPMGoodsGroupedModel : NSObject
/** 是否参与了活动 */
@property (nonatomic, assign) NSInteger isActivity;
/** 省了多少钱 */
@property (nonatomic, assign) float privilegeAmount;
/** 小计应付 */
@property (nonatomic, assign) float total_pay_price;
/** 促销信息 */
@property (nonatomic, strong) NSMutableArray *promotions;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
