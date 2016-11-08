//
//  NaviFooterBar.m
//  Trendpower
//
//  Created by trendpower on 15/12/1.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#define barHeight 55


#import "NaviFooterBar.h"

@interface NaviFooterBar()

@property (nonatomic, weak) UIView * naviBarView;
@property (nonatomic, weak) UIView * blackBgView;

@property (nonatomic, assign) BOOL isHidden;

@end


@implementation NaviFooterBar

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        [self initBaseView];
    }
    
    return self;
}

- (void)initBaseView{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.isHidden = YES;

    UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, barHeight)];
    barView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.900];
    [self addSubview:barView];
    self.naviBarView = barView;
    barView.alpha = 0;
    
    NSArray * iconArray = @[
                            [UIImage imageNamed:@"navi_search"],
                            [UIImage imageNamed:@"navi_home"]
                            ];
    NSArray * titleArray = @[@"搜索",@"首页"];
    
    CGFloat btnW = self.frame.size.width /iconArray.count;
    for (int i = 0; i < iconArray.count; i++) {
        TopImageButton * btn = [[TopImageButton alloc]initWithFrame:CGRectMake(i*btnW, 5, btnW, barHeight-10)];
        btn.tag = i;
        [btn setImage:iconArray[i] forState:UIControlStateNormal];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:btn];
    }
    
    
    // 1.blackBgView
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, barHeight, self.frame.size.width, self.frame.size.height -barHeight)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBlackBgView)];
    [bgView addGestureRecognizer:tap];
    
    [self addSubview:bgView];
    self.blackBgView = bgView;
}



#pragma mark - 点击了黑色地址区背影
- (void)tapBlackBgView{
    [self hiddenNaviFooterBar];
}

- (void)actionView{
    self.isHidden ? [self showNaviFooterBar] : [self hiddenNaviFooterBar];
}

- (void)hiddenNaviFooterBar{
    self.isHidden = YES;
    [UIView animateWithDuration:0.35 animations:^{
        self.blackBgView.alpha = 0;
        self.naviBarView.alpha = 0;
    } completion:^(BOOL finished) {

    }];
}


- (void)showNaviFooterBar{
    self.isHidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.blackBgView.alpha = 0.8;
        self.naviBarView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 事件处理
- (void)clickedBtn:(TopImageButton * )btn{
    if([self.delegate respondsToSelector:@selector(naviFooterBarClickedBtn:index:)])
    {
        [self.delegate naviFooterBarClickedBtn:btn index:btn.tag];
    }
}

@end
