//
//  PointsGoodsDetailModel.m
//  Trendpower
//
//  Created by 张帅 on 16/10/9.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "PointsGoodsDetailModel.h"

@implementation PointsGoodsDetailModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.goodsId = [[attributes valueForKey:@"goodsId"] integerValue];
        self.goodsCode = [attributes valueForKey:@"goodsCode"];
        self.agentId = [attributes valueForKey:@"agentId"];
        self.title = [attributes valueForKey:@"title"];
        self.goodsImage = [attributes valueForKey:@"goodsImage"];
        self.marketPrice = [[attributes valueForKey:@"marketPrice"] floatValue];
        self.point = [[attributes valueForKey:@"point"] integerValue];
        self.content = [attributes valueForKey:@"content"];
    }
    return self;
}

@end
