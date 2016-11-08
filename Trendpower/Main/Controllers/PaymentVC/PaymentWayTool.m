
//
//  PaymentWayTool.m
//  ZZBMall
//
//  Created by trendpower on 15/9/15.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "PaymentWayTool.h"

#import "NetworkingUtil.h"
#import "HUDUtil.h"

@interface PaymentWayTool ()

@property (nonatomic, strong) NetworkingUtil *networkingUtil;

@end

@implementation PaymentWayTool

+ (void)aliPayOrder_name:(NSString *)name order_price:(NSString *)price orderno:(NSString *)orderSn{
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088021521505557";
    NSString *seller = @"2601238319@qq.com";
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMq2U0RkqViIamSX9LIVWekd1gpUtu0++4ueka1N0mGEj+JMzHuXQ2SPjV+0G6ZLZ6EmUYKRwUElKWSs08ygaXQNOVK/fKnIi/pRYJpjA/1dHrV/1MKYUeENiRT49yK6XGN6ZCNtjb9tfeVkQXsHZsiiotawBreAkwFJoPettsqrAgMBAAECgYA2V7Rw1E91tXRYLUhi6UhmLyJvOJClf0nt/v9spz0r+V6dOxtiUoW1kqpCqsTyyqooUF5vk2VscmrrW02YQLSj9q4IWbQAonOq1/GM6iMtLvMphxVq8pHCmR+13dP9pwOoptq+vN4sOxzp87+UzxstGbfOGeIt+9M6SwESblvEoQJBAOmRzX50fnR1p8ZFgluSv24uz9m/L4Z7a3/aI58lbJ54xAJmrgwbvjOwiYZXNVrx1ke1DGoepI5Mzuhf9WjlbpECQQDeLejWP+Yb6T/pn3l8OoIUpGHv1FqMagww/fKRJdaHlGtPqn8a795hz/dUv9j2jRpEXA1r3DcNtWMlY/VpK3t7AkEAjUN+qo2gcaU7LKKbnfDaULSFR2fnQYnh0XjIdJd44zudKOqbN32MAs0x0AtsnK2JcOMiOAiCdAImXcqzrZad0QJBAIPKodHtJ3co/hN72JlbL2xFMh8MTQX7pe2txaRZ2I6l+J3SGgGFhdlpfmIURwPBIXKpVADGKRYFoaE9UQaol18CQQCI1cqS5d6XVQ1DDL0IT1VfFXkBxuWSKfKrSidpIDOfe0NZcZcF3SApy17/ZT3LZUIzkTO+I9Nh3TW7l8ftRD8w";
    // @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMnPAZOxYM08KbK+knKh2HCggh67R7ob3zR8k1Lq4oWwDKmfkearvnF5wdgogZ/AIXBkYcMi6ArnvVN9etypzRjo7VkZCmIToES1jKVINUmamgNwN56MYA62Hn6usfGF6HL7ZBHvJKqyH+JgBbjNbzK+ZMQe4iQsYJ7SIW1HIktPAgMBAAECgYB9ceIHDsGfkgBRjci23QgPqpZ3x+6kL2Ml2zIw3rUEaRTV88zb2HI/U3I9jaBVzzZ6CMwEYpRfAwJa/ar7s8k60Y3KF+WEDuOk6UShwvfadToJ4JKiC+suusr8gJDU3DcszaeLdbYt9+fb3+xKQhBvGw8FNYTsSn6hVZLy9RkRMQJBAPLM0rpV0WdGz3zrH2yiN6ci9Fcj/FuFwoJpyUU/iCPqyquc6n1dQt0NeL9xDQj4r8RLpnfSbhAbQhAGpPOW6jsCQQDUx67dy+32vfQtuYWCIS5y4KY9AXf/BmUmXD7/dtOgh5LXDxl8ZriYMWtmlyVPvQyTbajt2Bx4BmWq8JaH+n39AkAvfdbeMbkS/WvKYGc2JYjDPXgTr2tGL6S7Q5vl2qZzeBKKfNf1C4/vkxoCQEevcI1Y1P9LwrJanipO3i3Xo7ZPAkEA0Di8SbYXn38RpXFIUiiwcKCgbVCzobAbaeeZips4y34AV04ibZeECwNJi7JbQ+XHmboVNvNmIJp6AUbAuD6L7QJBAJInezvfLJfeiQKJibi9lw5udhKMJPFXKUob8RkUTm2Sw9LCy2dz3IOyVMJMcdVJCZ+OveL/YEGMTZY/HX7h37Q=";
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
    order.tradeNO = orderSn; //订单ID（由商家自行制定）
    order.productName = name; //商品标题
    order.productDescription =  [NSString stringWithFormat:@"%@，支付总额：%@元，下单来自：汽配猫iOS客户端",name,price];  //商品描述
    order.amount = price; //self.payModel.sum; //@"0.01"; //商品价格
    order.notifyURL = @"http://www.ecduo.cn/paynotify_wap.php"; //回调URL:index.php?app=paynotify&act=return_url
    //http://b2b2c.xyd.qushiyun.com/mobile/api/payment/alipay/notify_url.php
    ///phone/api/payment/ wxpay/ notify_url.php
    
    //NSLog(@"alipay---%@",[APP_DOMAIN stringByAppendingString:API_ORDER_PAY]);
    
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


+ (void)aliPayOrder_name:(NSString *)name order_price:(NSString *)price orderno:(NSString *)orderSn partner:(NSString *)partner seller:(NSString *)seller notifyURL:(NSString *)notifyURL{
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
//    NSString *partner = partner;
//    NSString *seller = seller;
    NSString *privateKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDACzmpxbH1h/sMUKiJ87aAewPyMOVT2M/vMIBK/ZBMKUPPtIlbxizSx91EKRKOmQf1rd4xlpkHb5HXyRfVg1Q7aaqaURHVwhXWmnmbHGr2op1qzeR8s8RLKCp07Eu09efH9EbBvzLMb6KOK1hh1SMK74Oop9MDLKbHw9zsXgCC2wIDAQAB";
    // @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMnPAZOxYM08KbK+knKh2HCggh67R7ob3zR8k1Lq4oWwDKmfkearvnF5wdgogZ/AIXBkYcMi6ArnvVN9etypzRjo7VkZCmIToES1jKVINUmamgNwN56MYA62Hn6usfGF6HL7ZBHvJKqyH+JgBbjNbzK+ZMQe4iQsYJ7SIW1HIktPAgMBAAECgYB9ceIHDsGfkgBRjci23QgPqpZ3x+6kL2Ml2zIw3rUEaRTV88zb2HI/U3I9jaBVzzZ6CMwEYpRfAwJa/ar7s8k60Y3KF+WEDuOk6UShwvfadToJ4JKiC+suusr8gJDU3DcszaeLdbYt9+fb3+xKQhBvGw8FNYTsSn6hVZLy9RkRMQJBAPLM0rpV0WdGz3zrH2yiN6ci9Fcj/FuFwoJpyUU/iCPqyquc6n1dQt0NeL9xDQj4r8RLpnfSbhAbQhAGpPOW6jsCQQDUx67dy+32vfQtuYWCIS5y4KY9AXf/BmUmXD7/dtOgh5LXDxl8ZriYMWtmlyVPvQyTbajt2Bx4BmWq8JaH+n39AkAvfdbeMbkS/WvKYGc2JYjDPXgTr2tGL6S7Q5vl2qZzeBKKfNf1C4/vkxoCQEevcI1Y1P9LwrJanipO3i3Xo7ZPAkEA0Di8SbYXn38RpXFIUiiwcKCgbVCzobAbaeeZips4y34AV04ibZeECwNJi7JbQ+XHmboVNvNmIJp6AUbAuD6L7QJBAJInezvfLJfeiQKJibi9lw5udhKMJPFXKUob8RkUTm2Sw9LCy2dz3IOyVMJMcdVJCZ+OveL/YEGMTZY/HX7h37Q=";
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
    order.tradeNO = orderSn; //订单ID（由商家自行制定）
    order.productName = name; //商品标题
    order.productDescription =  [NSString stringWithFormat:@"%@，支付总额：%@元，下单来自：汽配猫iOS客户端",name,price];  //商品描述
    order.amount = price; //self.payModel.sum; //@"0.01"; //商品价格
    order.notifyURL = notifyURL;//@"http://www.ecduo.cn/paynotify_wap.php"; //回调URL:index.php?app=paynotify&act=return_url
    //http://b2b2c.xyd.qushiyun.com/mobile/api/payment/alipay/notify_url.php
    ///phone/api/payment/ wxpay/ notify_url.php
    
    //NSLog(@"alipay---%@",[APP_DOMAIN stringByAppendingString:API_ORDER_PAY]);
    
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


+ (void)wxPayOrder_name:(NSString *)name order_price:(NSString *)price orderno:(NSString *)orderSn{
    
    [WXApi registerApp:APP_ID withDescription:@"汽配猫iOS客户端"];
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendOrder_name:name order_price:price orderno:orderSn];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        HUDUtil * hud = [HUDUtil sharedHUDUtil];
        [hud showTextMBHUDInWindowWithText:@"暂无法支付,请稍后重试" delay:2.0];
        
        DLog(@"%@\n\n",debug);
    }else{
        DLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }

}

