


//
//  NewVersionView.m
//  Trendpower
//
//  Created by HTC on 16/3/25.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "NewVersionView.h"


#define showImageCount 3

@interface NewVersionView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation NewVersionView


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];

        // 1.添加UISrollView
        [self setupScrollView];

        // 2.添加pageControl
        [self setupPageControl];
    }
    return self;
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = showImageCount;
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = self.frame.size.height - 20;
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor =[UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.000 alpha:0.174];
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.bounds;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;

    for (int index = 0; index< showImageCount; index++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;

        // 设置图片
        NSString *name = nil;

        /**
        switch ([self getPhoneModel]) {
            case 0:
                name = [NSString stringWithFormat:@"newVersionImage4_%d", index];
                break;
            case 1:
                name = [NSString stringWithFormat:@"newVersionImage5_%d", index];
                break;
            case 2:
                name = [NSString stringWithFormat:@"newVersionImage6_%d", index];
                break;
            case 3:
                name = [NSString stringWithFormat:@"newVersionImage6p_%d", index];
                break;
            default:
                name = [NSString stringWithFormat:@"newVersionImage5_%d", index];
                break;
        }
         */

        name = [NSString stringWithFormat:@"newVersion%d",index];
        
        imageView.image = [UIImage imageNamed:name];
        
        // 设置frame
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [scrollView addSubview:imageView];
        
        // 在最后一个图片上面添加按钮
        if (index == showImageCount - 1)
        {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * showImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
}

#pragma mark - 获得手机型号
- (int)getPhoneModel{
    int phoneModel = 0;
    int height = (int)[UIScreen mainScreen].bounds.size.height;
    switch (height) {
        case 480:
            phoneModel = 0;
            break;
        case 568:
            phoneModel = 1;
            break;
        case 667:
            phoneModel = 2;
            break;
        case 736:
            phoneModel = 3;
            break;
        default:
            break;
    }
    
    return phoneModel;
}

/**
 *  添加内容到最后一个图片
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 0.让imageView能跟用户交互
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    
    [startButton setBackgroundColor:[UIColor colorWithRed:0.953 green:0.427 blue:0.035 alpha:1.000]];
    
    startButton.layer.cornerRadius = 10;
    startButton.layer.masksToBounds = YES;
    startButton.layer.borderWidth = 2.5;
    startButton.layer.borderColor = [UIColor colorWithRed:0.969 green:0.565 blue:0.031 alpha:1.000].CGColor;
    
    // 2.设置frame
    startButton.frame = CGRectMake(self.frame.size.width/4, self.frame.size.height - 30 - 10 - 48, self.frame.size.width/2, 48);
    
    // 3.设置文字
    [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
    
    
}


/**
 *  只要UIScrollView滚动了,就会调用
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
}

/**
 *  进入登陆界面
 */
- (void)start
{
//    // 显示状态栏
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if (self.clickedStartBtn) {
        self.clickedStartBtn();
    }
}

@end
