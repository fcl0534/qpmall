//
//  TCPickerView.m
//  Trendpower
//
//  Created by trendpower on 15/9/2.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "TCPickerView.h"

#import "NetworkingUtil.h"
#import "HUDUtil.h"
#import "UserDefaultsUtils.h"
#import "Utility.h"
#import "RegionModelArray.h"


@interface TCPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>


/**
 *  黑色背影
 */

@property (nonatomic, weak) UIView* blackBgView;

@property (nonatomic, weak) UIPickerView * pickerView;
@property (nonatomic, weak) UIView * toolBar;

@property (nonatomic, strong) NSArray * regionArray;
@property (nonatomic, strong) NSArray * regionChildArray;
@property (nonatomic, strong) NSArray * regionSubChildArray;

/** 地区ID，最后一级 */
@property (nonatomic, copy) NSString *  regionId;

@end


@implementation TCPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        [self initBaseView];
    }
    
    return self;
}

- (void)initBaseView{
    
    

}


//选择器上的工具项
- (void)setToolBarView{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.frame), self.frame.size.width, 40)];
    topView.backgroundColor = [UIColor colorWithRed:0.933f green:0.933f blue:0.933f alpha:1.00f];
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [leftBtn setTitle:@"关闭" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn setTitleColor:[UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000] forState:UIControlStateNormal];
    
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 60 , 0, 60, 40)];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:[UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(cancelSeleted) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn addTarget:self action:@selector(finishSeleted) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:leftBtn];
    [topView addSubview:rightBtn];
    
    [self addSubview:topView];
    self.toolBar = topView;
}


@end
