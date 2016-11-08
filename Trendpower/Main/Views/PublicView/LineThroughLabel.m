//
//  LineThroughLabel.m
//  Trendpower
//
//  Created by trendpower on 15/5/13.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "LineThroughLabel.h"

@implementation LineThroughLabel

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code

        self.lineThroughColor = [UIColor colorWithWhite:0.200 alpha:1.000];//默认删除线的颜色
        
        self.lineThroughHeight = 1;//默认删除线的宽度是1pix
        
        self.showLineThrough = YES;//默认显示删除线
        
    }
 
    return self;

}


// Only override drawRect: if you perform custom drawing.

// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code

    [super drawRect:rect];
    
    if (self.showLineThrough && self.text.length)//显示删除线
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [self.lineThroughColor CGColor]);
        CGContextSetLineWidth(context, self.lineThroughHeight);
        
        CGContextBeginPath(context);
        
        CGFloat halfWayUp = (self.bounds.size.height - self.bounds.origin.y) / 2.0;
        
        CGContextMoveToPoint(context, self.bounds.origin.x -5, halfWayUp );
        
        CGSize fontSize = [self sizeWithText:self.text font:self.font maxSize:self.frame.size];
        CGContextAddLineToPoint(context, self.bounds.origin.x + fontSize.width +5, halfWayUp);
        
        CGContextStrokePath(context);
    }

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
