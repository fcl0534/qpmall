//
//  QPMPaymentSeparateModel.h
//  Trendpower
//
//  Created by 张帅 on 16/11/7.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPMPaymentSeparateModel : NSObject

/** 商家id */
@property (nonatomic, assign) NSInteger sellerId;

/** 商家编号 */
@property (nonatomic, strong) NSString *sellerCode;

/** 商家手机号 */
@property (nonatomic, strong) NSString *cellphone;

/** 商家邮箱 */
@property (nonatomic, strong) NSString *email;

/** 商家真实姓名 */
@property (nonatomic, strong) NSString *truename;

/** 商家公司名称 */
@property (nonatomic, strong) NSString *companyName;

/** 商家公司简称 */
@property (nonatomic, strong) NSString *companyShortName;

/** 商品总数 */
@property (nonatomic, assign) NSInteger total_quantity;

/** 商品总价 */
@property (nonatomic, assign) float total_amount;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
