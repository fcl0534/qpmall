//
//  NetworkStatusUtil.h
//  Trendpower
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"


@interface NetworkStatusUtil : NSObject

+ (void)startMonitoringNetworkStatus;
/** 获取当前网络类型WiFi、3G、4G 等*/
+(NSString *)getNetWorkStates;
/** 检查网络连通性*/
+ (BOOL)isReachable;
/** 检查网络是否为移动网络*/
+ (BOOL)isReachableViaWWAN;
/** 检查网络是否为WiFi网络*/
+ (BOOL)isReachableViaWiFi;

@end
