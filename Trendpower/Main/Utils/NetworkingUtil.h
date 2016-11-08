//
//  NetworkingUtil.h
//  Trendpower
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkingUtil : NSObject
/**  请求单例  */
+ (instancetype)sharedNetworkingUtil;

/**  取消全部网络请求 */
-(void)cancelAllRequest;

/**
 *  GET请求
 *
 *  @param URLString URL
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)GET:(NSString *)URLString success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  GET请求
 *
 *  @param URLString URL
 *  @param view      显示加载中HUD在视图
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)GET:(NSString *)URLString inView:(UIView *)view success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  GET请求
 *
 *  @param URLString URL
 *  @param parameters 请求参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  GET请求
 *
 *  @param URLString URL
 *  @param parameters 请求参数
 *  @param view      显示加载中HUD在视图
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters inView:(UIView *)view success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  GET请求
 *
 *  @param URLString URL
 *  @param header     头部
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)GET:(NSString *)URLString header:(id)header success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  GET请求
 *
 *  @param URLString URL
 *  @param header     头部
 *  @param parameters 请求参数
 *  @param view      显示加载中HUD在视图
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)GET:(NSString *)URLString header:(id)header inView:(UIView *)view success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  POST请求
 *
 *  @param URLString  URL
 *  @param parameters 请求参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  POST请求
 *
 *  @param URLString  URL
 *  @param parameters 请求参数
 *  @param view       显示加载中HUD在视图
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters inView:(UIView *)view success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString
  parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
     success:(void (^)(AFHTTPRequestSerializer *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestSerializer *operation, NSError *error))failure;

- (void)POST:(NSString *)URLString
  parameters:(id)parameters inView:(UIView *)view
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
     success:(void (^)(AFHTTPRequestSerializer *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestSerializer *operation, NSError *error))failure;

/**
 *  改变头部
 *
 *  @param URLString  URL
 *  @param header     头部
 *  @param parameters 请求参数
 *  @param view       显示加载中HUD在视图
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)POST:(NSString *)URLString header:(id)header parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)POST:(NSString *)URLString header:(id)header parameters:(id)parameters inView:(UIView *)view success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
