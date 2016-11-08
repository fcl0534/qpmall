//
//  AdvertiseModel.h
//  EcmallAPP
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AdvertiseModel :NSObject

/**
 * 广告类别 1网址 2商品分类ID 3商品ID 4商品品牌ID
 */
@property (nonatomic, copy) NSString * ad_type;
@property (nonatomic, copy) NSString * ad_value;
@property (nonatomic, copy) NSString * ad_title;
@property (nonatomic, copy) NSString * ad_image;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
