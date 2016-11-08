//
//  CustomerServiceVC.m
//  Trendpower
//
//  Created by trendpower on 15/6/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "CustomerServiceVC.h"
#import "CustomerServiceView.h"

#import "UMSocialQQHandler.h"

@interface CustomerServiceVC()<CustomerServiceViewDelegate, HUDAlertViewDelegate>

@property (nonatomic, strong) NSString * telNumber;

@property (nonatomic, strong) NSArray * qqArray;

@end

@implementation CustomerServiceVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self featchCustomerData];
}

- (NSArray *)qqArray{
    if (_qqArray == nil) {
        _qqArray = [NSArray array];
    }
    
    return _qqArray;
}

#pragma mark - 请求400电话和QQ
- (void)featchCustomerData{
    
    NSString *coustomerUrl = [API_ROOT stringByAppendingString:API_USER_COUSTOMER];
    
    [self.NetworkUtil GET:coustomerUrl inView:self.view success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            // 1.total
             NSDictionary * dic = [responseObject objectForKey:@"data"];
            
            self.telNumber = [dic objectForKey:@"phone"];
            
            self.qqArray = [dic objectForKey:@"qq"];
            
            [self initBaseView];
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}


- (void)initBaseView{
    
    CustomerServiceView * customerServiceView = [[CustomerServiceView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64)];
    customerServiceView.delegate = self;
    [self.view addSubview:customerServiceView];

}


- (void)customerServiceViewClickedButton:(UIButton *)btn titileField:(UITextField *)titileField contentView:(CustomTextView *)contentView{
    
    if(titileField.text.length == 0){
        [self.HUDUtil showTextMBHUDWithText:@"请填写标题" delay:1.5 inView:self.view];
        return;
    }
    
    if(contentView.text.length == 0){
        [self.HUDUtil showTextMBHUDWithText:@"请填写意见反馈" delay:1.5 inView:self.view];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSString *expresswayUrl=[API_ROOT stringByAppendingString:API_USER_DEVICE];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:KTP_USER_ID];
    [parameters setObject:titileField.text forKey:@"title"];
    [parameters setObject:contentView.text forKey:@"content"];

    [self.NetworkUtil POST:expresswayUrl parameters:parameters inView:self.view success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            [self.HUDUtil showTextMBHUDWithText:@"意见反馈成功" delay:1.5 inView:self.view];
            titileField.text = @"";
            contentView.text = @"";
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}


- (void)customerServiceViewclickedQQBtn:(UIButton *)btn{
    if (!self.qqArray.count) {
        self.HUDUtil.delegate = self;
        [self.HUDUtil showAlertViewWithTitle:@"暂无客服QQ" mesg:nil cancelTitle:@"确定" confirmTitle:nil tag:0];
        return;
    }
    
    self.HUDUtil.delegate = self;
    [self.HUDUtil showAlertViewWithTitle:@"联系QQ客服" mesg:nil cancelTitle:@"取消" otherButtonTitles:self.qqArray tag:100];
}

- (void)customerServiceViewclickedTelBtn:(UIButton *)btn{
    
    self.HUDUtil.delegate = self;
    [self.HUDUtil showAlertViewWithTitle:@"拨打客服电话" mesg:@"您确定要拨打客服电话？" cancelTitle:@"确定" confirmTitle:@"取消" tag:400];
}

#pragma mark - 删除商品
- (void)hudAlertViewClickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag{
    
    if (tag == 400) {
        switch (buttonIndex) {
            case 0: //确定
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.telNumber]]];
                break;
        }
    }else if(tag == 100){
        
        if (buttonIndex != 0) {
            NSString * qq = self.qqArray[buttonIndex -1];
            NSRange range = [qq rangeOfString:@":"];
            if (range.length > 0){
                NSArray * qqArr = [qq componentsSeparatedByString:@":"];
                qq = qqArr.lastObject;
            }
            
            QQApiWPAObject *wpaObj=[QQApiWPAObject objectWithUin:qq];
            SendMessageToQQReq *req=[SendMessageToQQReq reqWithContent:wpaObj];
            [QQApiInterface sendReq:req];
        }
    }
}

@end
