//
//  CustomButtonView.h
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomButtonViewDelegate <NSObject>

@optional
- (void) CustomButtonClicked:(UIButton *)btn;

@end


@interface CustomButtonView : UIView

@property (nonatomic, weak) id<CustomButtonViewDelegate> delegate;

@property (nonatomic, weak) UIButton * customBtn;

@end

