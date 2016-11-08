//
//  CameraVC.h
//  Trendpower
//
//  Created by 张帅 on 16/6/25.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "BaseViewController.h"

@protocol CameraVCDelegate <NSObject>

- (void)gotoSpecialSearch:(NSString *)vin;

@end

@interface CameraVC : BaseViewController

@property (nonatomic, weak) id<CameraVCDelegate> delegate;

@end
