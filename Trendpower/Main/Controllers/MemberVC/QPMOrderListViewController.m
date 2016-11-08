//
//  PaymentOrderVC.m
//  Trendpower
//
//  Created by HTC on 15/5/11.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//


#import "QPMOrderListViewController.h"
// model
#import "OrderModel.h"
// view
#import "PaymentOrderCell.h"
#import "OrderGoodsListView.h"
#import "XLScrollViewer.h"
#import "QPMCancelOrderView.h"

// vc
//#import "PaymentSubmitVC.h"
#import "ProductDetailVC.h"
#import "PaymentPayVC.h"
#import "QPMPaymentSubmitViewController.h"

@interface QPMOrderListViewController()<UITableViewDataSource,UITableViewDelegate,EmptyPlaceholderViewDelegate, PaymentOrderCellDelegate, XLScrollViewerDelegete, UIScrollViewDelegate, HUDAlertViewDelegate,QPMCancelOrderViewDelegate>
{
    NSString *_cancelReasonStr;

    NSIndexPath *_cancelIndx;
}

@property (nonatomic, weak) EmptyPlaceholderView *emptyView;

@property(nonatomic ,strong) XLScrollViewer * mainScrollView;//如果无需外部调用XLScrollViewer的属性，则无需写此属性


/** tableView数组 status订单状态（空为全部 10货到付款  11 等待买家付款 20买家已付款，等待卖家发货  30卖家已发货   40交易成功   0交易已取消 ） */
@property (nonatomic, strong) NSMutableArray * tableViewArray;


/** 订单模型数组 */
@property (nonatomic, strong) NSMutableArray * orderArray;


/** 记录 当前点击的cell下标 数组 */
@property (nonatomic, strong) NSMutableArray * showIndexPathArray;

/**
 *  判断当前点击cell时 是否要显示全部商品
 */
@property (nonatomic, strong) NSMutableArray * isShowAllGoodsArray;

/**
 *  记录全部标签的当前页数
 */
@property (nonatomic, strong) NSMutableArray * pageArray;

/**
 *  当前在点击标签
 */
@property (nonatomic, assign) BOOL isTapTag;

/** 取消订单背景view */
@property (nonatomic, strong) UIView *cancelView;

@end

@implementation QPMOrderListViewController


#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"全部订单";

    [self initMainScrollView];
   
    [self initEmptyView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - 空视图
- (void)initEmptyView{
    if (self.emptyView == nil) {
        EmptyPlaceholderView * emptyView = [[EmptyPlaceholderView alloc]initWithFrame:CGRectMake(0, 64+44, K_UIScreen_WIDTH, K_UIScreen_HEIGHT) placeholderText:@"你还没有相关订单" placeholderIamge:[UIImage imageNamed:@"order_null_bg"] btnName:nil];
        self.emptyView = emptyView;
        emptyView.delegate = self;
        [self.mainScrollView addSubview:emptyView];
    }
    self.emptyView.hidden = YES;
}


#pragma mark - 空点击事件
- (void)EmptyPlaceholderViewClickedButton:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_BACK_HOME object:nil];
}


#pragma mark - initView
- (void)initMainScrollView{
    // 1.
    self.emptyView.hidden = YES;
    
    // 2.对应填写两个数组
    [self initTableView];
    //status订单状态（0为全部 1等待买家付款 2买家已付款，等待卖家发货  30卖家已发货   40交易成功   0交易已取消 ）
    NSArray *names =@[@" 全部 ",@"待付款",@"待发货",@"待收货",@"已完成"];
    
    // 3.创建使用
    self.mainScrollView =[XLScrollViewer scrollWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) withViews:self.tableViewArray withButtonNames:names withThreeAnimation:211 selectIndex:self.selectIndex];//三中动画都选择
    self.mainScrollView.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1.000];
    self.mainScrollView.delegate = self;
    
    // 4.自定义各种属性
    self.mainScrollView.xl_topBackColor =[UIColor whiteColor];
    self.mainScrollView.xl_sliderColor =[UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
    self.mainScrollView.xl_buttonColorNormal =[UIColor colorWithWhite:0.200 alpha:1.000];
    self.mainScrollView.xl_buttonColorSelected =[UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
    self.mainScrollView.xl_buttonFont =16;
    self.mainScrollView.xl_buttonToSlider =2;
    self.mainScrollView.xl_sliderHeight =2;
    self.mainScrollView.xl_topHeight =44;
    self.mainScrollView.xl_isSliderCorner =NO;
    
    //加入控制器视图
    [self.view addSubview:self.mainScrollView];

    [self fetchPaymentList];
}


- (void)initTableView{
    
    for (int i = 0; i <5; i++){
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) style:UITableViewStylePlain];
        tableView.backgroundColor = K_GREY_COLOR;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc]init];
        
        [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchPaymentList)];
        [tableView.header setTitle:@"正在刷新，请稍候..." forState:MJRefreshHeaderStateRefreshing];
        tableView.header.updatedTimeHidden = YES;
        
        [self.tableViewArray addObject:tableView];
    }
}


