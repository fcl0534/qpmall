//
//  HomeBrandCollectionCell.m
//  Trendpower
//
//  Created by HTC on 16/1/27.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "HomeBrandCollectionCell.h"

#import <Masonry.h>


@implementation HomeBrandCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    
    return self;
}


- (void)setup{
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.layer.borderWidth = 0.35;
    
    self.imageView = [self getImageViewWithTag:0];
    //    self.image1 = [self getImageViewWithTag:1];
    //    self.image2 = [self getImageViewWithTag:2];
    //    self.image3 = [self getImageViewWithTag:3];
    //    self.image4 = [self getImageViewWithTag:4];
    
    [self addViewConstraints];
}

- (UIImageView *)getImageViewWithTag:(NSInteger)tag{
    UIImageView * view = [[UIImageView alloc]init];
    view.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:view];
    //    view.userInteractionEnabled = YES;
    //    view.tag = tag;
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedImageView:)];
    //    [view addGestureRecognizer:tap];
    //[self.imagesArray addObject:view];
    return view;
}


- (void)addViewConstraints{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(self.mas_width).offset(-20);
        make.height.mas_equalTo(self.mas_height).offset(-20);
    }];
    
}
@end
