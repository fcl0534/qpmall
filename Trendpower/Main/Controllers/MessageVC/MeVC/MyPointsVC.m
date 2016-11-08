//
//  MyPointsVC.m
//  Trendpower
//
//  Created by HTC on 16/2/27.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "MyPointsVC.h"

#import "ZFProgressView.h"

#import "MyPointsCell.h"
#import "MyPointsModel.h"
#import "PointsInfoModel.h"

@interface MyPointsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView * tableView;

/**  排序参数 */
/** 当前页码 */
@property(nonatomic, copy) NSString *currentPage;
/** 分页数量 1 */
@property(nonatomic, copy) NSString *pageSize;


/** 积分 */
@property (nonatomic, strong) MyPointsModel *myPointModel;

@property (nonatomic, strong) PointsInfoModel *pointsInfoModel;

@property (nonatomic, strong) ZFProgressView *progress;

@property (nonatomic, strong) UILabel * balancePoint;

@end

@implementation MyPointsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title= @"我的积分";
    self.currentPage = @"1";
    self.pageSize = @"10";

    [self myPointCycle];
}

#pragma mark - interface
- (void)myPointCycle {
    self.progress = [[ZFProgressView alloc] initWithFrame:CGRectMake(K_UIScreen_WIDTH/2 -180/2, 64+15, 180, 180)];
    [self.view addSubview:self.progress];
    [self.progress setBackgroundStrokeColor:[UIColor colorWithRed:0.046 green:0.674 blue:1.000 alpha:1.000]];
    [self.progress setProgressStrokeColor:[UIColor colorWithRed:1.000 green:0.388 blue:0.275 alpha:1.000]];
    [self.progress setProgress:0 Animated:NO];
    [self.progress setBackgourndLineWidth:7];
    [self.progress setProgressLineWidth:14];
    self.progress.step = 0.01;
    self.progress.progressViewSource = ZFProgressViewSourcePoint;

    UIView * cycle = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.progress.frame) +20, 8, 8)];
    cycle.backgroundColor = [UIColor colorWithRed:0.046 green:0.674 blue:1.000 alpha:1.000];
    cycle.layer.cornerRadius = 4;
    cycle.layer.masksToBounds = YES;
    [self.view addSubview:cycle];

    UILabel * credit = [[UILabel alloc]initWithFrame:CGRectMake(35, cycle.frame.origin.y  -30/2 +4, 100, 30)];
    credit.textColor = [UIColor colorWithWhite:0.137 alpha:1.000];
    credit.text = @"我的积分";
    [self.view addSubview:credit];

    self.balancePoint = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(credit.frame) +10, cycle.frame.origin.y -30/2 +4, K_UIScreen_WIDTH -CGRectGetMaxX(credit.frame) -25, 30)];
    self.balancePoint.textAlignment = NSTextAlignmentRight;
    self.balancePoint.textColor = [UIColor colorWithWhite:0.137 alpha:1.000];
    [self.view addSubview:self.balancePoint];

    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(credit.frame) +10, K_UIScreen_WIDTH, 0.8)];
    line.backgroundColor = [UIColor colorWithWhite:0.787 alpha:1.000];
    [self.view addSubview:line];


    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), K_UIScreen_WIDTH, K_UIScreen_HEIGHT -CGRectGetMaxY(line.frame)) style:UITableViewStylePlain];
    tableView.rowHeight = 85;
    [self.view addSubview:tableView];
    self.tableView = tableView;

    tableView.delegate = self;
    tableView.dataSource = self;

    tableView.tableFooterView = [UIView new];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyPointsCell class]) bundle:nil] forCellReuseIdentifier:@"MyPointsCell"];

//    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchMycredit)];
//    [self.tableView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
//    [self.tableView.header setStateHidden:YES];
//    self.tableView.header.updatedTimeHidden = YES;

    [self fetchPointsInfo];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pointsInfoModel.myPoints.count;
}

#pragma mark init cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //1.取出模型
    MyPointsModel * model = self.pointsInfoModel.myPoints[indexPath.row];

    //2.赋值
    MyPointsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyPointsCell"];
    cell.pointsModel = model;

    return cell;
}

#pragma mark - private method
#pragma mark - 积分信息
- (void)fetchPointsInfo {

    NSString *url=[API_ROOT stringByAppendingString:API_USER_Points];
    url = [url stringByAppendingFormat:@"userId=%@",self.userId];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    [self.NetworkUtil GET:url header:header success:^(id responseObject) {

        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            self.pointsInfoModel = [[PointsInfoModel alloc] initWithAttributes:responseObject];

            dispatch_async(dispatch_get_main_queue(), ^{

                [self.progress showBackgroundProgressAnimated:self.pointsInfoModel.totalPoint balance:self.pointsInfoModel.totalBalancePoint];

                if (self.pointsInfoModel.totalBalancePoint == 0) {
                    self.balancePoint.text = @"暂无积分";
                } else {
                    self.balancePoint.text = [NSString stringWithFormat:@"%.f",self.pointsInfoModel.totalBalancePoint];
                }

                [self.tableView reloadData];
            });

        } else {
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }

    } failure:^(NSError *error) {

        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
