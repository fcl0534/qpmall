//
//  FavoriteVC.m
//  Trendpower
//
//  Created by trendpower on 15/5/14.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#define Screen_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define ColCell_Item_WIDTH             ((Screen_WIDTH - 3*10 )/2)
#define ColCell_Item_HIGHT             (ColCell_Item_WIDTH +40+2+5+25)

#import "FavoriteVC.h"
#import "CollectionModel.h"

#import "ProductDetailVC.h"

@interface FavoriteVC()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, EmptyTipsViewDelegate, HUDAlertViewDelegate>

/**  collection */
@property(nonatomic,strong) UICollectionView *mainCollection;
/**  商品列表模型 */
@property(nonatomic,strong) NSMutableArray *goodsListArray;

/**  回到顶部按钮 */
@property(nonatomic,strong) UIButton *toTopBtn;

/**  空视图 */
@property (nonatomic, weak) EmptyTipsView *emptyView;

/**  排序参数 */
/** 当前页码 */
@property(nonatomic, copy) NSString *currentPage;
/** 分页数量 1 */
@property(nonatomic, copy) NSString *pageSize;

@end

@implementation FavoriteVC

#pragma mark -
- (NSMutableArray *)goodsListArray{
    if (_goodsListArray == nil) {
        _goodsListArray = [NSMutableArray array];
    }
    return _goodsListArray;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title= @"我的收藏";

    //空视图
    [self setEmptyView];
    [self initCollectionView];
    [self initTopBtn];
    
    //设置右按钮
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightBtn.center = CGPointMake(self.naviRightItem.frame.size.width/2, self.naviRightItem.frame.size.height/2);
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    [rightBtn setImage:[UIImage imageNamed:@"navi_listview_normal"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"navi_gridview_normal"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(switchDisplayStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviRightItem addSubview:rightBtn];
    
    self.displayType = DisplayTypeCol;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // [self resetNaviBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self refreshView];
}

#pragma mark - 空视图
- (void)setEmptyView{
    if (self.emptyView == nil) {
        EmptyTipsView * emptyView = [[EmptyTipsView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) tipsIamge:[UIImage imageNamed:@"favorite_null_bg"]  tipsTitle:@"暂无收藏商品" tipsDetail:nil btnName:@"随便逛逛"];
        self.emptyView = emptyView;
        emptyView.delegate = self;
        [self.view addSubview:emptyView];
    }
}


#pragma mark - 空点击事件
- (void)EmptyTipsViewClickedButton:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_BACK_HOME object:nil];
}



#pragma mark - init

#pragma mark - initCollectionView
-(void) initCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.mainCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height- 76) collectionViewLayout:flowLayout];
    self.mainCollection.backgroundColor= K_GREY_COLOR;
    
    UINib * rownib=[UINib nibWithNibName:@"ProductCollectionCellViewStyleDefault" bundle:[NSBundle mainBundle]];
    [self.mainCollection registerNib:rownib forCellWithReuseIdentifier:@"rowcell"];
    UINib * gridnib=[UINib nibWithNibName:@"ProductCollectionCellViewStyle1" bundle:[NSBundle mainBundle]];
    [self.mainCollection registerNib:gridnib forCellWithReuseIdentifier:@"gridcell"];
    
    self.mainCollection.delegate=self;
    self.mainCollection.dataSource=self;
    
    [self.view addSubview:self.mainCollection];
    
    [self.mainCollection addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    [self.mainCollection.header setTitle:@"正在刷新，请稍候..." forState:MJRefreshHeaderStateRefreshing];
    self.mainCollection.header.updatedTimeHidden = YES;
    
}


#pragma mark - 回到首部
-(void) initTopBtn{
    //添加回到顶部btn
    self.toTopBtn=[[UIButton alloc] initWithFrame:CGRectMake(K_UIScreen_WIDTH - 60, K_UIScreen_HEIGHT-120, 40, 40)];
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


#pragma mark - 切换展示的样式
- (void)switchDisplayStyle:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    
    if(self.displayType==DisplayTypeRow){
        self.displayType=DisplayTypeCol;
    }else{
        self.displayType=DisplayTypeRow;
    }
    
    [self.mainCollection reloadData];
}


//#pragma mark - 隐藏导航栏
//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    
//    if (velocity.y > 0.5) {
//        [self hiddenNaviBar];
//    }else if(velocity.y < -0.5){
//        [self resetNaviBar];
//    }
//}
//
//#pragma mark 重置导航栏
//- (void)resetNaviBar{
//    [UIView animateWithDuration:0.3 animations:^{
//        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//        self.mainCollection.frame=CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height- 76);
//        self.naviView.alpha=1;
//        self.naviView.frame = CGRectMake(0,0, K_UIScreen_WIDTH, 64);
//    } completion:^(BOOL finished) {  }];
//}
//
//#pragma mark 隐藏导航栏
//- (void)hiddenNaviBar{
//    [UIView animateWithDuration:0.3 animations:^{
//        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//        self.mainCollection.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -6);
//        self.naviView.alpha=0;
//        self.naviView.frame = CGRectMake(0, -64, K_UIScreen_WIDTH, 64);
//    } completion:^(BOOL finished) {  }];
//}


