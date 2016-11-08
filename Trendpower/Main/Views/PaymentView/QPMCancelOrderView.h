//
//  QPMCancelOrderView.h
//  Trendpower
//
//  Created by 张帅 on 16/7/18.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QPMCancelOrderViewDelegate <NSObject>

- (void)cancel;

- (void)submit:(NSDictionary *)params;

@end

@interface QPMCancelOrderView : UIView

@property (nonatomic, copy) NSArray *reasons;

@property (nonatomic, weak) id<QPMCancelOrderViewDelegate> delegate;

@end
