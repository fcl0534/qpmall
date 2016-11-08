//
//  HUDUtil.m
//  Trendpower
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

// MBProgressHUD 默认风格
#define K_MBProgressHUD_Animation MBProgressHUDAnimationZoomOut
#define K_MBProgressHUD_Dim NO
#define K_MBProgressHUD_Delay 2.0

// JGProgressHUD 默认风格 为灰黑色，没有交互，动画，没有背影和阴影
#define K_JGProgressHUD_Default_Style JGProgressHUDStyleDark
#define K_JGProgressHUD_InteractionType JGProgressHUDInteractionTypeBlockAllTouches
#define K_JGProgressHUD_Zoom YES
#define K_JGProgressHUD_Dim NO
#define K_JGProgressHUD_Shadow NO
#define K_JGProgressHUD_Delay 2.0



#import "HUDUtil.h"

@interface HUDUtil()<MBProgressHUDDelegate,JGProgressHUDDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIAlertView * alertView;
@property (nonatomic,strong) UIActionSheet * actionSheet;
@property (nonatomic,strong) MBProgressHUD *MBHUD;
@property (nonatomic,strong) JGProgressHUD *JGHUD;

@end

@implementation HUDUtil
// 定义一份变量(整个程序运行过程中, 只有1份)
static id _instance;

- (id)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载资源
            self.alertView = [[UIAlertView alloc]init];
            self.JGHUD = [JGProgressHUD progressHUDWithStyle:K_JGProgressHUD_Default_Style];
            self.MBHUD = [[MBProgressHUD alloc]init];
        });
    }
    return self;
}

/**
 *  重写这个方法 : 控制内存内存
 */
+ (id)allocWithZone:(struct _NSZone *)zone
{
    // 里面的代码永远只执行1次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    // 返回对象
    return _instance;
}

+ (instancetype)sharedHUDUtil
{
    // 里面的代码永远只执行1次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    // 返回对象
    return _instance;
}

#pragma mark - 隐藏
- (void)dismissMBHUD{
    [self.MBHUD hide:YES];
}

- (void)dismissJGHUD{
    [self.JGHUD dismiss];
}

- (void)dismissAllHUD{
    [self.JGHUD dismiss];
    [self.MBHUD hide:YES];
}

- (void)dismissMBHUDWithDelay:(NSTimeInterval)delay{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.MBHUD hide:YES];
    });
}

- (void)dismissJGHUDWithDelay:(NSTimeInterval)delay{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.JGHUD dismiss];
    });
}

- (void)dismissAllHUDWithDelay:(NSTimeInterval)delay{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.JGHUD dismiss];
        [self.MBHUD hide:YES];
    });
}



#pragma mark - UIAlertView
- (void)showAlertViewWithTitle:(NSString *)title mesg:(NSString *)mesg confirmTitle:(NSString *)confirmTitle tag:(NSInteger)tag{
    self.alertView = [[UIAlertView alloc]initWithTitle:title message:mesg delegate:self cancelButtonTitle:nil otherButtonTitles:confirmTitle, nil];
    self.alertView.tag = tag;
    self.alertView.alertViewStyle = UIAlertViewStyleDefault;
    self.alertView.delegate = self;
    [self.alertView show];
}

