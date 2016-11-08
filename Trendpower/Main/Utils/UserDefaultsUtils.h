//
//  UserDefaultsUtils.h
//  Trendpower
//
//  Created by trendpower on 15/5/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KTP_USER_ID   @"userId"
#define KTP_KEY       @"appToken"
@interface UserDefaultsUtils : NSObject

+ (NSString *) getUserId;
+ (NSString *) getKey;


+ (void) setInteger:(NSInteger)value forKey:(NSString *)key;
+ (void) setFloat:(float)value forKey:(NSString *)key;
+ (void) setDouble:(double)value forKey:(NSString *)key;
+ (void) setBool:(BOOL)value forKey:(NSString *)key;
+ (void) setURL:(NSURL *)url forKey:(NSString *)key;

+ (void) setValue:(nullable id)value byKey:(NSString*) key;

+ (void) setValueFromDictionary:(NSDictionary*) dic;

+ (id) getValueByKey:(NSString*) key;
+(BOOL)getBOOLByKey:(NSString *)key;

+ (void) removeObjectByKey:(NSString*) key;

+ (void) removeAllObject;

@end
