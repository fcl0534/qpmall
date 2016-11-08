//
//  CarBrandCollectionCell.m
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com All rights reserved.
//

#import "CarBrandCollectionCell.h"



@implementation CarBrandCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.frame) -20, 40)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.borderColor = K_LINEBD_COLOR.CGColor;
        imageView.layer.borderWidth = 1.0f;
        self.imageView = imageView;
        [self addSubview:imageView];
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, CGRectGetWidth(self.frame), 15)];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.nameLabel = label;
    }
    return self;
}

@end
