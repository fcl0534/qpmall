//
//  CategoryModel.h
//  二级分类的Model
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCategoryModel : NSObject

@property (nonatomic) int cateId;
@property (nonatomic,strong) NSString *cateName;
@property (nonatomic,strong) NSString *parent_id;
//是否有子目录
@property (nonatomic,assign) BOOL isChild;
/**
 *  三级目录模型
 */
@property (nonatomic,strong) NSArray *dataThreeCategoryArray;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
