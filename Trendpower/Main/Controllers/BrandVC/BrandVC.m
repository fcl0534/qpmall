//
//  BrandVC.m
//  Trendpower
//
//  Created by trendpower on 15/6/10.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//


#import "BrandVC.h"

//vc
#import "GoodsListViewController.h"
#import "SearchVC.h"


//model
#import "CarTypeLevel1Model.h"

//view
#import "CateTableViewCell.h"


@interface BrandVC()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *listTableView;

/**
 *  索引
 */
@property (nonatomic, strong) NSArray *sectionTitleArray;
/**
 *  存储模型，二维数组
 */
@property (nonatomic, strong) NSMutableArray *rowModelArray;


@end

@implementation BrandVC
- (NSMutableArray *)rowModelArray{
    if (_rowModelArray == nil) {
        _rowModelArray = [NSMutableArray array];
    }
    return _rowModelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌";
    
    //    UIButton * shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(K_UIScreen_WIDTH -44, 0, 44, 44)];
    //    [shareBtn setImage:[UIImage imageNamed:@"navi_RichScan_normal"] forState:UIControlStateNormal];
    //    [shareBtn addTarget:self action:@selector(clickedRichScanBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.naviBar addSubview:shareBtn];
    
    
    [self initTableView];
    [self fetchLevel1];
    
}

- (void)clickedRichScanBtn:(UIButton *)btn{
    
}



- (void)fetchLevel1{
    
    NSString *brandUrl=[API_ROOT stringByAppendingString:API_BRANDS_LIST];
    brandUrl = [brandUrl stringByAppendingFormat:@"userId=%@",self.userId];

    [self.NetworkUtil GET:brandUrl inView:self.view success:^(id responseObject) {
        
        //NSDictionary * dataArray = [responseObject objectForKey:@"retval"];
        NSDictionary * dataArray = [responseObject objectForKey:@"data"];
        
        NSArray *keys = dataArray.allKeys;
        // 排序（从小到大）
        NSArray *sortedArray = [keys sortedArrayUsingSelector:@selector(compare:)];
        self.sectionTitleArray = [NSArray arrayWithArray:sortedArray];
        
        // 倒序
        //NSArray* reversedArray = [[sortedArray reverseObjectEnumerator] allObjects];
        
        [self.rowModelArray removeAllObjects];
        //快速遍历
        for(id key in sortedArray) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary * dic in [dataArray objectForKey:key]) {
                CarTypeLevel1Model *model = [[CarTypeLevel1Model alloc] initWithAttributes:dic];
                [tempArray addObject:model];
            }
            [self.rowModelArray addObject:tempArray];
        }
        
        [self.listTableView reloadData];
        
        [self.listTableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.listTableView.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


- (void)initTableView{
    
    //搜索框
//    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH,45)];
//    searchBar.placeholder=@"17位车架号搜索";
//    searchBar.delegate = self;
//    searchBar.backgroundColor=[UIColor grayColor];
//    searchBar.keyboardType=UIKeyboardTypeDefault;
//    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    [self.view addSubview:searchBar];

    self.listTableView =
    [[UITableView alloc] initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH,K_UIScreen_HEIGHT -64) style:UITableViewStylePlain];
    self.listTableView.backgroundColor = K_GREY_COLOR;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.allowsSelection=YES;
    self.listTableView.showsHorizontalScrollIndicator = NO;
    self.listTableView.showsVerticalScrollIndicator = NO;
    //设置索引列文本的颜色
    self.listTableView.sectionIndexColor = self.mainColor;
    self.listTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.listTableView.sectionIndexTrackingBackgroundColor = K_GREY_COLOR;
    
    [self.view addSubview:self.listTableView];
    
    //设置上拉刷新
    [self.listTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchLevel1)];
    [self.listTableView.header setTitle:@"请稍候..." forState:MJRefreshHeaderStateRefreshing];
    
    
}


//添加索引列
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitleArray;
}

//索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index

{
    //点击索引，列表跳转到对应索引的行
    
    [tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //弹出首字母提示
    
    //[self showLetter:title ];
    
    return index;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 30)];
    headView.backgroundColor = K_GREY_COLOR; //[UIColor colorWithWhite:0.904 alpha:1.000];
    
    //标题文字
    UILabel *lblBiaoti = [[UILabel alloc]init];
    lblBiaoti.backgroundColor = [UIColor clearColor];
    lblBiaoti.textAlignment = NSTextAlignmentLeft;
    lblBiaoti.font = [UIFont systemFontOfSize:15];
    lblBiaoti.textColor = [UIColor blackColor];
    lblBiaoti.frame = CGRectMake(15, 0, 200, 30);
    lblBiaoti.text = [self.sectionTitleArray objectAtIndex:section];
    [headView addSubview:lblBiaoti];
    
    return headView;
}



////section （标签）标题显示
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    return [self.sectionTitleArray objectAtIndex:section];
//}


//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleArray.count;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 当前为一级cell
    if([[self.rowModelArray[indexPath.section][indexPath.row] class]isSubclassOfClass:[CarTypeLevel1Model class]]){
        return 70;
    }else{
        return 44;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.rowModelArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CateTableViewCell * cell = [CateTableViewCell cellWithTableView:tableView];
    cell.cellType = CateTableCellTypeBrand;
    //cell.rightBtn.selected = (self.indexPath == indexPath);
    
    UIView * view = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView = view;
    
    // 当前为一级cell
    if([[self.rowModelArray[indexPath.section][indexPath.row] class] isSubclassOfClass:[CarTypeLevel1Model class]]){
        CarTypeLevel1Model * model = self.rowModelArray[indexPath.section][indexPath.row];
        [WebImageUtil setImageWithURL:model.brand_logo placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:cell.iconView];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.brand];
//        cell.logoView.hidden = NO;
//        cell.detailLabel.text = nil;
//        cell.rightImage.hidden = YES;
//        cell.rightBtn.hidden = NO;
        cell.backgroundColor = [UIColor whiteColor];
        view.backgroundColor = [UIColor colorWithWhite:0.908 alpha:1.000];
    }else{
//        cell.logoView.hidden = YES;
//        cell.nameLabel.text = nil;
//        cell.rightImage.hidden = NO;
//        cell.rightBtn.hidden = YES;
//        view.backgroundColor = K_MAIN_COLOR;
//        cell.backgroundColor = [UIColor colorWithWhite:0.925 alpha:1.000];
//        cell.detailLabel.text = [NSString stringWithFormat:@"%@",self.rowModelArray[indexPath.section][indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CarTypeLevel1Model * model = self.rowModelArray[indexPath.section][indexPath.row];
    GoodsListViewController * vc = [[GoodsListViewController alloc]init];
    vc.filterName = model.brand;
    vc.filterType = GoodsFilterTypeBrand;
    vc.brandIds = model.keyId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
