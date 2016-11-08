//
//  EmptyPlaceholderView.m
//  Trendpower
//
//  Created by HTC on 15/5/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "EmptyPlaceholderView.h"

@implementation EmptyPlaceholderView

- (instancetype) initWithFrame:(CGRect)frame placeholderText:(NSString *)placeholdertext placeholderIamge:(UIImage *)image btnName:(NSString *)btnName{
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1.000];
        
        float topH = 90;//距离顶部多高
        float imageH = 100;
        float imageW = 100;
        float spacingH = 15;
        float tipsH = 30;
        float BtnH = 40;
        float spacingBtn = 50;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageH)];
        imageView.center = CGPointMake(frame.size.width/2 , topH + imageH/2);
        imageView.image = image;
        [self addSubview:imageView];
        
        UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+ spacingH, frame.size.width, tipsH)];
        tips.text = placeholdertext;
        tips.textColor = [UIColor colorWithWhite:0.555 alpha:1.000];
        tips.textAlignment = NSTextAlignmentCenter;
        tips.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:tips];
        
        
        if (btnName) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(spacingBtn, CGRectGetMaxY(tips.frame) +BtnH, frame.size.width - 2*spacingBtn, BtnH)];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_square_bg"] forState:UIControlStateNormal];
            [btn setTitle:btnName forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5.0f;
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(clickedLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
        }
        
    }
    return self;
}
         
         
#pragma mark - 登陆点击事件
- (void)clickedLoginBtn:(UIButton *)btn{
     if ([self.delegate respondsToSelector:@selector(EmptyPlaceholderViewClickedButton:)]) {
         [self.delegate EmptyPlaceholderViewClickedButton:btn];
     }
}
         
@end