- (void)showAlertViewWithTitle:(NSString *)title mesg:(NSString *)mesg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle tag:(NSInteger)tag{
    self.alertView = [[UIAlertView alloc]initWithTitle:title message:mesg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    self.alertView.tag = tag;
    self.alertView.alertViewStyle = UIAlertViewStyleDefault;
    self.alertView.delegate = self;
    [self.alertView show];
}

- (void)showAlertViewWithTitle:(NSString *)title mesg:(NSString *)mesg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle tag:(NSInteger)tag textInput:(BOOL)isInput{
    self.alertView = [[UIAlertView alloc]initWithTitle:title message:mesg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    self.alertView.tag = tag;
    self.alertView.delegate = self;
    if (isInput) {
        self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [self.alertView textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
    }else{
        self.alertView.alertViewStyle = UIAlertViewStyleDefault;
    }
    [self.alertView show];
}

- (void)showAlertViewWithTitle:(NSString *)title mesg:(NSString *)mesg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle tag:(NSInteger)tag inputText:(NSString *)text{
    self.alertView = [[UIAlertView alloc]initWithTitle:title message:mesg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    self.alertView.tag = tag;
    self.alertView.delegate = self;
    self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.alertView textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.alertView textFieldAtIndex:0].text = text;
    [self.alertView show];
}

- (void)showAlertViewWithTitle:(NSString *)title mesg:(NSString *)mesg cancelTitle:(NSString *)cancelTitle  otherButtonTitles:(NSArray *)otherButtonTitles tag:(NSInteger)tag{
    self.alertView = [[UIAlertView alloc]initWithTitle:title message:mesg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles: nil];
    for (int i= 0; i<[otherButtonTitles count ]; i++){
        NSString *str = [[NSString alloc]initWithFormat:@"%@",[otherButtonTitles objectAtIndex:i]];
        [self.alertView addButtonWithTitle :str];
    }
    self.alertView.tag = tag;
    self.alertView.delegate = self;
    [self.alertView show];
}

- (void)showActionSheetInView:(UIView *)view tag:(NSInteger)tag title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles{
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    for (int i= 0; i<[otherButtonTitles count ]; i++){
        NSString *str = [[NSString alloc]initWithFormat:@"%@",[otherButtonTitles objectAtIndex:i]];
        [self.actionSheet addButtonWithTitle :str];
    }
    self.actionSheet.tag = tag;
    self.actionSheet.delegate = self;
    self.actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [self.actionSheet showInView:view];
}

#pragma mark UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.delegate respondsToSelector:@selector(hudAlertViewClickedAtIndex:tag:)]) {
        [self.delegate hudAlertViewClickedAtIndex:buttonIndex tag:alertView.tag];
    }
    
    if ([self.delegate respondsToSelector:@selector(hudAlertView:clickedAtIndex:tag:)]) {
        [self.delegate hudAlertView:alertView clickedAtIndex:buttonIndex tag:alertView.tag];
    }
    
    if(self.clickedAlertViewBlock){
        self.clickedAlertViewBlock(alertView, buttonIndex, alertView.tag);
    }
}


#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([self.delegate respondsToSelector:@selector(hudActionSheetClickedAtIndex:tag:)]) {
        [self.delegate hudActionSheetClickedAtIndex:buttonIndex tag:actionSheet.tag];
    }
    
    if(self.clickedActionSheetBlock){
        self.clickedActionSheetBlock(actionSheet, buttonIndex, actionSheet.tag);
    }
}


#pragma mark - MBProgressHUD
#pragma mark 文字提示
- (void)showTextMBHUDWithText:(NSString *)text inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.mode = MBProgressHUDModeText;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.labelText = text;
    
    [self.MBHUD show:YES];
}


- (void)showTextMBHUDWithText:(NSString *)text delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.mode = MBProgressHUDModeText;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.labelText = text;
    
    [self.MBHUD show:YES];
    [self.MBHUD hide:YES afterDelay:delay];
}

- (void)showTextMBHUDInWindowWithText:(NSString *)text delay:(NSTimeInterval)delay{
    [self showTextMBHUDWithText:text delay:delay inView:[UIApplication sharedApplication].keyWindow];
}


- (void)showTextMBHUDWithText:(NSString *)text labelFont:(UIFont *)labelFont xOffset:(float)xOffse yOffset:(float)yOffset delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.mode = MBProgressHUDModeText;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.labelText = text;
    self.MBHUD.labelFont = labelFont;
    self.MBHUD.xOffset = xOffse;
    self.MBHUD.yOffset = yOffset;
    
    [self.MBHUD show:YES];
    [self.MBHUD hide:YES afterDelay:delay];
}


- (void)showTextMBHUDWithText:(NSString *)text labelFont:(UIFont *)labelFont xOffset:(float)xOffse yOffset:(float)yOffset margin:(float)margin delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.mode = MBProgressHUDModeText;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.labelText = text;
    self.MBHUD.labelFont = labelFont;
    self.MBHUD.xOffset = xOffse;
    self.MBHUD.yOffset = yOffset;
    self.MBHUD.margin = margin;
    
    [self.MBHUD show:YES];
    [self.MBHUD hide:YES afterDelay:delay];
}


- (void)showTextMBHUDWithText:(NSString *)text labelFont:(UIFont *)labelFont labelColor:(UIColor *)labelColor xOffset:(float)xOffse yOffset:(float)yOffset margin:(float)margin cornerRadius:(float)cornerRadius dimBackground:(BOOL)dim opacityBackground:(float)opacity colorBackground:(UIColor *)color activityIndicatorColor:(UIColor *)activityIndicatorColor animationType:(MBProgressHUDAnimation)animationType  delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.mode = MBProgressHUDModeText;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.labelText = text;
    self.MBHUD.labelFont = labelFont;
    self.MBHUD.labelColor = labelColor;
    self.MBHUD.xOffset = xOffse;
    self.MBHUD.yOffset = yOffset;
    self.MBHUD.margin = margin;
    self.MBHUD.cornerRadius = cornerRadius;
    self.MBHUD.dimBackground = dim;
    self.MBHUD.opacity = opacity;
    self.MBHUD.color = color;
    self.MBHUD.activityIndicatorColor = activityIndicatorColor;
    self.MBHUD.animationType = animationType;
    
    [self.MBHUD show:YES];
    [self.MBHUD hide:YES afterDelay:delay];
}

