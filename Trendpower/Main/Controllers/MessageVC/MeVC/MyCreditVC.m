//
//  MyCreditVC.m
//  Trendpower
//
//  Created by HTC on 16/2/27.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "MyCreditVC.h"

#import "ZFProgressView.h"

#import "MyCreditTableCell.h"

@interface MyCreditVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView * tableView;

/**  排序参数 */
/** 当前页码 */
@property(nonatomic, copy) NSString *currentPage;
/** 分页数量 1 */
@property(nonatomic, copy) NSString *pageSize;

/**  商品列表模型 */
@property(nonatomic, strong) NSMutableArray * creditListArray;

@end

@implementation MyCreditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title= @"我的信用";
    self.currentPage = @"1";
    self.pageSize = @"10";
    
    [self myCreditCycle];
}

#pragma mark - interface
- (void)myCreditCycle{
    ZFProgressView *progress = [[ZFProgressView alloc] initWithFrame:CGRectMake(K_UIScreen_WIDTH/2 -180/2, 64+15, 180, 180)];
    [self.view addSubview:progress];
    [progress setBackgroundStrokeColor:[UIColor colorWithRed:0.046 green:0.674 blue:1.000 alpha:1.000]];
    [progress setProgressStrokeColor:[UIColor colorWithRed:1.000 green:0.388 blue:0.275 alpha:1.000]];
    [progress setProgress:0 Animated:NO];
    [progress setBackgourndLineWidth:7];
    [progress setProgressLineWidth:14];
    progress.step = 0.01;
    [progress showBackgroundProgressAnimated:[self.userModel.totalCredit floatValue] balance:[self.userModel.balanceCredit floatValue]];
    progress.progressViewSource = ZFProgressViewSourceCredit;
    
    UIView * cycle = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(progress.frame) +20, 8, 8)];
    cycle.backgroundColor = [UIColor colorWithRed:0.046 green:0.674 blue:1.000 alpha:1.000];
    cycle.layer.cornerRadius = 4;
    cycle.layer.masksToBounds = YES;
    [self.view addSubview:cycle];
    
    UILabel * credit = [[UILabel alloc]initWithFrame:CGRectMake(35, cycle.frame.origin.y  -30/2 +4, 100, 30)];
    credit.textColor = [UIColor colorWithWhite:0.137 alpha:1.000];
    credit.text = @"可用额度";
    [self.view addSubview:credit];
    
    UILabel * balanceCredit = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(credit.frame) +10, cycle.frame.origin.y -30/2 +4, K_UIScreen_WIDTH -CGRectGetMaxX(credit.frame) -25, 30)];
    balanceCredit.textAlignment = NSTextAlignmentRight;
    balanceCredit.textColor = [UIColor colorWithWhite:0.137 alpha:1.000];
    balanceCredit.text = [NSString stringWithFormat:@"￥%@",self.userModel.balanceCredit];
    [self.view addSubview:balanceCredit];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(credit.frame) +10, K_UIScreen_WIDTH, 0.8)];
    line.backgroundColor = [UIColor colorWithWhite:0.787 alpha:1.000];
    [self.view addSubview:line];
    
    
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), K_UIScreen_WIDTH, K_UIScreen_HEIGHT -CGRectGetMaxY(line.frame)) style:UITableViewStylePlain];
//    tableView.backgroundColor = K_LINEBG_COLOR;
//    tableView.sectionHeaderHeight = 10;
//    tableView.sectionFooterHeight = 5;
    tableView.rowHeight = 85;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.tableFooterView = [UIView new];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchMycredit)];
    [self.tableView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
    [self.tableView.header setStateHidden:YES];
    self.tableView.header.updatedTimeHidden = YES;
    
    [self fetchMycredit];
}

- (void)fetchMycredit{

//    [self.tableView.footer resetNoMoreData];

    NSString *url=[API_ROOT stringByAppendingString:API_MY_Credits];
    url = [url stringByAppendingFormat:@"userId=%@&page=1&pageSize=%@",self.userId, self.pageSize];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    
    [self.NetworkUtil GET:url header:header success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            //1.
            //2.
            [self.creditListArray removeAllObjects];
            
            //3.解析产品
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSDictionary * pageData = [dataDic objectForKey:@"pageData"];
            NSArray * lists = [pageData objectForKey:@"lists"];
            for (NSDictionary *dic in lists){
                MyCreditModel *model = [[MyCreditModel alloc] initWithAttributes:dic];
                [self.creditListArray addObject:model];
            }
            
            //4.判断是否还有更多产品
            NSInteger totalPage = [[pageData objectForKey:@"totalPage"] integerValue];
            if (totalPage == 1 || totalPage == 0 ||self.creditListArray.count) {
                [self.tableView.footer noticeNoMoreData];
            }else{
                [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreCreditData)];
            }
            
            // 5.刷新
            [self.tableView reloadData];
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {

        [self.tableView.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


- (void)loadMoreCreditData{
    
    NSString *url=[API_ROOT stringByAppendingString:API_MY_Credits];
    url = [url stringByAppendingFormat:@"userId=%@&page=%d&pageSize=%@",self.userId,[self.currentPage intValue] +1, self.pageSize];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    
    
    [self.NetworkUtil GET:url header:header success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            
            //1.解析产品
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSDictionary * pageData = [dataDic objectForKey:@"pageData"];
            NSArray * lists = [pageData objectForKey:@"lists"];
            for (NSDictionary *dic in lists){
                MyCreditModel *model = [[MyCreditModel alloc] initWithAttributes:dic];
                [self.creditListArray addObject:model];
            }
            
            //2.判断是否还有更多产品
            NSInteger totalPage = [[dataDic objectForKey:@"totalPage"] integerValue];
            if (totalPage == [self.currentPage integerValue]) {
                [self.tableView.footer noticeNoMoreData];
            }else{
                self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] +1];
            }
            
            //3.
            self.currentPage = [NSString stringWithFormat:@"%d",[self.currentPage intValue] +1];
            
            // 4.刷新
            [self.tableView reloadData];
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {

        [self.tableView.footer endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.creditListArray.count;
}

#pragma mark init cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1.取出模型
    MyCreditModel * model = self.creditListArray[indexPath.row];
    
    //2.赋值
    MyCreditTableCell * cell = [MyCreditTableCell cellWithTableView:tableView];
    cell.myCreditModel = model;
    cell.indexPath = indexPath;
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - setting/getting
- (NSMutableArray *)creditListArray{
    if (!_creditListArray) {
        _creditListArray = [NSMutableArray array];
    }
    
    return _creditListArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
