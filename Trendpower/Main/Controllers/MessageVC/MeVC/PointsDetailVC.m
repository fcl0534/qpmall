//
//  PointsDetailVC.m
//  Trendpower
//
//  Created by 张帅 on 16/10/9.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "PointsDetailVC.h"

//购物车高度
#define K_CartBar_Height 50

#define K_NameView_Height 60

#define K_CELL_MARGIN 20

/** 临界值 */
#define K_Critical_Calue (64+64)

#define K_Tips_Height 44

#define K_Segment_Height 44

/**
 *  商品图片宽高
 */
#define K_Image_WH    kScreen_Width

#define K_Scroll_Height (kScreen_Height - 64)

/**
 *  vc
 */
#import "UIViewController+KNSemiModal.h"
#import "IDMPhotoBrowser.h"
#import "PointsPaymentVC.h"

/**
 *  view
 */

#import "PintsDetailNameView.h"
#import "PintsChangeBarView.h"
#import "TipsToScrollingView.h"
#import "BaseWebView.h"
#import "ShopCartBarView.h"
#import "BaseWeb.h"
#import "ProductSegmentView.h"
#import "FocusImageView.h"
#import "JSBadgeView.h"

#import "TipsScrolTopView.h"

/**
 *  model
 */
//#import "PaymentModel.h"
//#import "ProductModel.h"// 积分不使用

#import "PointsDetailModel.h"
#import "PointsGoodsDetailModel.h"
#import "MyPointsModel.h"

@interface PointsDetailVC()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ProductSegmentViewDelegate, FocusImageViewDelegate, IDMPhotoBrowserDelegate>



// 1.第一页面
/** 整个滚动视图 */
@property (nonatomic, weak) UIScrollView * scrollView;
/** 产品图片视图 */
@property (nonatomic, weak) UIView * goodsImageView;
/** 产品名称视图 */
@property (nonatomic, weak) PintsDetailNameView * productNameView;

/** 提示滚动视图 */
@property (nonatomic, weak) TipsToScrollingView * tipsView;

/** 购物车视图 */
@property (nonatomic, weak) PintsChangeBarView * cartView;

// 2.第二页面
/** 整个视图 */
@property (nonatomic, weak) UIView * secondView;
/** 分段视图（决定是否显示参数属性） */
@property (nonatomic, weak) ProductSegmentView * segmentControl;
/** 图文详情视图 */
@property (nonatomic, weak) BaseWebView * webView;
/** 产品参数视图 */
@property (nonatomic, weak) UITableView * tableView;
/** 回到首页按钮 */
@property (nonatomic, weak) UIButton * toTopBtn;
/** 回到首页tips */
@property (nonatomic, weak) TipsScrolTopView * toTopTipView;


/** 产品数据模型 */
@property (nonatomic, strong) PointsDetailModel * pointModel;

@property (nonatomic, strong) PointsGoodsDetailModel *detailModel;

@property (nonatomic, strong) MyPointsModel *myPointModel;

/** 购物车数量标志 */
@property (nonatomic, weak) JSBadgeView * badgeView;


/** 当前页面标志 */
@property (nonatomic, assign) BOOL isFirstPage;
@end

@implementation PointsDetailVC

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initBaseView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self fetchDate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectSpecSuccess:) name:@"AddCartSuccess" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCartTips:) name:@"addCartTips" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddCartSuccess" object:nil];
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addCartTips" object:nil];
}


#pragma mark - initView
#pragma mark init导航栏
- (void)initView{
    self.title = @"商品详情";
    //设置右按钮
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21, 21)];
    rightBtn.center = CGPointMake(self.naviRightItem.frame.size.width/2, self.naviRightItem.frame.size.height/2);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-shouyeshouye"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickedHomeButton:) forControlEvents:UIControlEventTouchUpInside];
    //[self.naviRightItem addSubview:rightBtn];

}


#pragma mark - 点击事件
- (void)clickedHomeButton:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_BACK_HOME object:nil];
}

