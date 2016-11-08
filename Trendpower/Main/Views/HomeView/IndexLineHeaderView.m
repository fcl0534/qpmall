//
//  IndexLineHeaderView.m
//  Trendpower
//
//  Created by trendpower on 15/9/24.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "IndexLineHeaderView.h"

#import <Masonry.h>



@interface IndexLineHeaderView()

@property (nonatomic, weak) UIView * lineView;

@end

@implementation IndexLineHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = K_GREY_COLOR;
//        UIView * lineView = [[UIView alloc]init];
//        lineView.backgroundColor = K_LINE_COLOR;
//        [self addSubview:lineView];
//        self.lineView = lineView;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = K_LINEBD_COLOR.CGColor;
        
        //[self setFrames];
        
    }
    
    return self;
}


- (void)setFrames{
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(@0.5);
    }];
    
}

@end
