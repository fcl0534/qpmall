
//
//  MeHeaderButton.m
//  EcoDuo
//
//  Created by trendpower on 15/11/10.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import "MeHeaderButton.h"

#import <masonry.h>

@interface MeHeaderButton()

@end


@implementation MeHeaderButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    // 1.
    self.titleLabel.hidden = YES;
    self.imageView.hidden = YES;
    
    // 2.
    UILabel * topLabel = [[UILabel alloc]init];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor whiteColor];
    [self addSubview:topLabel];
    self.topLabel = topLabel;
    
    // 3.
    UILabel * botLabel = [[UILabel alloc]init];
    botLabel.textAlignment = NSTextAlignmentCenter;
    botLabel.font = [UIFont systemFontOfSize:14.0f];
    botLabel.textColor = [UIColor blackColor];
    [self addSubview:botLabel];
    self.bottomLabel = botLabel;
    
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //    CGFloat W = rect.size.width;
    //    CGFloat H = rect.size.height;
    //    self.topLabel.frame = CGRectMake(0, 0, W, H/2);
    //    self.botLabel.frame = CGRectMake(0, H/2, W, H/2);
    
    [self addViewConstraints];
    
}



- (void)addViewConstraints{
    
    [self.topLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@(self.frame.size.height/2 -12));
    }];
    
    [self.bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@(self.frame.size.height/2 -12));
    }];
}

- (void)setTopText:(NSString *)topText{
    _topText = topText;
    self.topLabel.text = topText;
}


- (void)setBottomText:(NSString *)bottomText{
    _bottomText = bottomText;
    self.bottomLabel.text = bottomText;
}

@end
