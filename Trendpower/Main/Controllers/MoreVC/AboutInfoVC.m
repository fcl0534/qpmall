//
//  AboutInfoVC.m
//  Trendpower
//
//  Created by HTC on 15/5/8.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "AboutInfoVC.h"


@interface AboutInfoVC()

@end

@implementation AboutInfoVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"关于应用";
    
    [self initInfo];
}


- (void)initInfo{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    float logoWH = 120;
    
    UIImageView * logo = [[UIImageView alloc]initWithFrame:CGRectMake(K_UIScreen_WIDTH /2 -logoWH/2, 64 + 30, logoWH, logoWH)];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logo];
    
    [WebImageUtil setImageWithURL:self.infoModel.companyLogo placeholderImage:[UIImage imageNamed:@"appInfoLogo"] inView:logo];
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logo.frame) +5, K_UIScreen_WIDTH, 25)];
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = [UIColor colorWithWhite:0.367 alpha:1.000];
    name.font = [UIFont boldSystemFontOfSize:21.0f];
    NSString *key = @"CFBundleShortVersionString";
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    name.text = [NSString stringWithFormat:@"汽配猫v%@",currentVersion];
    [self.view addSubview:name];
    
    UITextView * des = [[UITextView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(name.frame)+5, K_UIScreen_WIDTH -40, K_UIScreen_HEIGHT -64 -CGRectGetMidY(name.frame) -90)];
    des.editable = NO;
//    des.textAlignment = NSTextAlignmentCenter;
    des.textColor = [UIColor grayColor];
    des.font = [UIFont systemFontOfSize:16.5f];
    des.text = self.infoModel.aboutUs;
    [self.view addSubview:des];

    UILabel * copyright = [[UILabel alloc]initWithFrame:CGRectMake(0,K_UIScreen_HEIGHT -30 -20, K_UIScreen_WIDTH, 18)];
    copyright.textAlignment = NSTextAlignmentCenter;
    copyright.textColor = [UIColor grayColor];
    copyright.font = [UIFont systemFontOfSize:14.0f];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY"];
    copyright.text = [NSString stringWithFormat:@"coyright @2015-%@",[formatter stringFromDate:[NSDate date]]];
    [self.view addSubview:copyright];
    
    
    UILabel * support = [[UILabel alloc]initWithFrame:CGRectMake(0,K_UIScreen_HEIGHT -30, K_UIScreen_WIDTH, 20)];
    support.textAlignment = NSTextAlignmentCenter;
    support.textColor = [UIColor grayColor];
    support.font = [UIFont systemFontOfSize:16.0f];
    support.text = self.infoModel.companyName;
    [self.view addSubview:support];
}


@end
