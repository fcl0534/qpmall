//
//  AddressAgentModelArray.h
//  Trendpower
//
//  Created by 张帅 on 16/7/19.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressAgentModelArray : NSObject

@property (nonatomic,strong) NSArray *agents;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
