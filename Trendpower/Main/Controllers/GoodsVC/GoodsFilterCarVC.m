//
//  GoodsFilterCarVC.m
//  Trendpower
//
//  Created by HTC on 16/2/4.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "GoodsFilterCarVC.h"

// tool

#import "MJRefresh.h"

#import "NetworkingUtil.h"
#import "HUDUtil.h"
#import "WebImageUtil.h"

//model
#import "CarTypeLevel1Model.h"

//view
#import "FetchTableViewCell.h"

//vc
#import "GoodsFilterCarStep2VC.h"

@interface GoodsFilterCarVC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *listTableView;

/**
 *  索引
 */
@property (nonatomic, strong) NSArray *sectionTitleArray;
/**
 *  存储模型，二维数组
 */
@property (nonatomic, strong) NSMutableArray *rowModelArray;

/**
 *  当前展开下标
 */
@property (nonatomic, strong) NSIndexPath * indexPath;

/**
 *  存储全部二级下标
 */
@property (nonatomic, strong) NSMutableArray * indexsArray;

/**
 *  当前展开的一级品牌名
 */
@property (nonatomic, copy) NSString * level2Brand;
/**
 *  当前展开的一级品牌id
 */
@property (nonatomic, copy) NSString * level2BrandID;

@end

@implementation GoodsFilterCarVC
- (NSMutableArray *)rowModelArray{
    if (_rowModelArray == nil) {
        _rowModelArray = [NSMutableArray array];
    }
    return _rowModelArray;
}

- (NSMutableArray *)indexsArray{
    if (_indexsArray == nil) {
        _indexsArray = [NSMutableArray array];
    }
    return _indexsArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车型";
    self.navigationBar.barTintColor = K_MAIN_COLOR;
    
    self.indexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
    [self initTableView];
    [self fetchLevel1];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationBar.leftTitle = @"返回";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)fetchLevel1{
    //清空下标
    self.indexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    [self.indexsArray removeAllObjects];
    
    NSString *fetchLevel1=[API_ROOT stringByAppendingString:API_CARTYPES];

    NetworkingUtil * network = [NetworkingUtil sharedNetworkingUtil];
    [network GET:fetchLevel1 inView:self.view success:^(id responseObject) {
        
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
        HUDUtil * hud = [HUDUtil sharedHUDUtil];
        [hud showNetworkErrorInView:self.view];
    }];
}


