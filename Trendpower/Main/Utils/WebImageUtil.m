//
//  WebImageUtil.m
//  Trendpower
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "WebImageUtil.h"
#import "NetworkStatusUtil.h"

@implementation WebImageUtil

+ (void)cancelCurrentImageLoad{
    
}


+ (NSURL *)getURLWithString:(NSString *)urlstr{
    BOOL isOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"WiFiShowImage"];
    if (isOn) {
        BOOL isWifi = [NetworkStatusUtil isReachableViaWiFi];
        if (isWifi) {
            return [NSURL URLWithString:urlstr];
        }else{
            return [NSURL URLWithString:@""];
        }
    }
    
    if (![urlstr isEqual:[NSNull null]]) {
        return [NSURL URLWithString:urlstr];
    } else {
        return [NSURL URLWithString:@"http://www.baidu.com"];
    }
    
//    return [NSURL URLWithString: urlstr != [NSNull null] ? urlstr : @"http://www.baidu.com"];
}

+ (void)setImageWithURL:(NSString *)urlstr inView:(UIImageView *)view{
    NSURL * url = [self getURLWithString:urlstr];
    [view sd_setImageWithURL:url];
}

+ (void)setImageWithURL:(NSString *)urlstr placeholderImage:(UIImage *)placeholder inView:(UIImageView *)view{
        NSURL * url = [self getURLWithString:urlstr];
    [view sd_setImageWithURL:url placeholderImage:placeholder];
}

+ (void)setImageWithURL:(NSString *)urlstr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options inView:(UIImageView *)view{
        NSURL * url = [self getURLWithString:urlstr];
    [view sd_setImageWithURL:url placeholderImage:placeholder options:options];
}

+ (void)setImageWithURL:(NSString *)urlstr completed:(SDWebImageCompletionBlock)completedBlock inView:(UIImageView *)view{
        NSURL * url = [self getURLWithString:urlstr];
    [view sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            completedBlock(image,error,cacheType,imageURL);
    }];
}

+ (void)setImageWithURL:(NSString *)urlstr placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock inView:(UIImageView *)view{
        NSURL * url = [self getURLWithString:urlstr];
    [view sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   completedBlock(image,error,cacheType,imageURL);
    }];
}

+ (void)setImageWithURL:(NSString *)urlstr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock inView:(UIImageView *)view{
        NSURL * url = [self getURLWithString:urlstr];
    [view sd_setImageWithURL:url placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   completedBlock(image,error,cacheType,imageURL);
    }];
}

+ (void)setImageWithURL:(NSString *)urlstr placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock inView:(UIImageView *)view{
        NSURL * url = [self getURLWithString:urlstr];
    [view sd_setImageWithURL:url placeholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        progressBlock(receivedSize,expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   completedBlock(image,error,cacheType,imageURL);
    }];
}

+ (void)setImageWithPreviousCachedImageWithURL:(NSString *)urlstr andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock inView:(UIImageView *)view{
        NSURL * url = [self getURLWithString:urlstr];
    
    [view sd_setImageWithURL:url placeholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        progressBlock(receivedSize,expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        completedBlock(image,error,cacheType,imageURL);
    }];
}
@end
