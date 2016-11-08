//
//  CompanyInfoModel.h
//  Tendpower
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyInfoModel : NSObject

/**  关于*/
@property (nonatomic,strong) NSString *aboutUs;
/**  logo*/
@property (nonatomic,strong) NSString *companyLogo;
/**  企业名*/
@property (nonatomic,strong) NSString *companyName;
/**  企业简介*/
@property (nonatomic,strong) NSString *companyProfile;
/**  联系方法*/
@property (nonatomic,strong) NSString *contactUs;
/**  协议*/
@property (nonatomic,strong) NSString *protocol;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
