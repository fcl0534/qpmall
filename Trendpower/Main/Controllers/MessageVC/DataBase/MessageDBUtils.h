//
//  MessageDBUtils.h
//  Trendpower
//
//  Created by HTC on 15/6/29.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#import "PushMessage.h"

@interface MessageDBUtils : NSObject


/* 全部标记为已读 */
+ (void)finishMessageRead;

/* 查询未读信息，如果有未读返回YES */
+ (BOOL)queryUnreadMessage;

/* 保存推送信息，如果不存在就存储 */
+ (void)saveMessageWithPushId:(NSString *)pushID;

/* 根据id查询是否已经存储了数据，如果存在未读消息返回NO */
+ (BOOL)queryExistMessageWithPushId:(NSString *)pushID;

/* 保存推送完整信息 */
+ (void)saveMessage:(NSDictionary * )dataDic;


+ (NSMutableArray *)queryAllMessage;

+ (void)testMessage;
@end
