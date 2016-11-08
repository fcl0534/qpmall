//
//  RegionModel.h
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-17.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegionChildModel.h"

/**
 *    {
         "is_default": 0,
         "level": "1",
         "parent_id": "0",
         "region_id": "657",
         "region_name": "黑龙江省"
      },
 */

@interface RegionModel : NSObject

@property (nonatomic, copy) NSString * regionId;
@property (nonatomic, copy) NSString * regionName;
@property (nonatomic, copy) NSString * parentId;
@property (nonatomic, copy) NSString * isDefault;
@property (nonatomic, copy) NSString * level;

/**
 *  二级的数据模型
 */
@property (nonatomic, strong) NSArray * dataChildModelArray;
/**
 *  默认二级地址所在row
 */
@property (nonatomic, assign) NSUInteger defaultRow;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
