//
//  BaseWeb.h
//  Trendpower
//
//  Created by HTC on 15/5/8.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseWeb : BaseViewController
@property (nonatomic,copy) NSString *titleName;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) UIWebView *webview;

- (void) displayContent:(NSString *) content;
@end
