//
//  BaseWebVC.m
//  ZZBMall
//
//  Created by trendpower on 15/8/25.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "BaseWebVC.h"

@interface BaseWebVC ()<UIWebViewDelegate>

@property (nonatomic, weak) UIWebView * webView;

@property (nonatomic, weak) UIButton * closeBtn;

@end

@implementation BaseWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    [self initWebView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 1.
    self.naviRightItem.hidden = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}


- (void)initWebView{
    
    self.naviCustomView.userInteractionEnabled = YES;
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"navi_backBtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickedBackItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviCustomView addSubview:backBtn];
    
    UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 44, 44)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickedCloseItem:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.hidden = YES;
    self.closeBtn = closeBtn;
    [self.naviCustomView addSubview:closeBtn];
    
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.hidden = NO;
    
    // [self.HUDUtil showLoadingMBHUDWithText:@"加载中.." inView:self.view];
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    //    [cache removeAllCachedResponses];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]];
    
}

#pragma mark - 点击返回
- (void)clickedBackItem:(UIButton *)btn{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        self.closeBtn.hidden = NO;
    }else{
        [self clickedCloseItem:nil];
    }
}

- (void)clickedCloseItem:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    [self.HUDUtil showLoadingMBHUDInView:self.webView delay:8.0];

//    if([request.URL.absoluteString hasPrefix:@"goodsdetail"]) {
//        NSString * goodsId = [self substringFormURL:request.URL.absoluteString protocol:@"goodsdetail://"];
//        //NSLog(@"---%@",goodsId);
//        ProductDetailVC * vc = [[ProductDetailVC alloc]init];
//        vc.productId = goodsId;
//        vc.productName = @"商品详情";
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        [self.HUDUtil dismissMBHUD];
//        return NO;
//    }else if([request.URL.absoluteString hasPrefix:@"pay"]){
//        //pay://paymenttype=alipay$$$orderAmount=0.01$$$paySn=150492876465436213
//        NSString * payway = [self substringFormURL:request.URL.absoluteString protocol:@"pay://"];
//        NSArray * pamentArray = [self substringFormShareURL:payway];
//        // NSString * paymenttype = [self substringFormequlURL:pamentArray[0]];
//        NSString * orderAmount = [self substringFormequlURL:pamentArray[1]];
//        NSString * paySn = [self substringFormequlURL:pamentArray[2]];
//        
//        // 支付宝
//        [self alipayWithorderAmount:orderAmount paySn:paySn];
//        
//        [self.HUDUtil dismissMBHUD];
//        return NO;
//    }
//    
    
    if (self.webView.canGoBack) {
        self.closeBtn.hidden = NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.HUDUtil dismissMBHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.HUDUtil dismissMBHUD];
    
    [self.HUDUtil showNetworkErrorInView:self.webView];
}

@end
