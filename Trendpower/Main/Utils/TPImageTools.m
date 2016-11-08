//
//  TPImageTools.m
//  Trendpower
//
//  Created by trendpower on 15/9/24.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "TPImageTools.h"

@implementation TPImageTools

/**
 *
 封装成公共方法 传递3个参数  图片地址，高度，宽度就可以了得到对应尺寸图片
 */
+(NSString *) getIamgeWithUrl:(NSString*)url width:(NSUInteger)width height:(NSUInteger)height{
    //http://pic.qushiyun.com/yanlongmall.tpsite.qushiyun.com/5556aa00ea3d6.jpg @293w_293h_4e.jpg
    
    NSArray * urlArry = [url componentsSeparatedByString:@"."];
    NSString * format = urlArry.lastObject;
    //NSLog(@"---%@",[NSString stringWithFormat:@"%@@%luw_%luh_4e.%@",url,width,height,format]);
    return [NSString stringWithFormat:@"%@@%dw_%dh_4e.%@",url,(int)width,(int)height,format];
}

@end
