//
//  Common.h
//  Trendpower
//
//  Created by hjz on 16/5/8.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define K_UIScreen_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define K_UIScreen_HEIGHT  [[UIScreen mainScreen] bounds].size.height

#define K_DEFAULT_NAVIBAR_BACKGROUND_COLOR  K_MAIN_COLOR
#define K_DEFAULT_NAVIBAR_TINT_COLOR        [UIColor whiteColor]
#define K_DEFAULT_NAVIBAR_TITLE_FONT        [UIFont systemFontOfSize:18.0f]

#define K_ITEMBTN_WIDTH         50.0f

#define K_NaviBar_NORMAL_FRAME   CGRectMake(0, 0, K_UIScreen_WIDTH, 64)
#define K_NaviBar_HIDDEN_FRAME   CGRectMake(0, -64, K_UIScreen_WIDTH, 64)

#endif /* Common_h */
