//
//  MeVC.m
//  Trendpower
//
//  Created by HTC on 16/1/20.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "MeViewController.h"

//model
#import "UserInfoModel.h"

// view
#import "MeHeaderView.h"
#import "MeBaseTableViewCell.h"
#import "MeOrderTableViewCell.h"

// vc
#import "LoginVC.h"
#import "SettingVC.h"
#import "UserInfoEditVC.h"
#import "SearchVC.h"
#import "MoreVC.h"
#import "FavoriteVC.h"
#import "CouponVC.h"
#import "MyCreditVC.h"
#import "QPMOrderListViewController.h"
#import "MyPointsVC.h"
#import "AddressListVC.h"
#import "MessageVC.h"
#import "PointsMallVC.h"
#import "MessageListVC.h"

@interface MeViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MeHeaderViewDelegate, MeOrderCellDelegate>

@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, weak) MeHeaderView * headerView;

/** 用户数据模型 */
@property (nonatomic, strong) UserInfoModel * userInfoModel;

/**
 *  客服电话
 */
@property (nonatomic, copy) NSString * cellPhone;

// 常量数组
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * detailArray;
@property (nonatomic, strong) NSArray * iconArray;


@end

@implementation MeViewController
#pragma mark - Life cycle   ###


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    //检查登录状态
    [self checkLogin];
    
    [self featchCustomerData];
    // 3.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BackHomeView) name:K_NOTIFI_BACK_HOME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHomeSearchView) name:@"BackHomeSearchView" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_NOTIFI_BACK_HOME object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BackHomeSearchView" object:self];
}

#pragma mark - Interface   ###

- (void)initTableView{
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -48) style:UITableViewStyleGrouped];
    tableView.backgroundColor = K_LINEBG_COLOR;
    tableView.sectionHeaderHeight = 10;
    tableView.sectionFooterHeight = 5;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    MeHeaderView * headerView = [[MeHeaderView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 270)];
    headerView.delegate = self;
    self.headerView = headerView;
    tableView.tableHeaderView = headerView;
    
//    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchUserInfo)];
//    [self.tableView.header setTitle:@"正在刷新..." forState:MJRefreshHeaderStateRefreshing];
//    [self.tableView.header setStateHidden:YES];
//    [self.tableView.header setTintColor:[UIColor whiteColor]];
//    [self.tableView.header setTextColor:[UIColor whiteColor]];
//    self.tableView.header.updatedTimeHidden = YES;
    
}


