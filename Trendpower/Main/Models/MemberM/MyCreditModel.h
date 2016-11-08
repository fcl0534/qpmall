//
//  MyCreditModel.h
//  Trendpower
//
//  Created by HTC on 16/2/27.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCreditModel : NSObject
/** 帐单期 */
@property (nonatomic,strong) NSString * creditTime;
/** 总信用分 */
@property (nonatomic,strong) NSString * creditLimit;
/** 可用信用 */
@property (nonatomic,strong) NSString * balanceCredit;
@property (nonatomic,strong) NSString * sellerTrueName;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
/**
 *
 balanceCredit = "13769.03";
 createdAt = 1450943240;
 creditId = 1;
 creditLimit = "10000.00";
 creditTime = 60;
 sellerCompanyName = jy;
 sellerId = 22;
 sellerTrueName = "景悦";
 updatedAt = 1452071113;
 userId = 8;
 */
@end
