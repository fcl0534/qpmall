//
//  IndexSubViewCell.h
//  EcoDuo
//
//  Created by HTC on 15/3/8.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexSubViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *promotionImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end
