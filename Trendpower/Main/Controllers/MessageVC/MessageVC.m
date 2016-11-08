//
//  MessageVC.m
//  Trendpower
//
//  Created by HTC on 16/2/27.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "MessageVC.h"

@interface MessageVC ()<EmptyTipsViewDelegate>

/**  空视图 */
@property (nonatomic, weak) EmptyTipsView *emptyView;

@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title= @"消息";
    
    //初始化排序栏
    [self setEmptyView];
}


#pragma mark - 空视图
- (void)setEmptyView{
    if (self.emptyView == nil) {
        EmptyTipsView * emptyView = [[EmptyTipsView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) tipsIamge:[UIImage imageNamed:@"message_null"]  tipsTitle:@"还没有消息哦" tipsDetail:nil btnName:nil];
        self.emptyView = emptyView;
        emptyView.delegate = self;
        [self.view addSubview:emptyView];
    }

}


#pragma mark - 空点击事件
- (void)EmptyTipsViewClickedButton:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_BACK_HOME object:nil];
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
