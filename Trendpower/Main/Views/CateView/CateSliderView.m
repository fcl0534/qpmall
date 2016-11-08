//
//  CateSliderView.m
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "CateSliderView.h"



@interface CateSliderView()


@property (nonatomic, assign) CGFloat sliderW;
@property (nonatomic, assign) CGFloat sliderH;
@property (nonatomic, assign) CGFloat leftW;

@end


@implementation CateSliderView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        float H = frame.size.height;
        float W = frame.size.width;
        self.sliderW = W;
        self.sliderH = H;
        self.leftW = frame.origin.x;
        
        //0.
        UIView * heder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W, 64)];
        heder.backgroundColor = K_MAIN_COLOR;
        [self addSubview:heder];
        
        //1.
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, W, 44)];
        name.font = [UIFont boldSystemFontOfSize:16.0f];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = [UIColor whiteColor];
        [heder addSubview:name];
        self.titleLbl = name;
        //自动缩放字体
        self.titleLbl.adjustsFontSizeToFitWidth = YES;
        self.titleLbl.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
        

        //2.
        UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 40, 44)];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [backBtn addTarget:self action:@selector(clickedBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        [heder addSubview:backBtn];
        
        //3.
        self.backgroundColor = [UIColor clearColor];
        UIView * shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 3, H-64)];
        shadowView.backgroundColor = [UIColor colorWithWhite:0.555 alpha:0.115];
        //[self addSubview:shadowView];
        
        // 4.
        UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(3, 64, W-3, H-64)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        self.contentView = contentView;
        contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        contentView.layer.shadowOffset = CGSizeMake(-2, 0);
        contentView.layer.shadowRadius = 3;
        contentView.layer.shadowOpacity = 0.3;
        
        
        [UIView setAnimationsEnabled:NO];
        [self hideSliderView];
        [UIView setAnimationsEnabled:YES];
        
    }
    return self;
}

- (void)showSliderView{
    
    CGRect frame = CGRectMake(self.leftW, 0, self.sliderW, self.sliderH);
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        ;
    }];
}


- (void)hideSliderView{
    CGRect frame = CGRectMake(self.leftW +self.sliderW, 0, self.sliderW, self.sliderH);
    [UIView animateWithDuration:0.40 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)clickedBackBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(cateSliderView:clickedBackBtn:)])
    {
        [self.delegate cateSliderView:self clickedBackBtn:btn];
    }
}


@end
