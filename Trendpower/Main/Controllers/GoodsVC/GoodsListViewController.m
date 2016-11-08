//
//  GoodsListVC.m
//  Trendpower
//
//  Created by HTC on 16/1/26.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "GoodsListViewController.h"

//model
#import "QPMGoodsModel.h"

//vc
#import "ProductDetailVC.h"
#import "CartViewController.h"
#import "SearchVC.h"
#import "YQNavigationController.h"
#import "GoodsFilterListVC.h"

// view
#import "NaviFooterBar.h"
#import "RightImageButton.h"
#import "GoodsListSortView.h"
#import "JSBadgeView.h"


#define K_LeftWidth      44
#define K_SliderWidth    ([UIScreen mainScreen].bounds.size.width -K_LeftWidth)

#define Screen_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define ColCell_Item_WIDTH             ((Screen_WIDTH - 3*10 )/2)
#define ColCell_Item_HIGHT             (ColCell_Item_WIDTH +40+2+5+25)

#define SelectBar_HIGHT    44
#define SortBar_HIGHT    48


@interface GoodsListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate, EmptyPlaceholderViewDelegate, NaviFooterBarDelegate, GoodsListSortViewDelegate>

/**  collection */
@property(nonatomic, strong) UICollectionView *collectionView;


/**  搜索栏 */
@property (nonatomic, weak) RightImageButton * keyBtn;
@property(nonatomic, weak) UIButton *searchField;

/** 购物车数量标志 */
@property (nonatomic, weak) JSBadgeView * badgeView;

/**  状态栏底色 */
@property(nonatomic, weak) UIView * statusView;
/**  选择栏 */
@property(nonatomic, weak) UIView * selectView;
/**  选择的视图 */
@property(nonatomic, weak) UIScrollView * selectScrollView;
/**  筛选栏 */
@property(nonatomic, weak) GoodsListSortView * sortBarView;

/**  回到顶部按钮 */
@property(nonatomic, weak) UIButton *toTopBtn;

/**  空视图 */
@property (nonatomic, weak) EmptyPlaceholderView *emptyView;

/** 更多下拉视图 */
@property (nonatomic, weak) NaviFooterBar * naviFooterBar;

/**  商品列表模型 */
@property(nonatomic, strong) NSMutableArray * goodsListArray;

/**  存取选择条件的字典数据 */
@property(nonatomic, strong) NSMutableArray * selectDicsArray;

///**  存取选择条件按钮对象 */
//@property(nonatomic, strong) NSMutableArray * selectBtnsArray;

/**  排序参数 */
/** 当前页码 */
@property(nonatomic, copy) NSString *currentPage;
/** 分页数量 1 */
@property(nonatomic, copy) NSString *pageSize;


@end

@implementation GoodsListViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    //self.title=self.categoryName;
    
    [self setEmptyView];
    [self initSelectView];
    [self initSortBar];
    [self initCollectionView];
    [self initTopBtn];
    [self initNaviView];
    [self setTitleSearchBar];
}

- (void)viewWillAppear:(BOOL)animated{
    
    //如果登陆或注销后，刷新数据，显示价格状态
    if ([[UserDefaultsUtils getValueByKey:@"is_change_user_state"] isEqualToString:@"YES"]) {
        [self fetchGoogdsList];
        [UserDefaultsUtils setValue:@"NO" byKey:@"is_change_user_state"];
    }else{
        self.goodsListArray.count ? : [self fetchGoogdsList];
    }
    
    self.isUserLogined?[self fecthCartQuantity]:nil;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resetNaviBar];
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

#pragma mark - Interface

#pragma mark init 点击更多
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

#pragma mark - 点击更多 响应
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