#pragma mark +DetailsTextHUD
- (void)showTextMBHUDWithLabelText:(NSString *)labeltext detailsText:(NSString *)detailsText inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.mode = MBProgressHUDModeText;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.labelText = labeltext;
    self.MBHUD.detailsLabelText = detailsText;
    
    [self.MBHUD show:YES];
}


- (void)showTextMBHUDWithLabelText:(NSString *)labeltext detailsText:(NSString *)detailsText  delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.mode = MBProgressHUDModeText;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.labelText = labeltext;
    self.MBHUD.detailsLabelText = detailsText;
    
    [self.MBHUD show:YES];
    [self.MBHUD hide:YES afterDelay:delay];
}


- (void)showTextMBHUDWithLabelText:(NSString *)labeltext detailsText:(NSString *)detailsText labelFont:(UIFont *)labelFont labelColor:(UIColor *)labelColor detailsLabelFont:(UIFont *)detailsLabelFont detailsLabelColor:(UIColor *)detailsLabelColor xOffset:(float)xOffse yOffset:(float)yOffset margin:(float)margin cornerRadius:(float)cornerRadius dimBackground:(BOOL)dim opacityBackground:(float)opacity colorBackground:(UIColor *)color activityIndicatorColor:(UIColor *)activityIndicatorColor animationType:(MBProgressHUDAnimation)animationType delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.mode = MBProgressHUDModeText;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.labelText = labeltext;
    self.MBHUD.labelFont = labelFont;
    self.MBHUD.labelColor = labelColor;
    self.MBHUD.detailsLabelText = detailsText;
    self.MBHUD.detailsLabelFont = detailsLabelFont;
    self.MBHUD.detailsLabelColor = detailsLabelColor;
    self.MBHUD.xOffset = xOffse;
    self.MBHUD.yOffset = yOffset;
    self.MBHUD.margin = margin;
    self.MBHUD.cornerRadius = cornerRadius;
    self.MBHUD.dimBackground = dim;
    self.MBHUD.opacity = opacity;
    self.MBHUD.color = color;
    self.MBHUD.activityIndicatorColor = activityIndicatorColor;
    self.MBHUD.animationType = animationType;
    
    [self.MBHUD show:YES];
    [self.MBHUD hide:YES afterDelay:delay];
}

#pragma mark 加载中...
- (void)showLoadingMBHUDInView:(UIView *)view{

    if (view == nil) {
        return;
    }

    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.mode = MBProgressHUDModeIndeterminate;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    
    [self.MBHUD show:YES];
}

- (void)showLoadingMBHUDInView:(UIView *)view delay:(NSTimeInterval)delay{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.mode = MBProgressHUDModeIndeterminate;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    
    [self.MBHUD show:YES];
    [self.MBHUD hide:YES afterDelay:delay];
}


- (void)showLoadingMBHUDWithText:(NSString *)text inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.mode = MBProgressHUDModeIndeterminate;
    self.MBHUD.delegate = self;
    self.MBHUD.labelText = text;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    
    [self.MBHUD show:YES];
}


- (void)showLoadingMBHUDWithText:(NSString *)text detailsText:(NSString *)detailsText inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.mode = MBProgressHUDModeIndeterminate;
    self.MBHUD.delegate = self;
    self.MBHUD.labelText = text;
    self.MBHUD.detailsLabelText = detailsText;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    
    [self.MBHUD show:YES];
}


#pragma mark 自定义视图
- (void)showCustomMBHUDWithCustomView:(UIView *)customView inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.mode = MBProgressHUDModeCustomView;
    self.MBHUD.customView = customView;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    
    [self.MBHUD show:YES];
}


- (void)showCustomMBHUDWithCustomView:(UIView *)customView delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.mode = MBProgressHUDModeCustomView;
    self.MBHUD.customView = customView;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    
    [self.MBHUD show:YES];
    [self.MBHUD hide:YES afterDelay:delay];
}


- (void)showCustomMBHUDWithCustomView:(UIView *)customView labeltext:(NSString *)labeltext inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.mode = MBProgressHUDModeCustomView;
    self.MBHUD.customView = customView;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.labelText = labeltext;
    
    [self.MBHUD show:YES];
}