#pragma mark - 隐藏全部TableView
- (void)hideTableView{
    for(UITableView *table in self.tableViewArray) {
        table.hidden = YES;
    }
}

#pragma mark - 
- (void)XLScrollViewerSelectIdexPath:(NSInteger)index{
    
    self.isTapTag = YES;
    
    // 1.
    UITableView * tableView = self.tableViewArray[self.selectIndex];
    tableView.scrollEnabled = NO;
    // 1.
    self.selectIndex = index;

    // 2.
    self.emptyView.hidden = YES;
    // 3.
    NSMutableArray * modelArray = self.orderArray[self.selectIndex];
    if (modelArray.count == 0) {
       [self fetchPaymentList];
    }
    self.isTapTag = NO;
    
    UITableView * tableView2 = self.tableViewArray[self.selectIndex];
    tableView2.scrollEnabled = YES;
}


#pragma mark - 请求付款列表
- (void)fetchPaymentList{
    
    // 1.重置页码
    self.pageArray[self.selectIndex] = @1;
    
    // 2.http://api.qpfww.com/order/myorder?userId=60&status=0&page=1&pageSize=10
    NSString *paymentListUrl=[API_ROOT stringByAppendingString:API_ORDER_MyLIST];
    paymentListUrl = [paymentListUrl stringByAppendingString:self.userId];
    paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&page=%@",self.pageArray[self.selectIndex]]];
    paymentListUrl = [paymentListUrl stringByAppendingString:@"&pageSize=10"];
    /**
     *  status :
                   11 等待买家付款
                   20买家已付款，等待卖家发货
                   30卖家已发货
                   40交易成功
                   0交易已取消
     */
    /** tableView数组 status订单状态（空为全部 11 等待买家付款 20买家已付款，等待卖家发货  30卖家已发货   40交易成功   0交易已取消 ） */
    switch (self.selectIndex) {
        case 0:
            paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&status=%d",0]];
            break;
        case 1:
            paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&status=%d",1]];
            break;
        case 2:
           paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&status=%d",2]];
            break;
        case 3:
           paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&status=%d",3]];
            break;
        case 4:
           paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&status=%d",7]];
            break;
        default:
            break;
    }
    
    UITableView * tableView = self.tableViewArray[self.selectIndex];
    // 3.
    [self.NetworkUtil GET:paymentListUrl inView:self.view success:^(id responseObject) {
        [tableView.header endRefreshing];
        //DLog(@"ORDER_LIST_UN_API---%@",responseObject);
        [tableView.footer resetNoMoreData];
        
        if([[responseObject objectForKey:@"status"] intValue] == 1){
            //1.清空数据
            NSMutableArray * modelArray = self.orderArray[self.selectIndex];
            [modelArray removeAllObjects];
        
            //2.解析产品
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            
            if(dataDic.count){
                NSArray *listArray = [dataDic objectForKey:@"orders"];
                if (listArray.count) {
                    for(NSDictionary * dic in listArray){
                        OrderModel *model = [[OrderModel alloc]initWithAttributes:dic];
                        [modelArray addObject:model];
                    }
                }
            }
            
            // 3.判断为空数据
            if (modelArray.count) {
                tableView.hidden = NO;
                self.emptyView.hidden = YES;
                // 3.1
                [tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(fetchMorePaymentList)];
                [tableView.footer setTitle:@"加载更多中..." forState:MJRefreshFooterStateRefreshing];
                 // 3.2 判断页数,显示没有更多
                if ([[dataDic objectForKey:@"currentPage"] integerValue] == [[dataDic objectForKey:@"totalPage"] integerValue]) {
                    [tableView.footer noticeNoMoreData];
                }else{
                    [tableView.footer resetNoMoreData];
                }
            }else{
                tableView.hidden = YES;
                self.emptyView.hidden = NO;
            }
        
            // 4
            [tableView reloadData];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
        
    } failure:^(NSError *error) {
        [tableView.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
        
    }];
}

#pragma mark -
- (void)fetchMorePaymentList{
    
    // 1.
    NSString *paymentListUrl=[API_ROOT stringByAppendingString:API_ORDER_MyLIST];
    paymentListUrl = [paymentListUrl stringByAppendingString:self.userId];
    paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&page=%d",[self.pageArray[self.selectIndex] intValue]+1]];
    paymentListUrl = [paymentListUrl stringByAppendingString:@"&pageSize=10"];
    /**
     *  status :
     11 等待买家付款
     20买家已付款，等待卖家发货
     30卖家已发货
     40交易成功
     0交易已取消
     */
    /** tableView数组 status订单状态（空为全部 11 等待买家付款 20买家已付款，等待卖家发货  30卖家已发货  40交易成功   0交易已取消 ） */
    switch (self.selectIndex) {
        case 0:
            paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&status=%d",0]];
            break;
        case 1:
            paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&status=%d",1]];
            break;
        case 2:
            paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&status=%d",2]];
            break;
        case 3:
            paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&status=%d",3]];
            break;
        case 4:
            paymentListUrl = [paymentListUrl stringByAppendingString:[NSString stringWithFormat:@"&status=%d",7]];
            break;
        default:
            break;
    }

    UITableView * tableView = self.tableViewArray[self.selectIndex];
    // 3.
    [self.NetworkUtil GET:paymentListUrl success:^(id responseObject) {
        [tableView.footer endRefreshing];
        
        if([[responseObject objectForKey:@"status"] intValue] == 1){
            // 1.重置页码
            self.pageArray[self.selectIndex] = @([self.pageArray[self.selectIndex] intValue] +1);
            NSMutableArray * modelArray = self.orderArray[self.selectIndex];

            //2.解析产品
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            if(dataDic.count){
                NSArray *listArray = [dataDic objectForKey:@"orders"];
                if (listArray.count) {
                    for(NSDictionary * dic in listArray){
                        OrderModel *model = [[OrderModel alloc]initWithAttributes:dic];
                        [modelArray addObject:model];
                    }
                }
                // 3. 判断页数,显示没有更多
                if ([[dataDic objectForKey:@"currentPage"] integerValue] == [[dataDic objectForKey:@"totalPage"] integerValue]) {
                    [tableView.footer noticeNoMoreData];
                }else{
                    [tableView.footer resetNoMoreData];
                }
            }
        
            // 4.
            [tableView reloadData];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
        
    } failure:^(NSError *error) {
        [tableView.footer endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
        
    }];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSMutableArray * modelArray = self.orderArray[self.selectIndex];
    NSInteger counts = modelArray.count;
    if (self.isTapTag) {
        counts = 0;
    }
    return counts;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger height = K_Cell_Goods_Height + K_Cell_Other_Height;
    //1.取出模型
    NSMutableArray * modelArray = self.orderArray[self.selectIndex];
    
    if (modelArray.count > indexPath.row) {
        OrderModel * model = modelArray[indexPath.row];
        if (model.dataGoodsArray.count == 0) {
            height = height - K_Cell_Goods_Height;
        }
        
        if (model.status == 1 || model.status == 2 || model.status == 3) {
            // 支付和取消按钮的高度
            height = height + 50;
        }

        NSIndexPath *currentIndexPath = self.showIndexPathArray[self.selectIndex];
        if (currentIndexPath.row == indexPath.row && currentIndexPath.section == currentIndexPath.section) {
            if ([self.isShowAllGoodsArray[self.selectIndex] intValue]) {
                //1.展开时列表的高度
                height = model.dataGoodsArray.count * K_Cell_Goods_Height + K_Cell_Other_Height + 50;
            }
        }
    }
  
    return height;
}


#pragma mark init cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PaymentOrderCell * cell = [PaymentOrderCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.isShowAllGoods = NO;
    NSIndexPath *currentIndexPath = self.showIndexPathArray[self.selectIndex];
    if (currentIndexPath.row == indexPath.row && currentIndexPath.section == indexPath.section){
        cell.isShowAllGoods = [self.isShowAllGoodsArray[self.selectIndex] intValue]?YES:NO;
    }else{
        cell.isShowAllGoods = NO;
    }
    
    if (self.isTapTag) {
        return cell;
    }
    
    
    NSMutableArray * modelArray = self.orderArray[self.selectIndex];

    // 解决滚动时崩溃问题
    if (modelArray.count <= indexPath.row) {
        return cell;
    }
    OrderModel * model = modelArray[indexPath.row];
    
    cell.indexPath = indexPath;
    cell.orderModel = model;
    cell.selected = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark Select Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 点击 展开商品列表
- (void)paymentOrderCellClickedArrowBtn:(UIButton *)arrowBtn indexPath:(NSIndexPath *)indexPath{

    if (arrowBtn.isSelected) {
       self.isShowAllGoodsArray[self.selectIndex] = @1;
    }else{
       self.isShowAllGoodsArray[self.selectIndex] = @0;
    }

    self.showIndexPathArray[self.selectIndex] = indexPath;
    
    UITableView * tableView = self.tableViewArray[self.selectIndex];
    [tableView reloadData];
}

#pragma mark - 支付订单
- (void)paymentOrderCellClickedPayBtn:(UIButton *)butoon indexPath:(NSIndexPath *)indexPath{
    /**
     *
     *  /mobile/index.php?app=order&act=get_shipping_list&user_id=11
     请求方式
     GET|POST
     请求参数
     必填：user_id ，addr_id（地址id）， coin_value（积分值）coupo_sn（优惠劵编号）postscript（留言）region_id（地区id）shipping_id（快递id）select_coupon（优惠劵id）
     shipping_quantity（购买总数）shipping_weight（重量）flow_type （购买类型）
     返回参数
     -1收获地址为空  -2配送方式为空
     */
    
    //1.取出模型
    NSMutableArray * modelArray = self.orderArray[self.selectIndex];
    
    // 解决滚动时崩溃问题
    if (modelArray.count <= indexPath.row) {
        return;
    }
    
    OrderModel * model = modelArray[indexPath.row];

    NSMutableDictionary *infoMDic = [NSMutableDictionary dictionary];
    [infoMDic setObject:model.payAmount forKey:@"payPrice"];
    [infoMDic setObject:model.orderSn forKey:@"transactionId"];

    switch (model.payType) {
        case 1:
            [infoMDic setObject:@"1" forKey:@"paymentType"];
            break;
        case 5:
            [infoMDic setObject:@"5" forKey:@"paymentType"];
            break;

        default:
            break;
    }

    QPMPaymentSubmitViewController *vc = [[QPMPaymentSubmitViewController alloc] init];
    vc.infoDic = infoMDic;
    vc.paymentSubmitSource = QPMPaymentSubmitSourceOrder;
    [self.navigationController pushViewController:vc animated:YES];

    /**
    PaymentPayVC * vc = [[PaymentPayVC alloc]init];
    vc.isFromMember = YES;
    vc.orderAmount = model.payAmount;
    vc.orderSn = model.orderId;
    vc.orderName = model.companyName;
    vc.paymentCode = @"alipay";
    [self.navigationController pushViewController:vc animated:YES];
     */
}

#pragma mark - 确认收货
- (void)paymentOrderCellClickedConfirmBtn:(UIButton *)butoon indexPath:(NSIndexPath *)indexPath
{
    [self processOrderAtRow:indexPath.row type:OrderOprationTypeConfirm];
}

#pragma mark - 取消订单
- (void)paymentOrderCellClickedCancelBtn:(UIButton *)butoon indexPath:(NSIndexPath *)indexPath{
    /**
     *  /mobile/index.php?app=user&act=set_order_failure&order_id=0
     请求方式
     GET
     请求参数
     order_id
     返回参数
     {
     "status": 1,
     "msg": "取消成功",
     
     }
     *
     */

    _cancelIndx = indexPath;

    //在这里做选择取消订单原因处理，自定义弹窗view
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, K_UIScreen_HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view.window addSubview:bgView];
    self.cancelView = bgView;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [self.cancelView addGestureRecognizer:tap];

    QPMCancelOrderView *view = [[[NSBundle mainBundle] loadNibNamed:@"QPMCancelOrderView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(20, K_UIScreen_HEIGHT/2-(40+30*9+10+0.5+40)/2, self.view.frame.size.width-40, 40+30*9+10+0.5+40);
    view.delegate = self;
    view.reasons = @[@"现在不想购买",@"商品价格比较贵",@"价格波动",@"商品缺货",@"无法完成支付",@"重复下单",@"添加或删除商品",@"收货人信息有误",@"其他原因"];

    [bgView addSubview:view];
}

- (void)cancel
{
    [self.cancelView removeFromSuperview];
}

- (void)submit:(NSDictionary *)params
{
    [self.cancelView removeFromSuperview];

    _cancelReasonStr = [params objectForKey:@"reason"];

    [self processOrderAtRow:_cancelIndx.row type:OrderOprationTypeCancel];
}

//处理订单
- (void)processOrderAtRow:(NSInteger)row type:(NSInteger)opType {
    //1.取出模型
    NSMutableArray * modelArray = self.orderArray[self.selectIndex];
    
    // 解决滚动时崩溃问题
    if (modelArray.count <= row) {
        return;
    }
    OrderModel * model = modelArray[row];
    
    //userId=17&orderNo=201603091339064255&opType=6
    NSString *orderCancelUrl = [API_ROOT stringByAppendingString:API_ORDER_Update];

    NSString *appToken = [UserDefaultsUtils getValueByKey:KTP_KEY];
  
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];

    [parameters setObject:appToken forKey:@"appToken"];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:model.orderId forKey:@"orderNo"];
    [parameters setObject:[NSNumber numberWithInteger:opType] forKey:@"opType"];
    if (_cancelReasonStr && _cancelReasonStr.length > 0) {
        [parameters setObject:_cancelReasonStr forKey:@"remark"];
    }
    //申请退换货参数
    

    [self.NetworkUtil POST:orderCancelUrl parameters:parameters inView:self.view success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            // 1.
            [self fetchPaymentList];
        }else{

            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
    } failure:^(NSError *error) {
        TPError;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - getter
- (NSMutableArray *)tableViewArray{
    if (_tableViewArray == nil) {
        _tableViewArray = [NSMutableArray array];
    }
    return _tableViewArray;
}

- (NSMutableArray *)orderArray{
    if (_orderArray == nil) {
        _orderArray = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil];
    }
    return _orderArray;
}

- (NSMutableArray *)showIndexPathArray{
    if (_showIndexPathArray == nil) {
        _showIndexPathArray = [NSMutableArray arrayWithObjects:[NSIndexPath indexPathForRow:-1 inSection:-1],[NSIndexPath indexPathForRow:-1 inSection:-1],[NSIndexPath indexPathForRow:-1 inSection:-1],[NSIndexPath indexPathForRow:-1 inSection:-1],[NSIndexPath indexPathForRow:-1 inSection:-1], nil];
    }
    return _showIndexPathArray;
}

- (NSMutableArray *)isShowAllGoodsArray{
    if (_isShowAllGoodsArray == nil) {
        _isShowAllGoodsArray = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
    }
    return _isShowAllGoodsArray;
}

- (NSMutableArray *)pageArray{
    if (_pageArray == nil) {
        _pageArray = [NSMutableArray arrayWithObjects:@1,@1,@1,@1,@1, nil];
    }
    return _pageArray;
}

@end