#pragma mark - init
- (void)initNaviView{
    
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(50, 7, K_UIScreen_WIDTH -50 -44*2 -10, 44 -14)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 3;
    searchView.layer.masksToBounds = YES;
    [self.naviBar addSubview:searchView];
    
    RightImageButton * keyBtn = [[RightImageButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [keyBtn setImage:[UIImage imageNamed:@"heise_sanjiao"] forState:UIControlStateNormal];
    [keyBtn setTitleColor:[UIColor colorWithRed:0.131 green:0.129 blue:0.132 alpha:1.000] forState:UIControlStateNormal];
    //    [keyBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 0, 0)];
    [keyBtn addTarget:self action:@selector(clickedSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:keyBtn];
    self.keyBtn = keyBtn;
    
    //搜索栏
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(65, 0, CGRectGetWidth(searchView.frame) -70, 30)];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [searchBtn setTitleColor:[UIColor colorWithWhite:0.710 alpha:1.000] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(clickedSearchBtn:) forControlEvents:UIControlEventTouchDown];
    [searchView addSubview:searchBtn];
    self.searchField = searchBtn;
    

    UIButton * cartBtn = [[UIButton alloc]initWithFrame:CGRectMake(K_UIScreen_WIDTH -44*2, 0, 44, 44)];
    [cartBtn setImage:[UIImage imageNamed:@"shopcart_normal"] forState:UIControlStateNormal];
    [cartBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [cartBtn addTarget:self action:@selector(gotoShopCart:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:cartBtn];
    
    //新标识视图.
    JSBadgeView * jsb = [[JSBadgeView alloc]initWithParentView:cartBtn alignment:JSBadgeViewAlignmentTopRight];
    self.badgeView = jsb;
    //在父控件（parentView）上显示，显示的位置TopRight
    self.badgeView.badgePositionAdjustment = CGPointMake(-10, 10);  //如果显示的位置不对，可以自己调整，超爽啊！
    self.badgeView.badgeBackgroundColor = [UIColor whiteColor];
    self.badgeView.badgeTextColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
    
    UIButton * moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(K_UIScreen_WIDTH -44, 0, 44, 44)];
    [moreBtn setImage:[UIImage imageNamed:@"navi_more"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [moreBtn addTarget:self action:@selector(showMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:moreBtn];
    
    
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 20)];
    statusView.backgroundColor = [K_MAIN_COLOR colorWithAlphaComponent:0.5];
    statusView.hidden = YES;
    [self.view addSubview:statusView];
    self.statusView = statusView;
}

- (void)setTitleSearchBar{
    
    if (self.filterType == GoodsFilterTypeVinCode) {
        [self.keyBtn setTitle:@"VIN" forState:UIControlStateNormal];
        [self.searchField setTitle:@"输入VIN查询" forState:UIControlStateNormal];
    }else{
        [self.keyBtn setTitle:@"关键词" forState:UIControlStateNormal];
        [self.searchField setTitle:@"商品名称、规格型号、分类、品牌、车型" forState:UIControlStateNormal];
    }
}


- (void)clickedSearchBtn:(UIButton *)btn{
    SearchVC *vc = [[SearchVC alloc] init];
    if (self.filterType == GoodsFilterTypeVinCode) {
        vc.currentFilterType = 1;
    }else{
        vc.currentFilterType = 0;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}


- (void)initSelectView{

    UIView * selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, SelectBar_HIGHT)];
    selectView.backgroundColor = K_LINEBG_COLOR;
    self.selectView = selectView;
    [self.view addSubview:selectView];
    
    UILabel * selectLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, SelectBar_HIGHT)];
    selectLbl.text = @"已选：";
    selectLbl.textAlignment = NSTextAlignmentCenter;
    selectLbl.textColor = [UIColor colorWithWhite:0.516 alpha:1.000];
    selectLbl.font = [UIFont systemFontOfSize:13.5];
    [selectView addSubview:selectLbl];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(55, 0, K_UIScreen_WIDTH -55, SelectBar_HIGHT)];
    scrollView.backgroundColor = K_LINEBG_COLOR;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.selectScrollView = scrollView;
    [selectView addSubview:scrollView];
    
    if (!self.isUnShowFilterName) {

        if (self.filterType != GoodsFilterTypeVinCode) {

            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjects:@[@(self.filterType),self.filterName,[self getFilterValueWithType:self.filterType]] forKeys:@[K_Filter_TYPE,K_Filter_NAME,K_Filter_VALVE]];
            [self.selectDicsArray addObject:dic];
            [self initSelectView:self.selectDicsArray];
        }
    }

}

- (NSString *)getFilterValueWithType:(GoodsFilterType)type{
    NSString * typeValue = @"";
    switch (type) {
        case GoodsFilterTypeCategory:// 商品分类
            typeValue = self.cateId;
            break;
        case GoodsFilterTypeBrand: // 商品品牌
            typeValue = self.brandIds;
            break;
        case GoodsFilterTypeCarSeries:// 车型的惟一号
            typeValue = self.carSeriesId;
            break;
        case GoodsFilterTypeVinCode:
            typeValue = self.vinCode;
            break;
        case GoodsFilterTypeGoodsName:// 搜索名字
            typeValue = self.goodsName;
            break;
        case GoodsFilterTypeCarBrand: // 车型的id
            typeValue = self.carBrandId;
            break;
        case GoodsFilterTypeCarModel: // 车型名称 【后面3种没有用到，因为要存储前面的类型】
            typeValue = self.carModel;
            break;
        case GoodsFilterTypeEmssion: // 车排量
            typeValue = self.carEmssion;
            break;
        case GoodsFilterTypeYear:// 车年份
            typeValue = self.carYear;
            break;
        default:
            break;
    }
    return typeValue;
}


