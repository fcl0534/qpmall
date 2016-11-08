//
//  MessageDetailViewController.h
//  EcoDuo
//
//  Created by trendpower on 15/1/9.
//  Copyright (c) 2015年 Felix Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import <AFNetworking.h>


@interface MessageDetailViewController : BaseViewController

@property(nonatomic,strong) NSString *requestUrl;
@property(nonatomic,strong) NSString *messageTitle;
@property (nonatomic, assign)  CGFloat screenWidth;
@property (nonatomic, assign)  CGFloat screenHeight;
@end
