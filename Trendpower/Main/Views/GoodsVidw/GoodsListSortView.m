//
//  GoodsListSortView.m
//  Trendpower
//
//  Created by HTC on 16/1/27.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "GoodsListSortView.h"

#import <Masonry.h>



@interface GoodsListSortView()

@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIView *middleLine;
@property (nonatomic, weak) UIView *bottomLine;

@property (nonatomic, weak) UIButton * sortBtn;
@property (nonatomic, weak) UIButton * filterBtn;

@end


@implementation GoodsListSortView


- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setView];
        
    }
    
    return self;
}

- (void)setView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.topLine = [self getLineView];
    self.middleLine = [self getLineView];
    self.bottomLine = [self getLineView];
    
    self.sortBtn = [self getBtn:@"综合排序" image:nil select:nil frame:CGRectZero];
    [self.sortBtn  setTitleColor:K_MAIN_COLOR forState:UIControlStateNormal];
    [self.sortBtn addTarget:self action:@selector(goodsListSortViewClickedSortBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.filterBtn = [self getBtn:@"筛选" image:[UIImage imageNamed:@"goodsBar_filter"] select:nil frame:CGRectZero];
    [self.filterBtn addTarget:self action:@selector(goodsListSortViewClickedFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addViewConstraints];
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.792 alpha:1.000];
    [self addSubview:line];
    return line;
}

- (UIButton *)getBtn:(NSString *)title image:(UIImage *)image select:(UIImage *)select frame:(CGRect)frame{
    UIButton * btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:select forState:UIControlStateHighlighted];
    [btn setTitleColor: [UIColor colorWithWhite:0.347 alpha:1.000] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.5f]];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:btn];
    return btn;
}

#pragma mark - 添加约束
-(void) addViewConstraints{

    // 1.
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    // 2.
    [self.sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(-1);
        make.top.mas_equalTo(self.topLine.mas_bottom).offset(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.bottom.mas_equalTo(self.bottomLine.mas_top);
    }];
    
    [self.middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sortBtn.mas_right).offset(0);
        make.top.mas_equalTo(self.topLine.mas_bottom).offset(13);
        make.width.mas_equalTo(@1);
        make.bottom.mas_equalTo(self.bottomLine.mas_top).offset(-13);
    }];
    
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.middleLine).offset(0);
        make.top.mas_equalTo(self.topLine.mas_bottom).offset(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.bottom.mas_equalTo(self.bottomLine.mas_top);
    }];
    
}



#pragma mark - 代理
- (void)goodsListSortViewClickedSortBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(goodsListSortViewClickedSortBtn:)]){
        [self.delegate goodsListSortViewClickedSortBtn:btn];
    }
    
}

- (void)goodsListSortViewClickedFilterBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(goodsListSortViewClickedFilterBtn:)]){
        [self.delegate goodsListSortViewClickedFilterBtn:btn];
    }
    
}


@end