- (void)initSelectView:(NSArray *)wordArray{
    // 0.如果没有数组，则隐藏
    if (!wordArray.count) {
        [self sortViewIsShow:NO];
        return;
    }else{
        [self sortViewIsShow:YES];
    }
    
    
    // 1.参数
    CGFloat margin = 10; //按钮间距
    CGFloat speace = 8; //按钮内边距
    CGFloat BtnX = 0;//按钮的X
    CGFloat BtnY = 9.5;
    CGFloat BtnH = SelectBar_HIGHT -BtnY*2;
    CGRect lastFrame = CGRectMake(0, 0, 0, 0);//记录最后一个按钮的frame
    UIFont * filterFont = [UIFont systemFontOfSize:12.5];
    
    // 2.清空
    [self.selectScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 布局
    for (int i =0; i<wordArray.count; i++) {
        // 1.
        NSInteger filterTag = [[wordArray[i] objectForKey:K_Filter_TYPE] integerValue];
        NSString * filterName = [wordArray[i] objectForKey:K_Filter_NAME];
        CGSize specSize = [self sizeWithText:filterName font:filterFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        // 2.
        CGFloat BtnW = 2*speace + specSize.width;//按钮宽
        
        UIButton * filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(BtnX, BtnY, BtnW, BtnH)];
        filterBtn.tag = filterTag;
        filterBtn.titleLabel.font = filterFont;
        [filterBtn setTitle:filterName forState:UIControlStateNormal];
        [filterBtn setTitleColor:K_MAIN_COLOR forState:UIControlStateNormal];
        [filterBtn.layer setBorderColor:K_MAIN_COLOR.CGColor];
        [filterBtn.layer setBorderWidth:1.2];
        [filterBtn.layer setCornerRadius:2];
        [filterBtn.layer setMasksToBounds:YES];
        filterBtn.backgroundColor = [UIColor whiteColor];
        
        // 删除背景
        CGFloat w = 30/2;
        CGFloat h = 24/2;
        UIImageView * delectImage = [[UIImageView alloc]initWithFrame:CGRectMake(filterBtn.frame.size.width -w, BtnH -h, w, h)];
        delectImage.image = [UIImage imageNamed:@"reddelete"];
        //[filterBtn addSubview:delectImage];
        [filterBtn insertSubview:delectImage belowSubview:filterBtn.titleLabel];
        
        [filterBtn addTarget:self action:@selector(clickedFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectScrollView addSubview:filterBtn];
        
        BtnX = BtnX + BtnW +margin;
        lastFrame = filterBtn.frame;//记录最后一个btn的frame
    }

    self.selectScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastFrame) +margin, SelectBar_HIGHT);

}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


- (void)initSortBar{
    
    GoodsListSortView * sortView = [[GoodsListSortView alloc]initWithFrame:CGRectMake(0, 64 +SelectBar_HIGHT, K_UIScreen_WIDTH, SortBar_HIGHT)];
    sortView.delegate = self;
    self.sortBarView = sortView;
    [self.view addSubview:sortView];
}


#pragma mark - initCollectionView
-(void) initCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 +SelectBar_HIGHT +SortBar_HIGHT, self.view.frame.size.width, self.view.frame.size.height- 64 -SortBar_HIGHT -SelectBar_HIGHT) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor= K_GREY_COLOR;
    
    UINib * rownib=[UINib nibWithNibName:@"ProductCollectionCellViewStyleDefault" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:rownib forCellWithReuseIdentifier:@"rowcell"];
    UINib * gridnib=[UINib nibWithNibName:@"ProductCollectionCellViewStyle1" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:gridnib forCellWithReuseIdentifier:@"gridcell"];
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchGoogdsList)];
    [self.collectionView.header setTitle:@"正在刷新，请稍候..." forState:MJRefreshHeaderStateRefreshing];
    self.collectionView.header.updatedTimeHidden = YES;
    
    [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.collectionView.footer setHidden:YES];
}


