//
//  BaseView.h
//  1j1j
//
//  Created by trendpower on 15/6/27.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h> //autoLayout
#import "LineThroughLabel.h" //删除线Label
#import "LineView.h" //线条
#import "CustomTextView.h" //带placeholder的TextView

#import "UIImageView+WebCache.h"

@interface BaseView : UIView

- (LineView *)getLineView;

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

@end
