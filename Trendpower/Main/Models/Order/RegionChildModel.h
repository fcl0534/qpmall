//
//  RegionChildModel.h
//  Trendpower
//
//  Created by trendpower on 15/5/22.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegionSubchildModel.h"

@interface RegionChildModel : NSObject



@property (nonatomic, copy) NSString * regionId;
@property (nonatomic, copy) NSString * regionName;
@property (nonatomic, copy) NSString * parentId;
@property (nonatomic, copy) NSString * isDefault;
@property (nonatomic, copy) NSString * level;

/**
 *  三级的数据模型
 */
@property (nonatomic, strong) NSArray * dataSubChildModelArray;
/**
 *  默认三级地址所在row【只有编辑时才有，新建时默认第一个三级就可以】
 */
@property (nonatomic, assign) NSUInteger defaultRow;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

/**
 *  {
         "child": [
                     {
                        "child": [
                                     {
                                         "level": "3",
                                         "parent_id": "2",
                                         "region_id": "3",
                                         "region_name": "东城区"
                                     },
                                     {
                                         "level": "3",
                                         "parent_id": "2",
                                         "region_id": "7",
                                         "region_name": "朝阳区"
                                     },
                                     {
                                         "level": "3",
                                         "parent_id": "2",
                                         "region_id": "18",
                                         "region_name": "平谷区"
                                     }
                                   ],
                         "is_default": 1,
                         "level": "2",
                         "parent_id": "1",
                         "region_id": "2",
                         "region_name": "市辖区"
                     },
                     {
                         "is_default": 0,
                         "level": "2",
                         "parent_id": "1",
                         "region_id": "19",
                         "region_name": "北京周边"
                     }
                   ],
         "is_default": 1,
         "level": "1",
         "parent_id": "0",
         "region_id": "1",
         "region_name": "北京市"
    },
 */

@end
