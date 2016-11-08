
//
//  OrderGoodsListView.m
//  Trendpower
//
//  Created by trendpower on 15/5/15.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "OrderGoodsListView.h"

@implementation OrderGoodsListView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        // 1.头像
        UIImageView *imagesView = [[UIImageView alloc] init];
        self.imagesView = imagesView;
        [self addSubview:imagesView];
        
        // 2.产品名称
        UILabel *nameView = [[UILabel alloc] init];
        nameView.font = [UIFont systemFontOfSize:14.0f];
        nameView.textAlignment = NSTextAlignmentLeft;
        nameView.numberOfLines = 2;
        nameView.textColor = [UIColor colorWithWhite:0.406 alpha:1.000];
        [self addSubview:nameView];
        self.nameLabel = nameView;
        
//        // 3.规格
//        UILabel *specView = [[UILabel alloc] init];
//        specView.font = [UIFont systemFontOfSize:11.0f];
//        specView.textAlignment = NSTextAlignmentLeft;
//        specView.textColor = [UIColor colorWithWhite:0.641 alpha:1.000];
//        [self addSubview:specView];
//        self.specLabel = specView;
//
//        // 4.商品原价
//        LineThroughLabel *priceLabel = [[LineThroughLabel alloc]init];
//        priceLabel.lineThroughColor = [UIColor colorWithWhite:0.276 alpha:1.000];
//        priceLabel.lineThroughHeight = 0.5;
//        priceLabel.font = [UIFont systemFontOfSize:14.0f];
//        priceLabel.textAlignment = NSTextAlignmentLeft;
//        priceLabel.textColor = [UIColor colorWithWhite:0.555 alpha:1.000];
//        [self addSubview:priceLabel];
//        self.priceLabel = priceLabel;
        
        // 5.商品会员价
        UILabel *priceMemberLabel = [[UILabel alloc]init];
        priceMemberLabel.font = [UIFont systemFontOfSize:15.5f];
        priceMemberLabel.textAlignment = NSTextAlignmentLeft;
        priceMemberLabel.textColor = [UIColor colorWithRed:0.962 green:0.167 blue:0.069 alpha:1.000];
        [self addSubview:priceMemberLabel];
        self.priceMemberLabel = priceMemberLabel;
        
        // 6.商品数量
        UILabel *subTotalLabel = [[UILabel alloc]init];
        subTotalLabel.font = [UIFont systemFontOfSize:18.0f];
        subTotalLabel.textAlignment = NSTextAlignmentLeft;
        subTotalLabel.textColor = [UIColor colorWithWhite:0.583 alpha:1.000];
        [self addSubview:subTotalLabel];
        self.subTotalLabel = subTotalLabel;
        
//        // 7.小计总价
//        UILabel *priceTotalLabel = [[UILabel alloc] init];
//        priceTotalLabel.font = [UIFont systemFontOfSize:16.0f];
//        priceTotalLabel.textAlignment = NSTextAlignmentLeft;
//        priceTotalLabel.textColor = [UIColor colorWithWhite:0.438 alpha:1.000];
//        [self addSubview:priceTotalLabel];
//        self.priceTotalLabel = priceTotalLabel;
        

        // 8.底部线条
        UIView *lineBottom = [[UIView alloc]init];
        lineBottom.backgroundColor = [UIColor colorWithWhite:0.882 alpha:1.000];
        [self addSubview:lineBottom];
        self.lineBottom = lineBottom;
        
        [self addViewConstraints];
    }
    
    return self;
}



/**
 *  添加约束
 */
-(void) addViewConstraints{
    
    float spacing = 10;
    float imageWH = 80;
    
    // 1.
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.size.mas_equalTo(CGSizeMake(imageWH, imageWH));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    // 2.
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@40);
    }];
//    // 3.
//    [self.specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.imagesView.mas_right).offset(spacing);
//        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(0);
//        make.right.mas_equalTo(self).offset(0);
//        make.height.mas_equalTo(@20);
//    }];
//    
//    // 4.
//    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.imagesView.mas_right).offset(spacing);
//        make.top.mas_equalTo(self.specLabel.mas_bottom).offset(0);
//        make.right.mas_equalTo(self).offset(-50);
//        make.height.mas_equalTo(@20);
//    }];
    
    // 5.
 
    
    // 6.
    [self.subTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imagesView.mas_right).offset(spacing);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(@40);
    }];

    [self.priceMemberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imagesView.mas_right).offset(spacing);
        make.top.mas_equalTo(self.subTotalLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(@20);
    }];
    
    // 7.
//    [self.priceTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.imagesView.mas_right).offset(spacing);
//        make.top.mas_equalTo(self.priceMemberLabel.mas_bottom).offset(5);
//        make.right.mas_equalTo(self).offset(0);
//        make.height.mas_equalTo(@25);
//    }];
    
    // 8.
    [self.lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.priceMemberLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(@(0.3));
    }];
}

@end
