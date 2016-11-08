//
//  QPMPaymentSubmitViewController.m
//  Trendpower
//
//  Created by 张帅 on 16/11/7.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "QPMPaymentSubmitViewController.h"

//Util
#import "NetworkingUtil.h"
#import "PaymentWayTool.h"

//VC
#include "PaymentSuccessVC.h"

@interface QPMPaymentSubmitViewController ()<BaseVCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *goodsCodeLbl;

@property (weak, nonatomic) IBOutlet UILabel *paymentWayLbl;

@property (weak, nonatomic) IBOutlet UILabel *amountLbl;

@property (nonatomic, strong) PaymentWayTool *paymentWayTool;

@end

@implementation QPMPaymentSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"支付";

    self.baseDelegate = self;

    self.customLeftItemAction = YES;

    if (self.paymentSubmitSource == QPMPaymentSubmitSourceCart) {

        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];

    } else if (self.paymentSubmitSource == QPMPaymentSubmitSourceOrder) {
        
    }

    self.paymentWayTool = [[PaymentWayTool alloc] init];

    self.goodsCodeLbl.text = [NSString stringWithFormat:@"商品编号：%@",[self.infoDic objectForKey:@"transactionId"]];

    switch ([[self.infoDic objectForKey:@"paymentType"] integerValue]) {
        case 1:
            self.paymentWayLbl.text = [NSString stringWithFormat:@"支付方式：支付宝支付"];
            break;
        case 5:
            self.paymentWayLbl.text = [NSString stringWithFormat:@"支付方式：微信支付"];
            break;

        default:
            self.paymentWayLbl.text = @"";
            break;
    }

    self.amountLbl.text = [NSString stringWithFormat:@"￥%@",[self.infoDic objectForKey:@"payPrice"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 1. 从ApplicationDelegate中回调支付结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processalipayResult:) name:@"alipayResult" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processwxpayResult:) name:@"wxpayResult" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 点击导航栏返回
- (void)baseVCDidClickedBackItem{

    if (self.paymentSubmitSource == QPMPaymentSubmitSourceCart) {

        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];

        NSArray * vcArray = self.navigationController.viewControllers;

        [self.navigationController popToViewController:[vcArray objectAtIndex:vcArray.count - 3] animated:YES];

    } else if (self.paymentSubmitSource == QPMPaymentSubmitSourceOrder) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - event response
- (IBAction)pay:(id)sender {
    //根据支付方式
    switch ([[self.infoDic objectForKey:@"paymentType"] integerValue]) {
        case 1: {

            NSString *url = [API_ROOT stringByAppendingString:API_ORDER_PAYMENT];
            url = [url stringByAppendingString:[NSString stringWithFormat:@"?userId=%@",[UserDefaultsUtils getUserId]]];

            if (self.paymentSubmitSource == QPMPaymentSubmitSourceCart) {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"&transactionId=%@",[self.infoDic objectForKey:@"transactionId"]]];
            } else if (self.paymentSubmitSource == QPMPaymentSubmitSourceOrder) {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"&orderNo=%@",[self.infoDic objectForKey:@"transactionId"]]];
            }
            
            [self.paymentWayTool aliPay:self.view url:url params:nil];
            
            break;
        }

        case 5: {

            NSString *url = [API_ROOT stringByAppendingString:API_ORDER_PAYMENT];
            [url stringByAppendingString:[NSString stringWithFormat:@"?userId=%@",[UserDefaultsUtils getUserId]]];

            if (self.paymentSubmitSource == QPMPaymentSubmitSourceCart) {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"&transactionId=%@",[self.infoDic objectForKey:@"transactionId"]]];

            } else if (self.paymentSubmitSource == QPMPaymentSubmitSourceOrder) {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"&orderNo=%@",[self.infoDic objectForKey:@"transactionId"]]];
            }

            [self.paymentWayTool wxPay:self.view url:url params:nil];
            break;
        }

        default:
            break;
    }
}

#pragma mark - private method
/**
 *   9000 订单支付成功
 8000 正在处理中
 4000 订单支付失败
 6001 用户中途取消
 6002 网络连接出错
 */
-(void) processalipayResult:(NSNotification*) notification{

    NSDictionary *resultDic=notification.userInfo;

    int statusCode=[[resultDic valueForKey:@"resultStatus"] intValue];

    switch (statusCode) {
        case 9000:{ // 9000 订单支付成功
            PaymentSuccessVC * vc = [[PaymentSuccessVC alloc]init];
            vc.paySn = [NSString stringWithFormat:@"订单编号：%@",[self.infoDic objectForKey:@"transactionId"]];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 8000:{ // 8000 正在处理中
            [self.HUDUtil showErrorMBHUDWithText:@"支付处理中，以订单状态为准" inView:self.view delay:3];
            break;
        }
        case 4000:{ // 4000 订单支付失败
            [self.HUDUtil showErrorMBHUDWithText:@"订单支付失败" inView:self.view delay:3];
            break;
        }
        case 6001:{ // 6001 用户中途取消
            [self.HUDUtil showErrorMBHUDWithText:@"支付已取消" inView:self.view delay:3];
            break;
        }
        case 6002:{ // 6002 网络连接出错
            [self.HUDUtil showErrorMBHUDWithText:@"网络连接出错" inView:self.view delay:3];
            break;
        }
        default:
            [self.HUDUtil showErrorMBHUDWithText:@"支付失败" inView:self.view delay:3];
            break;
    }
}

#pragma mark - 微信支付
- (void)processwxpayResult:(NSNotification *)notification {

    PayResp *response = (PayResp *)notification.object;

    switch(response.errCode){
        case WXSuccess: {
            PaymentSuccessVC * vc = [[PaymentSuccessVC alloc]init];
            vc.paySn = [NSString stringWithFormat:@"订单编号：%@",[self.infoDic objectForKey:@"paySn"]];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            [self.HUDUtil showErrorMBHUDWithText:@"订单支付失败" inView:self.view delay:3];

            break;
    }
}

@end
