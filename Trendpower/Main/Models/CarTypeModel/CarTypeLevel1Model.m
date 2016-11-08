//
//  CarTypeLevel1Model.m
//  Trendpower
//
//  Created by trendpower on 15/9/29.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "CarTypeLevel1Model.h"

@implementation CarTypeLevel1Model
-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if(self = [super init])
    {
//        self.brand = [attributes valueForKey:@"brand"];
//        self.brand_logo = [attributes valueForKey:@"brand_logo"];
//        self.keyId = [attributes valueForKey:@"keyId"];
        
        self.brand = [attributes valueForKey:@"title"];
        self.brand_logo = [attributes valueForKey:@"file_name"];
        self.keyId = [attributes valueForKey:@"id"];

        //self.backgroundColor = [attributes valueForKey:@"backgroundColor"];
    }
    return self;
}
@end

/**
 *  "brand": "安驰",
 "brand_logo": "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/560a282ec2ee9.png",
 "firstchar": "A",
 "keyId": "CAC0220M0001"
 */