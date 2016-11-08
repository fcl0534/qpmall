//
//  PushMessage.h
//  EcoDuo
//
//  Created by trendpower on 14/11/13.
//  Copyright (c) 2014年 Felix Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushMessage : NSObject
/**
 * {
     "add_time": "1429080323",
     "audience": "0",
     "content": "<p>wewewe<br/></p>",
     "cover": "/uploads/yanfamall.tpsite.qushiyun.com/552e0902ad17b.png",
     "is_success": "Y",
     "message_id": "31",
     "send_time": "1429080323",
     "store_id": "221",
     "title": "wewe"
   }
 */

@property(nonatomic,strong) NSString* message_type;
@property(nonatomic,strong) NSString* message_id;
@property(nonatomic,strong) NSString* message_title;
@property(nonatomic,strong) NSString* message_content;
@property(nonatomic,strong) NSString* send_time;
@property(nonatomic,strong) NSString* img_url;
@property(nonatomic,strong) NSString* read_flag;

@end
