//
//  CarTypeUsedViewController.m
//  Trendpower
//
//  Created by HTC on 16/3/7.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "CarTypeUsedViewController.h"

@interface CarTypeUsedViewController ()

@end

@implementation CarTypeUsedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}


- (void)initView{
    self.title = @"适用车型";
    
    UIView * ui = [[UIView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, 70)];
    ui.backgroundColor = [UIColor colorWithWhite:0.901 alpha:1.000];
    
    UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, K_UIScreen_WIDTH, 50)];
    lbl.text = @"   通用件";
    lbl .textColor = [UIColor colorWithRed:0.357 green:0.353 blue:0.353 alpha:1.000];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    lbl.layer.borderWidth = 0.8;
    [ui addSubview:lbl];
    [self.view addSubview:ui];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
