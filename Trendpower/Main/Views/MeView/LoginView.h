//
//  LoginView.h
//  Trendpower
//
//  Created by HTC on 15/5/10.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LoginViewDelegate <NSObject>

@optional
- (void)loginViewClickedButton:(UIButton *)btn userField:(UITextField *)userField pwField:(UITextField *)pwField;
- (void)loginViewClickedRegisterButton;
- (void)loginViewClickedFindPwButton;
- (void)loginViewClickedBackButton;
@end

@interface LoginView : UIView

@property (weak, nonatomic)  id<LoginViewDelegate>delegate;

/** 用户名 */
@property (weak, nonatomic)  UITextField *userF;

@end
