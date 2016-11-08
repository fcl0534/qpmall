//
//  CateModelArray.h
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CateModel.h"

@interface CateModelArray : NSObject

@property (nonatomic, strong) NSArray * cateArray;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
