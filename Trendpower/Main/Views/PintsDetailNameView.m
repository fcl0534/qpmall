
//
//  PintsDetailNameView.m
//  Trendpower
//
//  Created by HTC on 16/4/27.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "PintsDetailNameView.h"

#import "Macro.h"

@interface PintsDetailNameView()

@property (nonatomic, weak) UIView * lineTopView;
@property (nonatomic, weak) UILabel * productName;
@property (nonatomic, weak) UILabel * priceMember;
@property (nonatomic, weak) UILabel * priceLabel;
@property (nonatomic, weak) UIView * lineView1;

@property (nonatomic, weak) UILabel * stockName;
@property (nonatomic, weak) UILabel * shippingName;

@property (nonatomic, weak) UIView * lineView2;

@end

@implementation PintsDetailNameView
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        // 1.
        self.productName = [self getLabel];
        self.productName.numberOfLines = 2;
        self.productName.textColor = [UIColor colorWithWhite:0.165 alpha:1.000];
        self.productName.font = [UIFont boldSystemFontOfSize:17.5];
        // 2.
        self.priceMember = [self getLabel];
        self.priceMember.textColor = [UIColor colorWithRed:0.975 green:0.528 blue:0.069 alpha:1.000];
        self.priceMember.font = [UIFont systemFontOfSize:18.50];
        self.priceMember.text = @"积分购:";
        
        self.priceLabel = [self getLabel];
        self.priceLabel.font = [UIFont systemFontOfSize:15.0f];
        self.priceLabel.textColor = [UIColor colorWithRed:0.937 green:0.261 blue:0.232 alpha:1.000];
        
        
        // 3.
        
        //line
        self.lineTopView = [self getLineView];
        
        self.lineView1 = [self getLineView];
        
        // 5.
        self.shippingName = [self getLabel];
        // 6.
        self.stockName = [self getLabel];
        
        
        self.lineView2 = [self getBigLineView];
        
        
        [self addViewConstraints1];
    }
    return self;
}


- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0.361f green:0.384f blue:0.424f alpha:1.00f];
    [self addSubview:label];
    return label;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    [self addSubview:line];
    return line;
}


- (UIView *)getBigLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    line.layer.borderColor = [UIColor colorWithWhite:0.827 alpha:1.000].CGColor;
    line.layer.borderWidth = 0.5;
    [self addSubview:line];
    return line;
}


#pragma mark - 赋值
- (void)setPointModel:(PointsGoodsDetailModel *)pointModel{
    
    _pointModel = pointModel;
    
    self.productName.text = pointModel.title;
    
    NSString * price =  [NSString stringWithFormat:@"%ld积分",pointModel.point];
    self.priceLabel.font = [UIFont systemFontOfSize:13.5];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price attributes:attributes];

    //[attributedString addAttribute:NSForegroundColorAttributeName value:K_MAIN_COLOR range:[attributedString.string rangeOfString:pointModel.data.info.price]];
    //[attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19.5] range:[attributedString.string rangeOfString:pointModel.data.info.price]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:K_MAIN_COLOR range:[attributedString.string rangeOfString:[NSString stringWithFormat:@"%ld",pointModel.point]]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19.5] range:[attributedString.string rangeOfString:[NSString stringWithFormat:@"%ld",pointModel.point]]];
    self.priceLabel.attributedText = attributedString;
    
    //self.stockName.text = [NSString stringWithFormat:@"库存：%@",pointModel.data.info.stock];
    //self.shippingName.text = pointModel.data.info.is_free_shipping.integerValue?@"配送方式：包送货":@"配送方式：不包送货";
}

- (NSString *) getString:(NSString *)str1 str2:(NSString *)str2{
    return [NSString stringWithFormat:@"%@%@",str1,str2];
}


- (void) setLbl:(UILabel *)lbl text:(NSString *)titleText boldString:(NSString *)boldText{
    
    if (!titleText.length) {
        return;
    }
    if (!boldText.length) {
        lbl.text = titleText;
        return;
    }
    
    //重点字
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleText attributes:attributes];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.5] range:[attributedString.string rangeOfString:boldText]];
    lbl.attributedText = attributedString;
}



#pragma mark - 添加约束
-(void) addViewConstraints1{
    
    float spacing = 10;
    
    // 1.
    [self.lineTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    // 1.
    [self.productName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.lineTopView.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@45);
    }];
    
    // 2.
    [self.priceMember mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.productName.mas_bottom).offset(spacing);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(@25);
    }];
    
    // 3.
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceMember.mas_right).offset(0);
        make.top.mas_equalTo(self.productName.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@25);
    }];
    
    [self.lineView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.priceMember.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    // 4.
    [self.stockName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(spacing);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(@30);
    }];
    
    // 6.
    [self.shippingName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(@30);
    }];

    
    [self.lineView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.stockName.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
}


@end
