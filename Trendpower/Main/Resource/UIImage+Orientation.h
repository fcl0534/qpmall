//
//  UIImage+Orientation.h
//  Trendpower
//
//  Created by 张帅 on 16/6/28.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

- (UIImage *)fixOrientation:(UIImage *)aImage;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

@end
