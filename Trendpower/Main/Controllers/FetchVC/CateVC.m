
//
//  CateVC.m
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "CateVC.h"

//model
#import "CateModelArray.h"

// view
#import "CateTableViewCell.h"
#import "CateSliderView.h"
#import "CateCollectionViewCell.h"

// vc
#import "GoodsListViewController.h"

#define K_LeftWidth      78
#define K_SliderWidth    ([UIScreen mainScreen].bounds.size.width -K_LeftWidth)

#define ColCell_Spacing_WIDTH           10
#define ColCell_Item_WIDTH             ((K_SliderWidth -3 - 4*ColCell_Spacing_WIDTH)/3)
#define ColCell_Item_HIGHT             70


@interface CateVC ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CateSliderViewDelegate>

@property (nonatomic, weak) UITableView * tableView;
/**  空视图 */
@property (nonatomic, weak) EmptyPlaceholderView *emptyView;

@property (nonatomic, strong) CateModelArray * modelArray;

@property (nonatomic, weak) CateSliderView * sliderView;
@property (nonatomic, weak) UICollectionView * collectionView;
@property (nonatomic, strong) CateModel * selectCateModel;

@end

@implementation CateVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.modelArray.cateArray.count ? : [self fetchCateList];
}


#pragma mark - Interface
- (void)initView{
    self.title = @"配件分类";
    [self initTableView];
}

- (void)initTableView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.rowHeight = 70;
    tableView.backgroundColor = K_GREY_COLOR;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchCateList)];
    [self.tableView.header setTitle:@"正在刷新分类..." forState:MJRefreshHeaderStateRefreshing];
    self.tableView.header.updatedTimeHidden = YES;
}

- (void)initSliderView{
    
    if (!self.sliderView) {
        CateSliderView * sliderView = [[CateSliderView alloc]initWithFrame:CGRectMake(K_LeftWidth, 0, K_SliderWidth, K_UIScreen_HEIGHT)];
        [self.view addSubview:sliderView];
        self.sliderView = sliderView;
        self.sliderView.delegate = self;
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        UICollectionView * collectionView =[[UICollectionView alloc] initWithFrame:self.sliderView.contentView.bounds collectionViewLayout:flowLayout];
        self.collectionView = collectionView;
        self.collectionView.backgroundColor= [UIColor whiteColor];
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.alwaysBounceVertical = YES;
        
        [self.collectionView registerClass:[CateCollectionViewCell class] forCellWithReuseIdentifier:@"CateCollectionViewCell"];
        
        [self.sliderView.contentView addSubview:self.collectionView];
        
    }
}


#pragma mark - privite theme
- (void)fetchCateList{
    NSString *cateListUrl=[API_ROOT stringByAppendingString:API_CATEGORY];
    cateListUrl = [cateListUrl stringByAppendingFormat:@"userId=%@",self.userId];

    [self.NetworkUtil GET:cateListUrl inView:self.view success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            self.modelArray = [[CateModelArray alloc]initWithAttributes:responseObject];
            [self.tableView reloadData];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 事件


#pragma mark - delegate

#pragma cateSliderDelegate
- (void)cateSliderView:(CateSliderView *)cateSliderView clickedBackBtn:(UIButton *)btn{
    [cateSliderView hideSliderView];
}

#pragma mark TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.cateArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CateTableViewCell * cell = [CateTableViewCell cellWithTableView:tableView];
    cell.cellType = CateTableCellTypeCate;
    CateModel * model = self.modelArray.cateArray[indexPath.row];
    cell.nameLabel.text = model.cateName;
    [WebImageUtil setImageWithURL:model.imageUrl placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:cell.iconView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self initSliderView];
    
    CateModel * model = self.modelArray.cateArray[indexPath.row];
    
    if ([self.sliderView.titleLbl.text isEqualToString:model.cateName]) {
        self.sliderView.titleLbl.text = nil;
        [self.sliderView hideSliderView];
        return;
    }
    
    self.sliderView.titleLbl.text = model.cateName;
    self.selectCateModel = model;
    
    CateSubModel * submodel = self.selectCateModel.cateSubArray[0];
    if(self.selectCateModel.cateSubArray.count == 1 && [submodel.cateName isEqualToString:@"全部"]){
        // 没有子类，直接跳转
        GoodsListViewController * vc = [[GoodsListViewController alloc]init];
        vc.filterType = GoodsFilterTypeCategory;
        vc.filterName = self.selectCateModel.cateName;
        vc.cateId = [NSString stringWithFormat:@"%ld",self.selectCateModel.cateId];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
       [self.collectionView reloadData];
       [self.sliderView showSliderView];
    }
}

#pragma mark collectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.selectCateModel.cateSubArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CateCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CateCollectionViewCell" forIndexPath:indexPath];
    
    CateSubModel * model = self.selectCateModel.cateSubArray[indexPath.row];
    cell.nameLabel.text = model.cateName;
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"fenlei_all"];
    }else{
        [WebImageUtil setImageWithURL:model.imageUrl placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:cell.imageView];
    }
    
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(ColCell_Spacing_WIDTH, ColCell_Spacing_WIDTH, ColCell_Spacing_WIDTH, ColCell_Spacing_WIDTH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((int)ColCell_Item_WIDTH, ColCell_Item_HIGHT);;
}

//这个是两行之间的间距（上下cell间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20;
}

#pragma mark  点击collectionView
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsListViewController * vc = [[GoodsListViewController alloc]init];
    vc.filterType = GoodsFilterTypeCategory;

    if (indexPath.row == 0) {
        vc.filterName = self.selectCateModel.cateName;
        vc.cateId = [NSString stringWithFormat:@"%ld",self.selectCateModel.cateId];
    }else{
        CateSubModel * model = self.selectCateModel.cateSubArray[indexPath.row];
        
        vc.filterName = model.cateName;
        vc.cateId = [NSString stringWithFormat:@"%ld",model.cateId];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.sliderView.titleLbl.text = nil;
        [self.sliderView hideSliderView];
    });
}



#pragma mark - get/set


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
