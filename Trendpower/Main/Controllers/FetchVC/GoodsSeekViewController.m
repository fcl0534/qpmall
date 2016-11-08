//
//  FetchVC.m
//  Trendpower
//
//  Created by trendpower on 15/9/29.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#define HeaderHeight 100

#import "GoodsSeekViewController.h"

//vc
#import "BrandVC.h"
#import "CateVC.h"
#import "GoodsListViewController.h"
#import "CarTypesViewController.h"

// view
#import "IndexCategoryViewCell.h"
#import "CarBrandCollectionCell.h"
#import "IndexLineHeaderView.h"
#import "RecoHeaderView.h"

#import "ItemButton.h"

// model
#import "BrandModel.h"
#import "HomeCategoryModel.h"
#import "CarTypeLevel1Model.h"

@interface GoodsSeekViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

/** CollectionView */
@property(nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * fetchArray;

@property (nonatomic, strong) NSMutableArray * typeArray;

@end

@implementation GoodsSeekViewController

- (NSMutableArray *)fetchArray{
    if (_fetchArray == nil) {
        _fetchArray = [NSMutableArray array];
    }
    return _fetchArray;
}

- (NSMutableArray *)typeArray{
    if (_typeArray == nil) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找";
    [self initCollection];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.fetchArray.count) {
        [self refreshData];
    }
}

- (void)refreshData{
    NSString *url=[API_ROOT stringByAppendingString:API_FIND];
    url = [url stringByAppendingFormat:@"userId=%@",self.userId];

    [self.NetworkUtil GET:url inView:self.view success:^(id responseObject) {
    
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            
            [self.fetchArray removeAllObjects];
            [self.typeArray removeAllObjects];
            
            NSDictionary * data = [responseObject objectForKey:@"data"];
            NSArray * cateArray = [data valueForKey:@"hot_cate"];
            // 1、分类数组
            if (cateArray.count) {
                NSMutableArray *tempCateArray = [[NSMutableArray alloc] init];
                for (NSDictionary *tempData in cateArray){
                    HomeCategoryModel *cateModel = [[HomeCategoryModel alloc] initWithAttributes:tempData];
                    [tempCateArray addObject:cateModel];
                }
                
                [self.typeArray addObject:@"1"];
                [self.fetchArray addObject:tempCateArray];
            }
            
            // 2.品牌
            NSArray * brandArray = [data valueForKey:@"hot_brand"];
            //有品牌数组
            if (brandArray.count) {
                NSMutableArray *tempCateArray = [[NSMutableArray alloc] init];
                for (NSDictionary *tempData in brandArray){
                    BrandModel *cateModel = [[BrandModel alloc] initWithAttributes:tempData];
                    [tempCateArray addObject:cateModel];
                }
                
                [self.typeArray addObject:@"2"];
                [self.fetchArray addObject:tempCateArray];
            }
            
            // 3.车型
//            NSArray * carArray = [data valueForKey:@"hot_car"];
//            //有车型数组
//            if (carArray.count) {
//                NSMutableArray *tempCateArray = [[NSMutableArray alloc] init];
//                for (NSDictionary *tempData in carArray){
//                    CarTypeLevel1Model *cateModel = [[CarTypeLevel1Model alloc] initWithAttributes:tempData];
//                    [tempCateArray addObject:cateModel];
//                }
//                
//                [self.typeArray addObject:@"3"];
//                [self.fetchArray addObject:tempCateArray];
//            }
            
        }else if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] hasPrefix:@"4217"]){
            [self setUserLogout];
        }
        else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
        
        [self.collectionView.header endRefreshing];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [self.collectionView.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}


#pragma mark - UICollectionViewDataSource
//有多少个区域
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.typeArray.count;
}

// 共有多少个Item(就是格子Cube)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger counts;
    /** 类型判断:
     1、热门分类
     2、热门品牌
     3、热门车型
     */
    
    NSInteger type = [self.typeArray[section] integerValue];
    
    switch (type) {
        case 0:
            counts = 1;
            break;
        case 1:
        case 2:
        case 3:
        {
            NSInteger fillBlanks = ([self.fetchArray[section] count]) % 4;
            counts = [self.fetchArray[section] count] > 16 ? 16 : [self.fetchArray[section] count] + (fillBlanks ? 4-fillBlanks : 0);
        }
            break;
        default:
            counts = 0;
            break;
    }
    
    return counts;
}


