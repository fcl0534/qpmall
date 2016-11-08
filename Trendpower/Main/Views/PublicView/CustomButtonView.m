//
//  CustomButtonView.m
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "CustomButtonView.h"
#import <Masonry.h>

@interface CustomButtonView()

@property (nonatomic, strong) UIView * lineView;

@end

@implementation CustomButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //0.
        UIView * lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
        [self addSubview:lineView];
        self.lineView = lineView;
        
        
        UIButton * customBtn = [[UIButton alloc]init];
        [customBtn setBackgroundImage:[UIImage imageNamed:@"back_red"] forState:UIControlStateNormal];
        [self addSubview:customBtn];
        [customBtn addTarget:self action:@selector(clickedNewAddress:) forControlEvents:UIControlEventTouchUpInside];
        self.customBtn = customBtn;
        
        [self addViewConstraints];
    }
    return self;
}


#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 25;
    
    // 1.
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@38);
    }];
    
}


- (void)clickedNewAddress:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(CustomButtonClicked:)])
    {
        [self.delegate CustomButtonClicked:btn];
    }
}




@end