#pragma mark - 初始化
- (void)initBaseView{

    self.automaticallyAdjustsScrollViewInsets = NO;

    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, K_Scroll_Height)];
    [self.view addSubview:scrollView];
    [self.view sendSubviewToBack:scrollView];
    self.scrollView = scrollView;

    scrollView.pagingEnabled = NO;
    scrollView.decelerationRate = 0.0001;
    scrollView.alwaysBounceVertical = YES;
    scrollView.scrollEnabled = YES;
    scrollView.backgroundColor = K_GREY_COLOR;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;

    // 1.图片
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, K_Image_WH, K_Image_WH)];
    imageView.image = [UIImage imageNamed:@"placeholderImage"];
    UIView * goodsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_Image_WH, K_Image_WH)];
    [goodsView addSubview:imageView];
    [scrollView addSubview:goodsView];
    self.goodsImageView = goodsView;

    // 2.产品名称
    PintsDetailNameView * nameView = [[PintsDetailNameView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), kScreen_Width, 156)];
    [scrollView addSubview:nameView];
    self.productNameView = nameView;


    // 保证tips至少在屏底
    CGFloat tipY = K_Scroll_Height - K_Tips_Height;
    tipY = (tipY > CGRectGetMaxY(nameView.frame)) ? tipY : CGRectGetMaxY(nameView.frame);

    // 3.产品提示
    TipsToScrollingView * tipView = [[TipsToScrollingView alloc]initWithFrame:CGRectMake(0, tipY, kScreen_Width, K_Tips_Height)];
    [scrollView addSubview:tipView];
    self.tipsView = tipView;

    // 最后大小
    scrollView.contentSize = CGSizeMake(kScreen_Width, CGRectGetMaxY(tipView.frame)+10);

    // 第二页面
    UIView * twoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), kScreen_Width, K_Scroll_Height)];
    twoView.backgroundColor = K_GREY_COLOR;
    [self.view addSubview:twoView];
    self.secondView = twoView;

    // 4.分段视图（决定是否显示参数属性）
    ProductSegmentView * segmentControl = [[ProductSegmentView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    segmentControl.segmentsCount = 1;
    segmentControl.delegate = self;
    [twoView addSubview:segmentControl];
    self.segmentControl = segmentControl;

    // 5.web图文详情视图
    BaseWebView * webWiew = [[BaseWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentControl.frame), kScreen_Width, K_Scroll_Height -K_CartBar_Height -44)];
    webWiew.backgroundColor = K_GREY_COLOR;
    [twoView addSubview:webWiew];
    self.webView = webWiew;
    self.webView.scrollView.delegate = self;

    // 6.参数列表
    UITableView * tableView = [[UITableView alloc]initWithFrame:webWiew.frame style:UITableViewStylePlain];
    tableView.backgroundColor = K_GREY_COLOR;
    tableView.separatorColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [twoView addSubview:tableView];
    tableView.hidden = YES;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    // 8.添加回到顶部btn
    UIButton * topBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 60, K_Scroll_Height-120, 40, 40)];
    self.toTopBtn = topBtn;
    [self.toTopBtn setBackgroundImage:[UIImage imageNamed:@"scrolls_to_top"] forState:UIControlStateNormal];
    [self.toTopBtn addTarget:self action:@selector(setScrollToTopView) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:self.toTopBtn];
    [twoView bringSubviewToFront:self.toTopBtn];

    // 9.top
    TipsScrolTopView * topTipView = [[TipsScrolTopView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentControl.frame)+10, kScreen_Width, 44)];
    self.toTopTipView = topTipView;
    [twoView addSubview:topTipView];
    [twoView bringSubviewToFront:topTipView];


    // 7.
    PintsChangeBarView *cartView = [[PintsChangeBarView alloc]initWithFrame:CGRectMake(0, kScreen_Height - K_CartBar_Height, kScreen_Width, K_CartBar_Height)];
    self.cartView = cartView;
    self.cartView.hidden = YES;
    //    self.cartView.delegate = self;
    __weak typeof(self) weakSelf = self;
    self.cartView.clickedChangedBlock = ^(NSInteger counts){
#pragma mark - 点击兑换

        if (counts *weakSelf.detailModel.point > weakSelf.myPointModel.balancePoint) {
            [weakSelf.HUDUtil showTextJGHUDWithText:[NSString stringWithFormat:@"亲，您的积分不够兑换%ld件宝贝哦",counts]  delay:1.5 inView:weakSelf.view];
        }else{
            [weakSelf pyamentGoods:counts spec_id:nil];
        }

        if (weakSelf.pointModel.data.goods_spec.count == 0) { //没有属性

        }else{
            /**
            PointsPopVC * VC =[[PointsPopVC alloc] init];
            VC.productModel = self.pointModel;
            VC.view.backgroundColor=[UIColor clearColor];

            [weakSelf presentSemiViewController:VC withOptions:@{
                                                                 KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                                 KNSemiModalOptionKeys.animationDuration : @(0.4),
                                                                 KNSemiModalOptionKeys.shadowOpacity     : @(0.5),
                                                                 }
                                     completion:^{
                                         [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
                                     } dismissBlock:^{
                                         [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
                                     }];
             */
        }

    };
    [self.view addSubview:cartView];

}


