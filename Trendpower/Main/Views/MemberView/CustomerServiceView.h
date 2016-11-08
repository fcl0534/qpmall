//
//  CustomerServiceView.h
//  Trendpower
//
//  Created by HTC on 15/6/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextView.h"
#import <Masonry.h>
#import "HUDUtil.h"

@protocol CustomerServiceViewDelegate <NSObject>

@optional
- (void)customerServiceViewClickedButton:(UIButton *)btn titileField:(UITextField *)titileField contentView:(CustomTextView *)contentView;

- (void)customerServiceViewclickedQQBtn:(UIButton *)btn;
- (void)customerServiceViewclickedTelBtn:(UIButton *)btn;

@end

@interface CustomerServiceView : UIView

@property (weak, nonatomic)  id<CustomerServiceViewDelegate>delegate;

@end
