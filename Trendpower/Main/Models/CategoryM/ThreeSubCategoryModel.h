//
//  ThreeSubCategoryModel.h
//  Trendpower
//
//  Created by trendpower on 15/5/12.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeSubCategoryModel : NSObject
@property (nonatomic) int cateId;
@property (nonatomic,strong) NSString *cateName;
@property (nonatomic,strong) NSString *parent_id;
////是否有子目录
//@property (nonatomic,assign) BOOL isChild;
///**
// *  四级目录模型
// */
//@property (nonatomic,strong) NSArray *dataSubCategoryArray;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

@end
