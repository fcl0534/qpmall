//
//  BrandCollectionCell.m
//  Trendpower
//
//  Created by HTC on 15/6/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "BrandCollectionCell.h"

@implementation BrandCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame) -10, CGRectGetWidth(self.frame)/2 -10)];
        self.imageView = imageView;
        [self addSubview:imageView];

        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(self.frame), 20)];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.nameLabel = label;
    }
    return self;
}

@end
