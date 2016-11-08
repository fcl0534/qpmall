//
//  BaseView.m
//  1j1j
//
//  Created by trendpower on 15/6/27.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "BaseView.h"



@implementation BaseView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (LineView *)getLineView{
    LineView * line = [[LineView alloc]init];
    [self addSubview:line];
    return line;
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


@end
