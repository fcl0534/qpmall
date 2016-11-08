//
//  LineThroughLabel.h
//  Trendpower
//
//  Created by trendpower on 15/5/13.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineThroughLabel : UILabel

@property (nonatomic, assign) BOOL showLineThrough; //控制是否显示删除线

@property (nonatomic, assign) CGFloat lineThroughHeight;//设置删除线的宽度

@property (nonatomic, strong) UIColor *lineThroughColor;//设置删除线的颜色

@end
