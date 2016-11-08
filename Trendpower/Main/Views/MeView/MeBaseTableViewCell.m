//
//  MeBaseTableViewCell.m
//  EcoDuo
//
//  Created by trendpower on 15/11/7.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import "MeBaseTableViewCell.h"

#import <Masonry.h> //autoLayout

@interface MeBaseTableViewCell()

@property (nonatomic, weak) UIImageView * rightImageView;

@end

@implementation MeBaseTableViewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MeBaseTableViewCell";
    MeBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    self.leftImageView = [self getImageView];
    
    self.nameLbl = [self getLabel];
    self.nameLbl.font = [UIFont systemFontOfSize:15.0];
    self.nameLbl.textColor = [UIColor colorWithWhite:0.114 alpha:1.000];
    
    self.detailLbl = [self getLabel];
    self.detailLbl.font = [UIFont systemFontOfSize:13.0f];
    self.detailLbl.textAlignment = NSTextAlignmentRight;

    
    self.rightImageView = [self getImageView];
    self.rightImageView.image = [UIImage imageNamed:@"arrow-right"];
    
    [self addViewConstraints];
}


- (UIImageView *) getImageView{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];
    return imageView;
}


- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0.627 green:0.631 blue:0.639 alpha:1.000];
    [self.contentView addSubview:label];
    return label;
}


#pragma mark - update frame
- (void) addViewConstraints{
    
    CGFloat space = 10;
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(space);
        //        make.top.mas_equalTo(self.mas_top).offset(8);
        //        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        //        make.width.mas_equalTo(self.mas_height).offset(-16);
        make.width.mas_equalTo(@22);
        make.height.mas_equalTo(@22);
    }];
    
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(space);
        make.width.mas_equalTo(@80);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLbl.mas_right).offset(space);
        make.right.mas_equalTo(self.rightImageView.mas_left).offset(-5);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-space);
        //        make.top.mas_equalTo(self.mas_top).offset(8);
        //        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        //        make.width.mas_equalTo(self.mas_height).offset(-16);
        make.height.mas_equalTo(@13);
        make.width.mas_equalTo(@13);
    }];
}

@end
