//
//  CateSliderView.h
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CateSliderView;

@protocol CateSliderViewDelegate <NSObject>

- (void) cateSliderView:(CateSliderView *)cateSliderView clickedBackBtn:(UIButton *)btn;

@end


@interface CateSliderView : UIView

@property (nonatomic, weak) id<CateSliderViewDelegate> delegate;

@property (nonatomic, weak) UILabel * titleLbl;
@property (nonatomic, weak) UIView * contentView;

- (void)showSliderView;
- (void)hideSliderView;

@end
