//
//  RootViewController.m
//  Trendpower
//
//  Created by HTC on 15/4/29.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UITabBarControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabBar];
}

- (void)initTabBar{
    
    HomeViewController * homeVc = [[HomeViewController alloc] init];
    GoodsSeekViewController * seekVc = [[GoodsSeekViewController alloc] init];
    CarTypesViewController * carTypesVc = [[CarTypesViewController alloc]init];
    CartViewController * cartVc = [[CartViewController alloc] init];
    MeViewController * meVc = [[MeViewController alloc] init];
    
    self.delegate=self;
    
    self.viewControllers= @[homeVc, seekVc, carTypesVc, cartVc, meVc];
    self.tabBar.tintColor = K_MAIN_COLOR;
    NSArray *tabBarItems=self.tabBar.items;
    NSArray * title = @[@"首页",@"查找",@"车型",@"购物车",@"我的"];
    NSArray * image = @[@"tabbar_home_normal",
                        @"tabbar_search_normal",
                        @"tabbar_car_normal",
                        @"tabbar_shopcart_normal",
                        @"tabbar_member_normal"];
    
    [tabBarItems enumerateObjectsUsingBlock:^(UITabBarItem * indexItem, NSUInteger idx, BOOL *stop) {
        indexItem.title=[title objectAtIndex:idx];
        indexItem.image=[UIImage imageNamed:[image objectAtIndex:idx]];
    }];
}


@end