#pragma mark - 空视图
- (void)setEmptyView{
    if (self.emptyView == nil) {
        EmptyPlaceholderView * emptyView = [[EmptyPlaceholderView alloc]initWithFrame:CGRectMake(0, 64 +SelectBar_HIGHT +SortBar_HIGHT, K_UIScreen_WIDTH, K_UIScreen_HEIGHT) placeholderText:@"抱歉，没有找到符合条件的商品" placeholderIamge:[UIImage imageNamed:@"category_null_bg"] btnName:@"返回"];
        self.emptyView = emptyView;
        emptyView.delegate = self;
        [self.view addSubview:emptyView];
    }
    
    self.emptyView.hidden = YES;
}


#pragma mark - 空点击事件
- (void)EmptyPlaceholderViewClickedButton:(UIButton *)btn{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}


#pragma mark - 回到首部
-(void) initTopBtn{
    //添加回到顶部btn
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(K_UIScreen_WIDTH - 60, K_UIScreen_HEIGHT-120, 40, 40)];
    self.toTopBtn = btn;
    [self.toTopBtn setBackgroundImage:[UIImage imageNamed:@"scrolls_to_top"] forState:UIControlStateNormal];
    
    self.toTopBtn.hidden=YES;
    [self.toTopBtn addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toTopBtn];
    [self.view bringSubviewToFront:self.toTopBtn];
}

-(void) scrollToTop{
    [self resetNaviBar];
    NSIndexPath *bottomIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    [_collectionView scrollToItemAtIndexPath:bottomIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}


#pragma mark - //点击事件【筛选】
-(void)goodsListSortViewClickedFilterBtn:(UIButton *)filterBtn{
    YQNavigationController *vc = [[YQNavigationController alloc] initWithFrame:CGRectMake(K_LeftWidth, 0, K_SliderWidth, K_UIScreen_HEIGHT) rootViewController:nil];
    vc.touchSpaceHide = NO;
    vc.panPopView = YES;

    GoodsFilterListVC *root = [[GoodsFilterListVC alloc] init];
    vc.rootViewController = root;
    vc.rootViewController.navigationBar.barTintColor = K_MAIN_COLOR;
    root.arrayselectDics = self.selectDicsArray;

    typeof(self) weakSelf = self;

    root.clickedConfirmBlock = ^(){

        [weakSelf setFilterValueWithSelectArray:weakSelf.selectDicsArray];
        [weakSelf initSelectView:weakSelf.selectDicsArray];
        [weakSelf fetchGoogdsList];
    };
    [vc show:YES animated:NO];
}

#pragma mark - 点击事件【排序】
- (void)goodsListSortViewClickedSortBtn:(UIButton *)sortBtn{
    [self.collectionView.header beginRefreshing];
}



- (void)setFilterValueWithSelectArray:(NSMutableArray *)selectArray{
    [selectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger type = [[obj objectForKey:K_Filter_TYPE] integerValue];
        switch (type) {
            case GoodsFilterTypeCategory:// 商品分类
                self.cateId = [obj objectForKey:K_Filter_VALVE];
                break;
            case GoodsFilterTypeBrand: // 商品品牌
                self.brandIds =  [obj objectForKey:K_Filter_VALVE];
                break;
            case GoodsFilterTypeCarSeries:// 车型的惟一号
                self.carSeriesId = [obj objectForKey:K_Filter_VALVE];
                break;
            case GoodsFilterTypeVinCode:
                self.vinCode = [obj objectForKey:K_Filter_VALVE];
                break;
            case GoodsFilterTypeGoodsName:// 搜索名字
                self.goodsName = [obj objectForKey:K_Filter_VALVE];
                break;
            case GoodsFilterTypeCarBrand: // 车型的id
                self.carBrandId = [obj objectForKey:K_Filter_VALVE];
                break;
            case GoodsFilterTypeCarModel: // 车型名称 【后面3种没有用到，因为要存储前面的类型】
                self.carModel = [obj objectForKey:K_Filter_VALVE];
                break;
            case GoodsFilterTypeEmssion: // 车排量
                self.carEmssion = [obj objectForKey:K_Filter_VALVE];
                break;
            case GoodsFilterTypeYear:// 车年份
                self.carYear = [obj objectForKey:K_Filter_VALVE];;
                break;
            default:
                break;
        }
    }];
}



#pragma mark - 切换展示的样式
- (void)switchDisplayStyle:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    if(self.cellType==GoodsListCellTypeRow){
        self.cellType=GoodsListCellTypeCol;
    }else{
        self.cellType=GoodsListCellTypeRow;
    }
    [self.collectionView reloadData];
}


