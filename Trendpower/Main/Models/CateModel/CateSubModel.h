//
//  CateSubModel.h
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CateSubModel : NSObject

@property (nonatomic, assign) NSInteger cateId;
@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, copy) NSString * imageUrl;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
