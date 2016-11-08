//
//  Macro.h
//  Trendpower
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#ifndef Trendpower_Macro_h
#define Trendpower_Macro_h

// 开启测试环境
#define OPEN_Test_Environment  YES

// 开启推送信息
#define OPEN_Push_Message  YES
// 开启消息推送时，图标位置-1
#define OPEN_Push_Message_Icon 0


// 开启商品分享
#define OPEN_Share_Goods  YES

// 常用Key
#define KTP_USER_NAME @"username"
#define KTP_PASSWORD  @"password"
#define KTP_MSG       @"msg"
#define KTP_ISLOGIN   @"isLogin"
#define KTP_overTime_KEY  @"overTime"
#define KTP_overTime_VALUE  @"730"
#define KTP_HOME_Cache  @"KTP_HOME_CacheData"
#define KTP_Test_Environment  @"KTP_Test_Environment"

// 调试LOG功能
#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> \n%@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, \
[NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else
#define DLog(...)
#endif


// 通知
#define K_NOTIFI_SELECT_ADDRESS @"K_NOTIFI_SELECT_ADDRESS"
#define K_NOTIFI_BACK_HOME @"K_NOTIFI_BACK_HOME"
#define K_NOTIFI_ME_CENTER @"K_NOTIFI_ME_CENTER"
#define K_NOTIFI_MESSAGE_CENTER @"K_NOTIFI_MESSAGE_CENTER"

// 填写应用的AppleID，用于检查新版本
#define Apple_ID  @"1073928494"


// 填写支付宝的跳转URL
#define alipayScheme @"com.qpfww.qpm"


#define TPTestLog   DLog(@"---clicked---")
#define TPTapLog    DLog(@"%s",__FUNCTION__);
#define TPError     DLog(@"NSError---%@",error.description);


// RGB颜色
#define TPColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define TPFloatColor(r, g, b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1.0]

//应用主颜色
#define K_MAIN_COLOR   [UIColor colorWithRed:0.993 green:0.332 blue:0.212 alpha:1.000] //[UIColor colorWithRed:0.937f green:0.286f blue:0.286f alpha:1.00f]253,85,54
//苹果灰色  0.937255 0.937255 0.956863
#define K_GREY_COLOR TPFloatColor(0.937255, 0.937255, 0.956863)
//[UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1.000];
#define K_LINEBD_COLOR [UIColor colorWithWhite:0.943 alpha:1.000]
#define K_LINEBG_COLOR [UIColor colorWithRed:0.976 green:0.976 blue:0.976 alpha:1.00]

//标题灰
#define K_TITLE_GREY_COLOR  [UIColor colorWithWhite:0.276 alpha:1.000]

//文字灰
#define K_TXET_GREY_COLOR  [UIColor colorWithWhite:0.555 alpha:1.000]

#define K_CELL_TEXT_COLOR  [UIColor colorWithWhite:0.387 alpha:1.000];


/*16进制RGB转UIColor*/
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define NSNumberFromHex(number)  [NSNumber numberWithInt:number];


#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

/*宏类型的字符串m转换成NString*/
#define MACRO_VALUE_TO_STRING_( m ) #m
#define MACRO_VALUE_TO_STRING( m ) MACRO_VALUE_TO_STRING_( m )

/*字符串连接宏*/
#define STRING_CONCAT(string1,string2) [string1 stringByAppendingString: string2]


// iOS Version
#define IS_iOS7       [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define IS_iOS8       [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define IS_iOS9       [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0




#endif
