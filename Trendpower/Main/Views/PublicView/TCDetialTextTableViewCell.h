//
//  TCDetialTextTableViewCell.h
//  ZZBMall
//
//  Created by trendpower on 15/12/2.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCDetialTextTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * detailText;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
