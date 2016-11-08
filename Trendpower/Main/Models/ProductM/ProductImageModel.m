//
//  ProductImageModel.m
//  TabBarNavigationDemo
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "ProductImageModel.h"

@implementation ProductImageModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
     
        self.imageId = [attributes valueForKey:@"id"];
        self.goods_id = [attributes valueForKey:@"goods_id"];
        self.file_name = [attributes valueForKey:@"file_name"];
        self.is_default = [[attributes valueForKey:@"is_default"] boolValue];
    }
    return self;
}

/**
 *  "goods_images": [
 {
 "created_at": "2016-03-02 06:58:38",
 "deleted_at": "0",
 "file_name": "http://assets.qpfww.com/goods/0000/0002/2703/22703/45721449126160.jpg",
 "file_type": "1",
 "goods_id": "22703",
 "id": "2775",
 "image_name": null,
 "is_default": "1",
 "is_deleted": "0",
 "sort": "0",
 "updated_at": "2016-03-02 06:58:38"
 }
 ],
 */

@end
