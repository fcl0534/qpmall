//
//  ProductDetailVC.m
//  Trendpower
//
//  Created by HTC on 15/5/9.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

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
#define K_Image_WH    K_UIScreen_WIDTH

#define K_Scroll_Height (K_UIScreen_HEIGHT - 64)

/**
 *  vc
 */
#import "ProductDetailVC.h"
#import "CartViewController.h"
#import "ProductPropVC.h"
#import "IDMPhotoBrowser.h"
#import "SearchVC.h"
#import "QPMOrderConfirmViewController.h"

// 通用车型
#import "CarTypeUsedViewController.h"


/**
 *  view
 */

#import "ProductInfomationView.h"
#import "ProductSpecificationView.h"
#import "ProductShopCarBarView.h"
#import "TipsToScrollingView.h"
#import "BaseWebView.h"
#import "ShopCartBarView.h"
#import "BaseWeb.h"
#import "ProductSegmentView.h"
#import "FocusImageView.h"
#import "JSBadgeView.h"

#import "NaviFooterBar.h"
#import "TipsScrolTopView.h"

/**
 *  model
 */
#import "ProductModel.h"


@interface ProductDetailVC()<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
ProductNameViewDelegate,
ShopCartBarViewDelegate,
ProductSegmentViewDelegate,
FocusImageViewDelegate,
IDMPhotoBrowserDelegate,
NaviFooterBarDelegate>

//商品详情页面
/** 整个滚动视图 */
@property (nonatomic, weak) UIScrollView * scrollView;
/** 产品图片视图 */
@property (nonatomic, weak) UIView * goodsImageView;
/** 产品名称视图 */
@property (nonatomic, weak) ProductInfomationView * productNameView;

/** 提示滚动视图 */
@property (nonatomic, weak) TipsToScrollingView * tipsView;

/** 底部工具栏 */
@property (nonatomic, strong) ShopCartBarView * cartView;

//图片详情页面
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
@property (nonatomic, strong) ProductModel * productModel;

/** 购物车数量标志 */
@property (nonatomic, weak) JSBadgeView * badgeView;

/** 更多下拉视图 */
@property (nonatomic, weak) NaviFooterBar * naviFooterBar;

/** 当前页面标志 */
@property (nonatomic, assign) BOOL isFirstPage;

/** 规格id */
@property (nonatomic, assign) NSInteger goodsStandardId;

@end

@implementation ProductDetailVC

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    
    [self setupNaviBarView];
    [self initBaseView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self fetchGoodsDetail];
    
    if (self.isUserLogined) {
        [self fecthCartQuantity];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddCartSuccess:) name:@"AddCartSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoPaymentType:) name:@"gotoPaymentType" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddCartSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotoPaymentType" object:nil];
}


