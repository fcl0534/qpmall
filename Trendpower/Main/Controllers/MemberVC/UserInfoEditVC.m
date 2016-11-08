//
//  UserInfoEditVC.m
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "UserInfoEditVC.h"
#import "UserInfoEditView.h"

@interface UserInfoEditVC ()<UserInfoEditViewDelegate, HUDAlertViewDelegate, InfoHandleToolDelegate>

@property (nonatomic, weak) UserInfoEditView * editView;

@end

@implementation UserInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑用户信息";
    
    [self initBaseView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 1.
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void) initBaseView{
    
    UserInfoEditView * editView = [[UserInfoEditView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64)];
    editView.userModel = self.userModel;
    editView.delegate = self;
    [self.view addSubview:editView];
    self.editView = editView;
    
    //设置头像
    [WebImageUtil setImageWithURL:self.userModel.userPortraitUrl placeholderImage:[UIImage imageNamed:@"user_image"] inView:editView.imageView];
}

#pragma mark - 提醒
- (void) userInfoEditViewClickedTapIndex:(NSInteger)index{
    NSString * msg = @"";
    
    if (index == 1) {
        msg = @"对不起，审核过后不允许更改";
    }else if(index == 2){
       msg = @"对不起，审核过后不允许更改";
    }
    
    [self.HUDUtil showTextMBHUDWithText:msg delay:1.5 inView:self.view];
}


#pragma mark - 点击头像
- (void) userInfoEditViewClickedIamgeView:(UIImageView *)imageView{

    [self.HUDUtil showTextMBHUDWithText:@"手机暂时不能修改头像" delay:1.5 inView:self.view];
//    self.HUDUtil.delegate = self;
//    [self.HUDUtil showActionSheetInView:self.view tag:10 title:@"设置头像" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:
//     @[@"拍照",@"我的相册"]];
}

#pragma mark 选择照片方式
- (void)hudActionSheetClickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag{
    switch (buttonIndex) {
        case 0://取消
            break;
        case 1://拍摄
            [self.InfoHandleTool openCamera:self square:YES];
            self.InfoHandleTool.delegate = self;
            break;
        case 2://相册
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
            [[UIApplication sharedApplication]setStatusBarHidden:NO];
            [self.InfoHandleTool openPhotoLibrary:self square:YES];
            self.InfoHandleTool.delegate = self;
            break;
        default:
            break;
    }
}

#pragma mark - 取得照片
- (void)infoHandleToolImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    // 1.
    [picker dismissViewControllerAnimated:YES completion:^{
        // 2.
        UIImage * image = info[UIImagePickerControllerEditedImage];
        
        [self uploadingPortrait:image];
    }];
}

#pragma mark - 上传照片
- (void) uploadingPortrait:(UIImage *)image{
    
    // 1.
    NSString *userPortraitUrl=[API_ROOT stringByAppendingString:API_ROOT];

    // 2.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[UserDefaultsUtils getUserId] forKey:@"user_id"];
    
    
    // 3.
    [self.HUDUtil showLoadingMBHUDWithText:@"图片上传中" detailsText:@"请耐心等待" inView:self.view];
    
    [self.NetworkUtil POST:userPortraitUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 一定要在这个block中添加文件参数
        
        // 1.加载文件数据
        NSData *data = UIImageJPEGRepresentation(image, 0.3);
        // 2.拼接文件参数
        [formData appendPartWithFileData:data name:@"Filedata" fileName:@"image.png" mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestSerializer *operation, id responseObject) {
        
        [self.HUDUtil dismissMBHUD];
        
        if([[responseObject objectForKey:@"status"] intValue] == 1 ){
            // 1.设置头像
            [WebImageUtil setImageWithURL:[responseObject objectForKey:@"pic_name"] placeholderImage:[UIImage imageNamed:@"user_image"] inView:self.editView.imageView];
            // 2.
            [self.HUDUtil showTextMBHUDWithText:@"修改头像成功!"  delay:1 inView:self.view];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(AFHTTPRequestSerializer *operation, NSError *error) {
        [self.HUDUtil dismissMBHUD];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}


#pragma mark - 保存用户信息
- (void)userInfoEditViewClickedButton:(UIButton *)btn phoneField:(UITextField *)phoneField realNameField:(UITextField *)realNameField companyNameField:(UITextField *)companyNameField areaNameField:(UITextField *)areaNameField emailField:(UITextField *)emailField genderType:(NSString *)genderType{
    
    if (realNameField.text.length == 0 ) {
        [self.HUDUtil showTextMBHUDWithText:@"真实姓名不能为空" delay:1.5 inView:self.view];
        return;
    }
    
    if (companyNameField.text.length == 0 ) {
        [self.HUDUtil showTextMBHUDWithText:@"公司名称不能为空" delay:1.5 inView:self.view];
        return;
    }
    
//    if ([Utility isValidatePhoneNumber:phoneField.text]){
//        [self.HUDUtil showTextMBHUDWithText:@"手机格式有误" delay:1.5 inView:self.view];
//        return;
//    }

    
    if (emailField.text.length == 0 ) {
        [self.HUDUtil showTextMBHUDWithText:@"邮箱不能为空" delay:1.5 inView:self.view];
        return;
    }
    
    if ([Utility isValidateEmail:emailField.text]){
        [self.HUDUtil showTextMBHUDWithText:@"邮箱格式有误" delay:1.5 inView:self.view];
        return;
    }
    
    // 1.
    NSString *editInfoUrl=[API_ROOT stringByAppendingString:API_USER_EDIT];
//    editInfoUrl = [editInfoUrl stringByAppendingFormat:@"?userId=%@&trueName=%@&companyName=%@&emai=%@&provinceId=%@&cityId=%@&districtId=%@",self.userId,realNameField.text,companyNameField.text,emailField.text,self.userModel.provinceId,self.userModel.cityId,self.userModel.districtId];

    // 2.
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:emailField.text forKey:@"email"];
    [parameters setObject:realNameField.text forKey:@"trueName"];
    [parameters setObject:companyNameField.text forKey:@"companyName"];
    [parameters setObject:self.userModel.provinceId forKey:@"provinceId"];
    [parameters setObject:self.userModel.cityId forKey:@"cityId"];
    [parameters setObject:self.userModel.districtId forKey:@"districtId"];
    
    
    
    // 3.
    [self.NetworkUtil POST:editInfoUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        
        
        if([[responseObject objectForKey:@"status"] intValue] == 1 ){
            [self.HUDUtil showTextMBHUDWithText:@"修改成功!"  delay:1.5 inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
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
