//
//  AddressListTableViewCell.m
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "AddressListTableViewCell.h"
#import <Masonry.h>

@interface AddressListTableViewCell()

/** 收货人 */
@property (nonatomic, weak) UILabel * nameLabel;
/** 手机号 */
@property (nonatomic, weak) UILabel * phoneLabel;
/** 详情地址 */
@property (nonatomic, weak) UILabel * addressLabel;
/** LineView */
@property (nonatomic, weak) UIView * centerLine;

/** 默认地址按钮 */
@property (nonatomic, weak) UIButton * defaultButton;

/** 编辑地址按钮 */
@property (nonatomic, weak) UIButton * editButton;

/** 删除地址按钮 */
@property (nonatomic, weak) UIButton * deleteButton;

/**
 *  bottomLine
 */
@property (nonatomic, weak) UIView * bottomLine;

@end


@implementation AddressListTableViewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AddressListTableViewCell";
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AddressListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    self.nameLabel.textColor = [UIColor colorWithRed:0.169f green:0.169f blue:0.169f alpha:1.00f];
    self.nameLabel.font = [UIFont systemFontOfSize:18.0];
    
    self.phoneLabel = [self getLabel];
    self.phoneLabel.textColor = [UIColor colorWithWhite:0.207 alpha:1.000];
    self.phoneLabel.font = [UIFont systemFontOfSize:17.0];
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    
    self.addressLabel = [self getLabel];
    self.addressLabel.numberOfLines = 2;
    
    self.centerLine = [self getLineView];
    
    
    self.defaultButton = [self getButton:@" 设为默认" image:[UIImage imageNamed:@"flight_butn_check_unselect"] select:[UIImage imageNamed:@"flight_butn_check_select"]];
    [self.defaultButton setTitle:@" 默认地址" forState:UIControlStateSelected];
    [self.defaultButton addTarget:self action:@selector(clickedDefaultBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.editButton = [self getButton:@" 编辑" image:[UIImage imageNamed:@"MyAddressManager_edit"] select:nil];
    [self.editButton addTarget:self action:@selector(clickedEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteButton = [self getButton:@" 删除" image:[UIImage imageNamed:@"MyAddressManager_delete_new"] select:nil];
    [self.deleteButton addTarget:self action:@selector(clickedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomLine = [self getLineView];
    self.bottomLine.backgroundColor = [UIColor colorWithRed:0.933f green:0.941f blue:0.953f alpha:1.00f];
    self.bottomLine.layer.borderColor = [UIColor colorWithRed:0.886f green:0.886f blue:0.894f alpha:1.00f].CGColor;
    self.bottomLine.layer.borderWidth = 0.3;
    
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithWhite:0.391 alpha:1.000];
    [self addSubview:label];
    return label;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    [self addSubview:line];
    return line;
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


- (void) setAddressModel:(AddressModel *)addressModel{
    
    _addressModel = addressModel;
    self.nameLabel.text = addressModel.custommerName;
    self.phoneLabel.text = addressModel.cellPhone;
    self.addressLabel.text = addressModel.fullAddress;
    
    if (addressModel.isDefaultArress) {
        self.defaultButton.selected = YES;
    }else{
        self.defaultButton.selected = NO; //考虑重用，所以要设置
    }
    
    [self addViewConstraints];
}


#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 10;
    
    // 1.
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@20);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@20);
    }];
    
    
    // 2.
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@40);
    }];
    
    [self.centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    // 3.
    [self.defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.centerLine.mas_bottom).offset(0);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@40);
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerLine.mas_bottom).offset(0);
        make.right.mas_equalTo(self.deleteButton.mas_left).offset(-spacing);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@40);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.top.mas_equalTo(self.centerLine.mas_bottom).offset(0);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@40);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.defaultButton.mas_bottom).offset(0);
        make.height.mas_equalTo(@20);
    }];
}

#pragma mark - 按钮点击事件
- (void)clickedDefaultBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(clickedDefaultBtn:addressModel:indexPath:)]) {
        [self.delegate clickedDefaultBtn:btn addressModel:self.addressModel indexPath:self.indexPath];
    }
}

- (void)clickedEditBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(clickedEditBtn:addressModel:indexPath:)]) {
        [self.delegate clickedEditBtn:btn addressModel:self.addressModel indexPath:self.indexPath];
    }
}

- (void)clickedDeleteBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(clickedDeleteBtn:addressModel:indexPath:)]) {
        [self.delegate clickedDeleteBtn:btn addressModel:self.addressModel indexPath:self.indexPath];
    }
}


@end
