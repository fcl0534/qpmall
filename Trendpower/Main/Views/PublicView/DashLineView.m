//
//  DashLineView.m
//  EcDuoERP
//
//  Created by trendpower on 14/12/18.
//  Copyright (c) 2014年 trendpower. All rights reserved.
//

#import "DashLineView.h"

@implementation DashLineView

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.882f green:0.882f blue:0.882f alpha:1.00f] CGColor]);
    CGContextSetLineWidth(context, 2);

    CGFloat lengths[]={2,2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGPoint line[]={CGPointMake(0, 0),CGPointMake(self.frame.size.width, 0)};
    CGContextStrokeLineSegments(context, line, 2);
}

@end
