//
//  HomeAD4CollectionCell.m
//  Trendpower
//
//  Created by HTC on 16/1/25.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "HomeAD4CollectionCell.h"


#import <Masonry.h>

@interface HomeAD4CollectionCell()


@property (nonatomic, weak) UIImageView * image1;
@property (nonatomic, weak) UIImageView * image2;
@property (nonatomic, weak) UIImageView * image3;
@property (nonatomic, weak) UIImageView * image4;

@end

@implementation HomeAD4CollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    
    return self;
}


- (void)setup{
    
    self.backgroundColor = [UIColor colorWithRed:0.925f green:0.922f blue:0.922f alpha:1.00f];
    
    self.imageView = [self getImageViewWithTag:0];
//    self.image1 = [self getImageViewWithTag:1];
//    self.image2 = [self getImageViewWithTag:2];
//    self.image3 = [self getImageViewWithTag:3];
//    self.image4 = [self getImageViewWithTag:4];
    
    [self addViewConstraints];
}

- (UIImageView *)getImageViewWithTag:(NSInteger)tag{
    UIImageView * view = [[UIImageView alloc]init];
    //view.contentMode = UIViewContentModeScaleAspectFit;
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
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(self.mas_height);
    }];
    
//    [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top).offset(0);
//        make.left.mas_equalTo(self.image0.mas_right).offset(0);
//        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
//        make.height.mas_equalTo(self.image1.mas_width);
//    }];
//    
//    [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.image0.mas_bottom).offset(0);
//        make.left.mas_equalTo(self.mas_left).offset(0);
//        make.width.mas_equalTo(self.mas_width).multipliedBy(0.3333333333);
//        make.bottom.mas_equalTo(self.mas_bottom);
//    }];
//    
//    [self.image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.image0.mas_bottom).offset(0);
//        make.left.mas_equalTo(self.image2.mas_right).offset(0);
//        make.width.mas_equalTo(self.mas_width).multipliedBy(0.3333333333);
//        make.bottom.mas_equalTo(self.mas_bottom);
//    }];
//    
//    [self.image4 mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.image0.mas_bottom).offset(0);
//        make.left.mas_equalTo(self.image3.mas_right).offset(0);
//        make.width.mas_equalTo(self.mas_width).multipliedBy(0.3333333333);
//        make.bottom.mas_equalTo(self.mas_bottom);
//    }];
    
    
}

@end
