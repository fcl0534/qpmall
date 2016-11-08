//
//  CateModel.m
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "CateModel.h"

@implementation CateModel
-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(self)
    {
        self.cateId = [[attributes valueForKey:@"id"] intValue];
        self.cateName = [attributes valueForKey:@"title"];
        self.parentId = [[attributes valueForKey:@"parent_id"] intValue];
        self.imageUrl = [attributes valueForKey:@"icon"];
        NSArray *dataFromServer = [attributes valueForKey:@"sub_cate_list"];
        NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
        
        // 为方便，人工增加
        CateSubModel *model = [[CateSubModel alloc]init];
        model.cateName = @"全部";
        [mutilableData addObject:model];
        
        for (NSDictionary *categoryDic in dataFromServer){
            CateSubModel *model = [[CateSubModel alloc] initWithAttributes:categoryDic];
            [mutilableData addObject:model];
        }
        self.cateSubArray = [[NSArray alloc] initWithArray:mutilableData];
        self.isChild = self.cateSubArray.count;
    }
    return self;
}
@end
