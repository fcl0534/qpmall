//
//  ProductImageModel.h
//  TabBarNavigationDemo
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductImageModel : NSObject
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
@property (nonatomic, copy) NSString * imageId;
@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * file_name;

/** 是否为默认图片，是则第一张显示 */
@property (nonatomic, assign) BOOL is_default;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@end
