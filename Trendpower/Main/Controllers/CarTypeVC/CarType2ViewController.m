
//
//  CartType2VC.m
//  Trendpower
//
//  Created by HTC on 15/9/30.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "CarType2ViewController.h"

//view
#import "Fetch2TableViewCell.h"

// vc
#import "GoodsListViewController.h"


@interface CarType2ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listTableView;

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
@property (nonatomic, copy) NSString * level5Brand;

/**
 *  存储最后数据
 */
@property (nonatomic, strong) NSArray * lastArray;

@end

@implementation CarType2ViewController

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
    self.indexPath =  [NSIndexPath indexPathForRow:-1 inSection:-1];
    
    self.title = self.titleName;
    [self initTableView];
    
}

- (void)initTableView{
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) style:UITableViewStylePlain];
    self.listTableView.backgroundColor = K_GREY_COLOR;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.allowsSelection=YES;
    self.listTableView.showsHorizontalScrollIndicator = NO;
    self.listTableView.showsVerticalScrollIndicator = NO;
    //设置索引列文本的颜色
    self.listTableView.sectionIndexColor = [UIColor orangeColor];
    //self.myTableView.sectionIndexBackgroundColor=K_GREY_COLOR;
    //myTableView.sectionIndexTrackingBackgroundColor=BB_White_Color;
    self.listTableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:self.listTableView];
    
    [self.listTableView reloadData];
}


//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 当前为一级cell
    if([[self.rowModelArray[indexPath.row] class]isSubclassOfClass:[NSDictionary class]]){
        return 54;
    }else{
        return 44;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.rowModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Fetch2TableViewCell * cell = [Fetch2TableViewCell cellWithTableView:tableView];
    
    cell.rightBtn.selected = (self.indexPath == indexPath);
    
    UIView * view = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView = view;
    
    // 当前为一级cell
    if([[self.rowModelArray[indexPath.row] class] isSubclassOfClass:[NSDictionary class]]){
        cell.nameLabel.text = nil;
        cell.rightImage.hidden = NO;
        cell.rightBtn.hidden = YES;
        view.backgroundColor = K_MAIN_COLOR;
        cell.backgroundColor = [UIColor colorWithWhite:0.925 alpha:1.000];
        cell.detailLabel.text = [NSString stringWithFormat:@"%@",[self.rowModelArray[indexPath.row] objectForKey:@"year"]];
    
    }else{
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",self.rowModelArray[indexPath.row]];
        cell.detailLabel.text = nil;
        cell.rightImage.hidden = YES;
        cell.rightBtn.hidden = NO;
        cell.backgroundColor = [UIColor whiteColor];
        view.backgroundColor = [UIColor colorWithWhite:0.908 alpha:1.000];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 如果是当前列表 就收起来，关闭二级
    if(self.indexPath == indexPath ){
        self.indexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
        [self.listTableView deselectRowAtIndexPath:indexPath animated:YES];
        [self removeSubCellIndexPath:indexPath];
        Fetch2TableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.rightBtn.selected = NO;
        
    }else{
        // 当前为其它类型列表，则展开新的二级
        if(![[self.rowModelArray[indexPath.row] class] isSubclassOfClass:[NSDictionary class]]){
            if(self.indexsArray.count){
                //原来有二级，先关闭原来二级
                //因为同一个区的下标乱了，如果同一个区，并且点击位于展开的后面 还要减掉
                Fetch2TableViewCell * cell = [tableView cellForRowAtIndexPath:self.indexPath];
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

#pragma mark - 查询二级
- (void)fetchLevel2With:(NSIndexPath *)indexPath{
    [self.listTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *searchListUrl = self.fetchUrl;
    searchListUrl = [searchListUrl stringByAppendingString:@"&emssion="];
    searchListUrl = [searchListUrl stringByAppendingString:self.rowModelArray[indexPath.row]];
    self.level5Brand = self.rowModelArray[indexPath.row];

    //中文要编码
    searchListUrl = [searchListUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self.NetworkUtil GET:searchListUrl inView:self.view success:^(id responseObject) {
        
        NSArray * carArray = [responseObject objectForKey:@"data"];
        
        [self.indexsArray removeLastObject];
        if (carArray.count) {
            [carArray enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL * _Nonnull stop) {
                NSIndexPath * index = [NSIndexPath indexPathForRow:indexPath.row+idx+1 inSection:indexPath.section];
                [self.rowModelArray insertObject:dic atIndex:indexPath.row+idx+1];
                [self.indexsArray addObject:index];
            }];
        }
        
        [self addSubCellIndexPath:indexPath];
        Fetch2TableViewCell * cell = [self.listTableView cellForRowAtIndexPath:indexPath];
        cell.rightBtn.selected = YES;
        [self.listTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    } failure:^(NSError *error) {
        self.indexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
        Fetch2TableViewCell * cell = [self.listTableView cellForRowAtIndexPath:indexPath];
        cell.rightBtn.selected = NO;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}



#pragma mark - 查询三级
- (void)fetchLevel3With:(NSIndexPath *)indexPath{
    
    NSString * carID = [self.rowModelArray[indexPath.row] objectForKey:@"carId"];
    GoodsListViewController * vc = [[GoodsListViewController alloc]init];
    vc.filterName = [NSString stringWithFormat:@"%@ %@ %@",self.filterName,self.level5Brand,[self.rowModelArray[indexPath.row] objectForKey:@"year"]];
    vc.filterType = GoodsFilterTypeCarSeries;
    vc.carSeriesId = carID;
    [self.navigationController pushViewController:vc animated:YES];
    
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
        [self.rowModelArray removeObjectAtIndex:index.row];
    }
    
    [self.listTableView beginUpdates];
    
    [self.listTableView deleteRowsAtIndexPaths:self.indexsArray withRowAnimation:UITableViewRowAnimationTop];
    
    [self.listTableView endUpdates];
    
    [self.indexsArray removeAllObjects];
}

@end
