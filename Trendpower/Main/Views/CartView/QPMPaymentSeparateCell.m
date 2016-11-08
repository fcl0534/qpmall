//
//  QPMPaymentSeparateCell.m
//  Trendpower
//
//  Created by 张帅 on 16/11/7.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "QPMPaymentSeparateCell.h"

#import "QPMPaymentSeparateModel.h"

@interface QPMPaymentSeparateCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *numLbl;

@property (weak, nonatomic) IBOutlet UILabel *amountLbl;

@property (weak, nonatomic) IBOutlet UIButton *settlementBtn;

@end

@implementation QPMPaymentSeparateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.settlementBtn.layer.borderColor = UIColorFromRGB(0xfd5536).CGColor;
    self.settlementBtn.layer.borderWidth = 0.5;
    self.settlementBtn.layer.masksToBounds = YES;
    self.settlementBtn.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - event response
- (IBAction)settlementBtnAction:(id)sender {

    if ([self.delegate respondsToSelector:@selector(toSettleAccounts:)]) {
        [self.delegate toSettleAccounts:self.model.sellerId];
    }
}

#pragma mark - setter
- (void)setModel:(QPMPaymentSeparateModel *)model {

    _model = model;

    self.nameLbl.text = model.companyName;

    self.numLbl.text = [NSString stringWithFormat:@"共%ld件,合计:",model.total_quantity];

    self.amountLbl.text = [NSString stringWithFormat:@"￥%.2f",model.total_amount];
}

@end
