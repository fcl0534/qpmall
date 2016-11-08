//
//  ProductGoodStandardView.h
//  Trendpower
//
//  Created by 张帅 on 16/8/25.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductGoodStandardViewDelegate <NSObject>

/** 点击规格按钮 */
- (void)chooseDifferentStandard:(NSInteger)standardId;

@end

@interface ProductGoodStandardView : UIView

@property (nonatomic, weak) id<ProductGoodStandardViewDelegate> delegate;

@property (nonatomic, strong) NSArray *standardModels;

@end
