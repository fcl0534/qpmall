//
//  HUDUtil.h
//  Trendpower
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#if JGProgressHUD_Framework
#import <JGProgressHUD/JGProgressHUD.h>
#else
#import "JGProgressHUD.h"
#endif


@protocol HUDAlertViewDelegate <NSObject>

@optional
- (void)hudAlertViewClickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag;
- (void)hudAlertView:(UIAlertView * _Nullable)alertView clickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag;
- (void)hudActionSheetClickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag;
@end


@interface HUDUtil : NSObject

@property (nonatomic,weak) id<HUDAlertViewDelegate>delegate;

/**  HUDClickedHUDViewBlock */
typedef void(^HUDClickedHUDViewBlock)(_Nullable id hudView, NSInteger clickedIndex, NSInteger tag);

/**  HUD单例 */
+ (_Nullable instancetype)sharedHUDUtil;


/**  隐藏HUD */
/**  隐藏MBHUD */
- (void)dismissMBHUD;
/**  隐藏JGHUD */
- (void)dismissJGHUD;
/**  隐藏全部HUD */
- (void)dismissAllHUD;

- (void)dismissMBHUDWithDelay:(NSTimeInterval)delay;

- (void)dismissJGHUDWithDelay:(NSTimeInterval)delay;

- (void)dismissAllHUDWithDelay:(NSTimeInterval)delay;


/**  UIAlertView */

/**  UIAlertView 只有确认的提示框*/
- (void)showAlertViewWithTitle:(NSString * _Nullable)title mesg:(NSString * _Nullable)mesg confirmTitle:(NSString * _Nullable)confirmTitle tag:(NSInteger)tag;
/**  UIAlertView 标准取消确认的提示框*/
- (void)showAlertViewWithTitle:(NSString * _Nullable)title mesg:(NSString * _Nullable)mesg cancelTitle:(NSString * _Nullable)cancelTitle confirmTitle:(NSString * _Nullable)confirmTitle tag:(NSInteger)tag;
/**  UIAlertView 是否显示输入框的提示框*/
- (void)showAlertViewWithTitle:(NSString * _Nullable)title mesg:(NSString * _Nullable)mesg cancelTitle:(NSString * _Nullable)cancelTitle confirmTitle:(NSString * _Nullable)confirmTitle tag:(NSInteger)tag textInput:(BOOL)isInput;
/**  UIAlertView 预先输入框的提示框*/
- (void)showAlertViewWithTitle:(NSString * _Nullable)title mesg:(NSString * _Nullable)mesg cancelTitle:(NSString * _Nullable)cancelTitle confirmTitle:(NSString * _Nullable)confirmTitle tag:(NSInteger)tag inputText:(NSString * _Nullable)text;
/**  UIAlertView 多按钮的提示框*/
- (void)showAlertViewWithTitle:(NSString * _Nullable)title mesg:(NSString * _Nullable)mesg cancelTitle:(NSString * _Nullable)cancelTitle  otherButtonTitles:(NSArray * _Nullable)otherButtonTitles tag:(NSInteger)tag;
/**  UIAlertView ActionSheet*/
- (void)showActionSheetInView:(UIView * _Nullable)view tag:(NSInteger)tag title:(NSString * _Nullable)title cancelButtonTitle:(NSString * _Nullable)cancelButtonTitle destructiveButtonTitle:(NSString * _Nullable)destructiveButtonTitle otherButtonTitles:(NSArray * _Nullable)otherButtonTitles;

//    typeof(self) weakSelf = self;
/**
 *  AlertView回调
 */
@property (nonatomic, copy, nonnull) HUDClickedHUDViewBlock clickedAlertViewBlock;
@property (nonatomic, copy, nonnull) HUDClickedHUDViewBlock clickedActionSheetBlock;

/**  MBProgressHUD */
// TextHUD
- (void)showTextMBHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view;
- (void)showTextMBHUDWithText:(NSString * _Nullable)text delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;
- (void)showTextMBHUDWithText:(NSString * _Nullable)text labelFont:(UIFont * _Nullable)labelFont xOffset:(float)xOffse yOffset:(float)yOffset delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;
- (void)showTextMBHUDWithText:(NSString * _Nullable)text labelFont:(UIFont * _Nullable)labelFont xOffset:(float)xOffse yOffset:(float)yOffset margin:(float)margin delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;
- (void)showTextMBHUDWithText:(NSString * _Nullable)text labelFont:(UIFont * _Nullable)labelFont labelColor:(UIColor * _Nullable)labelColor xOffset:(float)xOffse yOffset:(float)yOffset margin:(float)margin cornerRadius:(float)cornerRadius dimBackground:(BOOL)dim opacityBackground:(float)opacity colorBackground:(UIColor * _Nullable)color activityIndicatorColor:(UIColor * _Nullable)activityIndicatorColor animationType:(MBProgressHUDAnimation)animationType  delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;
// show in Window
- (void)showTextMBHUDInWindowWithText:(NSString * _Nullable)text delay:(NSTimeInterval)delay;


