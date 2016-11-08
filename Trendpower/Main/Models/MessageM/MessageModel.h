//
//  MessageModel.h
//  Trendpower
//
//  Created by trendpower on 15/12/29.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

/**
      "add_time": "2015-12-28 17:23:15",
      "audience": "0",
      "content": "<p><br/></p><p>&nbsp; &nbsp; &nbsp; 在这个寒冬来临的时候，一只碗，一把伞，一个杯，可以给您及您的亲朋好友还有您的客户带来无限的温暖！<br/></p><p>&nbsp; &nbsp; &nbsp; 现在，泰兴隆诚意推出暖冬特价产品",
      "cover": "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/5680fd3e1757d.jpg",
      "is_success": "N",
      "message_id": "1713",
      "send_time": "2015-12-28 17:23:15",
      "store_id": "81",
      "title": "寒冬来袭，温暖踏来！"
 */

@property(nonatomic,copy) NSString* message_id;

@property(nonatomic,copy) NSString* message_title;

@property(nonatomic,copy) NSString* message_content;

@property(nonatomic,copy) NSString* add_time;

@property(nonatomic,copy) NSString* img_url;

@property(nonatomic,assign) NSInteger userId;

@property (nonatomic, assign) NSInteger agentId;

@property(nonatomic,assign) NSInteger message_type;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
