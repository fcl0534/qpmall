//
//  ThreeSubCategoryModel.m
//  Trendpower
//
//  Created by trendpower on 15/5/12.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "ThreeSubCategoryModel.h"

@implementation ThreeSubCategoryModel

-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.cateId = [[attributes valueForKey:@"cate_id"] intValue];
        self.cateName = [attributes valueForKey:@"cate_name"];
        self.parent_id = [attributes valueForKey:@"parent_id"];
    }
    return self;
}
@end
