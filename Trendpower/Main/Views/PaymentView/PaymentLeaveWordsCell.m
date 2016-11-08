
//
//  PaymentLeaveWordsView.m
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "PaymentLeaveWordsCell.h"

#import <Masonry.h>

@implementation PaymentLeaveWordsCell


#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PaymentLeaveWordsCell";
    PaymentLeaveWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PaymentLeaveWordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CustomTextView * textView = [[CustomTextView alloc]init];
        textView.placeholder = @"给卖家留言";
        textView.textColor = [UIColor colorWithRed:0.357 green:0.353 blue:0.353 alpha:1.000];
        textView.tintColor = [UIColor colorWithRed:0.988 green:0.353 blue:0.537 alpha:1.000];
        textView.layer.borderColor = [UIColor colorWithRed:0.871 green:0.879 blue:0.879 alpha:1.000].CGColor;
        textView.layer.borderWidth = 0.8;
        [self.contentView addSubview:textView];
        self.leaveWordsView = textView;
        
        
        [self addViewConstraints];
    }
    
    return self;
}


- (void)addViewConstraints{
    [self.leaveWordsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
}

@end
