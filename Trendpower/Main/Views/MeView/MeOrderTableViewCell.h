//
//  MeOrderTableViewCell.h
//  EcoDuo
//
//  Created by trendpower on 15/11/9.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeOrderButton.h"

#import "JSBadgeView.h"

@protocol MeOrderCellDelegate <NSObject>

@optional
- (void) meOrderCellClickedBtn:(UIButton *)btn withIndexPath:(NSIndexPath *)indexPath;

@end

@interface MeOrderTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MeOrderCellDelegate> delegate;


@property (nonatomic, weak) UIImageView * leftImageView;
@property (nonatomic, weak) UILabel * nameLbl;
@property (nonatomic, weak) UILabel * detailLbl;


@property (nonatomic, weak) JSBadgeView * badegView0;
@property (nonatomic, weak) JSBadgeView * badegView1;
@property (nonatomic, weak) JSBadgeView * badegView2;
@property (nonatomic, weak) JSBadgeView * badegView3;
@property (nonatomic, weak) JSBadgeView * badegView4;



@property (nonatomic, strong) NSIndexPath * indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
