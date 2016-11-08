
//
//  RegistVC.m
//  Trendpower
//
//  Created by HTC on 16/1/20.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "RegistVC.h"

#import "JPUSHService.h"

// view
#import "RegisterView.h"

// vc
#import "AddressPickerVC.h"
#import "RegistSuccessVC.h"
#import "BaseWeb.h"

// model
#import "CompanyInfoModel.h"
#import "AddressAgentModelArray.h"

@interface RegistVC ()<RegisterViewDelegate, AddressPickerVCDelegate>


@property (nonatomic, weak) RegisterView * registerView;

@property (nonatomic, strong) NSDictionary * addressDic;

/** 内容数据 */
@property (nonatomic, strong) CompanyInfoModel * infoModel;

@end

@implementation RegistVC
#pragma mark - Life cycle   ###
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"立即注册";
    
    [self initRegisterView];
}



#pragma mark - Interface   ###
- (void)initRegisterView{
    
    if (self.registerView == nil) {
        RegisterView * registerView = [[RegisterView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64)];
        registerView.delegate = self;
        //loginView.aboutCell.delegate = self;
        self.registerView = registerView;
        [self.view addSubview:registerView];
    }
}

#pragma mark - Event response   ###


#pragma mark - Private method   ###


#pragma mark - Delegate   ###

#pragma mark - 地址选择
- (void)addressPickerVC:(AddressPickerVC *)addressPickerVC{
    
    self.addressDic = [NSDictionary dictionaryWithDictionary:addressPickerVC.addressDic];
    [self.registerView setArea:[NSString stringWithFormat:@"%@ %@ %@",[self.addressDic objectForKey:@"title1"],[self.addressDic objectForKey:@"title2"],[self.addressDic objectForKey:@"title3"]]];

    //这里做一个根据城市id获取经销商的请求
    //http://api.qpfww.com/agents?city=76&province=6&district=695

    NSString *urlStr = [API_ROOT stringByAppendingString:[NSString stringWithFormat:@"%@city=%@&province=%@&district=%@",API__Dealers,[self.addressDic objectForKey:@"2"],[self.addressDic objectForKey:@"1"],[self.addressDic objectForKey:@"3"]]];

    [self.NetworkUtil GET:urlStr success:^(id responseObject) {
        //
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {

            AddressAgentModelArray *agentModel = [[AddressAgentModelArray alloc] initWithAttributes:responseObject];

            self.registerView.dealers = agentModel.agents;
        } else {

            self.registerView.dealers = nil;
        }
    } failure:^(NSError *error) {
        //

    }];

    [self dismissViewControllerAnimated:YES completion:^{

    }];
    
}


- (void)registerViewClickedArea{

    AddressPickerVC * vc = [[AddressPickerVC alloc]init];
    vc.delegate = self;
    vc.addressType = AddressTypeProvince;
    UINavigationController * naviVc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:naviVc animated:YES completion:^{
        //;
    }];
}


- (void)registerViewClickedProtocol{
    TPTapLog;

    if(self.infoModel){
        [self showPotocol];
        return;
    }
    
    NSString *companyInfoUrl=[API_ROOT stringByAppendingString:API_COMPANY_INFO];

    [self.NetworkUtil GET:companyInfoUrl success:^(id responseObject) {
        self.infoModel = [[CompanyInfoModel alloc]initWithAttributes:responseObject];
        [self showPotocol];
    } failure:^(NSError *error) {
        [self.HUDUtil showErrorMBHUDWithText:@"加载失败，请重新点击" inView:self.view delay:2];
    }];
    
}

- (void)showPotocol{
    BaseWeb * web = [[BaseWeb alloc]init];
    web.titleName = @"佳驰用户注册协议";
    [web displayContent:self.infoModel.protocol];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)registerViewClickedCodeButton:(UIButton *)btn phoneField:(UITextField *)phoneField{
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
    [parameters setObject:@"register" forKey:@"smsType"];

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
            [self.registerView startCount];
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


- (void)registerViewClickedRegisterButton:(UIButton *)registerBtn phoneField:(UITextField *)phoneField pwField:(UITextField *)pwField rePwField:(UITextField *)rePwField realNameField:(UITextField *)realNameField areaField:(UITextField *)areaField codeField:(UITextField *)codeField agreeBtn:(UIButton *)agreeBtn userCate:(NSInteger)userCate agentId:(NSInteger)agentId {
    
    [self.view endEditing:YES];
    
    if (realNameField.text.length == 0 ) {
        [self.HUDUtil showTextMBHUDWithText:@"企业名不能为空" delay:1.5 inView:self.view];
        return;
    }
    
    if (areaField.text.length == 0 ) {
        [self.HUDUtil showTextMBHUDWithText:@"所在区域不能为空" delay:1.5 inView:self.view];
        return;
    }
    
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
    }
    
    
    if (!agreeBtn.isSelected){
        [self.HUDUtil showTextMBHUDWithText:@"请阅读并同意协议" delay:1.5 inView:self.view];
        return;
    }
    
    NSString *loginUrl=[API_ROOT stringByAppendingString:API_USER_REGISTER];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phoneField.text forKey:@"cellphone"];
    [parameters setObject:pwField.text forKey:@"password"];
    [parameters setObject:rePwField.text forKey:@"confirmPassword"];
    [parameters setObject:realNameField.text forKey:@"companyName"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)userCate] forKey:@"userCategory"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)agentId] forKey:@"agentId"];
    [parameters setObject:[self.addressDic objectForKey:@"1"] forKey:@"provinceId"];
    [parameters setObject:[self.addressDic objectForKey:@"2"] forKey:@"cityId"];
    [parameters setObject:[self.addressDic objectForKey:@"3"] forKey:@"districtId"];
    [parameters setObject:codeField.text forKey:@"smsCode"];
    [parameters setObject:KTP_overTime_VALUE forKey:KTP_overTime_KEY];

    [self.NetworkUtil POST:loginUrl parameters:parameters inView:self.view success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {

            NSDictionary * info = [[responseObject objectForKey:@"data"] objectForKey:@"info"];
            
            //[self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG] delay:1.5 inView:self.view];
//            NSDictionary * info = [[responseObject objectForKey:@"data"] objectForKey:@"info"];
//            [UserDefaultsUtils setValue:[NSString stringWithFormat:@"%@",[info objectForKey:@"id"]] byKey:KTP_USER_ID];
//            [UserDefaultsUtils setValue:[NSString stringWithFormat:@"%@",[info objectForKey:@"appToken"]] byKey:KTP_KEY];
            [UserDefaultsUtils setValue:phoneField.text byKey:KTP_USER_NAME];
            //[UserDefaultsUtils setValue:pwField.text byKey:KTP_PASSWORD];
//            [UserDefaultsUtils setValue:@"YES" byKey:KTP_ISLOGIN];

            /**
             *  JPush 标签与别名设置
             */
            if (OPEN_Push_Message) {

                [JPUSHService setAlias:[NSString stringWithFormat:@"%@",[info objectForKey:@"id"]] callbackSelector:nil object:nil];
            }

            RegistSuccessVC * vc = [[RegistSuccessVC alloc]init];
            vc.phone = phoneField.text;
            [self.navigationController pushViewController:vc animated:YES];
            
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
