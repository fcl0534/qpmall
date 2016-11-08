//
//  CartType2VC.h
//  Trendpower
//
//  Created by HTC on 15/9/30.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "BaseViewController.h"

@interface CarType2ViewController : BaseViewController

@property (nonatomic, copy) NSString * filterName;

@property (nonatomic, copy) NSString * titleName;

@property (nonatomic, copy) NSString * fetchUrl;

@property (nonatomic, strong) NSMutableArray * rowModelArray;

@end
