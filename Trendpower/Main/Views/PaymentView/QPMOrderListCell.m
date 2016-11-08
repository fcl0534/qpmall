//
//  QPMOrderListCell.m
//  ZZBMall
//
//  Created by trendpower on 15/8/12.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "QPMOrderListCell.h"
#import "CartGoodsModel.h"
#import "WebImageUtil.h"

@interface QPMOrderListCell()

@property (nonatomic, weak) IBOutlet UIImageView *goodsImageView;
@property (nonatomic, weak) IBOutlet UILabel * goodsNameLbl;
@property (nonatomic, weak) IBOutlet UILabel * priceLbl;
@property (nonatomic, weak) IBOutlet UILabel * numLbl;
/** 促销描述 */
@property (nonatomic, strong) IBOutlet UILabel *promotionTypeLabel;
/** 原价 */
@property (nonatomic, strong) IBOutlet UILabel *originalPriceLabel;

@end

@implementation QPMOrderListCell

- (void)awakeFromNib {

    [super awakeFromNib];

    self.promotionTypeLabel.layer.borderWidth = 0.5;
    self.promotionTypeLabel.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)setGoodsModel:(CartGoodsModel *)goodsModel{
    _goodsModel = goodsModel;
    
    [WebImageUtil setImageWithURL:goodsModel.goodsIamge placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:self.goodsImageView];
    self.goodsNameLbl.text = goodsModel.goodsName;
    
    self.numLbl.text = [NSString stringWithFormat:@"x%@",goodsModel.quantity];
    
    //该商品是否促销活动
    if (goodsModel.isActivity == 1) {
        self.promotionTypeLabel.hidden = NO;
        self.originalPriceLabel.hidden = NO;
        self.promotionTypeLabel.text = [NSString stringWithFormat:@" %@ ", goodsModel.promotionType];
        
        NSString *originString = [NSString stringWithFormat:@"￥ %@", goodsModel.price];
        NSAttributedString *aString = [[NSAttributedString alloc] initWithString:originString attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
        
        self.originalPriceLabel.attributedText = aString;
        self.priceLbl.text = [NSString stringWithFormat:@"￥ %@", goodsModel.promotionPrice];
    } else {
        self.promotionTypeLabel.hidden = YES;
        self.originalPriceLabel.hidden = YES;

        if (goodsModel.point) {
            self.priceLbl.text = [NSString stringWithFormat:@"%ld积分",goodsModel.point];
        } else {
            self.priceLbl.text = [NSString stringWithFormat:@"¥ %@",goodsModel.price];
        }
    }

}

@end
