//
//  RegionChildModel.m
//  Trendpower
//
//  Created by trendpower on 15/5/22.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "RegionChildModel.h"


@implementation RegionChildModel



-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        
        self.regionId = [attributes valueForKey:@"region_id"];
        self.regionName = [attributes valueForKey:@"region_name"];
        self.parentId = [attributes valueForKey:@"parent_id"];
        self.isDefault = [attributes valueForKey:@"is_default"];
        self.level = [attributes valueForKey:@"level"];
        
        //如果是默认地址，就到下一级
        if([self.isDefault intValue] == 1){
            
            NSArray *childArray = [attributes valueForKey:@"child"];
            NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
            [childArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
                
                RegionSubchildModel *model = [[RegionSubchildModel alloc] initWithAttributes:dic];
                [mutilableData addObject:model];
                
                if ([[dic valueForKey:@"is_default"] intValue] == 1) {
                    self.defaultRow = idx;
                       // NSLog(@"3---%d",idx);
                }
                
            }];
            
            self.dataSubChildModelArray = [[NSArray alloc] initWithArray:mutilableData];
            
        }
        
        
    }
    return self;
}

@end
