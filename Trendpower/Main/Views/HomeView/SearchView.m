//
//  SearchView.m
//  Trendpower
//
//  Created by trendpower on 15/6/10.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "SearchView.h"

#import "LMContainsLMComboxScrollView.h"

@interface SearchView()<LMComBoxViewDelegate>

@property (nonatomic, strong) LMContainsLMComboxScrollView *bgScrollView;

@property (nonatomic, weak) UILabel * label1;
@property (nonatomic, weak) UILabel * label2;
@property (nonatomic, weak) UILabel * label3;
@property (nonatomic, weak) UILabel * label4;
@property (nonatomic, weak) UILabel * label5;
@property (nonatomic, weak) UILabel * label6;
@property (nonatomic, weak) UILabel * label7;

@property (nonatomic, weak) UITextField * textField;

@end


@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.bgScrollView.backgroundColor = [UIColor whiteColor];
        self.bgScrollView.showsVerticalScrollIndicator = NO;
        self.bgScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.bgScrollView];
        
        self.label1 = [self getLabel];
        self.label2 = [self getLabel];
        self.label3 = [self getLabel];
        self.label4 = [self getLabel];
        self.label5 = [self getLabel];
        self.label6 = [self getLabel];
        self.label7 = [self getLabel];
        
        self.label1.text = @"汽车品牌";
        self.label2.text = @"车型系列";
        self.label3.text = @"排量及型号";
        self.label4.text = @"年款";
        self.label5.text = @"查询配件品类";
        self.label6.text = @"17位车架号";
        self.label7.text = @"查询配件品类";
        

