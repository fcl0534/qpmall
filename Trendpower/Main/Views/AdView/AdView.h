//
//  AdView.h
//  EcoDuo
//
//  Created by trendpower on 15/7/3.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

@protocol AdViewDelegate <NSObject>

@optional
- (void)AdViewClickedADImageView:(UIGestureRecognizer *)tap;
- (void)AdViewClickedSkipBtn:(UIButton *)btn;
- (void)AdViewStartAnimation;
- (void)AdViewEndAnimation;
- (void)AdViewHidedAnimation;

@end


@interface AdView : UIView

@property (nonatomic, weak) id<AdViewDelegate>delegate;

@property (nonatomic, strong) UIImageView * adImageView;

@property (nonatomic, strong) UIButton * skipBtn;

@property (nonatomic, copy) NSString * adUrl;
@property (nonatomic, assign) NSTimeInterval MaxTime;
@property (nonatomic, assign) NSTimeInterval AdTime;

- (instancetype)initWithFrame:(CGRect)frame adUrl:(NSString *)adUrl adImage:(UIImage *)adImage;

- (void)startAnimation;
- (void)endAnimation;

@end
