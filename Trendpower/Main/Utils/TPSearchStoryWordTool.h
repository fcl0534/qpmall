//
//  TPSearchStoryWordTool.h
//  Trendpower
//
//  Created by HTC on 16/3/2.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Key
 */
#define KEY_searchId @"searchId"
#define KEY_searchName @"searchName"
#define KEY_searchType @"searchType"
#define KEY_searchVINResult @"searchVINResult"

/**
 *  搜索类型
 */
#define KEY_searchType_word @"word"
#define KEY_searchType_category @"category"
#define KEY_searchType_brand     @"brand"
#define KEY_searchType_VIN     @"VIN"


@interface TPSearchStoryWordTool : NSObject


/**
 *  存储历史word
 *
 *  @param word
 *
 *  @return 返回NO，说明跟最新的词重复
 */
+ (BOOL)setStoryWord:(NSDictionary *)wordDic;

+ (NSMutableArray *)getStoryWords;

+ (BOOL)removeAllStoryWord;


@end
