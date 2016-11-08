//
//  GoodsFilterCateVC.m
//  Trendpower
//
//  Created by HTC on 16/2/4.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "GoodsFilterCateVC.h"

// tool

#import "MJRefresh.h"

#import "NetworkingUtil.h"
#import "HUDUtil.h"
#import "WebImageUtil.h"

//model
#import "CateModelArray.h"

// view
#import "CateTableViewCell.h"
#import "CateSliderView.h"
#import "CateCollectionViewCell.h"

// vc
#import "GoodsFilterCateSecondVC.h"


#define K_Filter_TYPE @"K_Filter_TYPE"
#define K_Filter_NAME @"K_Filetr_NAME"
#define K_Filter_VALVE @"K_FIletr_VALVE"

typedef NS_ENUM(NSUInteger, GoodsFilterType) {
    GoodsFilterTypeNone = 0,  // 没有
    GoodsFilterTypeCategory,  // 商品分类
    GoodsFilterTypeBrand,     // 商品品牌
    GoodsFilterTypeCarSeries, // 车型的惟一号
    GoodsFilterTypeGoodsName, // 搜索名字
    GoodsFilterTypeCarBrand,  // 车型的id
    GoodsFilterTypeCarModel,  // 车型名称
    GoodsFilterTypeEmssion,   // 车排量
    GoodsFilterTypeYear,      // 车年份
};

@interface GoodsFilterCateVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView * tableView;

@property (nonatomic, strong) CateModelArray * modelArray;

@property (nonatomic, strong) CateModel * selectCateModel;

@end

@implementation GoodsFilterCateVC



#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配件分类";
    self.navigationBar.barTintColor = K_MAIN_COLOR;
    
    [self initTableView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationBar.leftTitle = @"返回";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.modelArray.cateArray.count ? : [self fetchCateList];
}


#pragma mark - Interface
- (void)initTableView{
    CGSize size = self.yqNavigationController.frame.size;
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height -64) style:UITableViewStylePlain];
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



#pragma mark - privite theme
- (void)fetchCateList{
    NSString *cateListUrl=[API_ROOT stringByAppendingString:API_CATEGORY];
    DLog(@"API_CATEGORY----%@",cateListUrl);
    NetworkingUtil * network = [NetworkingUtil sharedNetworkingUtil];
    HUDUtil * hud = [HUDUtil sharedHUDUtil];

    [network GET:cateListUrl inView:self.view success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            self.modelArray = [[CateModelArray alloc]initWithAttributes:responseObject];
            [self.tableView reloadData];
        }else{
            [hud showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [hud showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 事件


#pragma mark - delegate
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
    
    CateModel * model = self.modelArray.cateArray[indexPath.row];

    self.selectCateModel = model;
    
    CateSubModel * submodel = self.selectCateModel.cateSubArray[0];
    if(self.selectCateModel.cateSubArray.count == 1 && [submodel.cateName isEqualToString:@"全部"]){
        // 没有子类，直接返回
        NSString * filterName = self.selectCateModel.cateName;
        NSString * cateId = [NSString stringWithFormat:@"%ld",self.selectCateModel.cateId];
        
        BOOL isFild = NO; //标志是否已经存在的类型，存在替换就可以
        for(int i = 0; i<self.arrayselectDics.count; i++) {
            NSMutableDictionary * dic = self.arrayselectDics[i];
            NSInteger type = [[dic valueForKey:K_Filter_TYPE] integerValue];
            switch (type) {
                case GoodsFilterTypeCategory:
                    isFild = YES;
                    [dic setValue:filterName forKey:K_Filter_NAME];
                    [dic setValue:cateId forKey:K_Filter_VALVE];
                    [dic setValue:@(GoodsFilterTypeCategory) forKey:K_Filter_TYPE];
                    break;
                default:
                    break;
            }
        }
        
        if (!isFild) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjects:@[@(GoodsFilterTypeCategory),filterName,cateId] forKeys:@[K_Filter_TYPE,K_Filter_NAME,K_Filter_VALVE]];
            [self.arrayselectDics addObject:dic];
        }
        
       [self.yqNavigationController popYQViewControllerAnimated:YES];
    }else{
        GoodsFilterCateSecondVC *vc = [[GoodsFilterCateSecondVC alloc] init];
        vc.selectCateModel = model;
        vc.arrayselectDics = self.arrayselectDics;
        typeof(self) weakSelf = self;
        vc.clickedConfirmBlock = ^(){
            // 确定数据返回
            [weakSelf.yqNavigationController popYQViewControllerAnimated:YES];
        };
        [self.yqNavigationController pushYQViewController:vc animated:YES];
    }

}

#pragma mark - get/set
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
