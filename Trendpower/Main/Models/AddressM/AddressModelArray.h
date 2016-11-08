//
//  AddressModelArray.h
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-2.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModelArray : NSObject

@property (nonatomic,strong) NSArray *dataAddressArray;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
