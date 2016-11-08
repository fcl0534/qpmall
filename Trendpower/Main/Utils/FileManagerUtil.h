//
//  FileManagerUtil.h
//  Trendpower
//
//  Created by trendpower on 15/8/31.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagerUtil : NSObject

+(NSString *)cachesPath;
+(float)fileSizeAtPath:(NSString *)path;
+(float)folderSizeAtPath:(NSString *)path;
+(void)clearCache:(NSString *)path;

@end
