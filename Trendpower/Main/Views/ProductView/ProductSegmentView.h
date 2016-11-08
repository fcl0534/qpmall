//
//  ProductSegmentView.h
//  Trendpower
//
//  Created by trendpower on 15/5/20.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

@protocol ProductSegmentViewDelegate <NSObject>

@optional

- (void) productSegmentViewSelectedSegmentIndex:(NSInteger)index;

@end

@interface ProductSegmentView : UIView

@property (nonatomic, weak) id<ProductSegmentViewDelegate> delegate;

@property (nonatomic, assign) NSInteger segmentsCount;

@end
