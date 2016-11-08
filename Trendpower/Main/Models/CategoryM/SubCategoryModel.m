//
//  CategoryModel.m
//  EcmallAPP
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "SubCategoryModel.h"
#import "ThreeSubCategoryModel.h"

@implementation SubCategoryModel

-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.cateId = [[attributes valueForKey:@"cate_id"] intValue];
        self.cateName = [attributes valueForKey:@"cate_name"];
        self.parent_id = [attributes valueForKey:@"parent_id"];
        self.isChild  = [[attributes valueForKey:@"is_child"] intValue];
        
        NSArray *dataFromServer = [attributes valueForKey:@"sub_cate_list"];
        NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
        for (NSDictionary *categoryDic in dataFromServer)
        {
            ThreeSubCategoryModel *model = [[ThreeSubCategoryModel alloc] initWithAttributes:categoryDic];
            [mutilableData addObject:model];
        }
        self.dataThreeCategoryArray = [[NSArray alloc] initWithArray:mutilableData];
    }
    return self;
}

@end