#pragma mark - 设置导航栏
- (void)setupNaviBarView{
    
    //购物车图标
    UIButton * cartBtn = [[UIButton alloc]initWithFrame:CGRectMake(K_UIScreen_WIDTH -44*2, 0, 44, 44)];
    [cartBtn setImage:[UIImage imageNamed:@"shopcart_normal"] forState:UIControlStateNormal];
    [cartBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [cartBtn addTarget:self action:@selector(gotoShopCart:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:cartBtn];
    
    //购物车数量标志，在父控件（parentView）上显示，显示的位置TopRight
    JSBadgeView * jsb = [[JSBadgeView alloc] initWithParentView:cartBtn alignment:JSBadgeViewAlignmentTopRight];
    self.badgeView = jsb;
    self.badgeView.badgePositionAdjustment = CGPointMake(-10, 10);  //如果显示的位置不对，可以自己调整
    self.badgeView.badgeBackgroundColor = [UIColor whiteColor];
    self.badgeView.badgeTextColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoShopCart:)];
    jsb.userInteractionEnabled = YES;
    [jsb addGestureRecognizer:tap];
    
    //更多 按钮
    UIButton * moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(K_UIScreen_WIDTH -44, 0, 44, 44)];
    [moreBtn setImage:[UIImage imageNamed:@"navi_more"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [moreBtn addTarget:self action:@selector(showMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:moreBtn];
}

#pragma mark - 初始化
- (void)initBaseView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_Scroll_Height)];
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
    
    // 2.产品信息
    ProductInfomationView * nameView = [[ProductInfomationView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), K_UIScreen_WIDTH, 320)];
    [scrollView addSubview:nameView];
    nameView.delegate = self;
    self.productNameView = nameView;
    
    // 保证tips至少在屏底
    CGFloat tipY = K_Scroll_Height - K_Tips_Height;
    tipY = (tipY > CGRectGetMaxY(nameView.frame)) ? tipY : CGRectGetMaxY(nameView.frame);
    
    // 3.拖动提示
    TipsToScrollingView * tipView = [[TipsToScrollingView alloc] initWithFrame:CGRectMake(0, tipY, K_UIScreen_WIDTH, K_Tips_Height)];
    [scrollView addSubview:tipView];
    self.tipsView = tipView;
    
    // 最后大小
    scrollView.contentSize = CGSizeMake(K_UIScreen_WIDTH, CGRectGetMaxY(tipView.frame)+20);
    
    // 第二页面
    UIView * secondView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), K_UIScreen_WIDTH, K_Scroll_Height)];
    secondView.backgroundColor = K_GREY_COLOR;
    [self.view addSubview:secondView];
    self.secondView = secondView;
    
    // 4.分段视图（决定是否显示参数属性）
    ProductSegmentView * segmentControl = [[ProductSegmentView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 44)];
    segmentControl.segmentsCount = 1;
    segmentControl.delegate = self;
    [secondView addSubview:segmentControl];
    self.segmentControl = segmentControl;
    
    // 5.web图文详情视图
    BaseWebView * webWiew = [[BaseWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentControl.frame), K_UIScreen_WIDTH, K_Scroll_Height -K_CartBar_Height -44)];
    webWiew.backgroundColor = K_GREY_COLOR;
    [secondView addSubview:webWiew];
    self.webView = webWiew;
    self.webView.scrollView.delegate = self;
    
    //产品参数列表，默认隐藏先
    UITableView * tableView = [[UITableView alloc]initWithFrame:webWiew.frame style:UITableViewStylePlain];
    tableView.backgroundColor = K_GREY_COLOR;
    tableView.separatorColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [secondView addSubview:tableView];
    tableView.hidden = YES;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    tableView.estimatedRowHeight = 80.f;

    // 回到顶部btn
    UIButton * toTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(K_UIScreen_WIDTH - 60, K_Scroll_Height-120, 40, 40)];
    self.toTopBtn = toTopBtn;
    [self.toTopBtn setBackgroundImage:[UIImage imageNamed:@"scrolls_to_top"] forState:UIControlStateNormal];
    [self.toTopBtn addTarget:self action:@selector(setScrollToTopView) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:self.toTopBtn];
    [secondView bringSubviewToFront:self.toTopBtn];
    
    // 提示下拉回到商品详情 view
    TipsScrolTopView * topTipView = [[TipsScrolTopView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentControl.frame)+10, K_UIScreen_WIDTH, 44)];
    self.toTopTipView = topTipView;
    [secondView addSubview:topTipView];
    [secondView bringSubviewToFront:topTipView];
    
    //底部工具栏
    ShopCartBarView *cartView = [[ShopCartBarView alloc]initWithFrame:CGRectMake(0, K_UIScreen_HEIGHT - K_CartBar_Height, K_UIScreen_WIDTH, K_CartBar_Height)];
    self.cartView = cartView;
    self.cartView.hidden = YES;
    self.cartView.delegate = self;
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


//开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
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


//拖动后开始滑行
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    

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


//滑动到下方内容 点击系统顶部导航 自动定位到顶部时触发
-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{

    
}

//滑动到下方内容 点击系统顶部导航
-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{

    //返回是否 自动定位到顶部
    return YES;
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //DLog(@"---scrollViewDidEndScrollingAnimation+++( %f",scrollView.contentOffset.y);
    // 当触发[_scrollViw setContentOffset:CGPointMake(200, 200) animated:YES];后  触发此事件
    //如果animated:NO的话  不会触发此事件
    //NSLog(@"scrollViewDidEndScrollingAnimation %@",NSStringFromCGPoint(scrollView.contentOffset));
    
}


