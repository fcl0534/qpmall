//
//  MyCreditCell.m
//  Trendpower
//
//  Created by HTC on 16/2/27.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "MyCreditTableCell.h"

#import <Masonry.h>

@interface MyCreditTableCell()
/** 名字 */
@property (nonatomic, weak) UILabel * nameLabel;
/** 额度 */
@property (nonatomic, weak) UILabel * balanceAmountLabel;
/** 帐单期 */
@property (nonatomic, weak) UILabel * creditTimeLabel;
/** 可用额度 */
@property (nonatomic, weak) UILabel * balanceCreditLabel;

/** LineView */
@property (nonatomic, weak) UIView * bottomLine;

@end


@implementation MyCreditTableCell

#pragma mark - 初始化

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MyCreditTableCell";
    MyCreditTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MyCreditTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        //初始全部cell
        [self setBaseView];
    }
    return self;
}

- (void) setBaseView{
    
    self.nameLabel = [self getLabel];
//    self.nameLabel.textColor = [UIColor colorWithRed:0.169f green:0.169f blue:0.169f alpha:1.00f];
//    self.nameLabel.font = [UIFont systemFontOfSize:18.0];
    
    self.balanceAmountLabel = [self getLabel];
    self.balanceAmountLabel.textAlignment = NSTextAlignmentRight;
//    self.phoneLabel.textColor = [UIColor colorWithWhite:0.207 alpha:1.000];
//    self.phoneLabel.font = [UIFont systemFontOfSize:17.0];
//    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    
    self.balanceCreditLabel = [self getLabel];
    self.balanceCreditLabel.textAlignment = NSTextAlignmentRight;
    
    self.creditTimeLabel = [self getLabel];
    
    self.bottomLine = [self getLineView];
    
    [self addViewConstraints];
}


- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16.5f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithWhite:0.391 alpha:1.000];
    [self addSubview:label];
    
    label.adjustsFontSizeToFitWidth = YES;
    label.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
    return label;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    [self addSubview:line];
    return line;
}

- (void)setMyCreditModel:(MyCreditModel *)myCreditModel{
    _myCreditModel = myCreditModel;
    
    self.nameLabel.text = myCreditModel.sellerTrueName;
    
    self.balanceAmountLabel.text = [NSString stringWithFormat:@"信用额度：￥%@",myCreditModel.creditLimit];
    
    self.creditTimeLabel.text = [NSString stringWithFormat:@"账单期：%@天",myCreditModel.creditTime];
    
    self.balanceCreditLabel.text = [NSString stringWithFormat:@"可用额度：￥%@",myCreditModel.balanceCredit];

}

#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 10;
    
    // 1.
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.45);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.45);
    }];
    
    [self.balanceAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.45);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.35);
    }];

    [self.creditTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-spacing);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.45);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.35);
    }];
    
    [self.balanceCreditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-spacing);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.45);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.45);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.8);
    }];
    
}

@end
