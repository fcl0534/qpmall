//
//  PaymentPayVC.m
//  Trendpower
//
//  Created by trendpower on 15/7/24.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "PaymentPayVC.h"

#import "PaymentSubmitView.h"
#import "PaymentSuccessVC.h"
// alipay
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


@interface PaymentPayVC()<PaymentSubmitViewDelegate, BaseVCDelegate>

@end

@implementation PaymentPayVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"支付";
    
    self.baseDelegate = self;
    if(!self.isFromMember){
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    }
    [self initPaymentView];
}

#pragma mark - 点击导航栏返回
- (void)baseVCDidClickedBackItem{
    if (!self.isFromMember) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        // 1.发送id
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"BackPaymentVC" object:self.orderId];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_BACK_HOME object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 1. 从ApplicationDelegate中回调支付结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processPayResult:) name:@"alipayResult" object:nil];
}


- (void)initPaymentView{
    
    PaymentSubmitView * submitView = [[PaymentSubmitView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64)];
    submitView.delegate = self;
    submitView.orderPriceLabel.text = [NSString stringWithFormat:@"¥ %@",self.orderAmount];
    submitView.orderIdLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.orderSn];
    
    if([self.paymentCode isEqualToString:@"alipay"] || [self.paymentCode isEqualToString:@"wap_alipay"]){
        submitView.imagesView.image = [UIImage imageNamed:@"alipay_logo"];
    }else if([self.paymentCode isEqualToString:@"cod"]){
        self.title = @"货到付款";
        submitView.imagesView.image = [UIImage imageNamed:@"pay_on_delivery"];
        [submitView.submitBtn setTitle:@"完成" forState:UIControlStateNormal];
        submitView.orderNameLabel.hidden = YES;
        submitView.orderPriceLabel.hidden = YES;
        submitView.line.hidden = YES;
    }else{
        [submitView.submitBtn setTitle:@"暂时不能支付" forState:UIControlStateNormal];
    }
    
    [self.view addSubview:submitView];
}

- (void)paymentSubmitViewBtnClicked:(UIButton *)submitBtn{
    if([self.paymentCode isEqualToString:@"alipay"] || [self.paymentCode isEqualToString:@"wap_alipay"]){
       [self aliPay];
    }else{
        if(self.isFromMember){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self baseVCDidClickedBackItem];
        }
    }
}


- (void) aliPay{
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088121298452356";
    NSString *seller = @"zu.wu@jchp.cn";
    NSString *privateKey = @"MIICXwIBAAKBgQDACzmpxbH1h/sMUKiJ87aAewPyMOVT2M/vMIBK/ZBMKUPPtIlbxizSx91EKRKOmQf1rd4xlpkHb5HXyRfVg1Q7aaqaURHVwhXWmnmbHGr2op1qzeR8s8RLKCp07Eu09efH9EbBvzLMb6KOK1hh1SMK74Oop9MDLKbHw9zsXgCC2wIDAQABAoGBAJmhYUPbj33ohoFXlTym5vzpbEK3sv3cmJu0pS1Yo7MJ3+Gtf6UXaIxGr0/zu5CwA5oauYHaBBnau0Vw7cw0/5AVBgZq7ZCXz8EIjE9YBMoe2/mwliWMR0alAYXlmlEqVRJJAeGAFqpl3ERqGDXI3vSV8wDjeYMjC7G2HqfvkiUBAkEA5VaB5/UN4PjUVq86qX9WsIDISVMHgr5LeqAEhUKap4CFuIIksRnNlnGJ0WPSVm3GNnb8/qnzgJ1XNtxyUG4+YQJBANZeyCabivknq0ASrt3Q4CrNPIV3qmwzMzNjwJ9xDkCLaJpRxnjMNHC+Rw9DfPRIzXpz8IRU6pQxzsMaOpWKMrsCQQDFAd0yT3aOrfJqTLkN5c+oa9ih9GtdSu839cIsX5zPCz7T0yiF4m6TMBF+CEwl5sMBApIuifwdngvPmuuwYCPBAkEA0gDkPr4dtNuhrhEfcXmQQR3x7iY+s+Ssgel06D1O4vgvLw5xSiFyNgiRgGhy3rT7ZrxxoJG3hBoPHZ5ySdCqxQJBAL+T+YV1XlSMQrVR/zkoxACnLQUxXdjEI2e0omRiUNtFTMVG7HrXuuNuKu8vMjif0mPtm1XGl/uqfzp8HBBSzJk=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.orderSn; //订单ID（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"汽配猫-%@-%@",self.orderName,self.orderSn]; //商品标题
    order.productDescription =  [NSString stringWithFormat:@"汽配猫-%@-%@",self.orderName,self.orderSn];  //商品描述
    order.amount = self.orderAmount; //@"0.01"; //商品价格
    order.notifyURL = @"http://www.qpfww.com/payment/alipay/mobilenotify";//[NSString stringWithFormat:@"http://%@/includes/payments/appalipay/notify_url.php",MY_DOMAIN]; //@"http://www.ecduo.cn/paynotify_wap.php"; //回调URL:index.php?app=paynotify&act=return_url
    //index.php?app=paynotify&act=notify_url
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = alipayScheme;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:nil];
    }
}


/**
 *   9000 订单支付成功
 8000 正在处理中
 4000 订单支付失败
 6001 用户中途取消
 6002 网络连接出错
 */

-(void) processPayResult:(NSNotification*) notification{
    NSDictionary *resultDic=notification.userInfo;
    int statusCode=[[resultDic valueForKey:@"resultStatus"] intValue];
    switch (statusCode) {
        case 9000:{ // 9000 订单支付成功
            PaymentSuccessVC * vc = [[PaymentSuccessVC alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
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


@end
