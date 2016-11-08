//
//  HomeAD5CollectionCell.m
//  Trendpower
//
//  Created by 张帅 on 16/7/20.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "HomeAD5CollectionCell.h"

@implementation HomeAD5CollectionCell

- (void)awakeFromNib {

    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];

    [self imgAddTapGesture];
}

- (void)imgAddTapGesture
{
    for (NSInteger i=0; i<self.imagesArray.count; i++) {
        UIImageView *img = self.imagesArray[i];
        img.userInteractionEnabled = YES;
        img.tag = i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedImageView:)];
        [img addGestureRecognizer:tap];
    }
}

#pragma mark - 点击图片
- (void)clickedImageView:(UITapGestureRecognizer *)tap{
    UIImageView * view = (UIImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(homeAD5CollectionCellClickedImageView:indexPath:)]) {
        [self.delegate homeAD5CollectionCellClickedImageView:view.tag indexPath:self.indexPath];
    }
}

@end