- (void)showCustomMBHUDWithCustomView:(UIView *)customView labeltext:(NSString *)labeltext  delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.MBHUD.mode = MBProgressHUDModeCustomView;
    self.MBHUD.customView = customView;
    self.MBHUD.delegate = self;
    self.MBHUD.dimBackground = K_MBProgressHUD_Dim;
    self.MBHUD.animationType = K_MBProgressHUD_Animation;
    self.MBHUD.labelText = labeltext;
    
    [self.MBHUD show:YES];
    [self.MBHUD hide:YES afterDelay:delay];
    
}


#pragma mark 成功！
- (void)showSuccessMBHUDWithText:(NSString *)text inView:(UIView *)view{
    [self showCustomMBHUDWithCustomView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hud_success"]] labeltext:text inView:view];
}

- (void)showSuccessMBHUDWithText:(NSString *)text inView:(UIView *)view delay:(NSTimeInterval)delay{
    [self showCustomMBHUDWithCustomView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hud_success"]] labeltext:text delay:delay inView:view];
}

#pragma mark 失败！
- (void)showErrorMBHUDWithText:(NSString *)text inView:(UIView *)view{
    [self showCustomMBHUDWithCustomView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hud_error"]] labeltext:text inView:view];
}

- (void)showErrorMBHUDWithText:(NSString *)text inView:(UIView *)view delay:(NSTimeInterval)delay{
    [self showCustomMBHUDWithCustomView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hud_error"]] labeltext:text delay:delay inView:view];
}

#pragma mark 网络请求繁忙
- (void)showNetworkErrorInView:(UIView *)view{
    [self showTextMBHUDWithText:@"网络出错，请重试" delay:1.5 inView:view];
}



#pragma mark MBProgressHUDDelegate
//- (void)hudWasHidden:(MBProgressHUD *)hud {
//
//    	NSLog(@"---hudWasHidden");
//}


#pragma mark - JGProgressHUD
// init
- (JGProgressHUD *)prototypeHUDStyle:(JGProgressHUDStyle)style interactionType:(JGProgressHUDInteractionType)interaction zoom:(BOOL)zoom dim:(BOOL)dim shadow:(BOOL)shadow{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:style];
    HUD.interactionType = interaction;
    if (zoom) {
        JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
        HUD.animation = an;
    }
    
    if (dim) {
        HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    }
    
    if (shadow) {
        HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
        HUD.HUDView.layer.shadowOffset = CGSizeZero;
        HUD.HUDView.layer.shadowOpacity = 0.4f;
        HUD.HUDView.layer.shadowRadius = 8.0f;
    }
    
    HUD.delegate = self;
    return HUD;
}

#pragma mark 文字提示
- (void)showTextJGHUDWithText:(NSString *)text inView:(UIView *)view{
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.JGHUD.indicatorView = nil;
    self.JGHUD.textLabel.font = [UIFont systemFontOfSize:18.0f];
    self.JGHUD.textLabel.text = text;
    self.JGHUD.position = JGProgressHUDPositionCenter;
    [self.JGHUD showInView:view];
    [self.JGHUD dismissAfterDelay:K_JGProgressHUD_Delay];
}

- (void)showTextJGHUDWithText:(NSString *)text delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.JGHUD.indicatorView = nil;
    self.JGHUD.textLabel.font = [UIFont systemFontOfSize:18.0f];
    self.JGHUD.textLabel.text = text;
    self.JGHUD.position = JGProgressHUDPositionCenter;
    [self.JGHUD showInView:view];
    [self.JGHUD dismissAfterDelay:delay];
}

- (void)showTextJGHUDWithText:(NSString *)text font:(UIFont *)font position:(JGProgressHUDPosition)position delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.JGHUD.indicatorView = nil;
    self.JGHUD.textLabel.font = font;
    self.JGHUD.textLabel.text = text;
    self.JGHUD.position = position;
    [self.JGHUD showInView:view];
    [self.JGHUD dismissAfterDelay:delay];
}

- (void)showTextJGHUDWithText:(NSString *)text font:(UIFont *)font position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.JGHUD.indicatorView = nil;
    self.JGHUD.textLabel.text = text;
    self.JGHUD.textLabel.font = font;
    self.JGHUD.position = position;
    self.JGHUD.marginInsets = marginInsets;
    //    self.JGHUD.marginInsets = (UIEdgeInsets) {
    //        .top = 0.0f,
    //        .bottom = 20.0f,
    //        .left = 0.0f,
    //        .right = 0.0f,
    //    };
    [self.JGHUD showInView:view];
    [self.JGHUD dismissAfterDelay:delay];
}

