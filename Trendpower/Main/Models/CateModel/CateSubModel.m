//
//  CateSubModel.m
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "CateSubModel.h"

@implementation CateSubModel
-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(self)
    {
        self.cateId = [[attributes valueForKey:@"id"] integerValue];
        self.cateName = [attributes valueForKey:@"title"];
        self.parentId = [[attributes valueForKey:@"parent_id"] integerValue];
        self.imageUrl = [attributes valueForKey:@"icon"];
    }
    return self;
}
@end
