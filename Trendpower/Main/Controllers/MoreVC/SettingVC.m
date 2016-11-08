//
//  SettingVC.m
//  Trendpower
//
//  Created by HTC on 15/5/8.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "SettingVC.h"

#import "FileManagerUtil.h"

// vc
#import "MoreVC.h"
#import "CustomerServiceVC.h"

@interface SettingVC()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

/** 列表数据 */
@property (nonatomic, strong) NSArray * settingArray;

/** 列表数据 */
@property (nonatomic, assign) BOOL isReceiverPush;


@end

@implementation SettingVC
- (NSArray *)settingArray{
    if (_settingArray == nil) {
        if(OPEN_Test_Environment){
            _settingArray = @[@[@"接收消息推送",@"意见反馈",@"仅WiFi网络显示图片"],@[@"关于我们",@"消除本地缓存"],@[@"开启测试环境"]];
        }else{
            _settingArray = @[@[@"接收消息推送",@"意见反馈",@"仅WiFi网络显示图片"],@[@"关于我们",@"消除本地缓存"]];
        }
    }
    return _settingArray;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isReceiverPush = YES;
    
    [self initView];
    [self initTableView];
    //[self featchPushSetting];
}


#pragma mark - initView
- (void)initView{
    self.title = @"设置";
}


- (void)featchPushSetting{
    
    // 显示推送信息
    if (OPEN_Push_Message) {
        NSString *pushUrl = [API_ROOT stringByAppendingString:@""];
        pushUrl = [pushUrl stringByAppendingString:[UserDefaultsUtils getUserId]];

        [self.NetworkUtil GET:pushUrl inView:self.view success:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"status"] intValue] == 1) {
                // 1.total
                NSDictionary * dic = [responseObject objectForKey:@"data"];
                self.isReceiverPush = [[dic objectForKey:@"if_receiver_app_mes"] intValue];
                [self initTableView];
                
            }else{
                [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
            }
            
        } failure:^(NSError *error) {
            [self.HUDUtil showNetworkErrorInView:self.view];
        }];
    }else{
        [self initTableView];
    }
}

