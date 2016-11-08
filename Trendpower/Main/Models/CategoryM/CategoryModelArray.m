//
//  CategoryModelArray.m
//  EcmallAPP
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "CategoryModelArray.h"
#import "CategoryModel.h"

@implementation CategoryModelArray

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        NSArray *dataFromServer = [attributes valueForKey:@"data"];
        
        NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
        
        for (NSDictionary *categoryDic in dataFromServer)
        {
            CategoryModel *model = [[CategoryModel alloc] initWithAttributes:categoryDic];
            [mutilableData addObject:model];
        }
        
        self.dataCategory = [[NSArray alloc] initWithArray:mutilableData];
    }
    return self;
}

@end
