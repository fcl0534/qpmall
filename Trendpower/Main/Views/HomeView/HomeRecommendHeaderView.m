//
//  HomeRecommendHeaderView.m
//  Trendpower
//
//  Created by HTC on 16/1/26.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "HomeRecommendHeaderView.h"

#import <Masonry.h>



@interface HomeRecommendHeaderView()

@property (nonatomic, weak) UIView * leftLine;
@property (nonatomic, weak) UIView * rightLine;
@property (nonatomic, weak) UILabel * titleLbl;

@end

@implementation HomeRecommendHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    
    return self;
}


- (void)setup{

    self.leftLine = [self getLineView];
    self.rightLine = [self getLineView];
    self.titleLbl = [self getLabel];
}

- (UIView *)getLineView{
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.823 alpha:1.000];
    [self addSubview:line];
    return line;
}

- (UIImageView *) getImageView{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    return imageView;
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0.499 green:0.505 blue:0.521 alpha:1.000];
    [self addSubview:label];
    return label;
}


- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLbl.text = title;
    
    [self addViewConstraints];
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)addViewConstraints{
    
    
    CGSize textSize = [self sizeWithText:self.title font:self.titleLbl.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(textSize.width);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.titleLbl.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(@0.6);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.left.mas_equalTo(self.titleLbl.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(@0.6);
    }];
    
}

@end
