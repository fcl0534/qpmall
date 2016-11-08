//
//  PaymentWayModelArray.h
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-2.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentWayModelArray : NSObject

@property (nonatomic,strong) NSArray *data;

-(instancetype)initWithAttributes:(NSArray *)attributes;

@end
