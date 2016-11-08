//
//  CameraConfirmVC.h
//  Trendpower
//
//  Created by 张帅 on 16/6/25.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "BaseViewController.h"

//点击确定按钮
typedef void(^ConfirmClick)(NSString *vin);

//点击取消按钮
typedef void(^CancelClick)(void);

//点击退出按钮
typedef void(^ReturnClicked)(void);

@interface CameraConfirmVC : BaseViewController

@property (nonatomic, copy) ConfirmClick confirmClick;

@property (nonatomic, copy) CancelClick cancelClick;

@property (nonatomic, copy) ReturnClicked returnClicked;

@property (nonatomic, strong) UIImage *cutImg;

@property (nonatomic, strong) NSMutableArray *vinStr;

@end