#pragma mark - UITableViewDelegate
#pragma mark - Delegate
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * titiles = self.titleArray[section];
    return [titiles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    switch (indexPath.section) {
        case 0:
            rowHeight = 115;
            break;
        case 1:
        case 2:
            rowHeight = 48;
            break;
        default:
            rowHeight = 48;
            break;
    }
    return rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell;
    switch (indexPath.section) {

        case 0:{
            MeOrderTableViewCell * cell0 = (MeOrderTableViewCell*)[MeOrderTableViewCell cellWithTableView:tableView];
            cell0.leftImageView.image = [UIImage imageNamed:self.iconArray[indexPath.section][indexPath.row]];
            cell0.nameLbl.text = self.titleArray[indexPath.section][indexPath.row];
            cell0.detailLbl.text = self.detailArray[indexPath.section][indexPath.row];
            cell0.selectionStyle = UITableViewCellSelectionStyleNone;
            cell0.delegate = self;
            // 标志数量
//            cell0.badegView0.badgeText = [self.meInfoModel.dfk integerValue] ? self.meInfoModel.dfk : nil;
//            cell0.badegView1.badgeText = [self.meInfoModel.dfh integerValue] ? self.meInfoModel.dfh : nil;
//            cell0.badegView2.badgeText = [self.meInfoModel.yfh integerValue] ? self.meInfoModel.yfh : nil;
//            cell0.badegView3.badgeText = [self.meInfoModel.ysh integerValue] ? self.meInfoModel.ysh : nil;
//            cell0.badegView4.badgeText = [self.meInfoModel.thh integerValue] ? self.meInfoModel.thh : nil;
            cell = cell0;
            break;
        }
        case 1:
        case 2:{
            MeBaseTableViewCell * cell1 = [MeBaseTableViewCell cellWithTableView:tableView];

            cell1.leftImageView.image = [UIImage imageNamed:self.iconArray[indexPath.section][indexPath.row]];

            cell1.nameLbl.text = self.titleArray[indexPath.section][indexPath.row];

            cell1.detailLbl.text = self.detailArray[indexPath.section][indexPath.row];

            cell1.selectionStyle = UITableViewCellSelectionStyleDefault;

            if ([cell1.nameLbl.text isEqualToString:@"客服电话"]) {
                cell1.detailLbl.textColor = K_MAIN_COLOR;
                cell1.detailLbl.text = self.cellPhone;
            }
            cell = cell1;
            break;
        }
        default:
            break;
    }
    
    cell.imageView.image = [UIImage imageNamed:@"my_empty"];
    cell.imageView.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        MoreVC * vc = [[MoreVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row == 3){
        if (self.cellPhone.length) {
            [self.HUDUtil showAlertViewWithTitle:@"确定拨打客服电话？" mesg:nil cancelTitle:@"取消" confirmTitle:@"确定" tag:123];
            typeof(self) weakSelf = self;
            self.HUDUtil.clickedAlertViewBlock = ^(_Nullable id hudView, NSInteger clickedIndex, NSInteger tag){
                if(clickedIndex == 1){ //确定
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",weakSelf.cellPhone]]];
                }
            };
        }else{
            [self featchCustomerData];
        }
        return;
    }
    
    // 判断是否登陆
    if(!self.isUserLogined){
        self.headerView.isLogin = NO;
        [self gotoLogin];
        return;
    }
    
    if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0: {//我的积分
                MyPointsVC *VC = [[MyPointsVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
                break;
            }
            case 1: {//积分商城
                PointsMallVC *vc = [[PointsMallVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];

                break;
            }
            case 2:{//收货地址
                AddressListVC *VC = [[AddressListVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
                break;
            }
            case 3:{//客服电话
                
                break;
            }
            default:
                break;
        }
    }
}


#pragma mark - Event response   ###
#pragma mark 头部编辑按钮点击事件
-(void)meHeaderViewclickedEdit{
    if(!self.isUserLogined){
        self.headerView.isLogin = NO;
        [self gotoLogin];
        return;
    }
    
    UserInfoEditVC *VC = [[UserInfoEditVC alloc]init];
    VC.userModel = self.userInfoModel;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)meHeaderViewClickedNaviBarButton:(UIButton *)btn{
    if(!self.isUserLogined){
        self.headerView.isLogin = NO;
        [self gotoLogin];
        return;
    }
    
    switch (btn.tag) {
        case 1:{//设置
            SettingVC * vc = [[SettingVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{//消息
            MessageListVC * vc = [[MessageListVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


- (void)meHeaderViewClickedLoginButton:(UIButton *)btn{
    if(!self.isUserLogined){
        self.headerView.isLogin = NO;
        [self gotoLogin];
        return;
    }
    
    switch (btn.tag) {
        case 0:{//我的收藏
            FavoriteVC *VC = [[FavoriteVC alloc]init];
            VC.userModel = self.userInfoModel;
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case 1:{//优惠券
            CouponVC *VC = [[CouponVC alloc]init];
            VC.userModel = self.userInfoModel;
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case 2:{//我的信用
            MyCreditVC *VC = [[MyCreditVC alloc]init];
            VC.userModel = self.userInfoModel;
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case 100:{ //登录
            [self gotoLogin];
            break;
        }
        default:
            break;
    }
}

/**
 * type= 0 我的订单
 * type= 1 待付款订单
 * type= 2 待收货订单
 * type= 5 退换货订单
 */
- (void)meOrderCellClickedBtn:(UIButton *)btn withIndexPath:(NSIndexPath *)indexPath{
    if(!self.isUserLogined){
        self.headerView.isLogin = NO;
        [self gotoLogin];
        return;
    }
    
    QPMOrderListViewController *vc=[[QPMOrderListViewController alloc] init];
    vc.selectIndex = btn.tag;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private method   ###
- (void)BackHomeView{

    self.tabBarController.selectedIndex = 0;
}

- (void)backHomeSearchView{
    
    if(self.tabBarController.selectedIndex == 0){
        return;
    }
    
    self.tabBarController.selectedIndex = 0;
    SearchVC *vc = [[SearchVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark 检查登录状态
-(void) checkLogin{
    
    if(self.isUserLogined){
        self.headerView.isLogin = YES;
        [self fetchUserInfo];
    }else{
        self.headerView.isLogin = NO;
        //self.meInfoModel = nil;
        [self.tableView.header endRefreshing];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:NO];
    }
}

#pragma mark 请求网络用户信息
- (void)fetchUserInfo{
    
    NSString *url=[API_ROOT stringByAppendingString:API_USER_INFO];
    url = [url stringByAppendingFormat:@"userId=%@",self.userId];
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];


    [self.NetworkUtil GET:url header:header success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            // 1.
            self.userInfoModel = [[UserInfoModel alloc]initWithAttributes:responseObject];
        
            self.headerView.nameLbl.text = ![self.userInfoModel.userRealname isEqual: @""] ?self.userInfoModel.userRealname : self.userInfoModel.userPhone;
            self.headerView.detailLbl.text = self.userInfoModel.usercategoryName;
            self.headerView.button2.topText = self.userInfoModel.balanceCredit;
            self.headerView.button0.topText = self.userInfoModel.collectionCount;
            
        }else if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] hasPrefix:@"4217"]){
            [self setUserLogout];
            [self gotoLogin];
        }
        else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {

        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark 客服电话
- (void)featchCustomerData{
    
    NSString *coustomerUrl = [API_ROOT stringByAppendingString:API_USER_COUSTOMER];
    
    [self.NetworkUtil GET:coustomerUrl success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            // 1.total
            NSDictionary * dic = [responseObject objectForKey:@"data"];
            
            self.cellPhone = [dic objectForKey:@"phone"];
            
            [self.tableView reloadData];
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}

#pragma mark - Delegate   ###

#pragma mark - 下拉放大
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //NSLog(@"---   %f",scrollView.contentOffset.y);
    
    CGFloat yOffset   = scrollView.contentOffset.y;
    
    [self.headerView setBGImageOffset:yOffset];
    
//    //加载数据
    if (yOffset == -60) {
        [self fetchUserInfo];
    }
    
}

#pragma mark - Getters and Setters
- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@[@"我的订单"],@[@"我的积分",@"积分商城",@"收货地址",@"客服电话"],@[@"关于我们"]];
    }
    return _titleArray;
}

- (NSArray *)detailArray{
    if (_detailArray == nil) {
        _detailArray = @[@[@""],@[@"",@"",@"",@""],@[@""]];
    }
    return _detailArray;
}

- (NSArray *)iconArray{
    if (_iconArray == nil) {
        _iconArray = @[@[@""],@[@"points",@"my_point",@"my_home_shouhuoAddress",@"my_home_kehufuwu"],@[@"account_head"]];
    }
    return _iconArray;
}


#pragma mark - Others   ###
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
