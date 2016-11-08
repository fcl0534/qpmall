//
//  HomeGoodsModel.m
//  Trendpower
//
//  Created by HTC on 16/2/28.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "HomeGoodsModel.h"

@implementation HomeGoodsModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(self)
    {
        //1.产品详情
        self.goodsId = [[attributes valueForKey:@"id"] integerValue];
        self.goodsName = [attributes valueForKey:@"title"];
        self.goodsPrice = [attributes valueForKey:@"good_price"];
        self.goodsImageUrl = [attributes valueForKey:@"file_name"];
        self.is_activity = [[attributes valueForKey:@"is_activity"] integerValue];
    }
    return self;
}
@end
