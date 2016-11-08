//
//  GoodsFilterBrandVC.m
//  Trendpower
//
//  Created by HTC on 16/2/4.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "GoodsFilterBrandVC.h"

// tool

#import "MJRefresh.h"

#import "NetworkingUtil.h"
#import "HUDUtil.h"
#import "WebImageUtil.h"

//vc
#import "GoodsListViewController.h"
#import "SearchVC.h"


//model
#import "CarTypeLevel1Model.h"

//view
#import "BrandFilterCell.h"

#define K_Filter_TYPE @"K_Filter_TYPE"
#define K_Filter_NAME @"K_Filetr_NAME"
#define K_Filter_VALVE @"K_FIletr_VALVE"


@interface GoodsFilterBrandVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *listTableView;

/**
 *  索引
 */
@property (nonatomic, strong) NSArray *sectionTitleArray;
/**
 *  存储模型，二维数组
 */
@property (nonatomic, strong) NSMutableArray *rowModelArray;

/**
 *  存储选中的模型，数组
 */
@property (nonatomic, strong) NSMutableArray *selectModelArray;

@end

@implementation GoodsFilterBrandVC
- (NSMutableArray *)rowModelArray{
    if (_rowModelArray == nil) {
        _rowModelArray = [NSMutableArray array];
    }
    return _rowModelArray;
}

-(NSMutableArray *)selectModelArray{
    if (!_selectModelArray) {
        _selectModelArray = [NSMutableArray array];
    }
    return _selectModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌";
    self.navigationBar.barTintColor = K_MAIN_COLOR;
    
    self.navigationBar.rightTitle = @"确定";
    typeof(self) weakSelf = self;
    self.navigationBar.rightBlock= ^(){
        [weakSelf setFilterValue];
        [weakSelf.yqNavigationController popYQViewControllerAnimated:YES];
    };
    
    [self initTableView];
    [self fetchLevel1];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationBar.leftTitle = @"返回";
}

- (void)setFilterValue{
    
    NSString * filterName = @"";
    NSString * brandId = @"";
    
    // 搜到全部选中的品牌
    for (int i = 0; i<self.selectModelArray.count; i++) {
        CarTypeLevel1Model * model = self.selectModelArray[i];
        if (i == 0) {
            filterName = model.brand;
            brandId = model.keyId;
        }else{
            filterName = [filterName stringByAppendingFormat:@",%@",model.brand];
            brandId = [brandId stringByAppendingFormat:@",%@",model.keyId];
        }
    }
    
    
    BOOL isFild = NO; //标志是否已经存在的类型，存在替换就可以
    for(int i = 0; i<self.arrayselectDics.count; i++) {
        NSMutableDictionary * dic = self.arrayselectDics[i];
        NSInteger type = [[dic valueForKey:K_Filter_TYPE] integerValue];
        switch (type) {
            case GoodsFilterTypeBrand:
                isFild = YES;
                [dic setValue:filterName forKey:K_Filter_NAME];
                [dic setValue:brandId forKey:K_Filter_VALVE];
                [dic setValue:@(GoodsFilterTypeBrand) forKey:K_Filter_TYPE];
                break;
            default:
                break;
        }
    }
    
    if (!isFild) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjects:@[@(GoodsFilterTypeBrand),filterName,brandId] forKeys:@[K_Filter_TYPE,K_Filter_NAME,K_Filter_VALVE]];
        [self.arrayselectDics addObject:dic];
    }
}

- (void)fetchLevel1{
    
    [self.selectModelArray removeAllObjects];
    
    //http://api.qpfww.com/goods/brands?161
    NSString *brandUrl=[API_ROOT stringByAppendingString:API_BRANDS];
    
    if (self.cateId.length) {
        brandUrl = [brandUrl stringByAppendingString:self.cateId];
    }

    NSString *isLogin=[UserDefaultsUtils getValueByKey:KTP_ISLOGIN];

    if([isLogin isEqualToString:@"YES"]){

        brandUrl = [brandUrl stringByAppendingString:[NSString stringWithFormat:@"?userId=%@",[UserDefaultsUtils getUserId]]];
    }

    NetworkingUtil * network = [NetworkingUtil sharedNetworkingUtil];
    [network GET:brandUrl inView:self.view success:^(id responseObject) {
        
        //NSDictionary * dataArray = [responseObject objectForKey:@"retval"];
        NSDictionary * dataArray = [responseObject objectForKey:@"data"];
        //http://api.qpfww.com/goods/brands/90
        if(dataArray.count){
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
        }else{
            HUDUtil * hud = [HUDUtil sharedHUDUtil];
            [hud showTextMBHUDWithText:@"没有可筛选品牌！" delay:2.0 inView:self.view];
        }
        
        [self.listTableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.listTableView.header endRefreshing];
        HUDUtil * hud = [HUDUtil sharedHUDUtil];
        [hud showNetworkErrorInView:self.view];
    }];
}


- (void)initTableView{
    
    CGSize size = self.yqNavigationController.frame.size;
    UITableView * listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height -64) style:UITableViewStylePlain];
    self.listTableView = listTableView;
    self.listTableView.backgroundColor = K_GREY_COLOR;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    BrandFilterCell * cell = [BrandFilterCell cellWithTableView:tableView];
    CarTypeLevel1Model * model = self.rowModelArray[indexPath.section][indexPath.row];
    [WebImageUtil setImageWithURL:model.brand_logo placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:cell.iconView];
    cell.selectBtn.selected = model.isSelectBrand;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.brand];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CarTypeLevel1Model * model = self.rowModelArray[indexPath.section][indexPath.row];
    if (model.isSelectBrand) {//取消选中
        [self.selectModelArray removeObject:model];
        model.isSelectBrand = NO;
        [self.listTableView reloadData];
    }else{ //当前为未选中状态
        // 判断是否已经有5个选中
        if(self.selectModelArray.count == 5){
            HUDUtil * hud = [HUDUtil sharedHUDUtil];
            [hud showAlertViewWithTitle:@"选择不超过5个哦！" mesg:nil cancelTitle:@"确定" confirmTitle:nil tag:1];
        }else{
            model.isSelectBrand = YES;
            [self.selectModelArray addObject:model];
            [self.listTableView reloadData];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
