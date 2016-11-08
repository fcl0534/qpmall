//
//  PaymentAddressView.m
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "PaymentAddressCell.h"

#import "TopImageButton.h"

@interface PaymentAddressCell()

@property (nonatomic, weak) UILabel * naemLabel;
@property (nonatomic, weak) UILabel * phoneLabel;
@property (nonatomic, weak) UILabel * addressLabel;
@property (nonatomic, weak) UILabel * defaultLabel;

@property (nonatomic, weak) UIImageView * leftView;
@property (nonatomic, weak) UIImageView * rightView;

@property (nonatomic, weak) UIImageView * bgView;

@property (nonatomic, weak) TopImageButton * addBtn;

@end


@implementation PaymentAddressCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PaymentAddressCell";
    PaymentAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PaymentAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        
        self.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1.000];
        
        // 0. 白色背影
        UIImageView * bgView = [[UIImageView alloc]init];
        self.bgView = bgView;
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.image = [UIImage imageNamed:@"address_back"];
        bgView.layer.borderColor = [UIColor colorWithWhite:0.830 alpha:1.000].CGColor;
        bgView.layer.borderWidth = 0.5;
        [self.contentView addSubview:bgView];
        bgView.userInteractionEnabled = YES;
        // 0.1 手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedAddressView)];
        [bgView addGestureRecognizer:tap];
        
        // 2.
        UILabel *defaultLabel = [[UILabel alloc]init];
        defaultLabel.text = @"默认";
        defaultLabel.font = [UIFont systemFontOfSize:12.0];
        defaultLabel.textAlignment = NSTextAlignmentCenter;
        defaultLabel.textColor = [UIColor whiteColor];
        defaultLabel.backgroundColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
        defaultLabel.layer.cornerRadius = 4;
        defaultLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:defaultLabel];
        self.defaultLabel = defaultLabel;
        
        // 1.
        self.naemLabel = [self getLabel];
        self.naemLabel.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
        self.naemLabel.font = [UIFont systemFontOfSize:17.0];
        self.phoneLabel = [self getLabel];
        self.phoneLabel.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
        self.phoneLabel.font = [UIFont systemFontOfSize:17.0];
        self.phoneLabel.textAlignment = NSTextAlignmentRight;
        self.addressLabel = [self getLabel];
        self.addressLabel.numberOfLines = 2;
        
        
        // 3.
        UIImageView *leftView = [[UIImageView alloc]init];
        leftView.image = [UIImage imageNamed:@"address_icon"];
        [self.contentView addSubview:leftView];
        self.leftView = leftView;
        
        // 4.
        UIImageView *rightView = [[UIImageView alloc]init];
        rightView.image = [UIImage imageNamed:@"addressView_arrow"];
        [self.contentView addSubview:rightView];
        self.rightView = rightView;
        
        //
        TopImageButton * addBtn = [[TopImageButton alloc]init];
        [addBtn setImage:[UIImage imageNamed:@"address_add"] forState:UIControlStateNormal];
        [addBtn setTitle:@"新增地址" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor colorWithRed:0.545f green:0.545f blue:0.545f alpha:1.00f] forState:UIControlStateNormal];
        [addBtn.titleLabel setFont:[UIFont systemFontOfSize:12.5f]];
        [self.contentView addSubview:addBtn];
        self.addBtn = addBtn;
        addBtn.userInteractionEnabled = NO;
        addBtn.hidden = YES;
        
        
        [self addViewConstraints];
    }
    return self;
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0.396f green:0.408f blue:0.412f alpha:1.00f];
    [self.contentView addSubview:label];
    return label;
}


- (void)setPaymentListModel:(PaymentListModel *)paymentListModel{
    _paymentListModel = paymentListModel;
    
    // 没有地址
    if(paymentListModel.address_id == nil){
        self.leftView.hidden = YES;
        self.rightView.hidden = YES;
        self.defaultLabel.hidden = YES;
        self.addBtn.hidden = NO;
        
    }else{
        
        self.addBtn.hidden = YES;
        self.leftView.hidden = NO;
        self.rightView.hidden = NO;
        
        self.naemLabel.text = [NSString stringWithFormat:@"%@",paymentListModel.address_name];
        self.phoneLabel.text = [NSString stringWithFormat:@"%@",paymentListModel.add_mob_phone];
        self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",paymentListModel.add_area_info,paymentListModel.address];
        if (paymentListModel.add_is_default) {
            self.defaultLabel.hidden = NO;
        }else{
            self.defaultLabel.hidden = YES;
        }
    }
}

#pragma mark - 添加约束
-(void) addViewConstraints{
    float top = 15;
    float spacing = 10;
    
    // 1.
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-12);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@25);
    }];
    
    // 2.
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-8);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo(@10);
    }];
    
    // 3.
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightView.mas_left).offset(-spacing);
        make.top.mas_equalTo(self.mas_top).offset(top);
        make.width.mas_equalTo(@110);
        make.height.mas_equalTo(@30);
    }];
    
    // 4.
    [self.naemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftView.mas_right).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(top);
        make.right.mas_equalTo(self.phoneLabel.mas_left).offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    // 5.
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftView.mas_right).offset(spacing);
        make.right.mas_equalTo(self.rightView.mas_left).offset(-spacing);
        make.top.mas_equalTo(self.naemLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    // 6.
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightView.mas_left).offset(0);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@16);
    }];
    
    // 7.
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    // 8.
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(@64);
        make.height.mas_equalTo(@44);
    }];
    
    
}


#pragma mark - 点击view
- (void)clickedAddressView{
    if([self.delegate respondsToSelector:@selector(paymentAddressViewClicked)])
    {
        [self.delegate paymentAddressViewClicked];
    }
}

@end
