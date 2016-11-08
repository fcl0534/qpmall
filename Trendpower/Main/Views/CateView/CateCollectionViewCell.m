//
//  CateCollectionViewCell.m
//  Trendpower
//
//  Created by HTC on 16/1/18.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "CateCollectionViewCell.h"

#import <Masonry.h>


@implementation CateCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imageView = [[UIImageView alloc]init];
        self.imageView = imageView;
        [self addSubview:imageView];
        
        
        UILabel * label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = K_CELL_TEXT_COLOR;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.nameLabel = label;
        
        [self addViewConstraints];
    }
    return self;
}


#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 10;
    
    // 1.
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
    
    // 2.
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.imageView.mas_left).offset(-spacing);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.right.mas_equalTo(self.imageView.mas_right).offset(spacing);
        make.height.mas_equalTo(@15);
    }];
}

@end