- (void)showTextJGHUDWithText:(NSString *)text position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay zoom:(BOOL)zoom inView:(UIView *)view{
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.JGHUD.indicatorView = nil;
    self.JGHUD.textLabel.text = text;
    self.JGHUD.position = position;
    self.JGHUD.marginInsets = marginInsets;
    //    self.JGHUD.marginInsets = (UIEdgeInsets) {
    //        .top = 0.0f,
    //        .bottom = 20.0f,
    //        .left = 0.0f,
    //        .right = 0.0f,
    //    };
    [self.JGHUD showInView:view];
    [self.JGHUD dismissAfterDelay:delay];
}

- (void)showTextJGHUDWithStyle:(JGProgressHUDStyle)style interactionType:(JGProgressHUDInteractionType)interaction zoom:(BOOL)zoom dim:(BOOL)dim shadow:(BOOL)shadow text:(NSString *)text font:(UIFont *)font position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.JGHUD = [self prototypeHUDStyle:style interactionType:interaction zoom:zoom dim:dim shadow:shadow];
    self.JGHUD.indicatorView = nil;
    self.JGHUD.textLabel.text = text;
    self.JGHUD.textLabel.font = font;
    self.JGHUD.position = position;
    self.JGHUD.marginInsets = marginInsets;
    //    self.JGHUD.marginInsets = (UIEdgeInsets) {
    //        .top = 0.0f,
    //        .bottom = 20.0f,
    //        .left = 0.0f,
    //        .right = 0.0f,
    //    };
    [self.JGHUD showInView:view];
    [self.JGHUD dismissAfterDelay:delay];
}

#pragma mark 加载中...
- (void)showLoadingJGHUDInView:(UIView *)view  {
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    [self.JGHUD showInView:view];
    [self.JGHUD dismissAfterDelay:K_JGProgressHUD_Delay];
}

- (void)showLoadingJGHUDWithText:(NSString *)text inView:(UIView *)view  {
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.JGHUD.textLabel.text = text;
    [self.JGHUD showInView:view];
    [self.JGHUD dismissAfterDelay:K_JGProgressHUD_Delay];
}

- (void)showLoadingJGHUDInView:(UIView *)view delay:(NSTimeInterval)delay {
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    [self.JGHUD showInView:view];
    [self.JGHUD dismissAfterDelay:delay];
}

#pragma mark 成功！
- (void)showSuccessJGHUDWithText:(NSString *)text inView:(UIView *)view{
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.JGHUD .textLabel.text = text;
    self.JGHUD .indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    self.JGHUD .square = YES;
    [self.JGHUD  showInView:view];
    [self.JGHUD  dismissAfterDelay:K_JGProgressHUD_Delay];
}

- (void)showSuccessJGHUDWithText:(NSString *)text inView:(UIView *)view delay:(NSTimeInterval)delay {
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.JGHUD .textLabel.text = text;
    self.JGHUD .indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    self.JGHUD .square = YES;
    [self.JGHUD  showInView:view];
    [self.JGHUD  dismissAfterDelay:delay];
}

#pragma mark 失败！
- (void)showErrorJGHUDWithText:(NSString *)text inView:(UIView *)view {
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.JGHUD .textLabel.text = text;
    self.JGHUD .indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    self.JGHUD .square = YES;
    [self.JGHUD  showInView:view];
    [self.JGHUD  dismissAfterDelay:K_JGProgressHUD_Delay];
}

- (void)showErrorJGHUDWithText:(NSString *)text inView:(UIView *)view  delay:(NSTimeInterval)delay {
    self.JGHUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.JGHUD .textLabel.text = text;
    self.JGHUD .indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    self.JGHUD .square = YES;
    [self.JGHUD  showInView:view];
    [self.JGHUD  dismissAfterDelay:delay];
}

#pragma mark 进度HUD


#pragma mark JGProgressHUDDelegate

//- (void)progressHUD:(JGProgressHUD *)progressHUD willPresentInView:(UIView *)view {
//    NSLog(@"JGHUD %p will present in view: %p", progressHUD, view);
//}
//
//- (void)progressHUD:(JGProgressHUD *)progressHUD didPresentInView:(UIView *)view {
//    NSLog(@"JGHUD %p did present in view: %p", progressHUD, view);
//}
//
//- (void)progressHUD:(JGProgressHUD *)progressHUD willDismissFromView:(UIView *)view {
//    NSLog(@"JGHUD %p will dismiss from view: %p", progressHUD, view);
//}
//
//- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view {
//    NSLog(@"JGHUD %p did dismiss from view: %p", progressHUD, view);
//}



@end
