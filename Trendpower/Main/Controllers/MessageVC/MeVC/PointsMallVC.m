
//
//  PointsMallVC.m
//  Trendpower
//
//  Created by HTC on 16/4/24.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "PointsMallVC.h"

#import "CoinListModel.h"

#import "PointsMallListCollectionCell.h"

#import "PointsDetailVC.h"

#define Screen_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define ColCell_Item_WIDTH             ((Screen_WIDTH - 3*10 )/2)
#define ColCell_Item_HIGHT             (ColCell_Item_WIDTH +40+2+5+25)

@interface PointsMallVC()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, EmptyPlaceholderViewDelegate>

/**  collection */
@property(nonatomic,strong) UICollectionView *mainCollection;
/**  商品列表模型 */
@property(nonatomic,strong) NSMutableArray *goodsListArray;

/**  回到顶部按钮 */
@property(nonatomic,strong) UIButton *toTopBtn;
/**  空视图 */
@property (nonatomic, weak) EmptyPlaceholderView *emptyView;


/**  排序参数 */
@property(nonatomic, copy) NSString *currentPage;

@end

@implementation PointsMallVC


#pragma mark - Life cycle   ###
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title= @"积分商城";
    
    //设置右按钮
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21, 21)];
    rightBtn.center = CGPointMake(self.naviRightItem.frame.size.width/2, self.naviRightItem.frame.size.height/2);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-shouyeshouye"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(EmptyPlaceholderViewClickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviRightItem addSubview:rightBtn];

    //初始化排序栏
    [self setEmptyView];
    [self initCollectionView];
    [self initTopBtn];
//    [self initNaviStatusView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self resetNaviBar];
}

#pragma mark - 空视图
- (void)setEmptyView{
    if (self.emptyView == nil) {
        EmptyPlaceholderView * emptyView = [[EmptyPlaceholderView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height) placeholderText:@"暂无商品" placeholderIamge:[UIImage imageNamed:@"shop_car_null_bg"] btnName:@"随便逛逛"];
        self.emptyView = emptyView;
        emptyView.delegate = self;
        [self.view addSubview:emptyView];
    }
    
    self.emptyView.hidden = YES;
}

#pragma mark - 空点击事件
- (void)EmptyPlaceholderViewClickedButton:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_BACK_HOME object:nil];
}

#pragma mark - init

