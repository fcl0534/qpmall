//
//  UIImage+CutImg.h
//  Trendpower
//
//  Created by 张帅 on 16/6/28.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CutImg)

-(UIImage*)getSubImage:(CGRect)rect;

- (UIImage *)getCutImage:(CGRect)rect;

@end