//增加约束
        
        float top = 10;
        float spacing = 10;
        
        float W = self.frame.size.width;
        
        float comboxW = (W -3*spacing)/2;
        
        // 1.
        self.label1.frame = CGRectMake(0, top, W/2, 30);
        self.label2.frame = CGRectMake(CGRectGetMaxX(self.label1.frame), top, W/2, 30);
        
        self.comBox1 = [[LMComBoxView alloc]initWithFrame:CGRectMake(spacing, CGRectGetMaxY(self.label1.frame), comboxW, 30)];
        self.comBox2 = [[LMComBoxView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.comBox1.frame)+spacing, CGRectGetMaxY(self.label1.frame), comboxW, 30)];
        
        
        self.label3.frame = CGRectMake(0, CGRectGetMaxY(self.comBox1.frame)+spacing, W/2, 30);
        self.label4.frame = CGRectMake(CGRectGetMaxX(self.label3.frame), CGRectGetMaxY(self.comBox1.frame)+spacing, W/2, 30);
        
        self.comBox3 = [[LMComBoxView alloc]initWithFrame:CGRectMake(spacing, CGRectGetMaxY(self.label3.frame), comboxW, 30)];
        self.comBox4 = [[LMComBoxView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.comBox3.frame)+spacing, CGRectGetMaxY(self.label3.frame), comboxW, 30)];
        
        
        self.label5.frame = CGRectMake(0, CGRectGetMaxY(self.comBox3.frame)+spacing, W/2, 30);
        self.comBox5 = [[LMComBoxView alloc]initWithFrame:CGRectMake(spacing, CGRectGetMaxY(self.label5.frame), comboxW, 30)];
        
        
        // 2.
        UIButton * searchBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.comBox5.frame)+2*spacing, CGRectGetMaxY(self.comBox3.frame)+ 35, W/2 -3*spacing, 35)];
        searchBtn1.tag = 1;
        [searchBtn1 setBackgroundImage:[UIImage imageNamed:@"btn_square_bg"] forState:UIControlStateNormal];
        [searchBtn1 setTitle:@"搜索" forState:UIControlStateNormal];
        [searchBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [searchBtn1.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [searchBtn1 addTarget:self action:@selector(searchViewSearchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgScrollView addSubview:searchBtn1];
        
        
        // 分隔线
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.comBox5.frame)+2*spacing, W, 0.8)];
        line.backgroundColor = [UIColor colorWithWhite:0.801 alpha:1.000];
        [self.bgScrollView addSubview:line];
        
        
        self.label6.frame = CGRectMake(0, CGRectGetMaxY(line.frame)+2*spacing, W/2, 30);
        self.label7.frame = CGRectMake(CGRectGetMaxX(self.label6.frame), CGRectGetMaxY(line.frame)+2*spacing, W/2, 30);
        
        
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(spacing, CGRectGetMaxY(self.label6.frame), comboxW, 30)];
        textField.placeholder = @"17位车架号";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = [UIFont systemFontOfSize:12.0f];
        textField.tintColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = kBorderColor.CGColor;
        self.textField = textField;
        [self.bgScrollView addSubview:textField];
        
        self.comBox6 = [[LMComBoxView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.textField.frame)+spacing, CGRectGetMaxY(self.label6.frame), comboxW, 30)];
        
        
        UIButton * searchBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(2*spacing, CGRectGetMaxY(self.textField.frame)+spacing, W -4*spacing, 35)];
        searchBtn2.tag = 2;
        [searchBtn2 setBackgroundImage:[UIImage imageNamed:@"btn_square_bg"] forState:UIControlStateNormal];
        [searchBtn2 setTitle:@"搜索" forState:UIControlStateNormal];
        [searchBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [searchBtn2.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [searchBtn2 addTarget:self action:@selector(searchViewSearchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgScrollView addSubview:searchBtn2];
        
        
        // 分隔线
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBtn2.frame)+2*spacing, W, 0.8)];
        line2.backgroundColor = [UIColor colorWithWhite:0.801 alpha:1.000];
        [self.bgScrollView addSubview:line2];
        
        
        //重置功能
        UIButton * searchBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(2*spacing, CGRectGetMaxY(line2.frame)+2*spacing, W -4*spacing, 35)];
        searchBtn3.tag = 3;
        [searchBtn3 setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
        [searchBtn3 setTitle:@"重置全部选项" forState:UIControlStateNormal];
        [searchBtn3 setTitleColor:[UIColor colorWithWhite:0.276 alpha:1.000] forState:UIControlStateNormal];
        [searchBtn3.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [searchBtn3 addTarget:self action:@selector(searchViewSearchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgScrollView addSubview:searchBtn3];

        [self setComBoxView:self.comBox1];
        [self setComBoxView:self.comBox2];
        [self setComBoxView:self.comBox3];
        [self setComBoxView:self.comBox4];
        [self setComBoxView:self.comBox5];
        [self setComBoxView:self.comBox6];
        
        self.comBox5.titlesList = [NSMutableArray arrayWithArray:@[@"可选项"]];
        self.comBox6.titlesList = [NSMutableArray arrayWithArray:@[@"可选项"]];
        [self.comBox5 reloadData];
        [self.comBox6 reloadData];
        
        self.comBox1.tag = 0;
        self.comBox2.tag = 1;
        self.comBox3.tag = 2;
        self.comBox4.tag = 3;
        self.comBox5.tag = 4;
        self.comBox6.tag = 5;
        
        

        //[self addViewConstraints];
    }
    return self;
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    [self.bgScrollView  addSubview:label];
    return label;
}

- (void) setComBoxView:(LMComBoxView *)comBox{
    comBox.backgroundColor = [UIColor whiteColor];
    comBox.arrowImgName = @"down_dark0.png";
    NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:@[@"必选项"]];
    comBox.titlesList = itemsArray;
    comBox.delegate = self;
    comBox.supView = self.bgScrollView;
    [comBox defaultSettings];
    [self.bgScrollView addSubview:comBox];
}


#pragma mark -LMComBoxViewDelegate
- (void)tapInCombox:(LMComBoxView *)_combox{
    if([self.delegate respondsToSelector:@selector(searchViewTapInCombox:)]){
        [self.delegate searchViewTapInCombox:_combox];
    }
}


-(void)selectAtIndex:(NSInteger)index inCombox:(LMComBoxView *)_combox
{
    if([self.delegate respondsToSelector:@selector(searchViewSelectAtIndex:inCombox:)]){
        [self.delegate searchViewSelectAtIndex:index inCombox:_combox];
    }
}


- (void)searchViewSearchBtnClicked:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(searchViewSearchBtnClicked:withTextField:)]){
        [self.delegate searchViewSearchBtnClicked:btn withTextField:self.textField];
    }
}


@end
