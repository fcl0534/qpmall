//
//  CategoryModelArray.h
//  一级分类的Model
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.s
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property (nonatomic, assign) int cateId;
@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, assign) int parentId;
@property (nonatomic, copy) NSString * picture;

//是否有子目录
@property (nonatomic,assign) BOOL isChild;

@property (nonatomic,strong) NSArray *dataSubCategoryArray;
/**
 *  二级目录模型
 */
- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
