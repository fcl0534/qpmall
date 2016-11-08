//
//  BaseVC.h
//  TPtest
//
//  Created by HTC on 15/4/29.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//接口
#import "HUDUtil.h"//提示指示器
#import "CommonUtils.h"//公共方法
#import "WebImageUtil.h"//网络图片下载
#import "NetworkingUtil.h"//网络请求
#import "MJRefresh.h" //刷新控件
#import "DashLineView.h"//画虚线
#import "EmptyPlaceholderView.h"//空视图
#import "EmptyTipsView.h"
#import "UserDefaultsUtils.h"//userdefaults
#import <Masonry.h> //autoLayout
#import "LineThroughLabel.h" //删除线Label
#import "InfoHandleTool.h" //媒体通息处理
#import "Utility.h"
#import "TPImageTools.h"
#import "WZLBadgeImport.h"

@protocol BaseVCDelegate <NSObject>

@optional
- (void) baseVCDidClickedBackItem;

@end


@interface BaseViewController : UIViewController

@property (nonatomic, weak) id<BaseVCDelegate> baseDelegate;

@property (nonatomic, strong) UIColor * mainColor;
@property (nonatomic, copy) NSString * apiKey;
@property (nonatomic, copy) NSString * userId;

//Util
@property (nonatomic, strong) HUDUtil * HUDUtil;
@property (nonatomic, strong) NetworkingUtil * NetworkUtil;
@property (nonatomic, strong) InfoHandleTool * InfoHandleTool;

/** 当前push栈里控制器个数*/
@property (nonatomic,assign) NSUInteger * controllersCounts;


- (BOOL) isUserLogined;
- (void) setUserLogout;
- (void) gotoLogin;


/** 整个导航栏视图*/
- (NSUInteger) currentControllerCounts;

- (void)initNaviBar;

/****************** UINavigationBar *******************/
/**
 *  NaviView (0,0,W,64) //整个导航栏(包括状态栏) H64
 *    - NaviStateView (0,0,W,20)  //状态栏 H20
 *    - NaviBar  (0,20,W,44) //导航栏 H44
 *       - NnaviCustomView (0,20,W,44)  //留给自定义NaviBar
 *       - NaviLeftItem (0,0,40,44) //或者LeftItem
 *       - NaviRightItem (W-40,0,40,44)
 *       - NaviTitleView (40,0,W-80,44)
 *           - NaviTitleLabel (40,20,W-80,44)
 */
//视图
/** 整个导航栏视图*/
@property (nonatomic,strong) UIView * naviView;
/** 状态栏视图*/
@property (nonatomic,strong) UIView * naviStateView;
/** 导航条视图*/
@property (nonatomic,strong) UIView * naviBar;
/** 自定义导航条视图*/
@property (nonatomic,strong) UIView * naviCustomView;
/** 导航条的LiftItem*/
@property (nonatomic,strong) UIButton * naviLeftItem;
/** 导航条的RightItem*/
@property (nonatomic,strong) UIView * naviRightItem;
/** 导航条的TitleView*/
@property (nonatomic,strong) UIView * naviTitleView;
/** 导航条的TitleLabel*/
@property (nonatomic,strong) UILabel * naviTitleLabel;

//属性
/** 整个导航栏的背影*/
@property (nonatomic,strong) UIColor * naviBackgroundColor;
/** 整个导航栏文字的颜色*/
@property(nonatomic,strong) UIColor * navibarTintColor;
/** 导航条的Title*/
@property (nonatomic,copy) NSString * titleText;
/** 导航条的字体视图*/
@property (nonatomic,strong) UIFont * titleFont;
/** 是否隐藏导航栏视图*/
@property(nonatomic,assign) BOOL hidesNaviBar;

@property (nonatomic, assign) BOOL customLeftItemAction;

//方法
- (void)setTitleText:(NSString *)titleText;

//转字符串
- (NSString *)stringWithInt:(int)value;
- (NSString *)stringWithLonglnog:(long long)value;
- (NSString *)stringWithFloat:(float)value;

/**  显示或隐藏导航栏 */
- (void)setHidesNaviBar:(BOOL)hidden;
- (void)setNaviBarAnimationSlideHides:(BOOL)hidden;
- (void)hideNaviBarWithFrame:(CGRect)frame duration:(NSTimeInterval)duration;
- (void)hideNaviBarWithAnimation:(UIStatusBarAnimation)animation naviBarframe:(CGRect)frame duration:(NSTimeInterval)duration;
- (void)showNaviBarWithAnimation:(UIStatusBarAnimation)animation naviBarframe:(CGRect)frame duration:(NSTimeInterval)duration;

-(void)showAnimation:(void (^)())execute duration:(NSTimeInterval)duration;

@end
