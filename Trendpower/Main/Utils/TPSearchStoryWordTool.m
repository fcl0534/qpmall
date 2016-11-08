//
//  TPSearchStoryWordTool.m
//  Trendpower
//
//  Created by HTC on 16/3/2.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "TPSearchStoryWordTool.h"


#define MBCSearchStoryWord @"TPSearchStoryWordTool_Key"
/**
 *  分隔词
 */
#define ComponentWord   @"$$$"

@implementation TPSearchStoryWordTool

+ (BOOL)setStoryWord:(NSDictionary *)wordDic{
    //搜索词存储处理
    NSUserDefaults * dbl = [self getNSUserDefaults];
    NSMutableArray * oldWordArray = [dbl valueForKey:MBCSearchStoryWord];
    if (!oldWordArray.count) {//第一次存
        NSMutableArray * array = [NSMutableArray array];
        [array addObject:wordDic];
        return [self setWord:array forKey:MBCSearchStoryWord];
    }else{
        
        NSDictionary * oldDic = [oldWordArray lastObject];
        
        if (![[oldDic objectForKey:KEY_searchName] isEqualToString:[wordDic objectForKey:KEY_searchName]]) {//判断最后一个记录是否相同，如果不相同才记录
            if(oldWordArray.count == 10){ //已经有10个记录，则删除最后一个，并在开关加增一个
                NSMutableArray * array = [NSMutableArray arrayWithArray:oldWordArray];
                [array removeObjectAtIndex:0];
                [array addObject:wordDic];
                return [self setWord:array forKey:MBCSearchStoryWord];
            }else{ // 存储
                NSMutableArray * array = [NSMutableArray arrayWithArray:oldWordArray];
                [array addObject:wordDic];
                return [self setWord:array forKey:MBCSearchStoryWord];
            }
        }else{
            // 已经存在
            return NO;
        }
    }
}


+ (NSMutableArray *)getStoryWords{
    NSUserDefaults * dbl = [self getNSUserDefaults];
    NSMutableArray * storyWord = [dbl valueForKey:MBCSearchStoryWord];
    // 倒序
    NSArray * array = [[storyWord reverseObjectEnumerator] allObjects];
    return [NSMutableArray arrayWithArray:array];
}

+ (BOOL)removeAllStoryWord{
    NSUserDefaults * dbl = [self getNSUserDefaults];
    [dbl removeObjectForKey:MBCSearchStoryWord];
    return YES;
}

#pragma mark - other
+ (BOOL)setWord:(nullable id)value forKey:(NSString *)key{
    NSUserDefaults * dbl = [self getNSUserDefaults];
    [dbl setValue:value forKey:key];
    return [dbl synchronize];
}

+ (NSUserDefaults *)getNSUserDefaults{
    return [NSUserDefaults standardUserDefaults];
}

@end
