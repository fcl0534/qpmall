//
//  HomeCategoryModel.m
//  EcmallAPP
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "HomeCategoryModel.h"

@implementation HomeCategoryModel

-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.cateId = [[attributes valueForKey:@"id"] intValue];
        self.cateName = [attributes valueForKey:@"title"];
        self.imageURL = [attributes valueForKey:@"icon"];
        self.parent_id = [attributes valueForKey:@"parent_id"];
    }
    return self;
}

@end
