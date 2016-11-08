
//
//  PaymentPayTypeCell.m
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "PaymentPayTypeCell.h"
#import <Masonry.h>

@interface PaymentPayTypeCell()

@property (nonatomic, weak) UIButton * cellBtn;

@end

@implementation PaymentPayTypeCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PaymentPayTypeCell";
    PaymentPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PaymentPayTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

        self.imageLeft = [self getImageView];
        self.imageLeft.image = [UIImage imageNamed:@"payment_alipay"];
        self.imageRight = [self getImageView];
        self.imageRight.image = [UIImage imageNamed:@"payment_unselect"];
        
        self.nameLbl = [self getLabel];
        self.nameLbl.font = [UIFont systemFontOfSize:16.5f];
        self.nameLbl.text = @"支付宝支付";
        
        self.cellBtn = [self getButton];
        self.cellBtn.userInteractionEnabled = NO;
        
        [self addViewConstraints];
    }
    
    return self;
}

- (UIImageView *) getImageView{
    UIImageView * imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:imageView];
    return imageView;
}


- (UIButton *) getButton{
    UIButton * btn = [[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_black"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(clickedCellBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    return btn;
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor =[UIColor colorWithRed:0.259f green:0.259f blue:0.259f alpha:1.00f];
    [self.contentView addSubview:label];
    return label;
}

#pragma mark - setting
//- (void)setTitleText:(NSString *)titleText{
//    _titleText = titleText;
//    self.nameLbl.text = titleText;
//}
//
//
//- (void)setHeaderImage:(UIImage *)headerImage{
//    _headerImage = headerImage;
//    self.imageLeft.image = headerImage;
//}

#pragma mark - update frame

- (void) addViewConstraints{
    
    CGFloat space = 10;
    
    [self.imageLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(space);
        make.width.mas_equalTo(@28);
        make.height.mas_equalTo(@28);
    }];
    
    
    [self.imageRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-space-5);
        make.width.mas_equalTo(@25);
        make.height.mas_equalTo(@25);
    }];
    
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageLeft.mas_right).offset(5);
        make.right.mas_equalTo(self.imageRight.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    
    [self.cellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
}

#pragma - mark 代理
- (void)clickedCellBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(paymentPayTypeCellClickedBtn:withIndexPath:)]){
        [self.delegate paymentPayTypeCellClickedBtn:btn withIndexPath:self.indexPath];
    }
}

@end
