
//
//  CollectionModel.m
//  Trendpower
//
//  Created by HTC on 16/3/14.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(self)
    {
        //1.产品详情
        self.goodsId = [attributes valueForKey:@"goodsId"];
        self.goodsName = [attributes valueForKey:@"title"];
//        self.goodsPrice = [attributes valueForKey:@"good_price"];
        self.goodsImageUrl = [attributes valueForKey:@"goodsImages"];
    }
    return self;
}

@end