#pragma mark //隐藏筛选栏
- (void)sortViewIsShow:(BOOL)isShow{
    if (isShow) {
        [UIView animateWithDuration:0.2 animations:^{
            self.selectView.frame = CGRectMake(0, 64, K_UIScreen_WIDTH, SelectBar_HIGHT);
            self.sortBarView.frame = CGRectMake(0, 64 +SelectBar_HIGHT, K_UIScreen_WIDTH, SortBar_HIGHT);
            self.collectionView.frame = CGRectMake(0, 64 +SelectBar_HIGHT +SortBar_HIGHT, self.view.frame.size.width, self.view.frame.size.height- 64 -SortBar_HIGHT -SelectBar_HIGHT);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.selectView.frame = CGRectMake(0, 64, K_UIScreen_WIDTH, 0);
            self.sortBarView.frame = CGRectMake(0, 64, K_UIScreen_WIDTH, SortBar_HIGHT);
            self.collectionView.frame = CGRectMake(0, 64 +SortBar_HIGHT, self.view.frame.size.width, self.view.frame.size.height- 64 -SortBar_HIGHT);
        }];
    }
}

#pragma mark - 隐藏导航栏
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (velocity.y > 0.5) {
        [self hiddenNaviBar];
    }else if(velocity.y < -0.5){
        [self resetNaviBar];
    }
}

#pragma mark 重置导航栏
- (void)resetNaviBar{
    [UIView animateWithDuration:0.1 animations:^{
//        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        self.collectionView.frame=CGRectMake(0, CGRectGetMaxY(self.sortBarView.frame), self.view.frame.size.width, self.view.frame.size.height- 64 -SortBar_HIGHT + (self.selectView.frame.size.height!=0?(-SelectBar_HIGHT):0));
        self.naviView.alpha=1;
        self.naviView.frame = CGRectMake(0,0, K_UIScreen_WIDTH, 64);
        self.selectView.hidden = NO;
        self.sortBarView.hidden = NO;
        self.statusView.hidden = YES;
    } completion:^(BOOL finished) {  }];
}

#pragma mark 隐藏导航栏
- (void)hiddenNaviBar{
    [UIView animateWithDuration:0.1 animations:^{
//        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        self.collectionView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.naviView.alpha=0;
        self.naviView.frame = CGRectMake(0, -64 -SortBar_HIGHT -SelectBar_HIGHT, K_UIScreen_WIDTH, 64);
        self.selectView.hidden = YES;
        self.sortBarView.hidden = YES;
        self.statusView.hidden = NO;
    } completion:^(BOOL finished) {  }];
}


