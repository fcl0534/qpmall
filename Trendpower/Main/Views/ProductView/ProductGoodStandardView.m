//
//  ProductGoodStandardView.m
//  Trendpower
//
//  Created by 张帅 on 16/8/25.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "ProductGoodStandardView.h"
#import "ProductStandardMdoel.h"
#import "Masonry.h"

@interface ProductGoodStandardView () {
    UIButton *_tempBtn;
}

@property (nonatomic, strong) UILabel *tipLbl;

@property (nonatomic, strong) UIView *topLine;

@end

@implementation ProductGoodStandardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor groupTableViewBackgroundColor];

        [self addSubview:self.tipLbl];
        [self addSubview:self.topLine];

        [self layoutPageViews];
    }
    return self;
}

#pragma mark - event response
- (void)clickSpecBtn:(UIButton *)button {

    NSInteger btnTag = button.tag - 101;

    if(_tempBtn == button) {
        //选择同一个不做处理
        return;
    } else {
        button.selected = YES;
        button.layer.borderColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000].CGColor;

        _tempBtn.selected = NO;
        _tempBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }

    _tempBtn = button;

    ProductStandardMdoel *model = self.standardModels[btnTag];
    if ([self.delegate respondsToSelector:@selector(chooseDifferentStandard:)]) {
        [self.delegate chooseDifferentStandard:model.standardId];
    }
}

#pragma mark - private method
- (void)layoutPageViews {
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(0.5);
    }];

    [self.tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
    }];
}

#pragma mark - getters and setters
- (void)setStandardModels:(NSArray *)standardModels {

    _standardModels = standardModels;

    //规格
    /**
     *  1.未登录状态下不显示（接口也没有返回）。
     *  2.要判断如果goods_standards个数大于1才显示，如果为1，就隐藏，但默认选中。
     */

    CGFloat cellWidth = self.frame.size.width;
    //距左边距
    CGFloat marginLeft = 100;
    //x偏移量
    CGFloat xOffset = marginLeft;
    //y偏移量
    CGFloat yOffset = 7;
    //下一个x偏移量
    CGFloat xNextOffset = marginLeft;
    //item之间的间隔
    CGFloat spacing = 20;
    //item宽度
    CGFloat itemWidth = (cellWidth-marginLeft-60)/2;//90

    //先移除按钮
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }

    for (NSInteger i = 0; i < standardModels.count; i++) {

        ProductStandardMdoel *model = standardModels[i];

        UIButton *specBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [specBtn setTitle:model.title forState:UIControlStateNormal];
        [specBtn setTitleColor:[UIColor colorWithRed:0.361f green:0.384f blue:0.424f alpha:1.00f] forState:UIControlStateNormal];
        specBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        specBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        specBtn.layer.borderWidth = 1.0;
        specBtn.layer.cornerRadius = 4.0;
        specBtn.tag = 101 + i;

        if (model.isSelected) {
            specBtn.layer.borderColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000].CGColor;
        } else {
            specBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }

        [specBtn addTarget:self action:@selector(clickSpecBtn:) forControlEvents:UIControlEventTouchUpInside];

        //根据item宽度一行排列多少个
        xNextOffset += itemWidth + spacing;

        if (xNextOffset > cellWidth) {

            xOffset = marginLeft;

            xNextOffset = itemWidth + marginLeft + spacing;

            yOffset += 26 + 14;

        } else {

            xOffset = xNextOffset - (itemWidth + spacing);
        }

        specBtn.frame = CGRectMake(xOffset, yOffset, itemWidth, 26);

        [self addSubview:specBtn];

    }

}

- (UILabel *)tipLbl {
    if (!_tipLbl) {
        _tipLbl = [[UILabel alloc] init];
        _tipLbl.text = @"选择规格：";
        _tipLbl.textColor = [UIColor colorWithRed:0.361f green:0.384f blue:0.424f alpha:1.00f];
        _tipLbl.font = [UIFont systemFontOfSize:16.0f];
    }
    return _tipLbl;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    }
    return _topLine;
}

@end
