//
//  PaymentSubmitView.h
//  Trendpower
//
//  Created by trendpower on 15/5/25.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

@protocol PaymentSubmitViewDelegate <NSObject>

@optional

- (void) paymentSubmitViewBtnClicked:(UIButton *)submitBtn;

@end


@interface PaymentSubmitView : UIView

/** 商品规格 */
@property (nonatomic, weak) UILabel * orderIdLabel;
/** 商品价格 */
@property (nonatomic, weak) UILabel * orderPriceLabel;


/** 价格名字 */
@property (nonatomic, weak) UILabel * orderNameLabel;
/** line View */
@property (nonatomic, weak) UIView * line;
/** logo 图片 */
@property (nonatomic, weak) UIImageView * imagesView;
/** 支持按钮 */
@property (nonatomic, weak) UIButton * submitBtn;

@property (nonatomic, weak) id<PaymentSubmitViewDelegate> delegate;

@end