// +DetailsTextHUD
- (void)showTextMBHUDWithLabelText:(NSString * _Nullable)labeltext detailsText:(NSString * _Nullable)detailsText inView:(UIView * _Nullable)view;
- (void)showTextMBHUDWithLabelText:(NSString * _Nullable)labeltext detailsText:(NSString * _Nullable)detailsText  delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;
- (void)showTextMBHUDWithLabelText:(NSString * _Nullable)labeltext detailsText:(NSString * _Nullable)detailsText labelFont:(UIFont * _Nullable)labelFont labelColor:(UIColor * _Nullable)labelColor detailsLabelFont:(UIFont * _Nullable)detailsLabelFont detailsLabelColor:(UIColor * _Nullable)detailsLabelColor xOffset:(float)xOffse yOffset:(float)yOffset margin:(float)margin cornerRadius:(float)cornerRadius dimBackground:(BOOL)dim opacityBackground:(float)opacity colorBackground:(UIColor * _Nullable)color activityIndicatorColor:(UIColor * _Nullable)activityIndicatorColor animationType:(MBProgressHUDAnimation)animationType delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;

// LoadingHUD
- (void)showLoadingMBHUDInView:(UIView * _Nullable)view;
- (void)showLoadingMBHUDInView:(UIView * _Nullable)view delay:(NSTimeInterval)delay;
- (void)showLoadingMBHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view;
- (void)showLoadingMBHUDWithText:(NSString * _Nullable)text detailsText:(NSString * _Nullable)detailsText inView:(UIView * _Nullable)view;

//CustomView
- (void)showCustomMBHUDWithCustomView:(UIView * _Nullable)customView inView:(UIView * _Nullable)view;
- (void)showCustomMBHUDWithCustomView:(UIView * _Nullable)customView delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;
- (void)showCustomMBHUDWithCustomView:(UIView * _Nullable)customView labeltext:(NSString * _Nullable)labeltext inView:(UIView * _Nullable)view;
- (void)showCustomMBHUDWithCustomView:(UIView * _Nullable)customView labeltext:(NSString * _Nullable)labeltext  delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;

// SuccessTextHUD
- (void)showSuccessMBHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view;
- (void)showSuccessMBHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view delay:(NSTimeInterval)delay;
// ErrorTextHUD
- (void)showErrorMBHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view;
- (void)showErrorMBHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view delay:(NSTimeInterval)delay;

// 网络请求繁忙
- (void)showNetworkErrorInView:(UIView * _Nullable)view;


/**  JGProgressHUD */
// TextHUD
- (void)showTextJGHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view;
- (void)showTextJGHUDWithText:(NSString * _Nullable)text delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;
- (void)showTextJGHUDWithText:(NSString * _Nullable)text font:(UIFont * _Nullable)font position:(JGProgressHUDPosition)position delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;
- (void)showTextJGHUDWithText:(NSString * _Nullable)text font:(UIFont * _Nullable)font position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;
- (void)showTextJGHUDWithText:(NSString * _Nullable)text position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay zoom:(BOOL)zoom inView:(UIView * _Nullable)view;
- (void)showTextJGHUDWithStyle:(JGProgressHUDStyle)style interactionType:(JGProgressHUDInteractionType)interaction zoom:(BOOL)zoom dim:(BOOL)dim shadow:(BOOL)shadow text:(NSString * _Nullable)text font:(UIFont * _Nullable)font position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay inView:(UIView * _Nullable)view;
// LoadingHUD
- (void)showLoadingJGHUDInView:(UIView * _Nullable)view ;
- (void)showLoadingJGHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view;
- (void)showLoadingJGHUDInView:(UIView * _Nullable)view delay:(NSTimeInterval)delay;
// SuccessTextHUD
- (void)showSuccessJGHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view;
- (void)showSuccessJGHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view delay:(NSTimeInterval)delay;
// ErrorTextHUD
- (void)showErrorJGHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view;
- (void)showErrorJGHUDWithText:(NSString * _Nullable)text inView:(UIView * _Nullable)view delay:(NSTimeInterval)delay;

@end
