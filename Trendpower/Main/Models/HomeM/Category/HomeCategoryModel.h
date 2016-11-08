//
//  HomeCategoryModel.h
//  EcmallAPP
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HomeCategoryModel : NSObject
/**
 *    {
             "cate_id": "25163",
             "cate_name": "机油",
             "id": "13",
             "img_url": "",
             "sort_id": "255",
             "store_id": "81"
       },
 */
@property (nonatomic) int cateId;
@property (nonatomic, copy) NSString * cateName;
@property (nonatomic, copy) NSString * imageURL;
@property (nonatomic, copy) NSString * parent_id;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