#pragma mark - initCollectionView
-(void) initCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.mainCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height- 64) collectionViewLayout:flowLayout];
    self.mainCollection.backgroundColor= K_GREY_COLOR;
    
    [self.mainCollection registerNib:[UINib nibWithNibName:NSStringFromClass([PointsMallListCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"PointsMallListCollectionCell"];
    
    UINib * gridnib=[UINib nibWithNibName:@"ProductCollectionCellViewStyle1" bundle:[NSBundle mainBundle]];
    [self.mainCollection registerNib:gridnib forCellWithReuseIdentifier:@"gridcell"];
    
    self.mainCollection.delegate=self;
    self.mainCollection.dataSource=self;
    
    [self.view addSubview:self.mainCollection];
    
    [self.mainCollection addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    [self.mainCollection.header setTitle:@"正在刷新，请稍候..." forState:MJRefreshHeaderStateRefreshing];
    self.mainCollection.header.updatedTimeHidden = YES;
    
    [self.mainCollection addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.mainCollection.footer setTitle:@"加载更多，请稍候..." forState:MJRefreshFooterStateRefreshing];
    [self.mainCollection.footer setAppearencePercentTriggerAutoRefresh:0];

    [self refreshView];
}

#pragma mark - 回到首部
-(void) initTopBtn{
    //添加回到顶部btn
    self.toTopBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 60, kScreen_Height-120, 40, 40)];
    [self.toTopBtn setBackgroundImage:[UIImage imageNamed:@"scrolls_to_top"] forState:UIControlStateNormal];
    
    self.toTopBtn.hidden=YES;
    [self.toTopBtn addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toTopBtn];
    [self.view bringSubviewToFront:self.toTopBtn];
}

-(void) scrollToTop{
//    [self resetNaviBar];
    NSIndexPath *bottomIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    [_mainCollection scrollToItemAtIndexPath:bottomIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - 隐藏导航栏
//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    
//    if (velocity.y > 0.5) {
//        [self hiddenNaviBar];
//    }else if(velocity.y < -0.5){
//        [self resetNaviBar];
//    }
//}
//
//
//- (void)initNaviStatusView{
//    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.ScreenWidth, 20)];
//    statusView.backgroundColor = [K_MAIN_COLOR colorWithAlphaComponent:0.7];
//    statusView.hidden = YES;
//    [self.view addSubview:statusView];
//    self.statusView = statusView;
//}
//
//#pragma mark 重置导航栏
//- (void)resetNaviBar{
//    [UIView animateWithDuration:0.3 animations:^{
//        //        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//        self.mainCollection.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height- 64);
//        self.naviView.alpha=1;
//        self.naviView.frame = CGRectMake(0,0, self.ScreenWidth, 64);
//        self.statusView.hidden = YES;
//    } completion:^(BOOL finished) {  }];
//}
//
//#pragma mark 隐藏导航栏
//- (void)hiddenNaviBar{
//    [UIView animateWithDuration:0.3 animations:^{
//        //        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//        self.mainCollection.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        self.naviView.alpha=0;
//        self.naviView.frame = CGRectMake(0, -64, self.ScreenWidth, 64);
//        self.statusView.hidden = NO;
//    } completion:^(BOOL finished) {  }];
//}


#pragma mark - 头部刷新
-(void) refreshView{
    
    self.currentPage=@"1";
    
    [self.mainCollection.footer resetNoMoreData];
    
    NSString *goodsListUrl = [API_ROOT stringByAppendingString:API_USER_Pointstore];
    goodsListUrl = [goodsListUrl stringByAppendingString:[NSString stringWithFormat:@"userId=%@&page=%ld&pageSize=%ld",self.userId,[self.currentPage integerValue],(long)10]];
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    [self.NetworkUtil GET:goodsListUrl header:header success:^(id responseObject) {

        [self.mainCollection.header endRefreshing];
        [self.goodsListArray removeAllObjects];

        if([[responseObject objectForKey:@"status"] intValue] == 1 ){
            // 1.
            NSArray *productArray=[[responseObject objectForKey:@"data"] objectForKey:@"goods"];
            for (NSDictionary *dic in productArray)
            {
                CoinListModel *model = [[CoinListModel alloc] initWithAttributes:dic];
                [self.goodsListArray addObject:model];
            }
            // 2.
            NSInteger count = self.goodsListArray.count;
            if(count==0){
                self.mainCollection.hidden = YES;
                self.emptyView.hidden = NO;
            }else{
                self.mainCollection.hidden = NO;
                self.emptyView.hidden = YES;
            }
            
            [self.mainCollection reloadData];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        [self.mainCollection.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}

#pragma mark - 尾部刷新
- (void)loadMoreData{
    
    NSInteger page = [self.currentPage integerValue] +1;
    
    NSString *goodsListUrl = [API_ROOT stringByAppendingString:API_USER_Pointstore];
    goodsListUrl = [goodsListUrl stringByAppendingString:[NSString stringWithFormat:@"userId=%@&page=%ld&pageSize=%ld",self.userId,page,(long)10]];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    [self.NetworkUtil GET:goodsListUrl header:header success:^(id responseObject) {

        [self.mainCollection.footer endRefreshing];
        
        if([[responseObject objectForKey:@"status"] intValue] == 1 ){
            //1.设置当前页码
            self.currentPage = [NSString stringWithFormat:@"%ld",page];
            
            //2.解析产品
            NSArray *productArray=[[responseObject objectForKey:@"data"] objectForKey:@"goods"];
            for (NSDictionary *dic in productArray){
                CoinListModel *model = [[CoinListModel alloc] initWithAttributes:dic];
                [self.goodsListArray addObject:model];
            }
            
            //3.判断是否还有更多产品
            [self checkNoMoreData:responseObject];

            //4.刷新
            [self.mainCollection reloadData];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
        
    } failure:^(NSError *error) {
        [self.mainCollection.footer endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 检查是否还有更多产品，没有就显示到底
- (void) checkNoMoreData:(NSDictionary *)dic{
    NSDictionary * totalDic = [dic objectForKey:@"data"];

    NSInteger page  = [self.currentPage integerValue]*10;

    NSInteger total = [[totalDic objectForKey:@"goodsTotal"] integerValue];
    if (page >= total) {
        [self.mainCollection.footer noticeNoMoreData];
    }
}

#pragma  mark - Collectionviewdelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = self.goodsListArray.count;
    
    return count;
}

#pragma mark 显示回到顶部按钮
-(void) switchToTopBtn:(NSIndexPath*) indexPath{
    if(indexPath.row>8){
        self.toTopBtn.hidden=NO;
    }else{
        self.toTopBtn.hidden=YES;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    [self switchToTopBtn:indexPath];
    
    CoinListModel *goodsModel = [self.goodsListArray objectAtIndex:indexPath.row];
    PointsMallListCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PointsMallListCollectionCell" forIndexPath:indexPath];
    cell.model = goodsModel;
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Screen_WIDTH, 135);
}
//这个是两行之间的间距（上下cell间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 0;
}

#pragma mark - 点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    CoinListModel *goodsModel = [self.goodsListArray objectAtIndex:indexPath.row];
    PointsDetailVC * vc = [[PointsDetailVC alloc]init];
    vc.agentId = goodsModel.agentId;
    vc.goodsCode = goodsModel.goodsCode;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 跳转到商品详情
- (void) productDetailWithRow:(NSInteger )row{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Interface   ###


#pragma mark - Event response   ###


#pragma mark - Private method   ###


#pragma mark - Delegate   ###


#pragma mark - Getters and Setters   ###
- (NSMutableArray *)goodsListArray{
    if (_goodsListArray == nil) {
        _goodsListArray = [NSMutableArray array];
    }
    return _goodsListArray;
}

#pragma mark - Others   ###


@end
