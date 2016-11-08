//
//  MessageDBUtils.m
//  Trendpower
//
//  Created by HTC on 15/6/29.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "MessageDBUtils.h"

@implementation MessageDBUtils

static FMDatabaseQueue *_queue;

/**
 *  在C语言中，关键字static有三个明显的作用：
 
 1). 在函数体，一个被声明为静态的变量在这一函数被调用过程中只会初始化一次。
 
 2). 在模块内（但在函数体外），一个被声明为静态的变量可以被模块内所用函数访问，但不能被模块外其它函数访问。它是一个本地的全局变量。
 
 3). 在模块内，一个被声明为静态的函数只可被这一模块内的其它函数调用。那就是，这个函数被限制在声明它的模块的本地范围内使用。
 */

//create table if not exists tbl_push_message_unreceived(id integer  primary key autoincrement,message_id text,receive_flag text)
//create table if not exists tbl_push_message(id integer  primary key autoincrement,message_type text,message_id text,message_title text,message_content text,img_url text,send_time text,read_flag text)
/**
 * 
 {
 "add_time": "2015-06-29 18:02:43",
 "audience": "0",
 "content": "",
 "cover": "http://pic.qushiyun.com/mflapp.tpsite.qushiyun.com/559117bfa8904.png",
 "is_success": "Y",
 "message_id": "193",
 "send_time": "2015-06-29 18:02:43",
 "store_id": "254281",
 "title": "放到hiU盾发"
 }
 */

+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"message.sqlite"];
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 2.创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists push_message (id integer primary key autoincrement, message_id text,message_title text,message_content text,img_url text,send_time text,read_flag text);"];
    }];
}


/* 全部标记为已读 */
+ (void)finishMessageRead{
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         //查询数据库中是否存在url对应的项
         rs = [db executeQuery:@"select * from push_message where read_flag ='no'"];
         if(rs.next)
         {
             int ID = [rs intForColumn:@"id"];
             [db executeUpdate:@"update push_message set read_flag = 'yes' where id = ?;",[NSNumber numberWithInt:ID]];
         }
         
         [rs close];
     }];
}


+ (BOOL)queryUnreadMessage{
    
    __block BOOL unread = NO;
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         //查询数据库中是否存在url对应的项
         rs = [db executeQuery:@"select * from push_message where read_flag = ?",@"no"];
         if(rs.next){
             //存在没有阅读的消息
             unread = YES;
         }
         
         [rs close];
     }];
    
    return unread;
}

+ (void)saveMessageWithPushId:(NSString *)pushID{
    
    pushID = [NSString stringWithFormat:@"%d",[pushID intValue]];
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         //查询数据库中是否存在url对应的项
         rs = [db executeQuery:@"select * from push_message where message_id = ?",pushID];
         if(rs.next){

         }else{
             //插入未读项
             [db executeUpdate:@"insert into push_message(message_id, read_flag) values (?, ?)",pushID,@"no"];
         }
         
         [rs close];
     }];
}


+ (BOOL)queryExistMessageWithPushId:(NSString *)pushID{
    
    __block NSString * flag = @"yes";
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         //查询数据库中是否存在url对应的项
         rs = [db executeQuery:@"select * from push_message where message_id = ?",pushID];
         if(rs.next){
             
             flag = [rs stringForColumn:@"read_flag"];
         }
         
         [rs close];
     }];
    
    if ([flag isEqualToString:@"no"]) {
        return YES;
    }
    
    return NO;
}


+ (void)saveMessage:(NSDictionary * )dataDic{
    [_queue inDatabase:^(FMDatabase *db)
     {
         /**
          *  {
              "add_time": "2015-06-29 18:02:43",
              "audience": "0",
              "content": "",
              "cover": "http://pic.qushiyun.com/mflapp.tpsite.qushiyun.com/559117bfa8904.png",
              "is_success": "Y",
              "message_id": "193",
              "send_time": "2015-06-29 18:02:43",
              "store_id": "254281",
              "title": "放到hiU盾发"
              },
          */
         FMResultSet *rs = nil;
         //查询数据库中是否存在url对应的项
         rs = [db executeQuery:@"select * from push_message where message_id = ?",[dataDic objectForKey:@"message_id"]];
         
         if(rs.next){
            [db executeUpdate:@"update push_message set message_title = ? , message_content = ? , img_url = ? , send_time  = ? , read_flag = ? where message_id = ?;",[dataDic objectForKey:@"title"],[dataDic objectForKey:@"content"],[dataDic objectForKey:@"cover"],[dataDic objectForKey:@"send_time"],@"yes",[dataDic objectForKey:@"message_id"]];
         }else{
             [db executeUpdate:@"insert into push_message(message_id, message_title, message_content, img_url, send_time, read_flag) values (?, ?, ?, ?, ?, ?)",[dataDic objectForKey:@"message_id"],[dataDic objectForKey:@"title"],[dataDic objectForKey:@"content"],[dataDic objectForKey:@"cover"],[dataDic objectForKey:@"send_time"],@"yes"];
         }
         
         [rs close];
     }];
}



+ (void)testMessage{
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
             //1、查询数据库中有几组数据
             rs = [db executeQuery:@"select * from push_message"];
             int counts = 0;
             if (rs.next)
             {
                 counts = [rs intForColumnIndex:0] + 1;
                 NSLog(@"----");
             }
         
          [rs close];
         
     }];
}


+ (NSMutableArray *)queryAllMessage{
    
    __block NSMutableArray *dataArr = [NSMutableArray array];
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         NSLog(@"------queryAllMessage----");
         
         FMResultSet *rs = nil;
         //查询数据库中是否存在url对应的项
         //rs = [db executeQuery:@"select * from push_message where message_id = ?",@"183"];
         rs = [db executeQuery:@"select * from push_message order by send_time asc"];
         while([rs next]){
             //添加时间
             PushMessage *time=[[PushMessage alloc] init];
             time.message_type=@"99";//时间类型
             time.send_time=[rs stringForColumn:@"send_time"];
             [dataArr addObject:time];
             //添加正式消息
             PushMessage *message=[[PushMessage alloc] init];
             message.message_id=[rs stringForColumn:@"message_id"];
             message.message_type= @"0";
             message.message_title=[rs stringForColumn:@"message_title"];
             message.message_content=[rs stringForColumn:@"message_content"];
             message.img_url=[rs stringForColumn:@"img_url"];
             message.send_time=[rs stringForColumn:@"send_time"];
             [dataArr addObject:message];
             
         }
         
        [rs close];
     }];
    
    
    return dataArr;
    
    /**
     *      NSString *sql=@"select * from tbl_push_message";
     
     sql = [sql stringByAppendingString:@" order by send_time asc"];
     
     FMResultSet *resultSet=[FMDBUtils executeSelect:sql];
     while([resultSet next]){
     //添加时间
     PushMessage *time=[[PushMessage alloc] init];
     time.message_type=@"99";//时间类型
     time.send_time=[resultSet stringForColumn:@"send_time"];
     [self.mainMsgArray addObject:time];
     //添加正式消息
     PushMessage *message=[[PushMessage alloc] init];
     message.message_id=[resultSet stringForColumn:@"message_id"];
     message.message_type=[resultSet stringForColumn:@"message_type"];
     message.message_title=[resultSet stringForColumn:@"message_title"];
     message.message_content=[resultSet stringForColumn:@"message_content"];
     message.img_url=[resultSet stringForColumn:@"img_url"];
     message.send_time=[resultSet stringForColumn:@"send_time"];
     [self.mainMsgArray addObject:message];
     }
     *
     *  @return <#return value description#>
     */
}

@end