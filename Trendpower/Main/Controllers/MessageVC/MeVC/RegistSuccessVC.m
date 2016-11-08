
//
//  RegistSuccessVC.m
//  Trendpower
//
//  Created by 非整勿扰 on 16/1/26.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "RegistSuccessVC.h"

@interface RegistSuccessVC ()<BaseVCDelegate>

@end

@implementation RegistSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"注册完成";
    self.baseDelegate = self;
    
    [self initBaseView];
}

- (void)initBaseView{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, K_UIScreen_WIDTH, 200)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 5)];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.image = [UIImage imageNamed:@"colorFulline"];
    [baseView addSubview:image];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, K_UIScreen_WIDTH, 44)];
    btn.userInteractionEnabled = NO;
    [btn setImage:[UIImage imageNamed:@"success_icon"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0.324 green:0.694 blue:0.006 alpha:1.000] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [btn setTitle:@" 信息资料提交完成！" forState:UIControlStateNormal];
    [baseView addSubview:btn];
    
    UILabel * tips = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(btn.frame) +30, K_UIScreen_WIDTH -24, 60)];
    tips.numberOfLines = 0;
    tips.textColor = [UIColor colorWithRed:0.224 green:0.220 blue:0.224 alpha:1.000];
    //重点字
    NSString * tipstr = [NSString stringWithFormat:@"我们的业务员将尽快与您联系，请耐心等待。审核通过后，您可以使用“%@”登陆佳驰。",self.phone];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tipstr attributes:attributes];
    [attributedString addAttribute:NSForegroundColorAttributeName value:K_MAIN_COLOR range:[attributedString.string rangeOfString:self.phone]];
    tips.attributedText = attributedString;
    [baseView addSubview:tips];
    
    
    UIButton * submit = [[UIButton alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(baseView.frame) +30, K_UIScreen_WIDTH -100, 50)];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [submit setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateDisabled];
    [submit setBackgroundImage:[UIImage imageNamed:@"back_red"] forState:UIControlStateNormal];
    submit.layer.cornerRadius = 5;
    submit.layer.masksToBounds = YES;
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(clickedSumbitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    
}

#pragma mark - delegate
- (void)baseVCDidClickedBackItem{
    TPTapLog;
    [self clickedSumbitBtn];
}

#pragma mark - Event
- (void)clickedSumbitBtn{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_BACK_HOME object:nil];
    }];
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