#pragma mark - 点击条件按钮，删除筛选
- (void)clickedFilterBtn:(UIButton *)filterBtn{

    // 1.找到对应的按钮和数据字典，删除字段和数组
    NSString * filterName = [filterBtn currentTitle];
    
    for(int i = 0; i<self.selectDicsArray.count; i++) {

        NSDictionary * dic = self.selectDicsArray[i];
        
        if ([[dic valueForKey:K_Filter_NAME] isEqualToString:filterName]) {
            NSInteger type = [[dic valueForKey:K_Filter_TYPE] integerValue];
            switch (type) {
                case GoodsFilterTypeCategory:// 商品分类
                    self.cateId = nil;
                    break;
                case GoodsFilterTypeBrand: // 商品品牌
                    self.brandIds = nil;
                    break;
                case GoodsFilterTypeCarSeries:// 车型的惟一号
                    self.carSeriesId = nil;
                    break;
                case GoodsFilterTypeVinCode:
                    self.vinCode = nil;
                    break;
                case GoodsFilterTypeGoodsName:// 搜索名字
                    self.goodsName = nil;
                    break;
                case GoodsFilterTypeCarBrand: // 车型的id
                    self.step = CarTypeFindStepO;
                    self.carBrandId = nil;
                    break;
                case GoodsFilterTypeCarModel: // 车型名称 【后面3种没有用到，因为要存储前面的类型】
                    self.step = CarTypeFindStep1;
                    self.carModel = nil;
                    break;
                case GoodsFilterTypeEmssion: // 车排量
                    self.step = CarTypeFindStep2;
                    self.carEmssion = nil;
                    break;
                case GoodsFilterTypeYear:// 车年份
                    self.step = CarTypeFindStep3;
                    self.carYear = nil;
                    break;
                default:
                    break;
            }
            [self.selectDicsArray removeObject:dic];
            break;
        }
    }
    
    // 2.重新排序
    [self initSelectView:self.selectDicsArray];
    
    // 3.重新搜索
    [self fetchGoogdsList];
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

/**
 *
 车型请求示例：
 http://api.qpfww.com/goods/listgoods?step=1&carBrandId=9 车型品牌
 
 http://api.qpfww.com/goods/listgoods?step=2&carBrandId=9&carModel=3%E7%B3%BB
 
 http://api.qpfww.com/goods/listgoods?step=3&carBrandId=9&carModel=3%E7%B3%BB&emssion=2.5L
 
 http://api.qpfww.com/goods/listgoods?step=4&carBrandId=9&carModel=3%E7%B3%BB&emssion=2.5L&year=2008
 *
 */

/**
 *   
     appToken	是	string	null	登录或者注册成功后的appToken
     params
     cateId	否	Int	Null	分类Id
     pageSize	是	Int	10	分页数量
     brandIds	否	Sting	0	品牌id（多个用,分割）
     currentPageNo	是	Int	1	当前页码
     carSeriesId	否	Int	0	车型id
     goodsName	否	String	Null	商品名称
     userId	否	Int	0	会员id
     step	否	Int	1	车型查找的时候必须存在 1=车型品牌 2=车型 3=排量 4=年份
     carBrandId	否	Int		车型品牌id 如：9
     carModel	否	Sting		车型名称 如：3系
     emssion	否	Sting		排量 如：2.5l
     year	否	Sting		年份 如：2008
 *
 */


#pragma mark - 头部刷新请求
- (void) fetchGoogdsList{
    
    self.currentPage = @"1";
    
    NSString *url=[API_ROOT stringByAppendingString:API_GOODS_LIST];
    url = [url stringByAppendingString:@"pageSize=10&currentPageNo=1"];
    
    if (self.cateId != nil) {
        url = [url stringByAppendingFormat:@"&cateId=%@",self.cateId];
    }
    
    if (self.carSeriesId != nil) {
        url = [url stringByAppendingFormat:@"&carSeriesId=%@",self.carSeriesId];
    }
    
    if (self.vinCode != nil) {
        url = [url stringByAppendingFormat:@"&vin=%@",self.vinCode];
    }
    
    if (self.goodsName != nil) {
        url = [url stringByAppendingFormat:@"&goodsName=%@",self.goodsName];
    }
    
    if (self.brandIds != nil) {
        url = [url stringByAppendingFormat:@"&brandIds=%@",self.brandIds];
    }
    
    if (self.isUserLogined) {
        url = [url stringByAppendingFormat:@"&userId=%@",self.userId];
    }
    
    switch (self.step) {
        case CarTypeFindStep1:{
            url = [url stringByAppendingFormat:@"&step=1&carBrandId=%@",self.carBrandId];
            break;
        }
        case CarTypeFindStep2:{
            url = [url stringByAppendingFormat:@"&step=1&carBrandId=%@&carModel=%@",self.carBrandId,self.carModel];
            break;
        }
        case CarTypeFindStep3:{
            url = [url stringByAppendingFormat:@"&step=1&carBrandId=%@&carModel=%@&emssion=%@",self.carBrandId,self.carModel,self.carEmssion];
            break;
        }
        case CarTypeFindStep4:{
            url = [url stringByAppendingFormat:@"&step=1&carBrandId=%@&carModel=%@&emssion=%@&year=%@",self.carBrandId,self.carModel,self.carEmssion,self.carYear];
            break;
        }
        default:
            break;
    }
    
    
    //中文要编码
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    cateId	否	Int	Null	分类Id
//    pageSize	是	Int	10	分页数量
//    brandIds	否	Sting	0	品牌id（多个用,分割）
//    currentPageNo	是	Int	1	当前页码
//    carSeriesId	否	Int	0	车型id
//    goodsName	否	String	Null	商品名称
//    userId	否	Int	0	会员id
    
    
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    //
    
    [self.NetworkUtil GET:url header:header inView:self.view success:^(id responseObject) {
        //
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            //1.
            [self.goodsListArray removeAllObjects];
            
            //2.解析产品
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];

            NSArray * goodsArray = [dataDic objectForKey:@"list"];

            // 2.1 从首页广告过来，筛选名字从数据中取
            if (self.isUnShowFilterName || self.filterType == GoodsFilterTypeVinCode) {

                self.isUnShowFilterName = NO;

                NSString *modeName = [dataDic objectForKey:@"car_mode_name"];

                NSString * filterName = @"";

                if(self.filterType == GoodsFilterTypeBrand){
                    //brand_name
                    filterName = [dataDic objectForKey:@"brand_name"];
                }else if (self.filterType == GoodsFilterTypeCategory){
                    //cate_name
                    filterName = [dataDic objectForKey:@"cate_name"];
                } else if (self.filterType == GoodsFilterTypeVinCode) {

                    //如果vin码搜索不到数据，或者car_mode_name 为空依然显示搜索的vin码。
                    if (goodsArray.count > 0) {

                        if (modeName && modeName.length > 0) {
                            filterName = modeName;
                        } else {
                            filterName = self.filterName;
                        }
                    }
                }

                 [self.selectDicsArray removeAllObjects];

                 NSString *filterValue = [self getFilterValueWithType:self.filterType];

                 if (filterValue == nil) {
                     //去掉筛选
                     [self initSelectView:nil];

                 } else {

                     NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjects:@[@(self.filterType),filterName,filterValue] forKeys:@[K_Filter_TYPE,K_Filter_NAME,K_Filter_VALVE]];
                     [self.selectDicsArray addObject:dic];

                     [self initSelectView:self.selectDicsArray];
                 }
            }

            // 2.2
            for (NSDictionary *dic in goodsArray){
                QPMGoodsModel *model = [[QPMGoodsModel alloc] initWithAttributes:dic];
                [self.goodsListArray addObject:model];
            }
            
            //3.判断是否还有更多产品
            [self checkNoMoreData:responseObject];
            
            // 4.空数据
            NSInteger count = self.goodsListArray.count;
            if(count==0){
                self.collectionView.hidden = YES;
                //self.sortBar.hidden = YES;
                self.emptyView.hidden = NO;
            }else{
                self.collectionView.hidden = NO;
                //self.sortBar.hidden = NO;
                self.emptyView.hidden = YES;
                self.collectionView.footer.hidden = NO;
            }
            
            // 5.刷新
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.collectionView reloadData];

            });
            
        }else if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] hasPrefix:@"4217"]){
            [self setUserLogout];
        }
        else{
            self.collectionView.hidden = YES;
            //self.sortBar.hidden = NO;
            self.emptyView.hidden = NO;
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
        [self.collectionView.header endRefreshing];

    } failure:^(NSError *error) {
        [self.collectionView.header endRefreshing];

        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}


