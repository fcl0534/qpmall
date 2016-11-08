//
//  CarTypeLevel1Model.h
//  Trendpower
//
//  Created by trendpower on 15/9/29.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  "brand": "安驰",
 "brand_logo": "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/560a282ec2ee9.png",
 "firstchar": "A",
 "keyId": "CAC0220M0001"
 */

@interface CarTypeLevel1Model : NSObject

@property (nonatomic,strong) NSString *brand;
@property (nonatomic,strong) NSString *brand_logo;
@property (nonatomic,strong) NSString *keyId;

/**
 *  用于品牌筛选时，选中的品牌
 */
@property (nonatomic, assign) BOOL isSelectBrand;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;
@end
