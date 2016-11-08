//
//  AddressAgentModel.h
//  Trendpower
//
//  Created by 张帅 on 16/7/19.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressAgentModel : NSObject

@property (nonatomic, assign) NSInteger agentId;

@property (nonatomic, copy) NSString *user_code;

@property (nonatomic, copy) NSString *cellphone;

@property (nonatomic, copy) NSString *company_name;

@property (nonatomic, copy) NSString *company_short_name;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
