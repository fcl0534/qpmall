//
//  NaviFooterBar.h
//  Trendpower
//
//  Created by trendpower on 15/12/1.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopImageButton.h"

@protocol NaviFooterBarDelegate <NSObject>

@optional

- (void)naviFooterBarClickedBtn:(TopImageButton *)btn index:(NSInteger)index;

@end


@interface NaviFooterBar : UIView

@property (nonatomic, weak) id <NaviFooterBarDelegate>delegate;

- (void)showNaviFooterBar;
- (void)hiddenNaviFooterBar;
- (void)actionView;
@end
