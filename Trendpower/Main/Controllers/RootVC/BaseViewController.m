//
//  BaseVC.m
//  TPtest
//
//  Created by HTC on 15/4/29.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//



#import "BaseViewController.h"

#import "LoginVC.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景为淡灰色
    self.view.backgroundColor= K_GREY_COLOR;
    [self initNaviBar];
    [self initUtil];
}

- (void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:animated];
    
    if(self.currentControllerCounts >= 2){
        [self.naviLeftItem setHidden:NO];
    }else{
        [self.naviLeftItem setHidden:YES];
    }
    
    // 防止 HUD 加载超时时不能隐藏
    [self.HUDUtil dismissAllHUD];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


#pragma mark - 自定义导航栏
- (void)initNaviBar{
    /**
     * //层次结构图
     *  NaviView (0,0,W,64) //整个导航栏(包括状态栏) H64
     *    - NaviStateView (0,0,W,20)  //状态栏 H20
     *    - NaviBar  (0,20,W,44) //导航栏 H44
     *       - NaviCustomView (0,20,W,44)  //留给自定义NaviBar
     *       - NaviLeftItem (0,0,40,44) //或者BackItem
     *       - NaviRightItem (W-40,0,40,44)
     *       - NaviTitleView (40,0,W-80,44)
     *           - NaviTitleLabel (40,20,W-80,44)
     */
    
    /**
     *  //视图
             @property (nonatomic,weak) UIView * naviView;
             @property (nonatomic,weak) UIView * naviStateView;
             @property (nonatomic,weak) UIView * naviBar;
             @property (nonatomic,weak) UIView * naviCustomView;
             @property (nonatomic,weak) UIButton * naviLeftItem;
             @property (nonatomic,weak) UIButton * naviRightItem;
             @property (nonatomic,weak) UIView * naviTitleView;
             @property (nonatomic,weak) UILabel * naviTitleLabel;
     */
    
    //1、整个导航栏
    UIView * naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 64)];
    self.naviView = naviView;
    [self.view addSubview:naviView];
    //1.1、状态栏
    UIView * naviStateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 20)];
    self.naviStateView = naviStateView;
    [naviView addSubview:naviStateView];
    //1.2、导航条
    UIView * naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 20, K_UIScreen_WIDTH, 44)];
    self.naviBar = naviBar;
    [naviView addSubview:naviBar];

    //1.2.1、左导航按钮（或返回按钮）
    UIButton * naviLeftItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, K_ITEMBTN_WIDTH, 44)];
    self.naviLeftItem = naviLeftItem;
    [naviLeftItem setImage:[UIImage imageNamed:@"navi_backBtn"] forState:UIControlStateNormal];
    //[naviBackItem setTitle:@"返回" forState:UIControlStateNormal];
    [naviLeftItem addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:naviLeftItem];
    //1.2.2、右导航按钮
    UIView * naviRightItem = [[UIView alloc]initWithFrame:CGRectMake(K_UIScreen_WIDTH - K_ITEMBTN_WIDTH, 0, K_ITEMBTN_WIDTH, 44)];
    self.naviRightItem = naviRightItem;
    [naviBar addSubview:naviRightItem];

    //1.2.3、Title视图
    UIView * naviTitleView = [[UIView alloc]initWithFrame:CGRectMake(K_ITEMBTN_WIDTH, 0, K_UIScreen_WIDTH - 2*K_ITEMBTN_WIDTH, 44)];
    self.naviTitleView = naviTitleView;
    [naviBar addSubview:naviTitleView];
    //1.2.3.1、Title视图
    UILabel * naviTitleLabel = [[UILabel alloc]initWithFrame:naviTitleView.bounds];
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.naviTitleLabel = naviTitleLabel;
    [naviTitleView addSubview:naviTitleLabel];
    
