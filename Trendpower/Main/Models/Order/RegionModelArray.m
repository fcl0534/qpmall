//
//  RegionModelArray.m
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-17.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import "RegionModelArray.h"

@implementation RegionModelArray

/**
 *          },
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
             {
 */

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    NSArray *dataFromServer = [attributes valueForKey:@"data"];
    NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
    
 
    
    [dataFromServer enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
        
        RegionModel *model = [[RegionModel alloc] initWithAttributes:dic];
        [mutilableData addObject:model];
        if ([[dic valueForKey:@"is_default"] intValue] == 1) {
            self.defaultRow = idx;
               //NSLog(@"1---%lu",(unsigned long)idx);
        }
        
    }];
    self.dataRegionArray = [[NSArray alloc] initWithArray:mutilableData];

    return self;
}


@end
