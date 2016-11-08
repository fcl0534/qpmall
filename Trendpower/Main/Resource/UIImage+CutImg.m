//
//  UIImage+CutImg.m
//  Trendpower
//
//  Created by 张帅 on 16/6/28.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "UIImage+CutImg.h"

@implementation UIImage (CutImg)

- (UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));

    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();

    return smallImage;
}

- (UIImage *)getCutImage:(CGRect)rect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage,
                                                          CGRectMake(rect.origin.x,
                                                                     rect.origin.y,
                                                                     rect.size.width * self.scale,
                                                                     rect.size.height * self.scale));
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));

    //UIGraphicsBeginImageContext(smallBounds.size);
    UIGraphicsBeginImageContextWithOptions(smallBounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();

    return smallImage;
}

@end
