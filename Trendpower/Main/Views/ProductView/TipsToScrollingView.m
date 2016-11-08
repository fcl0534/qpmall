//
//  TipsToScrollingView.m
//  Trendpower
//
//  Created by HTC on 15/5/20.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "TipsToScrollingView.h"

@interface TipsToScrollingView()

@property (nonatomic, weak) UIView * leftLine;
@property (nonatomic, weak) UIView * rightLine;

@end


@implementation TipsToScrollingView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1.000];
        
        self.leftLine = [self getLineView];
        self.rightLine = [self getLineView];
        self.tipsBtn = [self getBtnTitile:@"继续拖动，查看图片详情" seleteImage:nil normalImage:nil];
        
        [self addViewConstraints];
    }
    return self;
}


- (UIButton *) getBtnTitile:(NSString *)title seleteImage:(UIImage *)seleteImage normalImage:(UIImage *)normalImage {
    UIButton *btn = [[UIButton alloc]init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [btn setTitleColor:[UIColor colorWithWhite:0.469 alpha:1.000] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:seleteImage forState:UIControlStateSelected];
    [btn setImage:normalImage forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(clickedGenderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.796 alpha:1.000];
    [self addSubview:line];
    return line;
}


#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 10;
    
    // 1.
    [self.tipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(@160);
        make.height.mas_equalTo(@20);
    }];
    
    // 2.
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.right.mas_equalTo(self.tipsBtn.mas_left).offset(-spacing);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    // 3.
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipsBtn.mas_right).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(@0.5);
    }];}

@end
