//
//  FetchTableViewCell.m
//  Trendpower
//
//  Created by trendpower on 15/9/29.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "FetchTableViewCell.h"
#import <Masonry.h>

@implementation FetchTableViewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FetchTableViewCell";
    FetchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[FetchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    //  1.
    self.nameLabel = [self getLabel];
    self.nameLabel.textColor = [UIColor colorWithRed:0.169f green:0.169f blue:0.169f alpha:1.00f];
    self.nameLabel.font = [UIFont systemFontOfSize:15.5];
    
    self.detailLabel = [self getLabel];
    self.detailLabel.textColor = [UIColor colorWithRed:0.169f green:0.169f blue:0.169f alpha:1.00f];
    self.detailLabel.font = [UIFont systemFontOfSize:13.5];
    
    
    self.logoView = [self getImageView];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.rightImage = [self getImageView];
    self.rightImage.image = [UIImage imageNamed:@"arrow-right"];
    self.rightImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.rightBtn = [self getButton:nil image:[UIImage imageNamed:@"arrow-right"] select:[UIImage imageNamed:@"C_list_arrow_2_2"]];
    self.rightBtn.userInteractionEnabled = NO;
    
    [self addViewConstraints];
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithWhite:0.391 alpha:1.000];
    [self addSubview:label];
    return label;
}

- (UIImageView *) getImageView{
    UIImageView *view = [[UIImageView alloc]init];
    [self addSubview:view];
    return view;
}

- (UIButton *) getButton:(NSString *)title image:(UIImage *)image select:(UIImage *)selectImage{
    UIButton *btn = [[UIButton alloc]init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [btn setTitleColor:[UIColor colorWithRed:0.522f green:0.525f blue:0.537f alpha:1.00f] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectImage forState:UIControlStateSelected];
    [self addSubview:btn];
    return btn;
}



#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 12;
    
    // 3.
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.width.mas_equalTo(self.mas_height);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-spacing);
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoView.mas_right).offset(5);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-50);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-spacing);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoView.mas_right).offset(20);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-50);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    // 1.
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(@16);
        make.height.mas_equalTo(@13);
    }];
    
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(@15);
        make.height.mas_equalTo(@15);
    }];
    
}


@end
