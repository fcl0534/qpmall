//
//  AdvertiseModel.m
//  首页广告每个图片的Model
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "AdvertiseModel.h"

@implementation AdvertiseModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if ([super init]) {
        self.ad_type = [attributes valueForKey:@"ad_type"];
        self.ad_value = [attributes valueForKey:@"ad_value"];
        self.ad_title = [attributes valueForKey:@"title"];
        self.ad_image = [attributes valueForKey:@"file_name"];
    }
    return self;
}

@end
