//
//  QPMOrderPromotionPopView.m
//  Trendpower
//
//  Created by hjz on 16/5/18.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "QPMOrderPromotionPopView.h"
#import "QPMGoodsGroupedModel.h"

@interface QPMOrderPromotionPopView ()

@property (weak, nonatomic) IBOutlet UIView *promoInfoView;


@end

@implementation QPMOrderPromotionPopView

- (void)awakeFromNib {
    
    self.promoInfoView.layer.cornerRadius = 5.0;
    self.promoInfoView.layer.masksToBounds = YES;
}

- (IBAction)closeButtonClick:(id)sender {
    [self removeFromSuperview];
}

- (void)setGoodsGroupedModel:(QPMGoodsGroupedModel *)goodsGroupedModel {
    _goodsGroupedModel = goodsGroupedModel;
    
    DLog(@"promotion:%@", goodsGroupedModel.promotions);
    for (int i = 0; i < goodsGroupedModel.promotions.count; i++) {
        NSDictionary *dataDic = goodsGroupedModel.promotions[i];
        NSString *typeString = dataDic[@"promotionType"];
        NSString *titleString = dataDic[@"promotionTitle"];
        if (i == 0) {
            UILabel *typeLabelOne = [self.promoInfoView viewWithTag:1001];
            typeLabelOne.hidden = NO;
            typeLabelOne.text = typeString;
            UILabel *titleLabelOne = [self.promoInfoView viewWithTag:1002];
            titleLabelOne.hidden = NO;
            titleLabelOne.text = titleString;
        } else if(i == 1) {
            UILabel *typeLabelThree = [self.promoInfoView viewWithTag:1003];
            typeLabelThree.hidden = NO;
            typeLabelThree.text = typeString;
            UILabel *titleLabelFour = [self.promoInfoView viewWithTag:1004];
            titleLabelFour.hidden = NO;
            titleLabelFour.text = titleString;
        } else {
            UILabel *typeLabelFive = [self.promoInfoView viewWithTag:1005];
            typeLabelFive.hidden = NO;
            typeLabelFive.text = typeString;
            UILabel *titleLabelSix = [self.promoInfoView viewWithTag:1006];
            titleLabelSix.hidden = NO;
            titleLabelSix.text = titleString;
        }
        
    }
}


@end
