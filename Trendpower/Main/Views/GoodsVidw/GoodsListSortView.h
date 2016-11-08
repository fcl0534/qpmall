//
//  GoodsListSortView.h
//  Trendpower
//
//  Created by HTC on 16/1/27.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GoodsListSortViewDelegate <NSObject>

@optional

- (void) goodsListSortViewClickedSortBtn:(UIButton *)sortBtn;
- (void) goodsListSortViewClickedFilterBtn:(UIButton *)filterBtn;

@end

@interface GoodsListSortView : UIView

@property (nonatomic, weak) id<GoodsListSortViewDelegate> delegate;


@end
