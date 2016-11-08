//
//  CropOverlay.m
//  Trendpower
//
//  Created by 张帅 on 16/6/25.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "CropOverlay.h"
#import "Utility.h"

@implementation CropOverlay

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        UIView *containerView = [[[UINib nibWithNibName:@"CropOverlay" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    return self;
}

@end
