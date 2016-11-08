//
//  MessageModel.m
//  Trendpower
//
//  Created by trendpower on 15/12/29.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(self)
    {
        self.message_id = [attributes valueForKey:@"id"];
        self.message_title = [attributes valueForKey:@"title"];
        self.message_content = [attributes valueForKey:@"content"];
        self.add_time = [attributes valueForKey:@"createdAt"];
        self.agentId = [[attributes valueForKey:@"agentId"] integerValue];
        self.userId = [[attributes valueForKey:@"userId"] integerValue];

        self.img_url = [attributes valueForKey:@"fileName"];
    }
    return self;
}
@end
