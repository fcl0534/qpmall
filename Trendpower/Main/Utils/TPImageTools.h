//
//  TPImageTools.h
//  Trendpower
//
//  Created by trendpower on 15/9/24.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  http://pic.qushiyun.com/yanlongmall.tpsite.qushiyun.com/5556aa00ea3d6.jpg@293w_293h_4e.jpg

    封装成公共方法 传递3个参数  图片地址，高度，宽度就可以了得到对应尺寸图片
 */

@interface TPImageTools : NSObject

+(NSString *) getIamgeWithUrl:(NSString *)url width:(NSUInteger)width height:(NSUInteger)height;

@end