#pragma mark - 尾部刷新
- (void)loadMoreData{
    
    NSString *url=[API_ROOT stringByAppendingString:API_GOODS_LIST];
    url = [url stringByAppendingFormat:@"pageSize=10&currentPageNo=%d",[self.currentPage intValue] +1];
    
    if (self.cateId != nil) {
        url = [url stringByAppendingFormat:@"&cateId=%@",self.cateId];
    }
    
    if (self.carSeriesId != nil) {
        url = [url stringByAppendingFormat:@"&carSeriesId=%@",self.carSeriesId];
    }
    
    if (self.vinCode != nil) {
        url = [url stringByAppendingFormat:@"&vin=%@",self.vinCode];
    }
    
    if (self.goodsName != nil) {
        url = [url stringByAppendingFormat:@"&goodsName=%@",self.goodsName];
    }
    
    if (self.brandIds != nil) {
        url = [url stringByAppendingFormat:@"&brandIds=%@",self.brandIds];
    }
    
    if (self.isUserLogined) {
        url = [url stringByAppendingFormat:@"&userId=%@",self.userId];
    }
    
    switch (self.step) {
        case CarTypeFindStep1:{
            url = [url stringByAppendingFormat:@"&step=1&carBrandId=%@",self.carBrandId];
            break;
        }
        case CarTypeFindStep2:{
            url = [url stringByAppendingFormat:@"&step=1&carBrandId=%@&carModel=%@",self.carBrandId,self.carModel];
            break;
        }
        case CarTypeFindStep3:{
            url = [url stringByAppendingFormat:@"&step=1&carBrandId=%@&carModel=%@&emssion=%@",self.carBrandId,self.carModel,self.carEmssion];
            break;
        }
        case CarTypeFindStep4:{
            url = [url stringByAppendingFormat:@"&step=1&carBrandId=%@&carModel=%@&emssion=%@&year=%@",self.carBrandId,self.carModel,self.carEmssion,self.carYear];
            break;
        }
        default:
            break;
    }
    
    
    //中文要编码
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //    cateId	否	Int	Null	分类Id
    //    pageSize	是	Int	10	分页数量
    //    brandIds	否	Sting	0	品牌id（多个用,分割）
    //    currentPageNo	是	Int	1	当前页码
    //    carSeriesId	否	Int	0	车型id
    //    goodsName	否	String	Null	商品名称
    //    userId	否	Int	0	会员id
    
    
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    //
    
    [self.NetworkUtil GET:url header:header success:^(id responseObject) {
        //
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            //1.
            self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] +1];
            //2.解析产品
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSArray * goodsArray = [dataDic objectForKey:@"list"];

            for (NSDictionary *dic in goodsArray){
                QPMGoodsModel *model = [[QPMGoodsModel alloc] initWithAttributes:dic];
                [self.goodsListArray addObject:model];
            }
            
            //3.判断是否还有更多产品
//            if (goodsArray.count == 0) {
//                [self.collectionView.footer noticeNoMoreData];
//            }

            
            // 4.刷新
            [self.collectionView reloadData];
            
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
        [self.collectionView.footer endRefreshing];
        //3.判断是否还有更多产品
        [self checkNoMoreData:responseObject];
    } failure:^(NSError *error) {
        [self.collectionView.footer endRefreshing];

        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 排序栏操作判断

#pragma mark - 检查是否还有更多产品，没有就显示到底
- (void) checkNoMoreData:(NSDictionary *)dic{
    NSDictionary * totalDic = [dic objectForKey:@"data"];
    NSInteger page  = [[totalDic objectForKey:@"curren_page"] integerValue];
    NSInteger total = [[totalDic objectForKey:@"total_page"] integerValue];
    if (page == total) {
        [self.collectionView.footer noticeNoMoreData];
    }else{
        [self.collectionView.footer resetNoMoreData];
    }
}


#pragma  mark - Collectionviewdelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsListArray.count;
}


