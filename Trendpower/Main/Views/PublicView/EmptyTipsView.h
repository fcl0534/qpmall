//
//  EmptyTipsView.h
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol EmptyTipsViewDelegate <NSObject>

@optional

- (void)EmptyTipsViewClickedButton:(UIButton *)btn;

@end

@interface EmptyTipsView : UIView

@property (weak, nonatomic)  id<EmptyTipsViewDelegate>delegate;

/**
 *  创建空 视图
 */
- (instancetype) initWithFrame:(CGRect)frame tipsIamge:(UIImage *)tipsimage tipsTitle:(NSString *)tipsTitle tipsDetail:(NSString *)tipsDetail btnName:(NSString *)btnName;
@end
