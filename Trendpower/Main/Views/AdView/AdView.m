//
//  AdView.m
//  EcoDuo
//
//  Created by trendpower on 15/7/3.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "AdView.h"
#import "UIImageView+WebCache.h"

@interface AdView()

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval progress;

@property (nonatomic, weak) UILabel * timeLabel;

@end


@implementation AdView

- (instancetype)initWithFrame:(CGRect)frame adUrl:(NSString *)adUrl adImage:(UIImage *)adImage{
    if([super initWithFrame:frame]){
        
        _adUrl = adUrl;
        _progress = 0;
        _MaxTime = 3;
        _AdTime = 3;
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        [self addSubview:imageView];
        self.adImageView = imageView;
        self.adImageView.image = adImage;
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedADImageView:)];
        [imageView addGestureRecognizer:tap];
        
        
        UILabel * timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:20.0f];
        timeLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.750];
        timeLabel.layer.cornerRadius = 20;
        timeLabel.layer.masksToBounds = YES;
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        self.timeLabel.hidden = YES;
        
        UIButton * btn = [[UIButton alloc]init];
        [btn setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.750]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"跳过" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickedSkipBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.skipBtn = btn;
        
        [btn.layer setCornerRadius:5.0f];
        [btn.layer setMasksToBounds:YES];
        //        [btn.layer setBorderColor:[UIColor whiteColor].CGColor];
        //        [btn.layer setBorderWidth:0.5];
        
        [self addViewConstraints];
        
        [self addViewConstraints];
    }
    return self;

}


-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        
        _progress = 0;
        _MaxTime = 3;
        _AdTime = 3;
        
        UIImageView * imageView = [[UIImageView alloc]init];
        [self addSubview:imageView];
        self.adImageView = imageView;
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedADImageView:)];
        [imageView addGestureRecognizer:tap];
        
        UILabel * timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:20.0f];
        timeLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.750];
        timeLabel.layer.cornerRadius = 16;
        timeLabel.layer.masksToBounds = YES;
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        self.timeLabel.hidden = YES;
        
        
        UIButton * btn = [[UIButton alloc]init];
        [btn setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.750]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"跳过" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickedSkipBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.hidden = YES;
        self.skipBtn = btn;
        
        [btn.layer setCornerRadius:5.0f];
        [btn.layer setMasksToBounds:YES];
//        [btn.layer setBorderColor:[UIColor whiteColor].CGColor];
//        [btn.layer setBorderWidth:0.5];
        
        [self addViewConstraints];
    }
    return self;
}

/**
 *  添加约束
 */
-(void) addViewConstraints{
    //添加地址View约束
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(25);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];
    
    
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-25);
        make.width.equalTo(@80);
        make.height.equalTo(@35);
    }];
    
}

- (void)clickedADImageView:(UIGestureRecognizer *)tapG{
    if([self.delegate respondsToSelector:@selector(AdViewClickedADImageView:)]){
        [self.delegate AdViewClickedADImageView:tapG];
    }
}


- (void)clickedSkipBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(AdViewClickedSkipBtn:)]){
        [self.delegate AdViewClickedSkipBtn:btn];
    }
}


#pragma mark - 广告
- (void)startAnimation{
    [self featchADView];
    [self addTimer:3.0];
}



- (void)endAnimation{
    [self stopLoading];
    
    // 提前告诉，可以提前加载
    if([self.delegate respondsToSelector:@selector(AdViewEndAnimation)]){
        [self.delegate AdViewEndAnimation];
    }
    
    NSTimeInterval growDuration = 0.9;
    self.skipBtn.hidden = YES;
    self.timeLabel.hidden = YES;
    
    [UIView animateWithDuration:growDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(3, 3);
        self.transform = scaleTransform;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if([self.delegate respondsToSelector:@selector(AdViewHidedAnimation)]){
            [self.delegate AdViewHidedAnimation];
        }
    }];
    
//    [UIView animateWithDuration:shrinkDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.75, 0.75);
//        self.transform = scaleTransform;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:growDuration animations:^{
//            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
//            self.transform = scaleTransform;
//            self.alpha = 0;
//        } completion:^(BOOL finished) {
//            [self removeFromSuperview];
//        }];
//    }];
}


- (void)featchADView{
    
    if (self.adUrl == nil) {
        [self endAnimation];
        return;
    }
    

    NSURL * nsurl = [NSURL URLWithString:self.adUrl];
    [self.adImageView sd_setImageWithURL:nsurl placeholderImage:self.adImageView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            if(self.progress < 3.0){
                self.skipBtn.hidden = NO;
                self.timeLabel.hidden = NO;
                [self stopLoading];
                [self addTimer:self.AdTime];
            }
        }else{
            [self endAnimation];
        }
    }];
    
}

#pragma mark- 定时器方法
/**
 *  添加定时器
 */
- (void)addTimer:(float)maxTime
{
    self.MaxTime = maxTime;
    self.progress = 0.0;
    /**
     CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startTimer)];
     displayLink.frameInterval = 2;
     [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
     */
    
    CGFloat step = 1.0;
    if (!self.timer) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:step target:self
                                                    selector:@selector(startTimer)
                                                    userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)startTimer;
{
    if(self.progress < self.MaxTime){
        self.progress += 1.0;
        self.timeLabel.text = [NSString stringWithFormat:@"%d",(int)(self.MaxTime - self.progress)+1];
    }else{
        [self stopLoading];
        [self endAnimation];
    }
}

- (void)stopLoading
{
    [self.timer invalidate];
    self.timer = nil;
}




@end