#pragma mark - 后台返回商品订单数据，不需要自己拼接
- (void)aliPay:(UIView *)view url:(NSString *)url params:(NSDictionary *)params {

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:[UserDefaultsUtils getKey] forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    self.networkingUtil = [[NetworkingUtil alloc] init];

    [self.networkingUtil GET:url header:header inView:view success:^(id responseObject) {

        NSString *orderString = [[[responseObject objectForKey:@"data"] objectForKey:@"gateway"] objectForKey:@"signOrderString"];

        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"QPMAlipay" callback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayResult" object:self userInfo:resultDic];
        }];

    } failure:^(NSError *error) {

    }];
}

- (void)wxPay:(UIView *)view url:(NSString *)url params:(NSDictionary *)params {

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:[UserDefaultsUtils getKey] forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    self.networkingUtil = [[NetworkingUtil alloc] init];
    
    [self.networkingUtil GET:url header:header inView:view success:^(id responseObject) {

        NSDictionary *orderString = [[[responseObject objectForKey:@"data"] objectForKey:@"gateway"] objectForKey:@"signOrderString"];

        PayReq *request = [[PayReq alloc] init];
        request.partnerId = [orderString objectForKey:@"partnerid"];
        request.prepayId = [orderString objectForKey:@"prepayid"];
        request.package = [orderString objectForKey:@"package"];
        request.nonceStr = [orderString objectForKey:@"nonceStr"];
        request.timeStamp = [[orderString objectForKey:@"timeStamp"] intValue];
        request.sign= [orderString objectForKey:@"sign"];

        [WXApi sendReq:request];

    } failure:^(NSError *error) {
        
    }];
}

@end
