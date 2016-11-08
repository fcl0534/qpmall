//
//  CustomCellView.m
//  Trendpower
//
//  Created by trendpower on 15/5/18.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "CustomCellView.h"

@interface CustomCellView()

@property (nonatomic, weak) UIButton * customBtn;
@property (nonatomic, weak) UIImageView * rightArrow;

@end

@implementation CustomCellView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        // 0.
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor colorWithWhite:0.675 alpha:1.000].CGColor;
        self.layer.borderWidth = 0.3;
        
        // 1.
        UILabel *text = [[UILabel alloc]init];
        [self addSubview:text];
        text.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
        text.textAlignment = NSTextAlignmentLeft;
        self.textLabel = text;
        
        // 2.
        UIImageView * rightArrow = [[UIImageView alloc]init];
        rightArrow.image = [UIImage imageNamed:@"C_list_arrow_1"];
        [self addSubview:rightArrow];
        self.rightArrow = rightArrow;
        
        // 3.
        UIButton * customBtn = [[UIButton alloc]init];
        customBtn.backgroundColor = [UIColor clearColor];
        [customBtn addTarget:self action:@selector(clickedCellView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:customBtn];
        self.customBtn = customBtn;
        
        [self addViewConstraints];
    }
    return self;
}


#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 10;
    
    // 1.
    [self.customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    float ImageWH = 15;
    
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.width.mas_equalTo(ImageWH-5);
        make.height.mas_equalTo(ImageWH);
    }];
    
}


- (void)clickedCellView:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(customCellViewClicked:)])
    {
        [self.delegate customCellViewClicked:btn];
    }
}


@end
