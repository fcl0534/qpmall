//
//  PaymentCouponCell.m
//  Trendpower
//
//  Created by HTC on 15/5/22.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "PaymentCouponCell.h"
#import <Masonry.h>

@interface PaymentCouponCell()

@property (nonatomic, weak) UILabel * couponLabel;
/** 优惠券名称 */
@property (nonatomic, weak) UILabel * nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel * startLabel;
@property (nonatomic, weak) UILabel * endLabel;

/** 选中的按钮 */
@property (nonatomic, weak) UIButton * selectButton;

/**
 *  bottomLine
 */
@property (nonatomic, weak) UIView * bottomLine;

@end


@implementation PaymentCouponCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PaymentCouponCell";
    PaymentCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PaymentCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    // 2.
    self.couponLabel = [self getLabel];
    self.couponLabel.text = @"红包";
    self.couponLabel.textAlignment = NSTextAlignmentCenter;
    self.couponLabel.textColor = [UIColor whiteColor];
    self.couponLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.361 blue:0.549 alpha:1.000];
    self.couponLabel.font = [UIFont boldSystemFontOfSize:13.0];
    
    self.startLabel = [self getLabel];
    
    self.endLabel = [self getLabel];
    
    // 3.
    self.selectButton = [self getButton:nil image:[UIImage imageNamed:@"flight_butn_check_unselect"] select:[UIImage imageNamed:@"flight_butn_check_select"]];
    
    self.bottomLine = [self getLineView];
    
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

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.845 alpha:1.000];
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


- (void)setIsSelectCoupon:(BOOL)isSelectCoupon{
    if(isSelectCoupon) {
        self.selectButton.selected = YES;
    }else{
        self.selectButton.selected = NO; //考虑重用，所以要设置
    }
}

- (void) setCouponModel:(PaymentCouponModel *)couponModel{
    _couponModel = couponModel;
    
    self.nameLabel.text = couponModel.coupon_name;
    self.startLabel.text = [NSString stringWithFormat:@"使用时间：%@",couponModel.start_time];
    self.endLabel.text = [NSString stringWithFormat:@"有效期至：%@",couponModel.end_time];
}


#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 10;
    
    // 1.
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        //make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.width.mas_equalTo(@30);
        make.height.mas_equalTo(@30);
    }];
    
    // 2.
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButton.mas_right).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@20);
    }];
    
    // 3.
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.couponLabel.mas_right).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@20);
    }];
    
    // 4.
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButton.mas_right).offset(spacing);
        make.top.mas_equalTo(self.couponLabel.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@20);
    }];
    
    // 5.
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButton.mas_right).offset(spacing);
        make.top.mas_equalTo(self.startLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@20);
    }];
    
    // 6.
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
}

@end
