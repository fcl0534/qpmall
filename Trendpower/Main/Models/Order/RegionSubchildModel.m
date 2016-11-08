//
//  RegionSubchildModel.m
//  Trendpower
//
//  Created by trendpower on 15/5/22.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "RegionSubchildModel.h"

@implementation RegionSubchildModel


-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.regionId = [attributes valueForKey:@"region_id"];
        self.regionName = [attributes valueForKey:@"region_name"];
        self.parentId = [attributes valueForKey:@"parent_id"];
        self.isDefault = [attributes valueForKey:@"is_default"];
        self.level = [attributes valueForKey:@"level"];
        
    }
    return self;
}


@end
