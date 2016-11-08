//
//  MeHeaderButton.h
//  EcoDuo
//
//  Created by trendpower on 15/11/10.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeHeaderButton : UIButton

@property (nonatomic, copy) NSString * topText;
@property (nonatomic, copy) NSString * bottomText;

@property (nonatomic, weak) UILabel * topLabel;
@property (nonatomic, weak) UILabel * bottomLabel;


@end
