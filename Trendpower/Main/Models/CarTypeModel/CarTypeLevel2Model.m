//
//  CarTypeLevel2Model.m
//  Trendpower
//
//  Created by trendpower on 15/9/29.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "CarTypeLevel2Model.h"

@implementation CarTypeLevel2Model
-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if(self = [super init])
    {
        self.brand_id = [attributes valueForKey:@"brand_id"];
        self.brand_name = [attributes valueForKey:@"brand_name"];
        self.brand_logo = [attributes valueForKey:@"brand_logo"];
        //self.backgroundColor = [attributes valueForKey:@"backgroundColor"];
    }
    return self;
}
@end
