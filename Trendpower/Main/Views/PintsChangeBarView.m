//
//  PintsChangeBarView.m
//  Trendpower
//
//  Created by HTC on 16/4/26.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "PintsChangeBarView.h"

#import "TCStepperView.h"

#import "Macro.h"

@interface PintsChangeBarView()

@property (nonatomic, weak) UIButton * shopcartBtn;

@property (nonatomic, weak) UIView * topLine;

@property (nonatomic, weak) UILabel * priceLabel;

/**
 *  数量编辑器
 */
@property (nonatomic, strong) TCStepperView * stepper ;

@end

@implementation PintsChangeBarView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 0.
        self.topLine = [self getLineView];
        
        // 1.
        TCStepperView *stepperView = [[TCStepperView alloc]initWithFrame:CGRectMake(10,4,110,self.frame.size.height -10)];
//        stepperView.setConstantValue = YES;
//        stepperView.delegate = self;
        [self addSubview:stepperView];
        self.stepper = stepperView;

        
        self.priceLabel = [self getLabel];
        self.priceLabel.font = [UIFont systemFontOfSize:15.0f];
        self.priceLabel.textColor = [UIColor colorWithRed:0.937 green:0.261 blue:0.232 alpha:1.000];
        
        // 2.
        self.shopcartBtn = [self getBtnTitile:@"我要兑换" seleteImage:nil normalImage:nil];
        [self.shopcartBtn setBackgroundColor:[UIColor colorWithRed:0.083 green:0.594 blue:1.000 alpha:1.000]];
        [self.shopcartBtn addTarget:self action:@selector(clickedChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addViewConstraints];
    }
    return self;
}


- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithWhite:0.391 alpha:1.000];
    [self addSubview:label];
    return label;
}


- (UIButton *) getBtnTitile:(NSString *)title seleteImage:(UIImage *)seleteImage normalImage:(UIImage *)normalImage {
    UIButton *btn = [[UIButton alloc]init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.50]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:seleteImage forState:UIControlStateSelected];
    [btn setImage:normalImage forState:UIControlStateNormal];
    btn.layer.cornerRadius = 18;
    btn.layer.masksToBounds = YES;
    [self addSubview:btn];
    return btn;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.792 alpha:1.000];
    [self addSubview:line];
    return line;
}

- (void)setPointModel:(PointsGoodsDetailModel *)pointModel{

    _pointModel = pointModel;

    self.stepper.hidden = NO;
    self.priceLabel.hidden = YES;
    //self.stepper.maxValue = [pointModel.data.info.stock integerValue];
    /**
    if (pointModel.data.goods_spec.count == 0) { //没有属性
        self.stepper.hidden = NO;
        self.priceLabel.hidden = YES;
        self.stepper.maxValue = [pointModel.data.info.stock integerValue];
        
    }else{
        self.stepper.hidden = YES;
        self.priceLabel.hidden = NO;
        
        NSString * price =  [NSString stringWithFormat:@"￥%@+%@积分",pointModel.data.info.price,pointModel.data.info.coin];
        self.priceLabel.font = [UIFont systemFontOfSize:13.5];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price attributes:attributes];
        [attributedString addAttribute:NSForegroundColorAttributeName value:K_MAIN_COLOR range:[attributedString.string rangeOfString:pointModel.data.info.price]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19.5] range:[attributedString.string rangeOfString:pointModel.data.info.price]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:K_MAIN_COLOR range:[attributedString.string rangeOfString:pointModel.data.info.coin]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19.5] range:[attributedString.string rangeOfString:pointModel.data.info.coin]];
        self.priceLabel.attributedText = attributedString;
    }
    */
}

#pragma mark - 添加约束
-(void) addViewConstraints{
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(0.8);
    }];
    
    [self.stepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(110);
        make.top.mas_equalTo(self.mas_top).offset(8);
        make.centerX.mas_equalTo(self.mas_centerX).offset(-50);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
    }];
    
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.shopcartBtn.mas_left).offset(-5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-0);
    }];
    
    // 3.
    [self.shopcartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(self.mas_top).offset(8);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
    }];
    
    
}


- (void)clickedChangeBtn:(UIButton *)btn{
    if (self.clickedChangedBlock) {
        self.clickedChangedBlock(self.stepper.currentValue);
    }
}

@end
