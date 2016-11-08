//
//  ShowVIN.h
//  Trendpower
//
//  Created by 张帅 on 16/6/27.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowVINDelegate <NSObject>

- (void)changeBtn:(UIButton *)btn allBtn:(NSMutableArray *)btnMArr isSelected:(BOOL)selected;

@end

@interface ShowVIN : UIView

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *characterKeys;

@property (nonatomic, weak) id<ShowVINDelegate> delegate;

@property (nonatomic, strong) NSArray *vinStrs;

@end
