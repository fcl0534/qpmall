
//
//  CartHeaderView.m
//  ZZBMall
//
//  Created by trendpower on 15/8/7.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "CartHeaderView.h"

@interface CartHeaderView()

@property (nonatomic, weak) LineView * topLine;
@property (nonatomic, weak) UIImageView * image;


@end


@implementation CartHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.4;
    self.layer.borderColor = [UIColor colorWithWhite:0.770 alpha:1.000].CGColor;
    
    self.topLine = [self getLineView];

    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"cart_shop_Image"];
    [self addSubview:image];
    self.image = image;
    
    UILabel * lbl = [[UILabel alloc]init];
    lbl.font = [UIFont boldSystemFontOfSize:16.5f];
    lbl.textColor = [UIColor colorWithRed:0.180 green:0.180 blue:0.176 alpha:1.000];
    self.shopNameLbl = lbl;
    [self addSubview:lbl];
    
    [self addViewConstraints];
}

- (LineView *)getLineView{
    LineView * line = [[LineView alloc]init];
    [self addSubview:line];
    return line;
}

- (void) addViewConstraints{
    
    // 1.
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@0);
    }];

    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo(@15);
    }];
    
    [self.shopNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLine.mas_bottom);
        make.left.mas_equalTo(self.image.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}


@end
