//
//  HomeAD2CollectionCell.m
//  Trendpower
//
//  Created by HTC on 16/1/25.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "HomeAD2CollectionCell.h"

#import <Masonry.h>

@interface HomeAD2CollectionCell()

@property (nonatomic, weak) UIImageView * image0;
@property (nonatomic, weak) UIImageView * image1;
@property (nonatomic, weak) UIImageView * image2;
@property (nonatomic, weak) UIImageView * image3;
@property (nonatomic, weak) UIImageView * image4;

@end

@implementation HomeAD2CollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    
    return self;
}


- (void)setup{
    
    self.backgroundColor = [UIColor colorWithRed:0.925f green:0.922f blue:0.922f alpha:1.00f];
    
    self.imagesArray = [NSMutableArray array];
    
    self.image0 = [self getImageViewWithTag:0];
    self.image1 = [self getImageViewWithTag:1];
    self.image2 = [self getImageViewWithTag:2];
    self.image3 = [self getImageViewWithTag:3];
    self.image4 = [self getImageViewWithTag:4];
    
    [self addViewConstraints];
}

- (UIImageView *)getImageViewWithTag:(NSInteger)tag{
    UIImageView * view = [[UIImageView alloc]init];
    //view.contentMode = UIViewContentModeScaleAspectFit;
    view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    view.layer.borderWidth = 0.3;
    [self addSubview:view];
    view.userInteractionEnabled = YES;
    view.tag = tag;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedImageView:)];
    [view addGestureRecognizer:tap];
    [self.imagesArray addObject:view];
    return view;
}


- (void)addViewConstraints{
    
    [self.image0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.image0.mas_right).offset(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.image1.mas_right).offset(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    [self.image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.image1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.image0.mas_right).offset(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    [self.image4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.image2.mas_bottom).offset(0);
        make.left.mas_equalTo(self.image3.mas_right).offset(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    
}

#pragma mark -
- (void)clickedImageView:(UITapGestureRecognizer *)tap{
    UIImageView * view = (UIImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(homeAD2CollectionCellClickedImageView:indexPath:)]) {
        [self.delegate homeAD2CollectionCellClickedImageView:view.tag indexPath:self.indexPath];
    }
}


@end
