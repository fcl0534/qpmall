//
//  UserInfoEditView.h
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "UserInfoModel.h"

@protocol UserInfoEditViewDelegate <NSObject>

@optional
- (void)userInfoEditViewClickedButton:(UIButton *)btn phoneField:(UITextField *)phoneField realNameField:(UITextField *)realNameField companyNameField:(UITextField *)companyNameField areaNameField:(UITextField *)areaNameField emailField:(UITextField *)emailField genderType:(NSString *)genderType;

- (void)userInfoEditViewClickedIamgeView:(UIImageView *)imageView;

- (void)userInfoEditViewClickedTapIndex:(NSInteger)index;


@end

@interface UserInfoEditView : UIView

@property (weak, nonatomic)  id<UserInfoEditViewDelegate>delegate;

@property (weak, nonatomic)  UILabel *imageLabel;
@property (weak, nonatomic)  UILabel *realNameLabel;
@property (weak, nonatomic)  UILabel *phoneLabel;
@property (weak, nonatomic)  UILabel *companyNameLabel;
@property (weak, nonatomic)  UILabel *areaNameLabel;
@property (weak, nonatomic)  UILabel *emailLabel;
@property (weak, nonatomic)  UILabel *genderLabel;

/** 头像 */
@property (weak, nonatomic)  UIImageView *imageView;
/** 真实姓名 */
@property (weak, nonatomic)  UITextField *realNameField;
/** 手机号码 */
@property (weak, nonatomic)  UITextField *phoneField;
/** 公司名 */
@property (weak, nonatomic)  UITextField *companyNameField;
/** 所在城市 */
@property (weak, nonatomic)  UITextField *areaNameField;
/** 邮箱 */
@property (weak, nonatomic)  UITextField *emailField;
/** 性别 */

/** 确认按钮 */
@property (weak, nonatomic)  UIButton * confirmButton;


/** 用户模型 */
@property (strong, nonatomic)  UserInfoModel * userModel;



@end
