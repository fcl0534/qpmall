//
//  PaymentCouponListVC.m
//  ZZBMall
//
//  Created by trendpower on 15/12/2.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#define K_Cell_Height  95

#import "PaymentCouponListVC.h"
#import "PaymentCouponCell.h"

@interface PaymentCouponListVC()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, weak) UITableView * tableView;

@end
@implementation PaymentCouponListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包";
    [self initTableView];
}

#pragma mark - TableView
- (void)initTableView{
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.rowHeight = K_Cell_Height;
    tableView.backgroundColor = K_GREY_COLOR;
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.payModel.couponArray.count;
}

#pragma mark init cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1.取出模型
    PaymentCouponModel * model = self.payModel.couponArray[indexPath.row];
    
    //2.赋值
    PaymentCouponCell * cell = [PaymentCouponCell cellWithTableView:tableView];
    cell.couponModel = model;
    cell.indexPath = indexPath;
    if ([model.coupon_id isEqualToString:self.payModel.selectedCoupon.coupon_id]) {
        cell.isSelectCoupon = YES;
    }else{
        cell.isSelectCoupon = NO;
    }
    
    // 3.
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark Select Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //1.取出模型
    PaymentCouponModel * model = self.payModel.couponArray[indexPath.row];
    
    //2.
    [self setSelectExpressWayModel:model];
}

#pragma mark - 请求更改地址
- (void)setSelectExpressWayModel:(PaymentCouponModel *)model{
    
    //如果当前选择的跟原来的一样，直接返回
    if([self.payModel.selectedCoupon.coupon_id isEqualToString:model.coupon_id]){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSString *cartSelectAllUrl=[API_ROOT stringByAppendingString:API_ORDER_LIST];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.apiKey forKey:KTP_KEY];
    [parameters setObject:self.cartGoods forKey:@"cart"];
    [parameters setObject:model.coupon_id forKey:@"coupon_user_id"];
    // Key(权限认证参数) , cart = “67|3,68|1 ”    (string类型，67、68为cart_id，3 、1为对应购买的数量)
    
    [self.NetworkUtil POST:cartSelectAllUrl parameters:parameters inView:self.view success:^(id responseObject) {
        
        //使用成功
        if ([[responseObject objectForKey:@"code"] intValue] == 1) {
            // 更新选中状态
            self.payModel.selectedCoupon = model;
            self.payModel.price = [responseObject objectForKey:@"sum"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


@end
