//
//  MeHeaderView.h
//  EcoDuo
//
//  Created by trendpower on 15/11/9.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeHeaderButton.h"

@protocol MeHeaderViewDelegate <NSObject>

@optional

- (void) meHeaderViewclickedEdit;

- (void) meHeaderViewClickedLoginButton:(UIButton *)btn;
- (void) meHeaderViewClickedNaviBarButton:(UIButton *)btn;
@end

@interface MeHeaderView : UIView

@property (nonatomic, weak) id<MeHeaderViewDelegate> delegate;

@property (nonatomic, assign) BOOL isLogin;

/**
 *  用户头像
 */
@property (nonatomic, weak) UIImageView * portraitView;
@property (nonatomic, weak) UILabel * nameLbl;
@property (nonatomic, weak) UILabel * detailLbl;

@property (nonatomic, weak) MeHeaderButton * button0;
@property (nonatomic, weak) MeHeaderButton * button1;
@property (nonatomic, weak) MeHeaderButton * button2;

- (void)setBGImageOffset:(CGFloat)offset;

@end
