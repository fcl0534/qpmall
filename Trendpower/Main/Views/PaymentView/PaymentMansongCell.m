//
//  PaymentMansongCell.m
//  ZZBMall
//
//  Created by trendpower on 15/11/27.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import "PaymentMansongCell.h"

//view
#import <Masonry.h>
#import "CartGoodsModel.h"


@interface PaymentMansongCell()

@property (nonatomic, weak) UILabel * leftLbl;
@property (nonatomic, weak) UILabel * rightLbl;

@end


@implementation PaymentMansongCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PaymentMansongCell";
    PaymentMansongCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PaymentMansongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.leftLbl = [self getLabel];
        self.leftLbl.font =  [UIFont boldSystemFontOfSize:14.5f];
        
        self.rightLbl = [self getLabel];
        self.rightLbl.textAlignment = NSTextAlignmentRight;
        self.rightLbl.textColor = [UIColor colorWithRed:1.000 green:0.361 blue:0.549 alpha:1.000];
        
        [self addViewConstraints];
    }
    
    return self;
}



- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor =[UIColor colorWithWhite:0.378 alpha:1.000];
    [self.contentView addSubview:label];
    return label;
}


- (void)setGoodsModel:(CartGoodsModel *)goodsModel{
    _goodsModel = goodsModel;
    
   
    
}

- (void) addViewConstraints{
    
    // 1.
    [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.width.mas_equalTo(80);
    }];
    
    [self.rightLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.leftLbl.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
}

@end