#pragma mark - 详情页面 手势

//正在拖拽
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offsetY = scrollView.contentOffset.y;
    if(self.scrollView == scrollView){
        if (offsetY > (self.scrollView.contentSize.height - K_Scroll_Height +200)) {
            [self setScrollToPageTwoView];
        }
    }else{
        self.toTopTipView.offsetY = -offsetY;
    }
}

//拖拽结束
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    float offsetY = scrollView.contentOffset.y;
    if(self.scrollView == scrollView){
        if (offsetY > (self.scrollView.contentSize.height - K_Scroll_Height +50)) {
            [self setScrollToPageTwoView];
        }
    }else{
        //self.toTopTipView.offsetY = -offsetY;
        if (-offsetY > 64) {
            [self setScrollToTopView];
        }
    }
}

//拖动后滑行结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    float offsetY = scrollView.contentOffset.y;
    if(self.scrollView == scrollView){
        if (offsetY > (self.scrollView.contentSize.height - K_Scroll_Height +50)) {
            [self setScrollToPageTwoView];
        }
    }else{
        self.toTopTipView.offsetY = -offsetY;
    }
}

//滑动到下方内容 点击系统顶部导航
-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{

    //返回是否 自动定位到顶部
    return YES;
}

#pragma mark - 返回到上一页面
- (void)setScrollToTopView{
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.frame = CGRectMake(0, 64, kScreen_Width, K_Scroll_Height);
        self.secondView.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), kScreen_Width, K_Scroll_Height);
    } completion:^(BOOL finished) {
        ;
    }];
}

#pragma mark - 下拉到下一页
- (void)setScrollToPageTwoView{
    if (self.detailModel.content.length) {
        [UIView animateWithDuration:0.4 animations:^{
            self.scrollView.frame = CGRectMake(0, -K_Scroll_Height+64, kScreen_Width, K_Scroll_Height);
            self.secondView.frame = CGRectMake(0, 64, kScreen_Width, K_Scroll_Height);
        } completion:^(BOOL finished) {
            ;
        }];
    }
}

#pragma mark - 请求产品详情
- (void)fetchDate{

    NSString *goodsDetailUrl=[API_ROOT stringByAppendingString:API_USER_Pointgoods];
    goodsDetailUrl = [goodsDetailUrl stringByAppendingString:[NSString stringWithFormat:@"userId=%@&agentId=%@&goodsCode=%@",[UserDefaultsUtils getUserId],self.agentId,self.goodsCode]];

    [self.NetworkUtil GET:goodsDetailUrl inView:self.view success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] intValue] == 1 ){

            self.detailModel = [[PointsGoodsDetailModel alloc] initWithAttributes:[[responseObject objectForKey:@"data"] objectForKey:@"goods"]];

            self.myPointModel = [[MyPointsModel alloc] initWithAttributes:[[responseObject objectForKey:@"data"] objectForKey:@"point"]];

            if (self.detailModel.content.length == 0) {
                //暂无商品详情
                [self.tipsView.tipsBtn setTitle:@"暂无商品图片详情" forState:UIControlStateNormal];

                CGRect frame = self.tipsView.frame;
                // 最后大小
                self.scrollView.contentSize = CGSizeMake(kScreen_Width, CGRectGetMaxY(frame)+60);
            }

            self.productNameView.pointModel = self.detailModel;

            // 3.
            self.webView.content = self.detailModel.content;

            // 4.
            [self showGoodsImageView];

            // 8.
            self.cartView.pointModel = self.detailModel;
            self.cartView.hidden = NO;

        }else{
            self.cartView.hidden = YES;
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        self.cartView.hidden = YES;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}