- (void)initTableView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = K_LINEBG_COLOR;
    tableView.sectionFooterHeight = 5;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 80)];
    //    footerView.backgroundColor = [UIColor colorWithWhite:0.812 alpha:1.000];
    UIButton * exitBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 25, K_UIScreen_WIDTH - 25*2, 40)];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"back_red"] forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    [footerView addSubview:exitBtn];
    [exitBtn addTarget:self action:@selector(clickedExitBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.settingArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.settingArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"SettingCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.settingArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.276 alpha:1.000];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    if (indexPath.section == 0 ) {
        switch (indexPath.row) {
            case 0:{// 推送消息
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch * switchBtn = [[UISwitch alloc]init];
                switchBtn.on = self.isReceiverPush;
                [switchBtn addTarget:self action:@selector(clickedPushMessageSwithBtn:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = switchBtn;
                break;
            }
            case 1:{

                break;
            }
            case 2:{ // WiFi
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch * switchBtn = [[UISwitch alloc]init];
                BOOL isOn = [UserDefaultsUtils getBOOLByKey:@"WiFiShowImage"];
                switchBtn.on = isOn;
                [switchBtn addTarget:self action:@selector(clickedWiFiSwithBtn:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = switchBtn;
                break;
            }
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                break;
            }
            case 1:{
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15.5];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fM",[FileManagerUtil folderSizeAtPath:[FileManagerUtil cachesPath]]];
                break;
            }
            default:
                break;
        }
    }else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0:{ //开启测试环境
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch * switchBtn = [[UISwitch alloc]init];
                BOOL isOn = [UserDefaultsUtils getBOOLByKey:KTP_Test_Environment];
                switchBtn.on = isOn;
                [switchBtn addTarget:self action:@selector(clickedTestEnvironmentSwithBtn:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = switchBtn;
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 ) {
        switch (indexPath.row) {
            case 0:{
                
                break;
            }
            case 1:{
                CustomerServiceVC * vc = [[CustomerServiceVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{
                
            }
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                MoreVC * vc = [[MoreVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:{
                [self.HUDUtil showLoadingMBHUDWithText:@"清理中..." detailsText:@"请耐心等待哦" inView:self.tableView];
                [FileManagerUtil clearCache:[FileManagerUtil cachesPath]];
                [self.HUDUtil dismissMBHUD];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
            default:
                break;
        }
    }
}


#pragma mark - 推送设置
- (void)clickedPushMessageSwithBtn:(UISwitch *)switchBtn{
    // http://m.mflapp.xyd.qushiyun.com/mobile/index.php?app=user&act=set_receiver_app_mes&user_id=2498973&if_receiver_app_mes=1
//    NSString *pushUrl = [API_ROOT stringByAppendingString:@""];
//    pushUrl = [pushUrl stringByAppendingString:[UserDefaultsUtils getUserId]];
//    if (switchBtn.isOn) {
//        pushUrl = [pushUrl stringByAppendingString:@"&if_receiver_app_mes=1"];
//    }else{
//        pushUrl = [pushUrl stringByAppendingString:@"&if_receiver_app_mes=0"];
//    }
    
//    DLog(@"USER_SET_PUSH_RECEIVER_API----%@",pushUrl);
//    
//    [self.NetworkUtil GET:pushUrl inView:self.view success:^(id responseObject) {
//        
//        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
//            // 1.total
//            [self.HUDUtil showTextMBHUDWithText:@"设置成功" delay:1.0 inView:self.view];
//            
//        }else{
//            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
//        }
//        
//    } failure:^(NSError *error) {
//        [self.HUDUtil showNetworkErrorInView:self.view];
//    }];
}


#pragma mark - wifi设置
- (void)clickedWiFiSwithBtn:(UISwitch *)switchBtn{
    [UserDefaultsUtils setBool:switchBtn.isOn forKey:@"WiFiShowImage"];
}

- (void)clickedTestEnvironmentSwithBtn:(UISwitch *)switchBtn{
    [UserDefaultsUtils setBool:switchBtn.isOn forKey:@"KTP_Test_Environment"];
}

#pragma mark - 点击注销
-  (void)clickedExitBtn:(UIButton *)btn{
    //注销 清理用户在服务器的缓存
    NSString *url=[API_ROOT stringByAppendingString:API_USER_LOGOUT];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:KTP_USER_ID];
    
    
    [self.NetworkUtil POST:url header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            //如果登陆或注销后，刷新数据，显示价格状态
            [UserDefaultsUtils setValue:@"YES" byKey:@"is_change_user_state"];
            [UserDefaultsUtils setValue:@"NO" byKey:KTP_ISLOGIN];
            [UserDefaultsUtils setValue:@"" byKey:KTP_USER_ID];
            [UserDefaultsUtils setValue:@"" byKey:KTP_KEY];

            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
    } failure:^(NSError *error) {
        DLog(@"error----%@",error);
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
    
//    [self.NetworkUtil GET:url header:header success:^(id responseObject) {
//        
//        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            //如果登陆或注销后，刷新数据，显示价格状态
//            //[UserDefaultsUtils setValue:@"YES" byKey:@"is_change_user_state"];
//            [UserDefaultsUtils setValue:@"NO" byKey:KTP_ISLOGIN];
//            [UserDefaultsUtils setValue:@"0" byKey:KTP_USER_ID];
//            [UserDefaultsUtils setValue:@"0" byKey:KTP_KEY];
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }else{
//            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
//        }
//    } failure:^(NSError *error) {
//        DLog(@"error----%@",error);
//        [self.HUDUtil showNetworkErrorInView:self.view];
//    }];
    
}


@end
