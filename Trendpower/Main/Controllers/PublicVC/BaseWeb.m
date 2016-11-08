//
//  BaseWeb.m
//  Trendpower
//
//  Created by HTC on 15/5/8.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "BaseWeb.h"

@interface BaseWeb ()<UIWebViewDelegate>

@end
@implementation BaseWeb

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initUIView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void) initUIView
{
    self.webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64)];
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    [self.view addSubview:self.webview];
}

/**
 *  将内容插入到html的body中
 *
 *  @param content 待插入的内容
 *
 *  @return 已插入content的完整html
 */
- (NSString *) insertContentToHtmlBody:(NSString *) content
{
    NSMutableString *completeHtml = [[NSMutableString alloc] init];
    NSString *htmlHead = [self readLocalHtmlFile:@"head"];
    NSString *htmlEnd = @"</body></html>";
    
    [completeHtml appendString:htmlHead];
    [completeHtml appendString:content?content:@""];
    [completeHtml appendString:htmlEnd];
    
    return completeHtml;
}

- (void) displayContent:(NSString *) content
{
    self.title = self.titleName;
    [self.webview loadHTMLString:[self insertContentToHtmlBody:content] baseURL:nil];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //[self.HUDUtil showLoadingMBHUDInView:self.view];
    return YES;
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //[self.HUDUtil dismissMBHUDWithDelay:0.15];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

/**
 *  读取本地css文件
 *  @param fileName 文件名
 *  @return 本地css文件的内容
 */
- (NSString *) readLocalCSSFile:(NSString *)fileName
{
    NSString*filePath=[[NSBundle mainBundle] pathForResource:fileName ofType:@"css"];
    NSString *str=[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return str;
}

/**
 *  读取本地的html文件
 *
 *  @param fileName 文件名
 *  @return 本地html文件的内容
 */
- (NSString *) readLocalHtmlFile:(NSString *)fileName
{
    NSString*filePath=[[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSString *str=[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return str;
}

/**
 *  读取本地的js文件
 *
 *  @param fileName 文件名
 *  @return 本地js文件的内容
 */
- (NSString *) readLocalJSFile:(NSString *)fileName
{
    NSString*filePath=[[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
    NSString *str=[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return str;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