//    //1.2.4、导航条自定义栏（大小与导航条相等），放在最前面，然后自定义其它view都加到这个透明视图
//    UIView * naviCustomView = [[UIView alloc]initWithFrame:naviBar.bounds];
//    self.naviCustomView = naviCustomView;
//    [naviBar addSubview:naviCustomView];
//    naviCustomView.userInteractionEnabled = NO;
    
    /**
    *    //属性
                @property (nonatomic,strong) UIColor * naviBackgroundColor;
                @property(nonatomic,strong) UIColor * navibarTintColor;//文字的颜色
                @property (nonatomic,copy) NSString * titleText;
                @property (nonatomic,strong) UIFont * titleFont;
                @property(nonatomic,assign) BOOL hidesNaviBar;
     */
    
    //设置默认属性
    //整个导航条的背影颜色 naviBackgroundColor (naviView、naviStateView、naviBar、naviItemView、naviTitleView）
    naviView.backgroundColor = K_DEFAULT_NAVIBAR_BACKGROUND_COLOR;
    naviStateView.backgroundColor = K_DEFAULT_NAVIBAR_BACKGROUND_COLOR;
    naviBar.backgroundColor = K_DEFAULT_NAVIBAR_BACKGROUND_COLOR;
    naviTitleView.backgroundColor = K_DEFAULT_NAVIBAR_BACKGROUND_COLOR;
    
    //naviCustomView.backgroundColor = [UIColor clearColor];;
    naviLeftItem.backgroundColor = [UIColor clearColor];
    naviRightItem.backgroundColor = [UIColor clearColor];
    naviTitleLabel.backgroundColor = [UIColor clearColor];

    //navibarTintColor (naviBackItem、naviRightItem、naviTitleLabel)
    [naviLeftItem setTitleColor:K_DEFAULT_NAVIBAR_TINT_COLOR forState:UIControlStateNormal];
    naviTitleLabel.textColor = K_DEFAULT_NAVIBAR_TINT_COLOR;
    
    //titleFont
    naviTitleLabel.font = K_DEFAULT_NAVIBAR_TITLE_FONT;
    
}



#pragma mark - 设置视图
- (void)setNaviView:(UIView *)naviView{
    _naviView = naviView;
}

- (void)setNaviStateView:(UIView *)naviStateView{
    _naviStateView = naviStateView;
}

- (void)setNaviBar:(UIView *)naviBar{
    _naviBar = naviBar;
}

-(void)setNaviCustomView:(UIView *)naviCustomView{
    _naviCustomView = naviCustomView;
}

- (void)setNaviTitleView:(UIView *)naviTitleView{
    _naviTitleView = naviTitleView;
}

- (void)setNaviLeftItem:(UIButton *)naviLeftItem{
    _naviLeftItem = naviLeftItem;
}

- (void)setNaviRightItem:(UIButton *)naviRightItem{
    _naviRightItem = nil;
    _naviRightItem.frame = CGRectMake(K_UIScreen_WIDTH - K_ITEMBTN_WIDTH, 0, K_ITEMBTN_WIDTH, 44);
    _naviRightItem = naviRightItem;
}

-(void)setNaviTitleLabel:(UILabel *)naviTitleLabel{
    _naviTitleLabel = naviTitleLabel;
}


#pragma mark - 设置属性
- (void)setNaviBackgroundColor:(UIColor *)naviBackgroundColor{
    _naviView.backgroundColor = naviBackgroundColor;
    _naviStateView.backgroundColor = naviBackgroundColor;
    _naviBar.backgroundColor = naviBackgroundColor;
    _naviTitleView.backgroundColor = naviBackgroundColor;
}

- (void)setNavibarTintColor:(UIColor *)navibarTintColor{
    [_naviLeftItem setTitleColor:navibarTintColor forState:UIControlStateNormal];
    _naviTitleLabel.textColor = navibarTintColor;
}

#pragma mark - 重写
- (void)setTitle:(NSString *)title{
    _naviTitleLabel.text = title;
}

- (void)setTitleText:(NSString *)titleText{
    _naviTitleLabel.text = titleText;
}

- (void)setTitleFont:(UIFont *)titleFont{
    self.titleFont = titleFont;
}


