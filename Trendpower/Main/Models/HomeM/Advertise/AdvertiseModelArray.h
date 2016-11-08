//
//  AdvertiseModel.h
//  EcmallAPP
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertiseModelArray : NSObject

@property (nonatomic,strong) NSArray *dataAD;
/** 广告图片个数 为0即不显示广告栏 */
@property (nonatomic, assign) NSInteger counts;
/** 判断类型 0、广告 1、分类 2、商品列表 */
@property (nonatomic, assign) NSInteger type;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