#pragma mark cell布局
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /** 类型判断:
     1、热门分类
     2、热门品牌
     3、热门车型
     */
    
    NSInteger type = [self.typeArray[indexPath.section] integerValue];
    
    switch (type) {
        case 1:{//分类
            IndexCategoryViewCell * categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexCategoryViewCell" forIndexPath:indexPath];
            NSInteger counts = [self.fetchArray[indexPath.section] count];
            if (indexPath.row < counts) {
                HomeCategoryModel * categoryModel =[self.fetchArray[indexPath.section] objectAtIndex:indexPath.row];
                categoryCell.nameLabel.text = categoryModel.cateName;
                [WebImageUtil setImageWithURL:categoryModel.imageURL placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:categoryCell.iconView];
                categoryCell.nameLabel.hidden = NO;
                categoryCell.iconView.hidden = NO;
            }else{
                categoryCell.nameLabel.hidden = YES;
                categoryCell.iconView.hidden = YES;
            }
            categoryCell.backgroundColor = [UIColor whiteColor];
            return categoryCell;
            break;
        }
        case 2:
        case 3:{
            CarBrandCollectionCell * categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarBrandCollectionCell" forIndexPath:indexPath];
            NSInteger counts = [self.fetchArray[indexPath.section] count];
            if (indexPath.row < counts) {
                if(type == 2){
                    BrandModel * brandModel =[self.fetchArray[indexPath.section] objectAtIndex:indexPath.row];
                    categoryCell.nameLabel.text = brandModel.brand_name;
                    [WebImageUtil setImageWithURL:brandModel.brand_logo placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:categoryCell.imageView];
                }else if(type == 3){
                    CarTypeLevel1Model * carModel =[self.fetchArray[indexPath.section] objectAtIndex:indexPath.row];
                    categoryCell.nameLabel.text = carModel.brand;
                    [WebImageUtil setImageWithURL:carModel.brand_logo placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:categoryCell.imageView];
                }
                categoryCell.nameLabel.hidden = NO;
                categoryCell.imageView.hidden = NO;
            }else{
                categoryCell.nameLabel.hidden = YES;
                categoryCell.imageView.hidden = YES;
            }
            return categoryCell;
            break;
        }
        default:
            break;
    }
    
    return nil;
}


#pragma mark cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    NSInteger type = [self.typeArray[indexPath.section] integerValue];
    
    switch (type) {
        case 1:
            size = CGSizeMake(K_UIScreen_WIDTH/4, 85);
            break;
        case 2:
        case 3:
            size = CGSizeMake(K_UIScreen_WIDTH/4, 75);
            break;
        default:
            size = CGSizeMake(0, 0);
            break;
    }
    
    return size;
}

//定义每个Section 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 20, 10);
    UIEdgeInsets insets;
    
    NSInteger type = [self.typeArray[section] integerValue];
    
    switch (type) {
        case 0:
            insets = UIEdgeInsetsMake(0, 0, 10, 0);//分别为上、左、下、右
            break;
        case 1:
        case 2:
        case 3:
            insets = UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
            break;
        default:
            insets = UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
            break;
    }
    
    return insets;
}


//这个是两行之间的间距（上下cell间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat spacing;
    
    NSInteger type = [self.typeArray[section] integerValue];
    
    switch (type) {
        case 0:
            spacing = 0;
            break;
        case 1:
        case 2:
        case 3:
            spacing = 0;
            break;
        default:
            spacing = 0;
            break;
    }
    
    return spacing;
}

//这个方法是两个之间的间距（同一行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat spacing;
    
    NSInteger type = [self.typeArray[section] integerValue];
    
    switch (type) {
        case 0:
            spacing = 0;
            break;
        case 1:
        case 2:
        case 3:
            spacing = 0;
            break;
        default:
            spacing = 0;
            break;
    }
    
    return spacing;
}