/**
 *  显示回到顶部按钮
 */
- (void)switchToTopBtn:(NSIndexPath*) indexPath{

    self.toTopBtn.hidden = indexPath.row > 8 ? NO : YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self switchToTopBtn:indexPath];
    
    UICollectionViewCell *cell;
    if(self.cellType== GoodsListCellTypeRow){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rowcell" forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gridcell" forIndexPath:indexPath];
    }
    cell.layer.borderColor = [UIColor colorWithWhite:0.802 alpha:1.000].CGColor;
    cell.layer.borderWidth = 0.3;
    
    QPMGoodsModel *goodsModel = [self.goodsListArray objectAtIndex:indexPath.row];
    [(UILabel*)[cell viewWithTag:2] setText:goodsModel.title];
    
    UILabel *priceLabel = [cell viewWithTag:3];
    [priceLabel setTextColor:K_MAIN_COLOR];
    
    NSString *priceText = nil;
    if (self.isUserLogined) { //已登录

        //车型搜索列表增加判断,判断is_sell =0 || goods_price =0 显示暂无库存
        if ([goodsModel.good_price floatValue] == 0 || ([goodsModel.is_sell integerValue] == 0 && goodsModel.is_sell)) {

            priceText = @"暂无库存";
        } else {
            priceText = [NSString stringWithFormat:@"价格：¥%@",goodsModel.good_price];
        }

    } else {
        priceText = @"价格：会员可见";
    }
    priceLabel.text = priceText;
    
    [WebImageUtil setImageWithURL:goodsModel.file_name placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:(UIImageView*)[cell viewWithTag:1]];
    
    //促销标识
    UIButton *sign = [cell viewWithTag:1004];
    if (sign) {
        sign.layer.cornerRadius = 5.0;
        sign.layer.masksToBounds = YES;
    }
    sign.hidden = goodsModel.isActivity ? NO : YES;
    
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insets;
    if(self.cellType==GoodsListCellTypeRow){
        insets=UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        insets=UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return insets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(self.cellType==GoodsListCellTypeRow){
        size=CGSizeMake(Screen_WIDTH, 115);
    }else{
        size=CGSizeMake(ColCell_Item_WIDTH, ColCell_Item_HIGHT);
    }
    return size;
}
//这个是两行之间的间距（上下cell间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat spacing;
    if(self.cellType==GoodsListCellTypeRow){
        spacing=0;
    }else{
        spacing=10;
    }
    return spacing;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    QPMGoodsModel *goodsModel = [self.goodsListArray objectAtIndex:indexPath.row];
    
    ProductDetailVC *productVC=[[ProductDetailVC alloc] init];
    productVC.productId = [NSString stringWithFormat:@"%ld",(long)goodsModel.goodsId];
    productVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productVC animated:YES];
}


#pragma mark - set/get
- (NSMutableArray *)goodsListArray{
    if (_goodsListArray == nil) {
        _goodsListArray = [NSMutableArray array];
    }
    return _goodsListArray;
}

- (NSMutableArray *)selectDicsArray{
    if (_selectDicsArray == nil) {
        _selectDicsArray = [NSMutableArray array];
    }
    return _selectDicsArray;
}

@end

