//
//  BrandFilterCell.m
//  Trendpower
//
//  Created by HTC on 16/3/2.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "BrandFilterCell.h"

#import <Masonry.h>
//

@interface BrandFilterCell()

@property (nonatomic, weak) UIImageView * rightView;

/**
 *  bottomLine
 */
@property (nonatomic, weak) UIView * bottomLine;

@end

@implementation BrandFilterCell


#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BrandFilterCell";
    BrandFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BrandFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    self.iconView = [self getImageView];
    
    // 2.
    self.nameLabel = [self getLabel];
    self.nameLabel.textColor = K_CELL_TEXT_COLOR;
    
    // 3.
    self.rightView = [self getImageView];
    self.rightView.image = [UIImage imageNamed:@"arrow-right"];
    
    // 4.
    self.bottomLine = [self getLineView];
    
    UIButton * btn = [[UIButton alloc]init];
    btn.userInteractionEnabled = NO;
    [btn setImage:[UIImage imageNamed:@"pinpaiselected"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"pinpaiUnselected"] forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    
    self.selectBtn = btn;
    
    [self addViewConstraints];
    
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithWhite:0.391 alpha:1.000];
    [self.contentView addSubview:label];
    return label;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    return line;
}

- (UIImageView *) getImageView{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];
    return imageView;
}

#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 10;
    
    // 1.
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
    

    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@50);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-spacing*2);
        make.height.mas_equalTo(@13);
        make.width.mas_equalTo(@13);
    }];
    
    // 2.
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(2*spacing+3);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.rightView.mas_left).offset(-spacing);
        make.height.mas_equalTo(@30);
    }];
    
    // 4.
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(@1);
    }];
}


@end
