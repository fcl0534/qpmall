//
//  FindPWVC.m
//  Trendpower
//
//  Created by HTC on 16/1/24.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "FindPWVC.h"


#import "FindPWView.h"

@interface FindPWVC ()<FindPWViewDelegate>

@property (nonatomic, weak) FindPWView * findView;

@end

@implementation FindPWVC

#pragma mark - cycle Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    [self initFindView];
}

#pragma mark - interface
- (void)initFindView{
    if (self.findView == nil) {
        FindPWView * findView = [[FindPWView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64)];
        findView.delegate = self;
        //loginView.aboutCell.delegate = self;
        self.findView = findView;
        [self.view addSubview:findView];
    }
}




#pragma mark - delegate
-(void)findPWViewClickedCodeButton:(UIButton *)btn phoneField:(UITextField *)phoneField{
    if (phoneField.text.length == 0 ) {
        [self.HUDUtil showTextMBHUDWithText:@"手机号不能为空" delay:1.5 inView:self.view];
        return;
    }
    
    if ([Utility isValidatePhoneNumber:phoneField.text]){
        [self.HUDUtil showTextMBHUDWithText:@"手机号码格式有误" delay:1.5 inView:self.view];
        return;
    }
    
    NSString *loginUrl=[API_ROOT stringByAppendingString:API_SMS_SEND];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phoneField.text forKey:@"cellphone"];
    [parameters setObject:@"findpwd" forKey:@"smsType"];

    /**
     *  cellphone:  手机号码
     smsType:
     发送短信类别: register:注册 findpwd:找回密码
     *
     */
    
    [self.NetworkUtil POST:loginUrl parameters:parameters inView:self.view success:^(id responseObject) {
        //
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG] delay:1.5 inView:self.view];
            [self.findView startCount];
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


- (void)findPWViewClickedSubmit:(UIButton *)btn phoneField:(UITextField *)phoneField pwField:(UITextField *)pwField rePwField:(UITextField *)rePwField codeField:(UITextField *)codeField{
    
    [self.view endEditing:YES];
    
    if (phoneField.text.length == 0 ) {
        [self.HUDUtil showTextMBHUDWithText:@"手机号不能为空" delay:1.5 inView:self.view];
        return;
    }
    
    if ([Utility isValidatePhoneNumber:phoneField.text]){
        [self.HUDUtil showTextMBHUDWithText:@"手机号码格式有误" delay:1.5 inView:self.view];
        return;
    }
    
    if (pwField.text.length < 6 ) {
        [self.HUDUtil showTextMBHUDWithText:@"密码至少为6位" delay:1.5 inView:self.view];
        return;
    }
    
    if (pwField.text.length > 20 ) {
        [self.HUDUtil showTextMBHUDWithText:@"密码最长为20位" delay:1.5 inView:self.view];
        return;
    }
    
    if (rePwField.text.length < 6 ) {
        [self.HUDUtil showTextMBHUDWithText:@"确认密码至少为6位" delay:1.5 inView:self.view];
        return;
    }
    
    if (rePwField.text.length > 20 ) {
        [self.HUDUtil showTextMBHUDWithText:@"确认密码最长为20位" delay:1.5 inView:self.view];
        return;
    }
    
    if (![pwField.text isEqualToString:rePwField.text]) {
        [self.HUDUtil showTextMBHUDWithText:@"两次密码不一致" delay:1.5 inView:self.view];
        return;
    }
    
    NSString *loginUrl=[API_ROOT stringByAppendingString:API_FIND_PW];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phoneField.text forKey:@"cellphone"];
    [parameters setObject:pwField.text forKey:@"password"];
    [parameters setObject:rePwField.text forKey:@"confirmPassword"];
    [parameters setObject:codeField.text forKey:@"smsCode"];
    [parameters setObject:KTP_overTime_VALUE forKey:KTP_overTime_KEY];
    
    [self.NetworkUtil POST:loginUrl parameters:parameters inView:self.view success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            //[self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG] delay:1.5 inView:self.view];
//            NSDictionary * info = [[responseObject objectForKey:@"data"] objectForKey:@"info"];
//            [UserDefaultsUtils setValue:[NSString stringWithFormat:@"%@",[info objectForKey:@"id"]] byKey:KTP_USER_ID];
//            [UserDefaultsUtils setValue:[NSString stringWithFormat:@"%@",[info objectForKey:@"appToken"]] byKey:KTP_KEY];
            [UserDefaultsUtils setValue:phoneField.text byKey:KTP_USER_NAME];
            //[UserDefaultsUtils setValue:pwField.text byKey:KTP_PASSWORD];
//            [UserDefaultsUtils setValue:@"YES" byKey:KTP_ISLOGIN];
            
            [self.HUDUtil showTextMBHUDInWindowWithText:@"修改密码成功" delay:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
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
