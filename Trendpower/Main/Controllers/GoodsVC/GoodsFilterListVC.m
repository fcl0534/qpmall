//
//  GoodsFilterListVC.m
//  Trendpower
//
//  Created by HTC on 16/2/2.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "GoodsFilterListVC.h"

// vc
#import "GoodsFilterCarVC.h"
#import "GoodsFilterCateVC.h"
#import "GoodsFilterBrandVC.h"

#import "GoodsListViewController.h"
#import "GoodsFilterCateSecondVC.h"

@interface GoodsFilterListVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView * tableView;
/** 列表数据 */
@property (nonatomic, strong) NSArray * filterArray;

@property (nonatomic, strong) NSMutableArray * detailArray;

/** 分类Id,如果有，用于品牌筛选 */
@property (nonatomic, copy) NSString * cateId;
@property (nonatomic, copy) NSString * cateName;

@end

@implementation GoodsFilterListVC
- (NSArray *)filterArray{
    if (_filterArray == nil) {
        _filterArray = @[@[@"车型"],@[@"分类",@"品牌"]];
    }
    return _filterArray;
}

- (NSMutableArray *)detailArray{
    if (!_detailArray) {
        _detailArray = [NSMutableArray arrayWithArray:@[@"全部",@"全部",@"全部"]];
    }
    return _detailArray;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";

    self.cateId = @"";
    self.cateName = @"";
    
    self.navigationBar.rightTitle = @"确定";
    typeof(self) weakSelf = self;
    self.navigationBar.rightBlock= ^(){
        [weakSelf.yqNavigationController show:NO animated:YES];
        if (weakSelf.clickedConfirmBlock) {
            weakSelf.clickedConfirmBlock();
        }
    };
    
    [self initTableView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setDetailCell];
}


- (void)setDetailCell{
    for(int i = 0; i<self.arrayselectDics.count; i++) {
        NSDictionary * dic = self.arrayselectDics[i];
        NSInteger type = [[dic valueForKey:K_Filter_TYPE] integerValue];
            switch (type) {
                case GoodsFilterTypeCategory:// 商品分类
                    [self.detailArray replaceObjectAtIndex:1 withObject:[dic valueForKey:K_Filter_NAME]];
                    self.cateId = [dic valueForKey:K_Filter_VALVE];
                    self.cateName = [dic valueForKey:K_Filter_NAME];
                    break;
                case GoodsFilterTypeBrand: // 商品品牌
                    [self.detailArray replaceObjectAtIndex:2 withObject:[dic valueForKey:K_Filter_NAME]];
                    break;
                case GoodsFilterTypeCarSeries:// 车型的惟一号
                    [self.detailArray replaceObjectAtIndex:0 withObject:[dic valueForKey:K_Filter_NAME]];
                    break;
                case GoodsFilterTypeGoodsName:// 搜索名字
                    break;
                case GoodsFilterTypeCarBrand: // 车型的id
                    [self.detailArray replaceObjectAtIndex:0 withObject:[dic valueForKey:K_Filter_NAME]];
                    break;
                case GoodsFilterTypeCarModel: // 车型名称 【后面3种没有用到，因为要存储前面的类型】
                    [self.detailArray replaceObjectAtIndex:0 withObject:[dic valueForKey:K_Filter_NAME]];
                    break;
                case GoodsFilterTypeEmssion: // 车排量
                    [self.detailArray replaceObjectAtIndex:0 withObject:[dic valueForKey:K_Filter_NAME]];
                    break;
                case GoodsFilterTypeYear:// 车年份
                    [self.detailArray replaceObjectAtIndex:0 withObject:[dic valueForKey:K_Filter_NAME]];
                    break;
                default:
                    break;
            }
    }
    
    [self.tableView reloadData];
}

#pragma mark - initView
- (void)initTableView{
    CGSize size = self.yqNavigationController.frame.size;    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.rowHeight = 50;
//    tableView.sectionHeaderHeight = 1;
    tableView.sectionFooterHeight = 15;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    UIView * footerView = [[UIView alloc]init];
    self.tableView.tableFooterView = footerView;
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.filterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.filterArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"GoodsFilterListCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.filterArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.349 alpha:1.000];
    
    cell.detailTextLabel.text = indexPath.section?self.detailArray[indexPath.row+1]:self.detailArray[0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 ) {
        switch (indexPath.row) {
            case 0:{
                GoodsFilterCarVC *vc = [[GoodsFilterCarVC alloc] init];
                vc.arrayselectDics = self.arrayselectDics;
                vc.clickedConfirmBlock = ^(){
                    
                };
                [self.yqNavigationController pushYQViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                //当前是否有 cateid，有直接到三级分类
                if (self.cateId.length) {
                    
                    // 有分类，显示二级分类
                    [self fetchSecondCate];
                    
                } else {
                    // 无分类，显示一级分类
                    GoodsFilterCateVC *vc = [[GoodsFilterCateVC alloc] init];
                    vc.arrayselectDics = self.arrayselectDics;
                    vc.clickedConfirmBlock = ^(){
                        
                    };
                    [self.yqNavigationController pushYQViewController:vc animated:YES];
                }
                
                break;
            }
            case 1:{
                GoodsFilterBrandVC *vc = [[GoodsFilterBrandVC alloc] init];
                vc.cateId = self.cateId;
                vc.arrayselectDics = self.arrayselectDics;
                vc.clickedConfirmBlock = ^(){
                    
                };
                [self.yqNavigationController pushYQViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }
}

- (void)fetchSecondCate {
    //ttp://api.qpfww.com/categorys/商品分类ID?userId=
    NSString *url=[API_ROOT stringByAppendingString:API_CATEGORY_Fetch];
    if (self.cateId.length) {
        url = [url stringByAppendingString:self.cateId];
    }
    
    NSString * userId = [UserDefaultsUtils getUserId];
    if (userId.length) {
        url = [url stringByAppendingFormat:@"?userId=%@",userId];
    }
    
    NetworkingUtil * network = [NetworkingUtil sharedNetworkingUtil];
    [network GET:url inView:self.view success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            
            NSDictionary * dataListArray = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            
            /** 构造一个跟原来模型一样的json，然后就不用更改逻辑
             "icon": "http://assets.qpfww.com/goodscategory/10101456736701.png",
             "id": "38",
             "is_parent": "1",
             "parent_id": "0",
             "sort": "1",
             "title": "冷却系统",
             "sub_cate_list": [
             
             */
            NSDictionary * categoryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"",@"icon",
                                          self.cateId,@"id",
                                          @"",@"is_parent",
                                          @"",@"parent_id",
                                          @"",@"sort",
                                          self.cateName,@"title",
                                          dataListArray,@"sub_cate_list", nil];
            CateModel *cateModel = [[CateModel alloc] initWithAttributes:categoryDic];
            
            GoodsFilterCateSecondVC *vc = [[GoodsFilterCateSecondVC alloc] init];
            vc.selectCateModel = cateModel;
            vc.isFirstPush = YES;
            vc.arrayselectDics = self.arrayselectDics;
            vc.clickedConfirmBlock = ^(){
                
            };
            [self.yqNavigationController pushYQViewController:vc animated:YES];
        }else{
            HUDUtil * hud = [HUDUtil sharedHUDUtil];
            [hud showTextMBHUDWithText:[responseObject objectForKey:@"data"] delay:2.0 inView:self.view];
        }
        
    } failure:^(NSError *error) {
        HUDUtil * hud = [HUDUtil sharedHUDUtil];
        [hud showNetworkErrorInView:self.view];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
