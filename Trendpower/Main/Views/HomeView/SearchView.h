//
//  SearchView.h
//  Trendpower
//
//  Created by trendpower on 15/6/10.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "LMComBoxView.h"

@protocol SearchViewDelegate <NSObject>

- (void)searchViewTapInCombox:(LMComBoxView *)combox;
-(void)searchViewSelectAtIndex:(NSInteger)index inCombox:(LMComBoxView *)combox;

-(void)searchViewSearchBtnClicked:(UIButton *)btn withTextField:(UITextField *)textField;

@end

@interface SearchView : UIView

@property (nonatomic, weak) id<SearchViewDelegate> delegate;

@property (nonatomic, strong) NSArray * comBoxArray;


@property (nonatomic, strong) LMComBoxView *comBox1;
@property (nonatomic, strong) LMComBoxView *comBox2;
@property (nonatomic, strong) LMComBoxView *comBox3;
@property (nonatomic, strong) LMComBoxView *comBox4;
@property (nonatomic, strong) LMComBoxView *comBox5;
@property (nonatomic, strong) LMComBoxView *comBox6;

@end
