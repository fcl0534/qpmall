//
//  ProductPropVC.m
//  Trendpower
//
//  Created by HTC on 15/5/20.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#define K_PropView_Height (K_UIScreen_HEIGHT *3/4)

#import "ProductPropVC.h"
#import "ProductPropView.h"


@interface ProductPropVC ()<ProductPropViewDelegate>

@property (nonatomic, weak) ProductPropView * propView;
@end

@implementation ProductPropVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决不了左滑回去空白的问题
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    [self initBaseView];
}

- (void) initBaseView{
    self.naviView.hidden = YES;
    
    // 1.
    ProductPropView * propView = [[ProductPropView alloc]initWithFrame:CGRectMake(0, K_UIScreen_HEIGHT -K_PropView_Height, K_UIScreen_WIDTH, K_PropView_Height)];
    propView.delegate = self;
    propView.productModel = self.productModel;
    [WebImageUtil setImageWithURL:self.productModel.defaultImageUrl placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:    propView.imageView];
    [self.view addSubview:propView];
    self.propView = propView;
    
    
    // 2.
    UIView * topBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, K_UIScreen_HEIGHT - K_PropView_Height)];
    [self.view addSubview:topBg];
    topBg.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer * closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [topBg addGestureRecognizer:closeTap];
    
}


#pragma mark - 提示错误信息
- (void)productPropViewShowError:(NSString *)error{
   [self.HUDUtil showTextMBHUDWithText:error delay:1 inView:self.view];
}


#pragma mark - 可以加入购物车
- (void)productPropViewClickedShopCartBtn:(UIButton *)btn specId:(NSString *)specId cartCounts:(NSInteger)cartCounts{
    
    if (self.isPaymentType) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:specId,@"sellerId",@(cartCounts),@"quantity", nil];
        [self gotoPayment:dic];
    }else{
        
        btn.enabled = NO;
        
        NSString *cartAddUrl = [API_ROOT stringByAppendingString:API_CART_AddCart];

        NSMutableDictionary * header = [NSMutableDictionary dictionary];
        [header setObject:self.apiKey forKey:@"value"];
        [header setObject:KTP_KEY forKey:@"key"];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:self.userId forKey:@"userId"];
        [parameters setObject:self.productModel.productId forKey:@"goodsId"];
        [parameters setObject:specId forKey:@"sellerId"];
        [parameters setObject:[NSString stringWithFormat:@"%ld",cartCounts?cartCounts:1] forKey:@"quantity"];
        
        
        [self.NetworkUtil POST:cartAddUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
            
            //添加成功
            if ([[responseObject objectForKey:@"status"] intValue] == 1) {
                btn.tag = [[[responseObject objectForKey:@"data"] objectForKey:@"total"] intValue];
                [self addAnimations:btn];
            }else{
                btn.enabled = YES;
                [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
            }
        } failure:^(NSError *error) {
            btn.enabled = YES;
            [self.HUDUtil showNetworkErrorInView:self.view];
        }];
    }
}


#pragma mark - 立即购买
- (void)gotoPayment:(NSDictionary *)dic{
    UIViewController * parent = [self.propView containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalViewWithCompletion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoPaymentType" object:dic userInfo:nil];
        }];
    }
}



#pragma mark - 加入购物车动画
-(void)addAnimations:(UIButton *)btn
{
    CGRect frame = self.propView.imageView.frame;
    UIImageView * image =[[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, K_UIScreen_HEIGHT -K_PropView_Height -20, frame.size.width,frame.size.height)];
    [WebImageUtil setImageWithURL:self.productModel.defaultImageUrl placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:    image];
    [self.view addSubview:image];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 11.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [image.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
    
    
    [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
        image.frame=CGRectMake(K_UIScreen_WIDTH -85, -(K_UIScreen_HEIGHT - CGRectGetHeight(self.view.frame) - 40), 0, 0);
    } completion:^(BOOL finished) {
        UIViewController * parent = [self.propView containingViewController];
        if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
            [parent dismissSemiModalViewWithCompletion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCartSuccess" object:[NSString stringWithFormat:@"%ld",btn.tag] userInfo:nil];
            }];
        }
    }];
    
//
//    [self insertAnimation:^{
//        _cartAnimView.frame=CGRectMake(K_UIScreen_WIDTH-55, -(K_UIScreen_HEIGHT - CGRectGetHeight(self.view.frame) - 40), 0, 0);
//        // _cartAnimView.transform = CGAffineTransformRotate(_cartAnimView.transform, M_PI_2);
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(animFinished)];
//    } withSeconds:1];
}


#pragma mark - 点击关闭按钮
- (void)productPropViewClickedCloseBtn:(UIButton *)btn{
    [self closeView];
}

#pragma mark - 关闭
- (void)closeView{
    //关闭
    UIViewController * parent = [self.propView containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalViewWithCompletion:^{

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
