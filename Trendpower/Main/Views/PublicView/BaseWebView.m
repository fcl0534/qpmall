//
//  BaseWebView.m
//  Trendpower
//
//  Created by HTC on 15/5/20.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "BaseWebView.h"

@interface BaseWebView()<UIWebViewDelegate>

@end

@implementation BaseWebView


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initUIView];
    }
    return self;
}


- (void) initUIView
{
    self.delegate = self;
    self.scalesPageToFit = YES;
}

- (void)setContent:(NSString *)content{
    
    [self loadHTMLString:[self insertContentToHtmlBody:content] baseURL:nil];
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



@end