#pragma mark - 头部刷新
-(void) refreshView{
    self.currentPage = @"1";
    [self.mainCollection.footer resetNoMoreData];
    
    NSString *url=[API_ROOT stringByAppendingString:API_GOODS_COLLECTION_LIST];
    url = [url stringByAppendingFormat:@"pageSize=10&currentPageNo=%d&userId=%@",1,self.userId];

    [self.NetworkUtil GET:url inView:self.view success:^(id responseObject) {
        [self.goodsListArray removeAllObjects];
        
        
        if([[responseObject objectForKey:@"status"] intValue] == 1 ){
            // 1.
            NSDictionary * data = [responseObject objectForKey:@"data"];
            NSArray *productArray = [data objectForKey:@"list"];
            for (NSDictionary *dic in productArray)
            {
                CollectionModel *model = [[CollectionModel alloc] initWithAttributes:dic];
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
                [self.mainCollection reloadData];
                
                [self.mainCollection addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
                [self.mainCollection.footer setTitle:@"加载更多，请稍候..." forState:MJRefreshFooterStateRefreshing];
                [self.mainCollection.footer setAppearencePercentTriggerAutoRefresh:0];
            }
        
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
        
        [self.mainCollection.header endRefreshing];
        //3.判断是否还有更多产品
        [self checkNoMoreData:responseObject];
        
    } failure:^(NSError *error) {
        [self.mainCollection.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}



#pragma mark - 检查是否还有更多产品，没有就显示到底
- (void) checkNoMoreData:(NSDictionary *)dic{
    NSDictionary * totalDic = [dic objectForKey:@"data"];
    NSInteger page  = [[totalDic objectForKey:@"curren_page"] integerValue];
    NSInteger total = [[totalDic objectForKey:@"total_page"] integerValue];
    if (page == total) {
        [self.mainCollection.footer noticeNoMoreData];
    }else{
        [self.mainCollection.footer resetNoMoreData];
    }
}


#pragma mark - 尾部刷新
- (void)loadMoreData{
    
    NSString *url=[API_ROOT stringByAppendingString:API_GOODS_COLLECTION_LIST];
    url = [url stringByAppendingFormat:@"pageSize=10&currentPageNo=%d&userId=%@",[self.currentPage intValue] +1,self.userId];

    [self.NetworkUtil GET:url inView:self.view success:^(id responseObject) {
        
        
        if([[responseObject objectForKey:@"status"] intValue] == 1 ){
            //1.
            self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] +1];
            
            // 2.
            NSDictionary * data = [responseObject objectForKey:@"data"];
            NSArray *productArray = [data objectForKey:@"list"];
            for (NSDictionary *dic in productArray)
            {
                CollectionModel *model = [[CollectionModel alloc] initWithAttributes:dic];
                [self.goodsListArray addObject:model];
            }
            
            // 3.
            [self.mainCollection reloadData];
            
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
        
        [self.mainCollection.footer endRefreshing];
        //3.判断是否还有更多产品
        [self checkNoMoreData:responseObject];
        
    } failure:^(NSError *error) {
        [self.mainCollection.footer endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
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
    if(indexPath.row>6){
        self.toTopBtn.hidden=NO;
    }else{
        self.toTopBtn.hidden=YES;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    [self switchToTopBtn:indexPath];
    UICollectionViewCell *cell;
    if(self.displayType== DisplayTypeRow){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rowcell" forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gridcell" forIndexPath:indexPath];
    }
    
    CollectionModel *goodsModel = [self.goodsListArray objectAtIndex:indexPath.row];
    [(UILabel*)[cell viewWithTag:2] setText:goodsModel.goodsName];
    [(UILabel*)[cell viewWithTag:3] setText:@""];
    
    [WebImageUtil setImageWithURL:goodsModel.goodsImageUrl placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:(UIImageView*)[cell viewWithTag:1]];
    
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = [[UIColor colorWithWhite:0.600 alpha:1.000] CGColor];
    cell.layer.borderWidth = 0.3;
    
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insets;
    if(self.displayType==DisplayTypeRow){
        insets=UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        insets=UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return insets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(self.displayType==DisplayTypeRow){
        size=CGSizeMake(Screen_WIDTH, 105);
    }else{
        size=CGSizeMake(ColCell_Item_WIDTH, ColCell_Item_HIGHT);
    }
    return size;
}


#pragma mark - 点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.HUDUtil.delegate = self;
    [self.HUDUtil showActionSheetInView:self.view tag:indexPath.row title:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"查看商品详情",@"取消收藏"]];
    
}


#pragma mark 选择是否删除地址
- (void)hudActionSheetClickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag{
    
    switch (buttonIndex) {
        case 0://取消按钮
            break;
        case 1://查看商品详情
            [self productDetailWithRow:tag];
            break;
        case 2://取消收藏
            [self cancelFavoriteWithRow:tag];
            break;
        default:
            break;
    }
}

#pragma mark - 取消收藏
- (void) cancelFavoriteWithRow:(NSInteger)row{
    
    CollectionModel *goodsModel = [self.goodsListArray objectAtIndex:row];
    
    
    NSString *cartAddUrl = [API_ROOT stringByAppendingString:API_GOODS_COLLECTION];
    
    //ttp://api.qpfww.com/collection?goodsId=22643&userId=18
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:goodsModel.goodsId forKey:@"goodsId"];
    
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    [self.NetworkUtil POST:cartAddUrl header:header parameters:parameters success:^(id responseObject) {
        
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
            [self refreshView];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1 inView:self.view];
        }
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}



#pragma mark - 跳转到商品详情
- (void) productDetailWithRow:(NSInteger )row{
    CollectionModel *goodsModel = [self.goodsListArray objectAtIndex:row];
    
    ProductDetailVC *productVC=[[ProductDetailVC alloc] init];
    productVC.productId = [NSString stringWithFormat:@"%ld",(long)[goodsModel.goodsId integerValue]];
    productVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
