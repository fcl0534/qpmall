//
//  ProductStandardMdoel.m
//  Trendpower
//
//  Created by 张帅 on 16/8/21.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "ProductStandardMdoel.h"

@implementation ProductStandardMdoel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.standardId = [[attributes valueForKey:@"id"] integerValue];
        self.isSelected = [[attributes valueForKey:@"is_selected"] boolValue];
        self.title = [attributes valueForKey:@"title"];
    }
    return self;
}

@end
