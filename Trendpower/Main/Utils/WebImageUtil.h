//
//  WebImageUtil.h
//  Trendpower
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"

@interface WebImageUtil : NSObject

+ (void)cancelCurrentImageLoad;

+ (void)setImageWithURL:(NSString *)urlstr inView:(UIImageView *)view;

+ (void)setImageWithURL:(NSString *)urlstr placeholderImage:(UIImage *)placeholder inView:(UIImageView *)view;

+ (void)setImageWithURL:(NSString *)urlstr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options inView:(UIImageView *)view;

+ (void)setImageWithURL:(NSString *)urlstr completed:(SDWebImageCompletionBlock)completedBlock inView:(UIImageView *)view;

+ (void)setImageWithURL:(NSString *)urlstr placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock inView:(UIImageView *)view;

+ (void)setImageWithURL:(NSString *)urlstr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock inView:(UIImageView *)view;

+ (void)setImageWithURL:(NSString *)urlstr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock inView:(UIImageView *)view;

+ (void)setImageWithPreviousCachedImageWithURL:(NSString *)urlstr andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock inView:(UIImageView *)view;

@end