#pragma mark - 返回到上一页面
- (void)setScrollToTopView{
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.frame = CGRectMake(0, 64, K_UIScreen_WIDTH, K_Scroll_Height);
        self.secondView.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), K_UIScreen_WIDTH, K_Scroll_Height);
    } completion:^(BOOL finished) {
        ;
    }];
}

#pragma mark - 下拉到下一页
- (void)setScrollToPageTwoView{
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.frame = CGRectMake(0, -K_Scroll_Height+64, K_UIScreen_WIDTH, K_Scroll_Height);
        self.secondView.frame = CGRectMake(0, 64, K_UIScreen_WIDTH, K_Scroll_Height);
    } completion:^(BOOL finished) {
        ;
    }];
}


#pragma mark - 获取购物车总数
- (void)fecthCartQuantity{
    
    NSString *url=[API_ROOT stringByAppendingString:API_CART_QUANTiTY];
    url = [url stringByAppendingFormat:@"userId=%@",self.userId];
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    
    [self.NetworkUtil GET:url header:header success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] intValue] == 1){
            
            self.badgeView.badgeText = [[[responseObject objectForKey:@"data"] objectForKey:@"cartCount"] integerValue]?[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"cartCount"]]:@"";
        }else{
            //[self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {
        TPError;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 请求产品详情
- (void)fetchGoodsDetail{
    
    NSString *goodsDetailUrl=[API_ROOT stringByAppendingString:API_GOODS_DETAIL];
    goodsDetailUrl = [goodsDetailUrl stringByAppendingString:[NSString stringWithFormat:@"goods_id=%@",self.productId]];
    if (self.isUserLogined) {
        goodsDetailUrl = [goodsDetailUrl stringByAppendingString:[NSString stringWithFormat:@"&user_id=%@",self.userId]];
    }

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    [self.NetworkUtil GET:goodsDetailUrl header:header inView:self.view success:^(id responseObject) {
        
        if([[responseObject objectForKey:@"status"] intValue] == 1 ){

            self.productModel = [[ProductModel alloc] initWithAttributes:responseObject];

            //有规格时显示的滚动视图大小
            if (self.productModel.goods_stores.count > 1 || self.productModel.goods_standards.count > 1) {

                CGFloat standardViewHeight = 0;

                if (self.productModel.goods_standards.count%2 == 0) {
                    standardViewHeight = (self.productModel.goods_standards.count/2)*40;
                } else {
                    standardViewHeight = (self.productModel.goods_standards.count/2+1)*40;
                }

                //接在商品名称下面
                CGRect nameFrame = CGRectMake(0, CGRectGetMinY(self.productNameView.frame), K_UIScreen_WIDTH, 320 + standardViewHeight);
                self.productNameView.frame = nameFrame;
                
                // 保证tips至少在屏底
                CGFloat tipY = K_Scroll_Height - K_Tips_Height;
                tipY = (tipY > CGRectGetMaxY(self.productNameView.frame)) ? tipY : CGRectGetMaxY(self.productNameView.frame);
                
                // 产品提示
                self.tipsView.frame = CGRectMake(0, tipY, K_UIScreen_WIDTH, K_Tips_Height);
                
                self.scrollView.contentSize = CGSizeMake(K_UIScreen_WIDTH, CGRectGetMaxY(self.tipsView.frame)+10);
            }

            self.productNameView.productModel = self.productModel;
            
            //web 内容
            self.webView.content = self.productModel.detail_images;
            //产品图片
            [self showGoodsImageView];
            //经销商列表
            if (self.productModel.goods_stores.count) {
                // 有参数列表
                [self.tableView reloadData];
                self.segmentControl.segmentsCount = 2;
                
            }else{
                self.segmentControl.userInteractionEnabled = NO;
            }

            if (self.productModel.isCollection) {
                self.cartView.collectionBtn.selected = YES;
            }

            self.cartView.isNoStores = self.productModel.isNoStores;
            self.cartView.hidden = NO;
            
        } else {
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
    return self.productModel.goods_stores.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 48;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"ProductPropCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:self.isUserLogined?UITableViewCellStyleSubtitle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    //cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    ProductSpecificationModel * model = self.productModel.goods_stores[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.276 alpha:1.000];
    cell.textLabel.numberOfLines = 0;

    cell.detailTextLabel.text = self.isUserLogined?[NSString stringWithFormat:@"%@ ￥%@",model.company_name,model.good_price]:@"";
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.555 alpha:1.000];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.numberOfLines = 0;

    return cell;
}


#pragma mark - 到购物车界面
- (void) gotoShopCart:(UIButton *)btn{
    //如果没有登陆，就去登陆
    if (!self.isUserLogined) {
        [self gotoLogin];
        return;
    }
    
    CartViewController *vc = [[CartViewController alloc]init];
    vc.isFromProduct = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 适用车型
- (void)productNameViewClickedCloseBtn:(UIButton *)btn productModel:(ProductModel *)productModel{
    
//    btn.enabled = NO;
    NSString *carUrl=[API_ROOT stringByAppendingString:API_GOODS_CARMODEL];
    carUrl = [carUrl stringByAppendingFormat:@"goodsId=%@",self.productId];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    
    
    [self.NetworkUtil GET:carUrl header:header inView:self.view success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            NSArray * array = [responseObject objectForKey:@"data"];
            __block NSString * contentsStr =@"";
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                contentsStr = [contentsStr stringByAppendingFormat:@"<p>%@</p>",obj];
            }];
            
            if(contentsStr.length){
                [self webViewWithTitle:@"适用车型" content:contentsStr];
            }else{
                CarTypeUsedViewController *vc = [[CarTypeUsedViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }

        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
//        btn.enabled = YES;
    } failure:^(NSError *error) {
//        btn.enabled = YES;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 点击规格
- (void)chooseDifferentSpec:(NSInteger)specId {
    //
    self.goodsStandardId = specId;

    NSString *goodsDetailUrl=[API_ROOT stringByAppendingString:API_GOODS_DETAIL];
    goodsDetailUrl = [goodsDetailUrl stringByAppendingString:[NSString stringWithFormat:@"goods_id=%@&sku=%ld",self.productId,(long)specId]];
    if (self.isUserLogined) {
        goodsDetailUrl = [goodsDetailUrl stringByAppendingString:[NSString stringWithFormat:@"&user_id=%@",self.userId]];
    }

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    [self.NetworkUtil GET:goodsDetailUrl header:header inView:self.view success:^(id responseObject) {

        if([[responseObject objectForKey:@"status"] intValue] == 1 ){

            self.productModel = [[ProductModel alloc] initWithAttributes:responseObject];

            //有规格时显示的滚动视图大小
            if (self.productModel.goods_stores.count > 1) {
                //接在商品名称下面
                CGRect nameFrame = CGRectMake(0, CGRectGetMinY(self.productNameView.frame), K_UIScreen_WIDTH, 320);
                self.productNameView.frame = nameFrame;

                // 保证tips至少在屏底
                CGFloat tipY = K_Scroll_Height - K_Tips_Height;
                tipY = (tipY > CGRectGetMaxY(self.productNameView.frame)) ? tipY : CGRectGetMaxY(self.productNameView.frame);

                // 产品提示
                self.tipsView.frame = CGRectMake(0, tipY, K_UIScreen_WIDTH, K_Tips_Height);

                self.scrollView.contentSize = CGSizeMake(K_UIScreen_WIDTH, CGRectGetMaxY(self.tipsView.frame)+10);
            }

            self.productNameView.productModel = self.productModel;
            
            //web 内容
            self.webView.content = self.productModel.detail_images;
            //产品图片
            [self showGoodsImageView];

            //经销商列表
            if (self.productModel.goods_stores.count) {
                // 有参数列表
                [self.tableView reloadData];
                self.segmentControl.segmentsCount = 2;

            }else{
                self.segmentControl.userInteractionEnabled = NO;
            }

            if (self.productModel.isCollection) {
                self.cartView.collectionBtn.selected = YES;
            }

            self.cartView.isNoStores = self.productModel.isNoStores;
            self.cartView.hidden = NO;

        } else {
            self.cartView.hidden = YES;

            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        self.cartView.hidden = YES;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 跳转到网页
- (void) webViewWithTitle:(NSString *)title content:(NSString *)content{
    
    BaseWeb * web = [[BaseWeb alloc]init];
    web.titleName = title;
    [web displayContent:content];
    [self.navigationController pushViewController:web animated:YES];
}


#pragma mark - 展示更多
- (void) showMoreBtn:(UIButton *)btn{
    
    if(self.naviFooterBar == nil){
        NaviFooterBar * naviFootbar = [[NaviFooterBar alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT)];
        [self.view addSubview:naviFootbar];
        self.naviFooterBar = naviFootbar;
        self.naviFooterBar.delegate = self;
        //[self.view insertSubview:naviFootbar belowSubview:self.goodsImageView];
    
    }
    
    [self.naviFooterBar actionView];
}

#pragma mark - 点击更多
- (void)naviFooterBarClickedBtn:(TopImageButton *)btn index:(NSInteger)index{
    [self.naviFooterBar hiddenNaviFooterBar];
    
    if (index == 0) {
        SearchVC *vc = [[SearchVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_BACK_HOME object:nil];
    }
    
    
}

#pragma mark - 点击立即购物
- (void)shopCartBarViewClickedPromptPaymentCartBtn:(UIButton *)btn{
    //如果没有登陆，就去登陆
    if (!self.isUserLogined) {
        [self gotoLogin];
        return;
    }
    
    
    if (self.productModel.isNoStores) {
        [self.HUDUtil showAlertViewWithTitle:@"温馨提示" mesg:@"对不起，本地区暂时没有经销该商品，我们会尽快开通销售。" cancelTitle:@"确认" confirmTitle:nil tag:1];
        return;
    }
    
    
    if ([self.productModel.good_price floatValue] == 0.00) {
        [self.HUDUtil showAlertViewWithTitle:@"温馨提示" mesg:@"对不起，商品暂时不支持购买" cancelTitle:@"确认" confirmTitle:nil tag:1];
        return;
    }
    
    //如果没有规格
    if (self.productModel.goods_stores.count <= 1) {
//        self.productModel.goods_stores.count == 0
        NSInteger quantity = self.productNameView.stepper.currentValue?self.productNameView.stepper.currentValue:1;
        [self cartOrderDirectbuyWithQuantity:quantity sellerId:self.productModel.seller_id];
    }else{
        ProductPropVC * VC =[[ProductPropVC alloc] init];
        VC.isPaymentType = YES;
        VC.productModel = self.productModel;
        VC.view.backgroundColor=[UIColor clearColor];
        
        [self presentSemiViewController:VC withOptions:@{
                                                         KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                         KNSemiModalOptionKeys.animationDuration : @(0.4),
                                                         KNSemiModalOptionKeys.shadowOpacity     : @(0.5),
                                                         }
                             completion:^{
                                 [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
                             } dismissBlock:^{
                                 [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
                             }];
    }

}


#pragma mark - 点击加入购物车
- (void) shopCartBarViewClickedShopCartBtn:(UIButton *)btn{
    
    //如果没有登陆，就去登陆
    if (!self.isUserLogined) {
        [self gotoLogin];
        return;
    }
    
    
    if (self.productModel.isNoStores) {
        [self.HUDUtil showAlertViewWithTitle:@"温馨提示" mesg:@"对不起，本地区暂时没有经销该商品，我们会尽快开通销售。" cancelTitle:@"确认" confirmTitle:nil tag:1];
        return;
    }
    
    if ([self.productModel.good_price floatValue] == 0.00) {
        [self.HUDUtil showAlertViewWithTitle:@"温馨提示" mesg:@"对不起，商品暂时不支持购买" cancelTitle:@"确认" confirmTitle:nil tag:1];
        return;
    }
    
     //如果没有规格就直接加入购物车
    if (self.productModel.goods_stores.count <= 1) {
        
        [self clickedShopCartBtn:(UIButton *)btn];
    }else{
        ProductPropVC * VC =[[ProductPropVC alloc] init];
        VC.productModel = self.productModel;
        VC.view.backgroundColor=[UIColor clearColor];
        
        [self presentSemiViewController:VC withOptions:@{
                                                         KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                         KNSemiModalOptionKeys.animationDuration : @(0.4),
                                                         KNSemiModalOptionKeys.shadowOpacity     : @(0.5),
                                                         }
                             completion:^{
                                 [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
                             } dismissBlock:^{
                                 [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
                             }];
    }
}


#pragma mark - 没有规格 可以加入购物车
- (void)clickedShopCartBtn:(UIButton *)btn{
    // 1
    btn.enabled = NO;
    
    NSString *cartAddUrl = [API_ROOT stringByAppendingString:API_CART_AddCart];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:self.productModel.productId forKey:@"goodsId"];
    [parameters setObject:self.productModel.seller_id forKey:@"sellerId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)(self.productNameView.stepper.currentValue?self.productNameView.stepper.currentValue:1)] forKey:@"quantity"];
    //规格id
    ProductStandardMdoel *model = self.productModel.goods_standards[0];
    NSInteger standardId = self.goodsStandardId?self.goodsStandardId:model.standardId;
    [parameters setObject:@(standardId) forKey:@"goodsStandardId"];
    
    [self.NetworkUtil POST:cartAddUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        //添加成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            btn.tag = [[[responseObject objectForKey:@"data"] objectForKey:@"total"] intValue];
            [self addAnimationsCartBtn:btn];
        }else{
            btn.enabled = YES;
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
        // self.shopcartArray = [[ShopCartModelArray alloc]initWithAttributes:responseObject];
    } failure:^(NSError *error) {
        btn.enabled = YES;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}

#pragma mark - 加入购物车动画
-(void)addAnimationsCartBtn:(UIButton *)btn
{
    UIImageView * image =[[UIImageView alloc] initWithFrame:CGRectMake(K_CartBar_Height*2,K_UIScreen_HEIGHT -K_CartBar_Height,K_CartBar_Height*1.5,K_CartBar_Height*0.5)];
    image.image = [UIImage imageNamed:@"gouwuche_image"];
    image.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:image];
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
         image.frame = CGRectMake(K_CartBar_Height*3,K_UIScreen_HEIGHT -K_CartBar_Height*2.5,K_CartBar_Height*2,K_CartBar_Height);
    } completion:^(BOOL finished) {
        [self.HUDUtil showTextMBHUDWithText:@"恭喜，加入购物车成功"  delay:1.0 inView:self.view];
        [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
            image.frame=CGRectMake(self.naviRightItem.frame.origin.x -15, self.naviRightItem.frame.origin.y+25, 5, 5);
        } completion:^(BOOL finished) {
            self.badgeView.badgeText = (btn.tag == 0)?nil:[NSString stringWithFormat:@"%ld",(long)btn.tag];
            btn.enabled = YES;
            [image removeFromSuperview];
        }];
    }];

}


#pragma mark - 监听加入购物车成功
- (void)AddCartSuccess:(NSNotification*) notification{
    [self.HUDUtil showTextMBHUDWithText:@"恭喜，添加到购物车成功！" delay:1.2 inView:self.view];
    self.badgeView.badgeText = notification.object;
}


#pragma mark - 监听立即购物
- (void)gotoPaymentType:(NSNotification*) notification{
    NSDictionary * dic = notification.object;
    
    [self cartOrderDirectbuyWithQuantity:[[dic objectForKey:@"quantity"] integerValue] sellerId:[dic objectForKey:@"sellerId"]];
}


#pragma mark - 请求立即支付
- (void)cartOrderDirectbuyWithQuantity:(NSInteger )quantity sellerId:(NSString *)sellerId{
    
    NSString *cartAddUrl = [API_ROOT stringByAppendingString:API_ORDER_DIRECTBUY];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:self.productId forKey:@"goodsId"];
    [parameters setObject:sellerId forKey:@"sellerId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",quantity?quantity:1] forKey:@"quantity"];
    //规格id
    ProductStandardMdoel *model = self.productModel.goods_standards[0];
    NSInteger standardId = self.goodsStandardId?self.goodsStandardId:model.standardId;
    [parameters setObject:@(standardId) forKey:@"goodsStandardId"];
    
    
    [self.NetworkUtil POST:cartAddUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        //添加成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            // 更新选中状态
            PaymentListModel * model = [[PaymentListModel alloc]initWithAttributes:responseObject];
            
            QPMOrderConfirmViewController * vc = [[QPMOrderConfirmViewController alloc]init];
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


#pragma mark - 加入收藏夹
- (void) shopCartBarViewClickedCollectionBtn:(UIButton *)btn{
    // 1.如果没有登陆，就去登陆
    if (!self.isUserLogined) {
        [self gotoLogin];
        return;
    }

    // 2.
    NSString *cartAddUrl = [API_ROOT stringByAppendingString:API_GOODS_COLLECTION];
   
    //ttp://api.qpfww.com/collection?goodsId=22643&userId=18
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:self.productId forKey:@"goodsId"];
    
    btn.enabled = NO;
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    [self.NetworkUtil POST:cartAddUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        btn.enabled = YES;
        /**
         *  {
         data =     {
                         createdAt = 1457958746;
                         goodsId = 53163;
                         isCollection = 1;
                         updatedAt = 1457958746;
                         userId = 17;
         };
         msg = "\U53d6\U6d88\U6536\U85cf";
         status = 1;
         }
         */
        // 添加成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            NSString *tipsMsg;
            if([[[responseObject objectForKey:@"data"] objectForKey:@"isCollection"] boolValue]){
                tipsMsg = @"恭喜，成功添加到收藏夹！";
                btn.selected = YES;
            }else{
                tipsMsg = @"已经取消收藏！";
                btn.selected = NO;
            }
            [self.HUDUtil showTextMBHUDWithText:tipsMsg delay:1 inView:self.view];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1 inView:self.view];
        }
    } failure:^(NSError *error) {
        btn.enabled = YES;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


#pragma mark - 显示商品图片视图
- (void)showGoodsImageView{
    
    //没有图片就返回
    if (self.productModel.goods_images.count ==0) {
        return;
    }
    
    NSMutableArray * array = [NSMutableArray array];
    for(ProductImageModel * model in self.productModel.goods_images){

        //商品详情页面的图片判断默认图"is_default": 1,如果都没有默认用第一张
        if (model.is_default) {

            [array insertObject:model.file_name atIndex:0];
        } else {
            [array addObject:model.file_name];
        }
    }

    for (UIView *view in self.goodsImageView.subviews) {
        if ([view isKindOfClass:[FocusImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    FocusImageView * header = [[FocusImageView alloc]initWithFrame:CGRectMake(0, 0, K_Image_WH, K_Image_WH) forcusImages:array titles:nil];
    header.delegate = self;
    [self.goodsImageView addSubview:header];
}

#pragma mark - 点击图片 FocusImagesDelegate
-(void)focusImageWithtouchImagePage:(NSInteger)page imageurl:(NSString *)url scrollView:(UIScrollView *)scrollview{
    
    // Create an array to store IDMPhoto objects
    NSMutableArray *photos = [NSMutableArray new];
    
    NSMutableArray * arrayURLs = [NSMutableArray array];
    for(ProductImageModel * model in self.productModel.goods_images){
        [arrayURLs addObject:[NSURL URLWithString:model.file_name]];
    }
    
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
    DLog(@"Did show photoBrowser with photo index: %ld, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser willDismissAtPageIndex:(NSUInteger)pageIndex
{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    DLog(@"Will dismiss photoBrowser with photo index: %ld, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)pageIndex
{
    id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
    DLog(@"Did dismiss photoBrowser with photo index: %ld, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex
{
    id <IDMPhoto> photo = [photoBrowser photoAtIndex:photoIndex];
    DLog(@"Did dismiss actionSheet with photo index: %ld, photo caption: %@", photoIndex, photo.caption);
    
}



@end