- (void)initTableView{
    
    CGSize size = self.yqNavigationController.frame.size;
    self.listTableView =
    [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height -64) style:UITableViewStylePlain];
    self.listTableView.backgroundColor = K_GREY_COLOR;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.allowsSelection=YES;
    self.listTableView.showsHorizontalScrollIndicator = NO;
    self.listTableView.showsVerticalScrollIndicator = NO;
    //设置索引列文本的颜色
    self.listTableView.sectionIndexColor = K_MAIN_COLOR;
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
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    headView.backgroundColor = K_GREY_COLOR; //[UIColor colorWithWhite:0.904 alpha:1.000];
    
    //标题文字
    UILabel *lblBiaoti = [[UILabel alloc]init];
    lblBiaoti.backgroundColor = [UIColor clearColor];
    lblBiaoti.textAlignment = NSTextAlignmentLeft;
    lblBiaoti.font = [UIFont boldSystemFontOfSize:16];
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
        return 54;
    }else{
        return 44;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.rowModelArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    FetchTableViewCell * cell = [FetchTableViewCell cellWithTableView:tableView];
    
    cell.rightBtn.selected = (self.indexPath == indexPath);
    
    UIView * view = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView = view;
    
    // 当前为一级cell
    if([[self.rowModelArray[indexPath.section][indexPath.row] class] isSubclassOfClass:[CarTypeLevel1Model class]]){
        CarTypeLevel1Model * model = self.rowModelArray[indexPath.section][indexPath.row];
        [WebImageUtil setImageWithURL:model.brand_logo placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:cell.logoView];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.brand];
        cell.logoView.hidden = NO;
        cell.detailLabel.text = nil;
        cell.rightImage.hidden = YES;
        cell.rightBtn.hidden = NO;
        cell.backgroundColor = [UIColor whiteColor];
        view.backgroundColor = [UIColor colorWithWhite:0.908 alpha:1.000];
    }else{
        cell.logoView.hidden = YES;
        cell.nameLabel.text = nil;
        cell.rightImage.hidden = NO;
        cell.rightBtn.hidden = YES;
        view.backgroundColor = K_MAIN_COLOR;
        cell.backgroundColor = [UIColor colorWithWhite:0.925 alpha:1.000];
        cell.detailLabel.text = [NSString stringWithFormat:@"%@",self.rowModelArray[indexPath.section][indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // 如果是当前列表 就收起来，关闭二级
    if(self.indexPath.section == indexPath.section && self.indexPath.row == indexPath.row){
        self.indexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
        [self.listTableView deselectRowAtIndexPath:indexPath animated:YES];
        [self removeSubCellIndexPath:indexPath];
        FetchTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.rightBtn.selected = NO;
        
    }else{
        // 当前为其它类型列表，则展开新的二级
        if([[self.rowModelArray[indexPath.section][indexPath.row] class] isSubclassOfClass:[CarTypeLevel1Model class]]){
            if(self.indexsArray.count){
                //原来有二级，先关闭原来二级
                //因为同一个区的下标乱了，如果同一个区，并且点击位于展开的后面 还要减掉
                FetchTableViewCell * cell = [tableView cellForRowAtIndexPath:self.indexPath];
                cell.rightBtn.selected = NO;
                NSIndexPath * newIndex = indexPath;
                if(self.indexPath.section == indexPath.section && self.indexPath.row < indexPath.row){
                    newIndex = [NSIndexPath indexPathForRow:indexPath.row -self.indexsArray.count inSection:indexPath.section];
                }
                [self removeSubCellIndexPath:indexPath];
                self.indexPath = newIndex;
                [self fetchLevel2With:newIndex];
            }else{
                self.indexPath = indexPath;
                [self fetchLevel2With:indexPath];
            }
        }else{
            [self.listTableView deselectRowAtIndexPath:indexPath animated:YES];
            // 当前为二级，跳到下一级
            [self fetchLevel3With:indexPath];
        }
    }
    
}


#pragma mark - 查询三级
- (void)fetchLevel3With:(NSIndexPath *)indexPath{
    NSString *searchListUrl =[API_ROOT stringByAppendingString:API_CARINOFS];
    NSString * level3Brand = self.rowModelArray[indexPath.section][indexPath.row];
    searchListUrl = [searchListUrl stringByAppendingFormat:@"step=2&brand_id=%@&car_model=%@",self.level2BrandID,level3Brand];
    //中文要编码
    searchListUrl = [searchListUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NetworkingUtil * network = [NetworkingUtil sharedNetworkingUtil];
    [network GET:searchListUrl inView:self.view success:^(id responseObject) {
        
        NSArray * dataArray = [responseObject objectForKey:@"data"];
        NSMutableArray * carArray = [NSMutableArray array];
        if (dataArray.count) {
            [dataArray enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL * _Nonnull stop) {
                [carArray addObject:[dic objectForKey:@"displacement"]];
            }];
        }
        
        GoodsFilterCarStep2VC *vc = [[GoodsFilterCarStep2VC alloc]init];
        vc.filterName = [NSString stringWithFormat:@"%@ %@",self.level2Brand,level3Brand];
        vc.titleName = [NSString stringWithFormat:@"%@-%@",self.level2Brand,level3Brand];
        vc.rowModelArray = [NSMutableArray arrayWithArray:carArray];
        NSString *searchListUrl =[API_ROOT stringByAppendingString:API_CARINOFS];
        NSString * level3Brand = self.rowModelArray[indexPath.section][indexPath.row];
        searchListUrl = [searchListUrl stringByAppendingFormat:@"step=3&brand_id=%@&car_model=%@",self.level2BrandID,level3Brand];
        vc.fetchUrl = searchListUrl;
        vc.arrayselectDics = self.arrayselectDics;
        __block typeof(self) weakSelf = self;
        vc.clickedConfirmBlock = ^(){
            // 确定数据返回
            [weakSelf.yqNavigationController popYQViewControllerAnimated:YES];
        };
        [self.yqNavigationController pushYQViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        HUDUtil * hud = [HUDUtil sharedHUDUtil];
        [hud showNetworkErrorInView:self.view];
    }];
}

//    第一步：
//http://api.qpfww.com/carinfos?brand_id=1&step=1
//    第二步 ：
//http://api.qpfww.com/carinfos?brand_id=1&car_model=%E5%A8%81%E8%B1%B9&step=2
//    第三步：
//http://api.qpfww.com/carinfos?brand_id=1&step=3&car_model=%E5%A8%81%E8%B1%B9&emssion=2.0L

#pragma mark - 查询二级
- (void)fetchLevel2With:(NSIndexPath *)indexPath{
    [self.listTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *searchListUrl =[API_ROOT stringByAppendingString:API_CARINOFS];
    CarTypeLevel1Model * model = self.rowModelArray[indexPath.section][indexPath.row];
    searchListUrl = [searchListUrl stringByAppendingFormat:@"step=1&brand_id=%@",model.keyId];
    self.level2Brand = model.brand;
    self.level2BrandID = model.keyId;
    //中文要编码
    searchListUrl = [searchListUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NetworkingUtil * network = [NetworkingUtil sharedNetworkingUtil];
    [network GET:searchListUrl inView:self.view success:^(id responseObject) {
        
        NSArray * carArray = [responseObject objectForKey:@"data"];
        
        [self.indexsArray removeLastObject];
        if (carArray.count) {
            [carArray enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL * _Nonnull stop) {
                NSIndexPath * index = [NSIndexPath indexPathForRow:indexPath.row+idx+1 inSection:indexPath.section];
                [self.rowModelArray[indexPath.section] insertObject:[dic objectForKey:@"carSet"] atIndex:indexPath.row+idx+1];
                [self.indexsArray addObject:index];
            }];
        }
        
        [self addSubCellIndexPath:indexPath];
        FetchTableViewCell * cell = [self.listTableView cellForRowAtIndexPath:indexPath];
        cell.rightBtn.selected = YES;
        [self.listTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    } failure:^(NSError *error) {
        self.indexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
        FetchTableViewCell * cell = [self.listTableView cellForRowAtIndexPath:indexPath];
        cell.rightBtn.selected = NO;
        HUDUtil * hud = [HUDUtil sharedHUDUtil];
        [hud showNetworkErrorInView:self.view];
    }];
}

- (void) addSubCellIndexPath:(NSIndexPath *)indexPath{
    
    [self.listTableView beginUpdates];
    
    [self.listTableView insertRowsAtIndexPaths:self.indexsArray withRowAnimation:UITableViewRowAnimationTop];
    
    [self.listTableView endUpdates];
    
}

- (void) removeSubCellIndexPath:(NSIndexPath *)indexPath{
    
    // 从后往前删除
    for (NSInteger i = self.indexsArray.count ; i > 0 ; i--) {
        NSIndexPath * index = self.indexsArray[i-1];
        [self.rowModelArray[index.section] removeObjectAtIndex:index.row];
    }
    
    [self.listTableView beginUpdates];
    
    [self.listTableView deleteRowsAtIndexPaths:self.indexsArray withRowAnimation:UITableViewRowAnimationTop];
    
    [self.listTableView endUpdates];
    
    [self.indexsArray removeAllObjects];
    
}

@end
