//
//  FindPWView.h
//  Trendpower
//
//  Created by HTC on 16/1/24.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindPWViewDelegate <NSObject>

@optional

- (void)findPWViewClickedCodeButton:(UIButton *)btn phoneField:(UITextField *)phoneField;
- (void)findPWViewClickedSubmit:(UIButton *)btn phoneField:(UITextField *)phoneField pwField:(UITextField *)pwField rePwField:(UITextField *)rePwField codeField:(UITextField *)codeField;

@end

@interface FindPWView : UIView

@property (weak, nonatomic)  id<FindPWViewDelegate>delegate;

- (void)startCount;
- (void)removeTimer;

@end
