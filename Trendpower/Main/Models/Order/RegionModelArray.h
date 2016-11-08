//
//  RegionModelArray.h
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-17.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegionModel.h"

@interface RegionModelArray : NSObject

/**
 *  一级
 */
@property (nonatomic,strong) NSArray *dataRegionArray;

/**
 *  默认一级地址所在row
 */
@property (nonatomic, assign) NSUInteger defaultRow;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
