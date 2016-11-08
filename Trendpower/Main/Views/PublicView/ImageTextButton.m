//
//  ImageTextButton.m
//  Trendpower
//
//  Created by trendpower on 15/12/17.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "ImageTextButton.h"

@implementation ImageTextButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    //self.titleLabel.backgroundColor = [UIColor colorWithRed:0.270 green:0.633 blue:1.000 alpha:1];
    
    //    self.titleLabel.layer.cornerRadius = 4;
    //    self.titleLabel.layer.masksToBounds = YES;
    
    //    self.layer.borderColor = [[UIColor colorWithWhite:0.800 alpha:1.000]CGColor];
    //    self.layer.borderWidth = 0.5f;
    //    self.layer.cornerRadius = 0;
    //    self.layer.masksToBounds = YES;
    
    
}

// 设置文字
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat H = contentRect.size.height;
    CGFloat W = contentRect.size.width;
    
    return CGRectMake(0, H/2, W, H/2);
}


// 顶部图片
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width;
    CGFloat H = contentRect.size.height;
    
    return CGRectMake(0, 5, W, H/2);
}

@end
