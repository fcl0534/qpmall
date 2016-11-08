//
//  UserDefaultsUtils.m
//  Trendpower
//
//  Created by trendpower on 15/5/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "UserDefaultsUtils.h"

@implementation UserDefaultsUtils


+ (void)setInteger:(NSInteger)value forKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

+ (void)setFloat:(float)value forKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setFloat:value forKey:key];
    [defaults synchronize];
}

+ (void)setDouble:(double)value forKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setDouble:value forKey:key];
    [defaults synchronize];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

+ (void)setURL:(NSURL *)url forKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setURL:url forKey:key];
    [defaults synchronize];
}


+(void)setValue:(nullable id)value byKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}


+(void)setValueFromDictionary:(NSDictionary *)dic{
    NSEnumerator *keyEnumerator = [dic keyEnumerator];
    for (NSString *key in keyEnumerator) {
        NSString *value=[dic objectForKey:key];
        if(![value isKindOfClass:[NSNull class]]&&value!=nil){
            NSString * valueStr = [NSString stringWithFormat:@"%@",value];
            [self setValue:valueStr byKey:key];
        }else{
            NSLog(@"the value of key %@ is null",key);
        }
    }
}

+ (NSString *) getUserId{
    return [[self getValueByKey:KTP_USER_ID] length]?[self getValueByKey:KTP_USER_ID]:@"";
}

+ (NSString *) getKey{
    return [[self getValueByKey:KTP_KEY] length]?[self getValueByKey:KTP_KEY]:@"";
}

+(id)getValueByKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    id value = [defaults objectForKey:key];
    return value;
}

+(BOOL)getBOOLByKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:key];
    return value;
}

+(void)removeObjectByKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}


+(void)removeAllObject{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *keyDic=[defaults dictionaryRepresentation];
    for(NSString *key in [keyDic allKeys]){
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];
}

@end
