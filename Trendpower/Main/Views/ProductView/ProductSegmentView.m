//
//  ProductSegmentView.m
//  Trendpower
//
//  Created by trendpower on 15/5/20.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "ProductSegmentView.h"

@interface ProductSegmentView()

@property (nonatomic, weak) UIButton * segment1Btn;
@property (nonatomic, weak) UIButton * segment2Btn;

/**
 *  中间分隔线
 */
@property (nonatomic, weak) UIView * centerLine;

@property (nonatomic, weak) UIView * bottomLineView;
@property (nonatomic, weak) UIView * bottomLine;

@end

@implementation ProductSegmentView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.
        self.backgroundColor = [UIColor whiteColor];
        
        //2.
        self.segment1Btn = [self getBtnTitile:@"图文详情"];
        self.segment1Btn.tag = 0;
        self.segment1Btn.selected = YES;
        self.segment2Btn = [self getBtnTitile:@"产品参数"];
        self.segment2Btn.tag = 1;
        
        // 3.
        self.bottomLineView = [self getLineView];
        self.bottomLine = [self getLineView];
        self.bottomLine.backgroundColor = [UIColor colorWithWhite:0.861 alpha:1.000];
        
    }
    
    return self;
}

#pragma mark 初始化视图
- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
    [self addSubview:line];
    return line;
}

- (UIButton *) getBtnTitile:(NSString *)title{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
    btn.backgroundColor = [UIColor whiteColor];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorWithWhite:0.420 alpha:1.000] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedSegmentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

#pragma mark - 初始化数据
- (void)setSegmentsCount:(NSInteger)segmentsCount{
    switch (segmentsCount) {
        case 1:
            [self addViewConstraints1];
            break;
        case 2:
            [self addViewConstraints2];
            break;
        default:
            break;
    }
    
    
}


#pragma mark - 添加约束
-(void) addViewConstraints1{ //只有一段子
    
    float lineHeight = 2;
    
    // 1.
    [self.segment1Btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.bottomLine.mas_top).offset(0);
    }];
    
    // 2.
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.segment1Btn.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(lineHeight);
    }];
    
    
    // 3.
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(@0.5);
    }];
    
    //4.
    [self.segment2Btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(@0);
        make.height.mas_equalTo(@0);
    }];
    
    
}

#pragma mark - 添加约束
-(void) addViewConstraints2{
    
    float lineHeight = 2;
    
    NSNumber * halfW = [NSNumber numberWithFloat:self.frame.size.width/2];
    
    
    // 1.
    [self.segment1Btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(halfW);
        make.bottom.mas_equalTo(self.bottomLine.mas_top).offset(0);
    }];
    
    // 2.
    [self.segment2Btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(halfW);
        make.bottom.mas_equalTo(self.bottomLine.mas_top).offset(0);
    }];
    

    // 3.
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.bottomLine.mas_top).offset(0);
        make.width.mas_equalTo(halfW);
        make.height.mas_equalTo(lineHeight);
    }];
    
    // 4.
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(@0.5);
    }];
    
}


#pragma mark - 代理
- (void)clickedSegmentBtn:(UIButton *)btn{
    
    // 如果已经选中了，直接返回
    if (btn.isSelected) {
        return;
    }
    
    btn.selected = YES;
    
    [self lineViewMove:btn.tag];
    switch (btn.tag) {
        case 0://点左按钮,向左移动
            self.segment2Btn.selected = NO;
            [self lineViewMove:btn.tag];
            break;
        case 1://点右按钮，向右移动
            self.segment1Btn.selected = NO;
            [self lineViewMove:btn.tag];
            break;
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(productSegmentViewSelectedSegmentIndex:)])
    {
        [self.delegate productSegmentViewSelectedSegmentIndex:btn.tag];
    }
    
}

- (void) lineViewMove:(NSInteger)moveRight{
    
    CGRect frame = self.bottomLineView.frame;
    
    if (moveRight){
        frame = CGRectMake(self.frame.size.width/2, frame.origin.y, frame.size.width, frame.size.height);
    }else{
        frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
    }

    [UIView animateWithDuration:0.2 animations:^{
        self.bottomLineView.frame = frame;
    } completion:^(BOOL finished) {
        //动画会导致约束位
        float lineHeight = 2;
        CGFloat halfW = self.frame.size.width/2;
        CGFloat x = moveRight ? halfW : 0;
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(x);
            make.bottom.mas_equalTo(self.bottomLine.mas_top).offset(0);
            make.width.mas_equalTo(halfW);
            make.height.mas_equalTo(lineHeight);
        }];
    }];
    
}



@end
