//
//  PaymentSuccessVC.m
//  ZZBMall
//
//  Created by trendpower on 15/8/13.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "PaymentSuccessVC.h"

#import "EmptyTipsView.h"


@interface PaymentSuccessVC()<EmptyPlaceholderViewDelegate, BaseVCDelegate>

@property (nonatomic, weak) EmptyPlaceholderView *emptyView;

@end


@implementation PaymentSuccessVC
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseDelegate = self;

    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];

    self.title = @"支付成功";

    [self initEmptyView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.naviLeftItem.hidden = YES;
}

#pragma mark - 空视图
- (void)initEmptyView{
    if (self.emptyView == nil) {
        EmptyPlaceholderView * emptyView = [[EmptyPlaceholderView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT) placeholderText:self.paySn placeholderIamge:[UIImage imageNamed:@"payment_success"] btnName:@"完成"];
        self.emptyView = emptyView;
        emptyView.delegate = self;
        [self.view addSubview:emptyView];
    }
}


#pragma mark - 点击完成事件
- (void)EmptyPlaceholderViewClickedButton:(UIButton *)btn{
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_BACK_HOME object:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_BACK_HOME object:nil];
//    });
}


@end
