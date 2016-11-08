//
//  EmptyPlaceholderView.h
//  Trendpower
//
//  Created by HTC on 15/5/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmptyPlaceholderViewDelegate <NSObject>

@optional

- (void)EmptyPlaceholderViewClickedButton:(UIButton *)btn;

@end

@interface EmptyPlaceholderView : UIView

@property (weak, nonatomic)  id<EmptyPlaceholderViewDelegate>delegate;
/**
 *  创建空 视图
 */
- (instancetype) initWithFrame:(CGRect)frame placeholderText:(NSString *)placeholdertext placeholderIamge:(UIImage *)image btnName:(NSString *)btnName;
@end
