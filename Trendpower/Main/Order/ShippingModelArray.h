//
//  ShippingModelArray.h
//  EcmallAPP
//
//  Created by zhanghongbo on 13-12-31.
//  Copyright (c) 2013年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShippingModelArray : NSObject

@property (nonatomic,strong) NSArray *data;

-(instancetype)initWithAttributes:(NSArray *)attributes;

@end
