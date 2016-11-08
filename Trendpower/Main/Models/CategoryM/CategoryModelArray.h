//
//  CategoryModelArray.h
//  EcmallAPP
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModelArray : NSObject


@property (nonatomic,strong) NSArray *dataCategory;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
