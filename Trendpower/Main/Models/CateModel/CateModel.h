//
//  CateModel.h
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CateSubModel.h"

@interface CateModel : NSObject

@property (nonatomic, assign) long cateId;
@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, assign) long parentId;
@property (nonatomic, copy) NSString * imageUrl;

//是否有子目录
@property (nonatomic,assign) BOOL isChild;

@property (nonatomic,strong) NSArray *cateSubArray;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
