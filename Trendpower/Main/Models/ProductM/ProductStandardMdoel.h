//
//  ProductStandardMdoel.h
//  Trendpower
//
//  Created by 张帅 on 16/8/21.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductStandardMdoel : NSObject

/** 规格id */
@property (nonatomic, assign) NSInteger standardId;

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/** 标题 */
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
