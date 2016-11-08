//
//  MemberHeaderView.h
//  Trendpower
//
//  Created by trendpower on 15/5/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserInfoModel.h"

@protocol MemberHeaderViewDelegate <NSObject>

@optional
/** 点击头像 */
- (void)MemberHeaderViewClickedUserIamgeView;
/** 点击背景 */
- (void)MemberHeaderViewClickedBackgroundView;
/**
 *  点击订单视图
 */
- (void)MemberHeaderViewClickedOrderBtn:(UIButton *)btn;

@end


@interface MemberHeaderView : UIView

@property (weak, nonatomic)  id<MemberHeaderViewDelegate>delegate;

@property (weak, nonatomic)  UIImageView *userIamgeView;
@property (weak, nonatomic)  UILabel * userNameLbel;
// 积分
@property (weak, nonatomic)  UILabel * coinTotalLbel;

@property (nonatomic, strong) UserInfoModel *userModel;


@end