#pragma mark - 切换详情界面
- (void)productSegmentViewSelectedSegmentIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            self.webView.hidden = NO;
            self.tableView.hidden = YES;
            break;
        case 1:
            self.webView.hidden = YES;
            self.tableView.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;//self.productModel.dataPropArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"ProductPropCell";

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }

    //cell
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryNone;
//
//    ProductPropModel * model = self.productModel.dataPropArray[indexPath.row];
//    cell.textLabel.text = model.proName;
//    cell.textLabel.textColor = [UIColor colorWithWhite:0.276 alpha:1.000];
//    cell.detailTextLabel.text = model.value;
//    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.555 alpha:1.000];

    return cell;
}


#pragma mark - 监听加入购物车成功
- (void)selectSpecSuccess:(NSNotification*) notification{
    NSDictionary * dic = notification.object;

    [self pyamentGoods:[[dic objectForKey:@"quantity"] integerValue] spec_id:[dic objectForKey:@"spec_id"]];
}


#pragma mark - 下订单
- (void)pyamentGoods:(NSInteger)counts spec_id:(NSString *)spec_id{

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:@(self.detailModel.goodsId) forKey:@"goodsId"];
    [parameters setObject:self.detailModel.agentId forKey:@"sellerId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",counts?counts:1] forKey:@"quantity"];
    
    NSString *orderIndexUrl=[API_ROOT stringByAppendingString:API_POINTORDER_Directbuy];

    [self.NetworkUtil POST:orderIndexUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {

        //添加成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            // 更新选中状态
            PaymentListModel * model = [[PaymentListModel alloc]initWithAttributes:responseObject];

            PointsPaymentVC * vc = [[PointsPaymentVC alloc]init];
            vc.isDirectBuy = YES;
            vc.payModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        TPError;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 显示商品图片视图
- (void)showGoodsImageView{

    //没有图片就返回
    if (!self.detailModel.goodsImage || self.detailModel.goodsImage.length == 0) {
        return;
    }
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:self.detailModel.goodsImage];
    
    FocusImageView * header = [[FocusImageView alloc]initWithFrame:CGRectMake(0, 0, K_Image_WH, K_Image_WH) forcusImages:array titles:nil];
    header.delegate = self;
    [self.goodsImageView addSubview:header];
}

#pragma mark - 点击图片 FocusImagesDelegate
-(void)focusImageWithtouchImagePage:(NSInteger)page imageurl:(NSString *)url scrollView:(UIScrollView *)scrollview{

    // Create an array to store IDMPhoto objects
    NSMutableArray *photos = [NSMutableArray new];

    NSMutableArray * arrayURLs = [NSMutableArray array];

    [arrayURLs addObject:[NSURL URLWithString:self.detailModel.goodsImage]];

    NSArray *photosWithURL = [IDMPhoto photosWithURLs:arrayURLs];

    photos = [NSMutableArray arrayWithArray:photosWithURL];

    // Create and setup browser
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    browser.delegate = self;
    browser.displayCounterLabel = YES;
    browser.displayActionButton = NO;
    browser.displayArrowButton = NO;
    browser.displayDoneButton = NO;

    [browser setInitialPageIndex:page];

    //
    [[UIApplication sharedApplication]setStatusBarHidden:YES];

    // Show
    [self presentViewController:browser animated:NO completion:nil];

}

#pragma mark - IDMPhotoBrowser Delegate

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)pageIndex
{
    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser willDismissAtPageIndex:(NSUInteger)pageIndex
{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];

    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)pageIndex
{
    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex
{
    id <IDMPhoto> photo = [photoBrowser photoAtIndex:photoIndex];
}

@end