#pragma mark -	返回上个ViewController
- (void) backButtonPressed{
    
    //代理监听
    if(self.baseDelegate &&[self respondsToSelector:@selector(baseVCDidClickedBackItem)]){
        [self.baseDelegate baseVCDidClickedBackItem];
    }

    if (self.customLeftItemAction) {
        return;
    }
    
    NSArray * controllers = [self.navigationController viewControllers];
    NSUInteger count = [controllers count];
    if( count >= 2){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark -	 当前Push栈的控制器个数
- (NSUInteger) currentControllerCounts{
    
    NSArray * controllers = [self.navigationController viewControllers];
    NSUInteger count = [controllers count];
    return count;
}

#pragma mark - 获得屏幕参数

- (UIColor *)mainColor{
    _mainColor = K_DEFAULT_NAVIBAR_BACKGROUND_COLOR;
    return _mainColor;
}


#pragma mark - initUtil
- (void)initUtil{
    if (_HUDUtil == nil) {
        _HUDUtil = [HUDUtil sharedHUDUtil];
    }
    
    if (_NetworkUtil == nil) {
        _NetworkUtil = [NetworkingUtil sharedNetworkingUtil];
    }
    
    if (_InfoHandleTool == nil) {
        _InfoHandleTool = [InfoHandleTool sharedInfoTool];
    }
    
}

//- (HUDUtil *)HUDUtil{
//    if (_HUDUtil == nil) {
//        _HUDUtil = [HUDUtil sharedHUDUtil];
//    }
//    return _HUDUtil;
//}

#pragma mark - 导航栏隐藏与显示
- (void)setHidesNaviBar:(BOOL)hidden{
    _naviView.hidden = hidden;
}

- (void)setNaviBarAnimationSlideHides:(BOOL)hidden{
    if (hidden) {
        [self hideNaviBarWithAnimation:UIStatusBarAnimationSlide naviBarframe:K_NaviBar_HIDDEN_FRAME duration:1.5];
    }else{
        [self showNaviBarWithAnimation:UIStatusBarAnimationSlide naviBarframe:K_NaviBar_NORMAL_FRAME duration:1.5];
    }
}

- (void)hideNaviBarWithFrame:(CGRect)frame duration:(NSTimeInterval)duration{
    [self hideNaviBarWithAnimation:UIStatusBarAnimationSlide naviBarframe:frame duration:duration];
}

- (void)hideNaviBarWithAnimation:(UIStatusBarAnimation)animation naviBarframe:(CGRect)frame duration:(NSTimeInterval)duration {
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:animation];
        switch (animation) {
            case UIStatusBarAnimationNone:
                _naviView.hidden = YES;
                break;
            case UIStatusBarAnimationFade:{
                [UIView animateWithDuration:duration animations:^{
                    _naviView.alpha = 0;
                }];
                break;
            }
            case UIStatusBarAnimationSlide:{
                [UIView animateWithDuration:duration animations:^{
                    _naviView.frame = frame;
                }];
                break;
            }
            default:
                break;
        }
}

- (void)showNaviBarWithAnimation:(UIStatusBarAnimation)animation naviBarframe:(CGRect)frame duration:(NSTimeInterval)duration {
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:animation];
    switch (animation) {
        case UIStatusBarAnimationNone:
            _naviView.hidden = NO;
            break;
        case UIStatusBarAnimationFade:{
            [UIView animateWithDuration:duration animations:^{
                _naviView.alpha = 1;
            }];
            break;
        }
        case UIStatusBarAnimationSlide:{
            [UIView animateWithDuration:duration animations:^{
                _naviView.frame = frame;
            }];
            break;
        }
        default:
            break;
    }
}


-(void)showAnimation:(void (^)())execute duration:(NSTimeInterval)duration{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    execute();
    [UIView commitAnimations];
}

#pragma mark - 获得key
- (NSString *)apiKey{
    return [UserDefaultsUtils getKey];
}

- (NSString *)userId{
   return [UserDefaultsUtils getUserId];
}

#pragma mark - 是否登陆
- (BOOL)isUserLogined{
    NSString *isLogin=[UserDefaultsUtils getValueByKey:KTP_ISLOGIN];
    BOOL isLogined=NO;
    if([isLogin isEqualToString:@"YES"]){
        isLogined=YES;
    }
    return isLogined;
}


- (void)gotoLogin{
    LoginVC *vc=[[LoginVC alloc] init];
    vc.hidesBottomBarWhenPushed=YES;
    UINavigationController * naviVc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:naviVc animated:YES completion:^{  }];
}


- (void)setUserLogout{
    //注销后
    [UserDefaultsUtils setValue:@"" byKey:KTP_USER_ID];
    [UserDefaultsUtils setValue:@"NO" byKey:KTP_ISLOGIN];
    [UserDefaultsUtils setValue:@"" byKey:KTP_KEY];
}


#pragma mark - 转字符串
- (NSString *)stringWithInt:(int)value{
    return [NSString stringWithFormat:@"%d",value];
}

- (NSString *)stringWithLonglnog:(long long)value{
    return [NSString stringWithFormat:@"%lld",value];
}

- (NSString *)stringWithFloat:(float)value{
    return [NSString stringWithFormat:@"%0.2f",value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
