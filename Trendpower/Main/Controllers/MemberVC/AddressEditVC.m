//
//  AddressEditVC.m
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "AddressEditVC.h"
#import "AddressEditView.h"

#import "AddressPickerVC.h"



@interface AddressEditVC ()<AddressEditViewDelegate, HUDAlertViewDelegate, AddressPickerVCDelegate>

@property (nonatomic, strong) AddressEditView * addressView;

@property (nonatomic, strong) NSDictionary * addressDic;

@end

@implementation AddressEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseView];
}

- (void) initBaseView{
    
    AddressEditView * editView = [[AddressEditView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64)];
    editView.delegate = self;
    [self.view addSubview:editView];
    self.addressView = editView;
    editView.isFromNewAddress = self.isFromNewAddress;
    
    if (self.isFromNewAddress) {
        self.title = @"新建收货地址";
    }else{
        self.title = @"编辑收货地址";
        [self initEditAddressView];
    }
    
}


- (void) initEditAddressView{

    // 1.
    self.addressView.addressModel = self.addressModel;
    
    // 2.
    //删除按钮(如果来自提交订单，不能删除）
    if(!self.isFromPayment){
        UIButton * deleteBtn = [[UIButton alloc]initWithFrame:self.naviRightItem.bounds];
        deleteBtn.tag = [self.addressModel.addressId integerValue];
        deleteBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [deleteBtn addTarget:self action:@selector(clickedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.naviRightItem addSubview:deleteBtn];
    }
}

#pragma mark  点击删除地址

- (void)clickedDeleteBtn:(UIButton *)btn{
    
    self.HUDUtil.delegate = self;
    [self.HUDUtil showActionSheetInView:self.view tag:btn.tag title:@"是否确认删除该地址？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil];
    
}

#pragma mark 选择是否删除地址
- (void)hudActionSheetClickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag{
    
    switch (buttonIndex) {
        case 0://确认按钮
            [self deleteAddressId:tag];
            break;
        case 1://取消按钮
            
            break;
        default:
            break;
    }
}

#pragma mark - 删除地址请求
- (void) deleteAddressId:(NSInteger)addressId{
    
    NSString *deleteAddressUrl=[API_ROOT stringByAppendingString:API_ADDRESS_DELETE];
    
    
    // 1.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",addressId] forKey:@"addressId"];
    // 2.
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    
    
    
    // 3.
    [self.NetworkUtil POST:deleteAddressUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        if([[responseObject objectForKey:@"status"] intValue] == 1 ){
            [self.HUDUtil showTextMBHUDWithText:@"地址删除成功!"  delay:1 inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        TPError;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


#pragma mark - Delegate   ###

#pragma mark - 地址选择
- (void)addressPickerVC:(AddressPickerVC *)addressPickerVC{
    self.addressDic = [NSDictionary dictionaryWithDictionary:addressPickerVC.addressDic];
    [self.addressView setArea:[NSString stringWithFormat:@"%@ %@ %@",[self.addressDic objectForKey:@"title1"],[self.addressDic objectForKey:@"title2"],[self.addressDic objectForKey:@"title3"]]];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}


- (void)AddressEditViewClickedRegionArea{
    
    AddressPickerVC * vc = [[AddressPickerVC alloc]init];
    vc.delegate = self;
    vc.addressType = AddressTypeProvince;
    UINavigationController * naviVc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:naviVc animated:YES completion:^{
        //;
    }];
}

#pragma mark - 确认地址
- (void)AddressEditViewClickedButton:(UIButton *)btn consigneeField:(UITextField *)consigneeField mobphoneField:(UITextField *)mobphoneField regionNameField:(UITextField *)regionNameField addressView:(CustomTextView *)addressView regionId:(NSString *)regionid defaultBtn:(UIButton *)defaultBtn{
    
    // 1.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:consigneeField.text forKey:@"recipient"];
    [parameters setObject:mobphoneField.text forKey:@"recipientMobile"];
    [parameters setObject:addressView.text forKey:@"address"];
    [parameters setObject:defaultBtn.isSelected?@"1":@"0" forKey:@"isDefault"];
    
    if (self.addressDic == nil) {
        [parameters setObject:self.addressModel.provinceId forKey:@"provinceId"];
        [parameters setObject:self.addressModel.cityId forKey:@"cityId"];
        [parameters setObject:self.addressModel.districtId forKey:@"districtId"];
    }else{
        [parameters setObject:[self.addressDic objectForKey:@"1"] forKey:@"provinceId"];
        [parameters setObject:[self.addressDic objectForKey:@"2"] forKey:@"cityId"];
        [parameters setObject:[self.addressDic objectForKey:@"3"] forKey:@"districtId"];
    }
    
    // 2.
    NSString *addressUrl;
    if (self.isFromNewAddress) {
        // 1. 新建地址
        addressUrl = [API_ROOT stringByAppendingString:API_ADDRESS_ADD];
    }else{
        // 2. 编辑地址
        addressUrl = [API_ROOT stringByAppendingString:API_ADDRESS_EDIT];
        [parameters setObject:self.addressModel.addressId forKey:@"addressId"];
    }
    
    // 3.
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    
    
    
    // 3.
    [self.NetworkUtil POST:addressUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            
            if (self.isFromPayment) {
                [self.navigationController popViewControllerAnimated:NO];
                if([self.delegate respondsToSelector:@selector(addressEditVCPaymentSaveSuccess)]){
                    [self.delegate addressEditVCPaymentSaveSuccess];
                }
            }else{
                if (self.isFromNewAddress) {
                    // 1. 新建地址
                    [self.HUDUtil showTextMBHUDWithText:@"地址创建成功!"  delay:1 inView:self.view];
                }else{
                    // 2. 编辑地址
                    [self.HUDUtil showTextMBHUDWithText:@"地址编辑成功!"  delay:1 inView:self.view];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
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

@end
