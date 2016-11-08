//
//  MyPointsCell.m
//  Trendpower
//
//  Created by 张帅 on 16/10/24.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "MyPointsCell.h"

#import "MyPointsModel.h"

@interface MyPointsCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *pointLbl;

@end

@implementation MyPointsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPointsModel:(MyPointsModel *)pointsModel {

    self.nameLbl.text = pointsModel.agentCompanyName;

    self.pointLbl.text = [NSString stringWithFormat:@"%ld",pointsModel.balancePoint];
}

@end