#pragma mark 头headerView的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    
    NSInteger type = [self.typeArray[section] integerValue];
    
    switch (type) {
        case 0:
            size = CGSizeMake(0, 0);
            break;
        case 1:
        case 2:
        case 3:
            size = CGSizeMake(K_UIScreen_WIDTH, 40);
            break;
        default:
            size = CGSizeMake(0, 0);
            break;
    }
    
    return size;
}

#pragma mark 头headerView的布局
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader){

        NSInteger type = [self.typeArray[indexPath.section] integerValue];
        RecoHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RecoHeaderView" forIndexPath:indexPath];
        headerView.rightBtn.hidden = NO;
        headerView.titleLabel.textColor = K_MAIN_COLOR;
        switch (type) {
            case 1:{
                headerView.titleLabel.text = @"热门分类";
                headerView.rightBtn.tag = 1;
                [headerView.rightBtn addTarget:self action:@selector(clickedMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            case 2:
                headerView.titleLabel.text = @"热门品牌";
                headerView.rightBtn.tag = 2;
                [headerView.rightBtn addTarget:self action:@selector(clickedMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3:
                headerView.titleLabel.text = @"热门车型";
                headerView.rightBtn.tag = 3;
                [headerView.rightBtn addTarget:self action:@selector(clickedMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                headerView = nil;
                break;
        }
        return headerView;
        
    }else if (kind == UICollectionElementKindSectionFooter){
        // 尾部
        NSInteger type = [self.typeArray[indexPath.section] integerValue];
        switch (type) {
            case 0:
                return  nil;
                break;
            case 1:
            case 2:
            case 3:{
                IndexLineHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"IndexLineHeaderView" forIndexPath:indexPath];
                return headerView;
                break;
            }
            default:
                break;
        }
        return  nil;
    }
    
    return nil;
}

#pragma mark 尾footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size;
    
    NSInteger type = [self.typeArray[section] integerValue];
    
    switch (type) {
        case 0:
            size = CGSizeMake(0, 0);
            break;
        case 1:
        case 2:
        case 3:
            size = CGSizeMake(K_UIScreen_WIDTH, 15);
            break;
        default:
            size = CGSizeMake(0, 0);
            break;
    }
    
    return size;
}


#pragma mark 点击更多
- (void)clickedMoreBtn:(UIButton *)btn{
    
    switch (btn.tag) {
        case 1:{
            CateVC * vc = [[CateVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            BrandVC * vc = [[BrandVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:{
            CarTypesViewController * vc = [[CarTypesViewController alloc]init];
            vc.isFromOther = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


#pragma mark 点击Collection处理事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    /** 类型判断:
     0、入口
     1、热门分类
     2、热门品牌

     */
    
    NSInteger type = [self.typeArray[indexPath.section] integerValue];
    switch (type) {
        case 0:
            break;
        case 1:{//分类
            NSInteger counts = [self.fetchArray[indexPath.section] count];
            if(indexPath.row >= counts) break;
            HomeCategoryModel * cateModel =[self.fetchArray[indexPath.section] objectAtIndex:indexPath.row];
            [self productListViewTitle:cateModel.cateName cateId:[NSString stringWithFormat:@"%d",cateModel.cateId]];
            break;
        }
        case 2:{
            // 热门品牌
            NSInteger counts = [self.fetchArray[indexPath.section] count];
            if(indexPath.row >= counts) break;
            BrandModel * brandModel =[self.fetchArray[indexPath.section] objectAtIndex:indexPath.row];
            GoodsListViewController * vc = [[GoodsListViewController alloc]init];
            vc.filterName = brandModel.brand_name;
            vc.filterType = GoodsFilterTypeBrand;
            vc.brandIds = brandModel.brand_id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:{
            // 热门车型
            CarTypeLevel1Model * carModel =[self.fetchArray[indexPath.section] objectAtIndex:indexPath.row];
            GoodsListViewController * vc = [[GoodsListViewController alloc]init];
            vc.filterName = carModel.brand;
            vc.filterType = GoodsFilterTypeCarBrand;
            vc.step = CarTypeFindStep1;
            vc.carBrandId = carModel.keyId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}

#pragma mark - 跳转到商品列表
- (void) productListViewTitle:(NSString *)title cateId:(NSString *)cateId {
    GoodsListViewController * vc = [[GoodsListViewController alloc]init];
    vc.filterName = title;
    vc.filterType = GoodsFilterTypeCategory;
    vc.cateId = cateId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 初始化Collection
-(void) initCollection{
    
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, HeaderHeight)];
    [self.view addSubview:header];
    [self setHeaderView:header];
    
    //1.创建一个流布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame), self.view.frame.size.width, self.view.frame.size.height-64 -48 -HeaderHeight) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // 1.设置collectionView的背景色
    //self.collectionView.backgroundColor = K_GREY_COLOR;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 2.注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"IndexCategoryViewCell" bundle:nil] forCellWithReuseIdentifier:@"IndexCategoryViewCell"];
    [self.collectionView registerClass:[CarBrandCollectionCell class] forCellWithReuseIdentifier:@"CarBrandCollectionCell"];
    
    
    //3.注册headerView Nib的view需要继承UICollectionReusableView
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecoHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RecoHeaderView"];
    [self.collectionView registerClass:[IndexLineHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"IndexLineHeaderView"];
    [self.collectionView registerClass:[IndexLineHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"IndexLineHeaderView"];
    
    
    //4.设置collectionView显示垂直滚动
    self.collectionView.showsVerticalScrollIndicator= YES;
    
    //设置上拉刷新
    [self.collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.collectionView.header setTitle:@"请稍候..." forState:MJRefreshHeaderStateRefreshing];
    [self.view addSubview:self.collectionView];
    
    //    [self.mainCollection addLegendFooterWithRefreshingTarget:self refreshingAction:nil];
    //    [self.mainCollection.footer setTitle:@"加载更多中..." forState:MJRefreshFooterStateRefreshing];
    //    [self.mainCollection.footer noticeNoMoreData];
    
}


#pragma mark - 入口设置
- (void)setHeaderView:(UIView *)cell{
    
    CGFloat bottonH = 15;
    CGFloat btnH = HeaderHeight -bottonH;
    
    ItemButton * cateBtn = [self getItemButtonFrame:CGRectMake(0, 0, K_UIScreen_WIDTH/3, btnH) Title:@"分类" image:[UIImage imageNamed:@"btn_category"]];
    [cell addSubview:cateBtn];
    cateBtn.tag = 1;
    [cateBtn addTarget:self action:@selector(clickedMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    ItemButton * brandBtn = [self getItemButtonFrame:CGRectMake(CGRectGetMaxX(cateBtn.frame), 0, K_UIScreen_WIDTH/3, btnH) Title:@"品牌" image:[UIImage imageNamed:@"btn_brand"]];
    [cell addSubview:brandBtn];
    brandBtn.tag = 2;
    [brandBtn addTarget:self action:@selector(clickedMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    ItemButton * carBtn = [self getItemButtonFrame:CGRectMake(CGRectGetMaxX(brandBtn.frame), 0, K_UIScreen_WIDTH/3, btnH) Title:@"车型" image:[UIImage imageNamed:@"btn_cartype"]];
    [cell addSubview:carBtn];
    carBtn.tag = 3;
    [carBtn addTarget:self action:@selector(clickedMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat maring = 20;
    UIColor * LineBG = [UIColor colorWithWhite:0.854 alpha:1.000];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cateBtn.frame), maring, 0.9, btnH -2*maring)];
    line1.backgroundColor = LineBG;
    [cell addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(brandBtn.frame), maring, 0.9, btnH -2*maring)];
    line2.backgroundColor = LineBG;
    [cell addSubview:line2];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, btnH, K_UIScreen_WIDTH, bottonH)];
    lineView.backgroundColor = K_LINEBG_COLOR;
    lineView.layer.borderColor = K_LINEBD_COLOR.CGColor;
    lineView.layer.borderWidth = 1.0f;
    [cell addSubview:lineView];
}

- (ItemButton * )getItemButtonFrame:(CGRect)frame Title:(NSString *)title image:(UIImage *)image{
    ItemButton * btn = [[ItemButton alloc]initWithFrame:frame];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


@end
