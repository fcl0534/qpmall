//
//  TipsScrolTopView.m
//  Trendpower
//
//  Created by trendpower on 15/12/15.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "TipsScrolTopView.h"

#import "ImageTextButton.h"


@interface TipsScrolTopView()

@property (nonatomic, weak) ImageTextButton * btn;

@end


@implementation TipsScrolTopView


- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        ImageTextButton * btn = [[ImageTextButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [btn setImage:[UIImage imageNamed:@"switch_arrow_down"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"switch_arrow_up"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithRed:0.244 green:0.245 blue:0.239 alpha:1.000] forState:UIControlStateNormal];
        [btn setTitle:@"下拉，返回商品详情" forState:UIControlStateNormal];
        [btn setTitle:@"松手，返回商品详情" forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        btn.alpha = 0;
        self.btn = btn;
        [self addSubview:btn];
    }
    return self;
}


- (void)setOffsetY:(CGFloat)offsetY{
    _offsetY = offsetY;
    if (offsetY <65) {
        self.btn.selected = NO;
        self.btn.alpha = offsetY/64;
    }else{
        self.btn.selected = YES;
        self.btn.alpha = 1;
    }
}


@end
