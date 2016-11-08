
//
//  EmptyTipsView.m
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "EmptyTipsView.h"

@interface EmptyTipsView()

@end


@implementation EmptyTipsView

-(instancetype)initWithFrame:(CGRect)frame tipsIamge:(UIImage *)tipsimage tipsTitle:(NSString *)tipsTitle tipsDetail:(NSString *)tipsDetail btnName:(NSString *)btnName{
    if (self = [super initWithFrame:frame]) {
        
        // 1.
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.alwaysBounceVertical = YES;
        scrollView.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1.000];
        [self addSubview:scrollView];
        scrollView.contentSize = frame.size;
        
        CGFloat W = frame.size.width;
        CGFloat H = frame.size.height;
        
        
        CGFloat imageH = self.frame.size.width/3.5;//100;
        CGFloat imageW = imageH;
        CGFloat spacingH = 10;
        CGFloat titleH = 25;
        CGFloat detailH = 40;
        
        CGFloat BtnH = 40;
        CGFloat spacingBtn = 50;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageH)];
        imageView.center = CGPointMake(W/2 , H/2 -imageH*3/2);
        if (btnName == nil) imageView.center = CGPointMake(W/2 , H/2 -imageH);
        imageView.image = tipsimage;
        [scrollView addSubview:imageView];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+ spacingH, W, titleH)];
        title.text = tipsTitle;
        title.textColor = [UIColor colorWithWhite:0.555 alpha:1.000];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:18.0f];
        [scrollView addSubview:title];
        
        UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), W, detailH)];
        if(tipsDetail != nil){
            detail.numberOfLines = 0;
            detail.text = tipsDetail;
            detail.textColor = [UIColor colorWithWhite:0.676 alpha:1.000];
            detail.textAlignment = NSTextAlignmentCenter;
            detail.font = [UIFont systemFontOfSize:14.5f];
            [scrollView addSubview:detail];
        }
        
        
        if (btnName != nil) {
            CGFloat btnY = tipsDetail == nil ? CGRectGetMaxY(title.frame) : CGRectGetMaxY(detail.frame);
            
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(spacingBtn, btnY +BtnH, frame.size.width - 2*spacingBtn, BtnH)];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_square_bg"] forState:UIControlStateNormal];
            [btn setTitle:btnName forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5.0f;
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(clickedLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:btn];
        }
        
    }
    return self;
}


#pragma mark - 登陆点击事件
- (void)clickedLoginBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(EmptyTipsViewClickedButton:)]) {
        [self.delegate EmptyTipsViewClickedButton:btn];
    }
}


@end
