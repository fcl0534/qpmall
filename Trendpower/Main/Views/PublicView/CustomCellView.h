//
//  CustomCellView.h
//  Trendpower
//
//  Created by trendpower on 15/5/18.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>


@protocol CustomCellViewDelegate <NSObject>

@optional
- (void) customCellViewClicked:(UIButton *)btn;

@end


@interface CustomCellView : UIView

@property (nonatomic, weak) id<CustomCellViewDelegate> delegate;

@property (nonatomic, weak) UILabel * textLabel;

@end
