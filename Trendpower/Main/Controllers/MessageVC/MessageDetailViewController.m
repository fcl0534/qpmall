//
//  MessageDetailViewController.m
//  EcoDuo
//
//  Created by trendpower on 15/1/9.
//  Copyright (c) 2015年 Felix Zhang. All rights reserved.
//

#define title_Height 0


#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()
{
    UIWebView *webView;
    UILabel *titleLabel;

}
@end

@implementation MessageDetailViewController
@synthesize requestUrl;


- (void)viewDidLoad {
    [super viewDidLoad];
//    K_UIScreen_WIDTH = self.view.frame.size.width;
//    K_UIScreen_HEIGHT = self.view.frame.size.height;
    [self initView];
    [self loadData];
}

-(void) initView{
//    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, title_Height)];
//    titleLabel.backgroundColor = [UIColor whiteColor];
//    titleLabel.font=[UIFont boldSystemFontOfSize:18];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text=self.messageTitle;
//    [self.view addSubview:titleLabel];
//    
//    titleLabel.layer.borderColor = [UIColor colorWithWhite:0.555 alpha:1.000].CGColor;
//    titleLabel.layer.borderWidth = 0.3;
    
    self.title = self.messageTitle;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64+title_Height, self.view.frame.size.width, self.view.frame.size.height-64-title_Height)];
    //webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
}


-(void) loadData{
   
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    NSString *encodingUrl=[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [manager GET:encodingUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {

            NSDictionary *dic =[responseObject objectForKey:@"data"];
            NSString * content = [dic objectForKey:@"content"];
            NSData * contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
            NSString *headString=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HtmlHead" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
            NSString *htmlString=[[NSString alloc] initWithData:contentData encoding:NSUTF8StringEncoding];
            NSString * contentHtml = [headString stringByReplacingOccurrencesOfString:@"${body}" withString:htmlString];
            [webView loadHTMLString:contentHtml baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
