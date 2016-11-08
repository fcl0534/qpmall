//
//  PointsMallListCollectionCell.m
//  Trendpower
//
//  Created by 张帅 on 16/10/7.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "PointsMallListCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "CoinListModel.h"

@interface PointsMallListCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;

@property (weak, nonatomic) IBOutlet UIImageView *tagImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *marketPriceLbl;

@property (weak, nonatomic) IBOutlet UILabel *pointsLbl;

@property (weak, nonatomic) IBOutlet UILabel *pointsUnitLbl;

@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (weak, nonatomic) IBOutlet UILabel *priceUnitLbl;

@end

@implementation PointsMallListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.goodsImg.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.goodsImg.layer.borderWidth = 0.5;
}

- (void)setModel:(CoinListModel *)model {

    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goodsImage] placeholderImage:nil];
    self.nameLbl.text = model.title;
    self.marketPriceLbl.text = [NSString stringWithFormat:@"市场参考价:%.2f元",model.marketPrice];

    self.pointsLbl.text = [NSString stringWithFormat:@"%ld",(long)model.point];
    self.pointsUnitLbl.text = @"积分";
    self.priceLbl.hidden = YES;
    self.priceUnitLbl.hidden = YES;
}

@end
