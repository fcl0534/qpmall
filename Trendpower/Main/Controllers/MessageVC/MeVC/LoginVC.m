//
//  LoginVC.m
//  Trendpower
//
//  Created by HTC on 16/1/20.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "LoginVC.h"

#import "JPUSHService.h"

// view
#import "LoginView.h"

// vc
#import "RegistVC.h"
#import "FindPWVC.h"

@interface LoginVC ()<LoginViewDelegate>

@property (nonatomic, weak) LoginView * loginView;

@end

@implementation LoginVC

#pragma mark - Life cycle   ###

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录";
    self.navigationController.navigationBarHidden = YES;
    
    [self initLoginView];
    
}




- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

#pragma mark - Interface   ###
#pragma mark initloginView
- (void)initLoginView{
    
    if (self.loginView == nil) {
        LoginView * loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, K_UIScreen_HEIGHT)];
        loginView.delegate = self;
        //loginView.aboutCell.delegate = self;
        self.loginView = loginView;
        [self.view addSubview:loginView];
    }
    
    self.loginView.userF.text = [UserDefaultsUtils getValueByKey:KTP_USER_NAME];
}

#pragma mark - Event response   ###



#pragma mark - Private method   ###


#pragma mark - Delegate   ###
- (void)loginViewClickedBackButton{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)loginViewClickedFindPwButton{
    FindPWVC * vc = [[FindPWVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)loginViewClickedRegisterButton{
    RegistVC * vc = [[RegistVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)loginViewClickedButton:(UIButton *)btn userField:(UITextField *)userField pwField:(UITextField *)pwField{
    [self.view endEditing:YES];
    
    if (userField.text.length == 0 ) {
        [self.HUDUtil showTextMBHUDWithText:@"手机号不能为空" delay:1.5 inView:self.view];
        return;
    }
    
    if ([Utility isValidatePhoneNumber:userField.text]){
        [self.HUDUtil showTextMBHUDWithText:@"手机号码格式有误" delay:1.5 inView:self.view];
        return;
    }
    
    if (pwField.text.length ==0 ) {
        [self.HUDUtil showTextMBHUDWithText:@"密码不能为空" delay:1.5 inView:self.view];
        return;
    }
    
    NSString *loginUrl=[API_ROOT stringByAppendingString:API_USER_LOGIN];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userField.text forKey:@"loginName"];
    [parameters setObject:pwField.text forKey:@"loginPwd"];
    [parameters setObject:KTP_overTime_VALUE forKey:KTP_overTime_KEY];

    [self.NetworkUtil POST:loginUrl parameters:parameters inView:self.view success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {

            NSDictionary * info = [[responseObject objectForKey:@"data"] objectForKey:@"info"];

            [UserDefaultsUtils setValue:[NSString stringWithFormat:@"%@",[info objectForKey:@"id"]] byKey:KTP_USER_ID];
            [UserDefaultsUtils setValue:[NSString stringWithFormat:@"%@",[info objectForKey:@"appToken"]] byKey:KTP_KEY];
            [UserDefaultsUtils setValue:userField.text byKey:KTP_USER_NAME];
            //[UserDefaultsUtils setValue:pwField.text byKey:KTP_PASSWORD];
            [UserDefaultsUtils setValue:@"YES" byKey:KTP_ISLOGIN];
            //如果登陆或注销后，刷新数据，显示价格状态
            [UserDefaultsUtils setValue:@"YES" byKey:@"is_change_user_state"];
            
            /**
             *  JPush 标签与别名设置
             */
            if (OPEN_Push_Message) {

                [JPUSHService setAlias:[NSString stringWithFormat:@"%@",[info objectForKey:@"id"]] callbackSelector:nil object:nil];
            }

//            //如果从其它地方来，跳转回去
//            if (self.isFromProduct) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }
            
            [self loginViewClickedBackButton];
            
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}



#pragma mark - Getters and Setters   ###


#pragma mark - Others   ###


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
