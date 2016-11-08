//
//  MyPointsModel.h
//  Trendpower
//
//  Created by 张帅 on 16/10/11.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPointsModel : NSObject

/** 会员id */
@property (nonatomic, assign) NSInteger userId;

/** 经销商id */
@property (nonatomic, assign) NSInteger agentId;

/** 经销商公司名 */
@property (nonatomic, strong) NSString *agentCompanyName;

/** 总积分 */
@property (nonatomic, assign) NSInteger totalPoint;

/** 剩余积分 */
@property (nonatomic, assign) NSInteger balancePoint;

/** 冻结积分 */
@property (nonatomic, assign) NSInteger frozenPoint;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
