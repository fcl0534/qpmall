//
//  RegisterView.h
//  Trendpower
//
//  Created by HTC on 15/5/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterViewDelegate <NSObject>

@optional

- (void)registerViewClickedArea;
- (void)registerViewClickedProtocol;
- (void)registerViewClickedCodeButton:(UIButton *)btn phoneField:(UITextField *)phoneField;
- (void)registerViewClickedRegisterButton:(UIButton *)registerBtn phoneField:(UITextField *)phoneField pwField:(UITextField *)pwField rePwField:(UITextField *)rePwField realNameField:(UITextField *)realNameField areaField:(UITextField *)areaField codeField:(UITextField *)codeField agreeBtn:(UIButton *)agreeBtn userCate:(NSInteger)userCate agentId:(NSInteger)agentId;

@end


@interface RegisterView : UIView

@property (weak, nonatomic)  id<RegisterViewDelegate>delegate;

@property (nonatomic, strong) NSArray *dealers;

- (void)setArea:(NSString *)area;

- (void)startCount;
- (void)removeTimer;

@end
