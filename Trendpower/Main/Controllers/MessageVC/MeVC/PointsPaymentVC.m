//
//  PointsPaymentVC.m
//  Trendpower
//
//  Created by 张帅 on 16/10/9.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "PointsPaymentVC.h"

#import "AddressModel.h"

//pay
#import "PaymentWayTool.h"

// vc
#import "AddressListVC.h"
#import "PaymentSuccessVC.h"
#import "PaymentCouponListVC.h"

// view
#import "CartHeaderView.h"
#import "QPMOrderListCell.h"
#import "PaymentAddressCell.h"
#import "PaymentPayTypeCell.h"
#import "QPMOrderListFooterView.h"
#import "PaymentLeaveWordsCell.h"
#import "PaymentMansongCell.h"
#import "TCDetialTextTableViewCell.h"
#import "PaymentSubmitBarView.h"
#import "QPMOrderPromotionPopView.h"

#import "QPMGoodsGroupedModel.h"


#define K_PLAY_Bar_Height 50
#define K_Header_Height 40

// 支付方法
typedef NS_ENUM(NSInteger, PaymentType) {
    PaymentTypeNone =0,
    PaymentTypeAlipay =1,
    PaymentTypeWXpay =5,
    PaymentTypeOfflinepay =7,
    PaymentTypePoint = 8,
};

@interface PointsPaymentVC ()<UITableViewDataSource,UITableViewDelegate,PaymentAddressViewDelegate,PaymentSubmitBarViewDelegate,PaymentFooterViewDelegate>

@property (nonatomic, weak) UITableView * tableView;

@property (nonatomic, weak) CustomTextView * leaveWordsView;
@property (nonatomic, weak) PaymentSubmitBarView * submitView;

@property (nonatomic, assign) PaymentType paymetType;

@property (nonatomic, copy) NSString * paySn;

@end

static NSString *QPMOrderListCellID = @"QPMOrderListCell";

@implementation PointsPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    self.paymetType = PaymentTypeNone;

    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAddress:) name:K_NOTIFI_SELECT_ADDRESS object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableView
- (void)initTableView{
    if (self.tableView == nil) {
        UITableView * tableView;
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) style:UITableViewStyleGrouped];
        tableView.rowHeight = 50;
        tableView.backgroundColor = K_GREY_COLOR;
        [tableView registerNib:[UINib nibWithNibName:@"QPMOrderListCell" bundle:nil] forCellReuseIdentifier:QPMOrderListCellID];
        self.tableView = tableView;

        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, K_PLAY_Bar_Height, 0);
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        tableView.delegate = self;
        tableView.dataSource = self;

        [self.view addSubview:tableView];
        //tableView.tableFooterView = [[UIView alloc]init];

        //结算栏
        [self initPaymentView];
    }

    [self.tableView reloadData];
}

#pragma mark - 结算栏
- (void)initPaymentView{

    PaymentSubmitBarView *paymentView = [[PaymentSubmitBarView alloc]initWithFrame:CGRectMake(0, K_UIScreen_HEIGHT -K_PLAY_Bar_Height, K_UIScreen_WIDTH, K_PLAY_Bar_Height)];
    paymentView.priceLbl.text = [NSString stringWithFormat:@"￥%0.2f",[self.payModel.pay_price floatValue]];
    paymentView.delegate = self;
    self.submitView = paymentView;
    [self.view addSubview:paymentView];
}


#pragma mark UITableViewDataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.payModel.shopArray.count +3 +self.payModel.hasCoupon;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger last = self.payModel.shopArray.count +2 +self.payModel.hasCoupon;

    NSInteger rows = 0;
    if (section == 0  || section == last || (self.payModel.hasCoupon && section == 2)) {// 地址栏，留言栏，红包栏
        rows =  1;
    }else if(section == 1){//支付方式
        rows = self.payModel.usedPaywayArry.count;
    }else{
        PaymentShopsModel * shopModel = self.payModel.shopArray[section-2-self.payModel.hasCoupon];
        rows =  shopModel.goodsArray.count;
    }

    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // 1.
    NSInteger last = self.payModel.shopArray.count +2 +self.payModel.hasCoupon;

    if (indexPath.section == 0) {
        PaymentAddressCell *cell = [PaymentAddressCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.paymentListModel = self.payModel;
        return cell;
    }else if (indexPath.section == 1){
        PaymentPayTypeCell *cell = [PaymentPayTypeCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;

        NSDictionary * dic = self.payModel.usedPaywayArry[indexPath.row];
        NSInteger pay_type = [[dic objectForKey:@"pay_type"] integerValue];
        // 1.判断第一次选中第一个支付类型
        if(self.paymetType == PaymentTypeNone && indexPath.row == 0){
            self.paymetType = pay_type;
        }

        // 2.初始化
        switch (pay_type) {
            case 1:
                cell.imageLeft.image = [UIImage imageNamed:@"pay_wap_alipay"];
                cell.imageRight.image = self.paymetType == PaymentTypeAlipay ? [UIImage imageNamed:@"payment_select"] :[UIImage imageNamed:@"payment_unselect"];
                cell.nameLbl.text = [dic objectForKey:@"pay_name"];//@"支付宝支付";
                break;
            case 5:
                cell.imageLeft.image = [UIImage imageNamed:@"pay_wxpay"];
                cell.imageRight.image = self.paymetType == PaymentTypeWXpay ? [UIImage imageNamed:@"payment_select"] :[UIImage imageNamed:@"payment_unselect"];
                cell.nameLbl.text = [dic objectForKey:@"pay_name"];// @"微信支付";
                break;
            case 7:
                cell.imageLeft.image = [UIImage imageNamed:@"pay_cod"];
                cell.imageRight.image = self.paymetType == PaymentTypeOfflinepay ? [UIImage imageNamed:@"payment_select"] :[UIImage imageNamed:@"payment_unselect"];
                cell.nameLbl.text = [dic objectForKey:@"pay_name"];//@"货到付款";
                break;
            case 8:
                cell.imageLeft.image = [UIImage imageNamed:@"my_point"];
                cell.imageRight.image = self.paymetType == PaymentTypePoint ? [UIImage imageNamed:@"payment_select"] :[UIImage imageNamed:@"payment_unselect"];
                cell.nameLbl.text = [dic objectForKey:@"pay_name"];
                break;
            default:
                break;
        }
        return cell;
    }else if (indexPath.section == last){
        PaymentLeaveWordsCell *cell = [PaymentLeaveWordsCell cellWithTableView:tableView];
        self.leaveWordsView = cell.leaveWordsView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (self.payModel.hasCoupon && indexPath.section == 2){
        TCDetialTextTableViewCell *cell = [TCDetialTextTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.text = @"红包";
        cell.detailText = self.payModel.selectedCoupon ? self.payModel.selectedCoupon.coupon_name : @"未使用";
        return cell;
    }

    PaymentShopsModel *shopModel = self.payModel.shopArray[indexPath.section-2-self.payModel.hasCoupon];
    CartGoodsModel *goodsModel = shopModel.goodsArray[indexPath.row];


    //单个商品
    QPMOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:QPMOrderListCellID];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.goodsModel = goodsModel;
    cell.indexPath = indexPath;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    switch (indexPath.section) {
        case 0:
            height = 100;//地址cell
            break;
        case 1:
            height = 50;//支付cell
            break;
        default:{
            NSInteger last = self.payModel.shopArray.count +2 +self.payModel.hasCoupon;
            if (indexPath.section == last ) {
                height = 80;//留言
            }else if(self.payModel.hasCoupon && indexPath.section == 2){
                height = 50;
            }else{

                height = 120;//商品高度
            }
            break;
        }
    }

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSInteger last = self.payModel.shopArray.count +2 +self.payModel.hasCoupon;
    if (section == 0 || section == 1 || section == last || (self.payModel.hasCoupon && section == 2)) {
        return 0.1;
    }else{
        return K_Header_Height;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSInteger last = self.payModel.shopArray.count +2 +self.payModel.hasCoupon;
    if (section == 0 || section == 1 || section == last || (self.payModel.hasCoupon && section == 2)) {
        return nil;
    }else{
        CartHeaderView * header = [[CartHeaderView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, K_Header_Height)];
        PaymentShopsModel * shopModel = self.payModel.shopArray[section-2-self.payModel.hasCoupon];
        header.shopNameLbl.text = shopModel.companyName;
        return header;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSInteger last = self.payModel.shopArray.count +2 +self.payModel.hasCoupon;
    if (section == 0 || section == 1 || section == last || (self.payModel.hasCoupon && section == 2)) {
        return 15;
    }else{
        return 120;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSInteger last = self.payModel.shopArray.count +2 +self.payModel.hasCoupon;
    if (section == 0 || section == 1 || section == last || (self.payModel.hasCoupon && section == 2)) {
        return nil;
    }else{

        QPMOrderListFooterView * footer = [[QPMOrderListFooterView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 120)];
        PaymentShopsModel * shopModel = self.payModel.shopArray[section-2-self.payModel.hasCoupon];

        QPMGoodsGroupedModel *goodsGroupedModel = self.payModel.cartGoods[section - 2 - self.payModel.hasCoupon];

        footer.goodsGroupedModel = goodsGroupedModel;
        footer.shopModel = shopModel;

        footer.section = section;
        footer.delegate = self;
        return footer;
    }
}

#pragma mark - 订单促销 button 回调
/**
 *  点击 section footer 促销按钮回调
 *
 */
- (void)promotionButtonClickWithGoodsGroupedModel:(QPMGoodsGroupedModel *)goodsGroupedModel {

    if (goodsGroupedModel.promotions.count > 0) {
        QPMOrderPromotionPopView *popView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QPMOrderPromotionPopView class]) owner:nil options:nil] lastObject];
        popView.frame = CGRectMake(0, 0, K_UIScreen_WIDTH, K_UIScreen_HEIGHT);

        popView.goodsGroupedModel = goodsGroupedModel;

        [[UIApplication sharedApplication].keyWindow addSubview:popView];
    }
}

#pragma mark- 选择支付方式
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        // 点击支付方式
        NSDictionary * dic = self.payModel.usedPaywayArry[indexPath.row];
        NSInteger pay_type = [[dic objectForKey:@"pay_type"] integerValue];
        self.paymetType = pay_type;
        // 刷新
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }else if (self.payModel.hasCoupon && indexPath.section == 2){
        // 点击红包
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        // 判断支付订单号是不是已经生成，生成后不能在改变红包
        if(self.paySn.length > 0){
            [self.HUDUtil showErrorMBHUDWithText:@"订单已生成，不能选择红包啦！" inView:self.view delay:1.2];
        }else{
            PaymentCouponListVC * vc = [[PaymentCouponListVC alloc]init];
            vc.cartGoods = self.cartGoods;
            vc.payModel = self.payModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 配送类型
- (void)paymentFooterViewDidSelectExpress:(PaymentShopsModel *)shopModel inSection:(NSInteger)section{

    __block float price = [self.payModel.pay_price floatValue];

    [shopModel.expressArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj objectForKey:@"distributionType"] integerValue] == !shopModel.isDistributionTypeOne) {
            if ([[obj objectForKey:@"isFree"] integerValue] == 1 ) {

            }else{
                price = price - [[obj objectForKey:@"price"] floatValue];
            }

        }else if([[obj objectForKey:@"distributionType"] integerValue] == shopModel.isDistributionTypeOne ) {
            if ([[obj objectForKey:@"isFree"] integerValue] == 1 ) {

            }else{
                price = price + [[obj objectForKey:@"price"] floatValue];
            }
        }
    }];


    self.payModel.price = [NSString stringWithFormat:@"%0.2f",price];
    self.payModel.pay_price = [NSString stringWithFormat:@"%0.2f",price];
    self.submitView.priceLbl.text = [NSString stringWithFormat:@"￥%@",self.payModel.pay_price];
}

#pragma mark - 选择地址后，通知回调
- (void)selectAddress:(NSNotification *)notifi{

    //1.取出模型
    AddressModel * model = notifi.object;

    self.payModel.address_id = model.addressId;
    self.payModel.address_name = model.custommerName;
    self.payModel.add_mob_phone = model.cellPhone;
    self.payModel.add_area_info = model.regionName;
    self.payModel.address = model.address;

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - 选择地址
- (void)paymentAddressViewClicked{
    AddressListVC * vc = [[AddressListVC alloc]init];
    vc.isFormPayment = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 提交订单
- (void)paymentSubmitBarViewClickedSumbitBtn:(UIButton *)btn{

    if (self.payModel.address_id == nil) {
        [self.HUDUtil showTextMBHUDWithText:@"请选择地址" delay:2.0 inView:self.view];
        return;
    }

    if (self.paymetType == PaymentTypeNone) {
        [self.HUDUtil showTextMBHUDWithText:@"请选择支付方式" delay:2.0 inView:self.view];
        return;
    }


    // 判断支付订单号是不是为空，不为空直接支付
    if(self.paySn.length > 0){
        switch (self.paymetType) {
            case PaymentTypeAlipay:
                [self paymentSubmitAliPay:self.paySn];
                break;
            case PaymentTypeWXpay:
                [self paymentSubmitWeixinPay:self.paySn];
                break;
            default:
                [self paymentSubmitWeixinPay:self.paySn];
                break;
        }
    }


    btn.enabled = NO;
    NSString *cartSelectAllUrl=[API_ROOT stringByAppendingString:API_POINTORDER_Create];

    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:self.payModel.address_id forKey:@"addressId"];
    [parameters setObject:self.leaveWordsView == nil ? @"" : self.leaveWordsView.text forKey:@"remark"];

    if (self.paymetType == PaymentTypePoint) {
        [parameters setObject:@"1" forKey:@"offline"];
    }

    NSMutableArray * distributionDic = [NSMutableArray array];

    [self.payModel.shopArray enumerateObjectsUsingBlock:^(PaymentShopsModel * shopModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if(self.isDirectBuy){
            CartGoodsModel *model = shopModel.goodsArray[0];
            [parameters setObject:model.goodsId forKey:@"goodsId"];
            [parameters setObject:shopModel.sellerId forKey:@"sellerId"];
            [parameters setObject:model.quantity forKey:@"quantity"];
        }
        [shopModel.expressArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            if ([[obj objectForKey:@"distributionType"] integerValue] == shopModel.isDistributionTypeOne) {

                NSString * agentId = [obj objectForKey:@"agentId"];
                NSString * expressId = [obj objectForKey:@"expressId"];
                NSDictionary * dic = [NSDictionary dictionaryWithObjects:@[agentId,expressId] forKeys:@[@"sellerId",@"expressId"]];
                [distributionDic addObject:dic];
            }
        }];
    }];

    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:distributionDic options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        NSLog(@"Successfully serialized the dictionary into data.");
        //NSData转换为String
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [parameters setObject:jsonString forKey:@"distribution"];
        NSLog(@"JSON String = %@", jsonString);
    }

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];

    [self.NetworkUtil POST:cartSelectAllUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {

        btn.enabled = YES;
        //添加成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {

            NSDictionary * data = [responseObject objectForKey:@"data"];
            NSString * payPrice = [data objectForKey:@"payPrice"];
            self.payModel.price = payPrice;
            self.paySn = [data objectForKey:@"transactionId"];


            // 2.初始化，为什么放这里，放这里存在一种可能我选择一种支付方式，但是没有开通，提示用户，然后用户切换支付方式，这件商品已经不存在了。
            switch (self.paymetType) {
                case 1:
                    [self paymentSubmitAliPay:self.paySn];//@"支付宝支付";
                    break;
                case 5:
                    [self.HUDUtil showTextMBHUDInWindowWithText:@"微信支付开发中,敬请期待" delay:2.0];
                    //[self paymentSubmitWeixinPay:self.paySn];// @"微信支付";
                    break;
                case 7:{
                    //@"货到付款";
                    PaymentSuccessVC * vc = [[PaymentSuccessVC alloc]init];
                    vc.paySn = [NSString stringWithFormat:@"订单编号：%@",self.paySn];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 8: {
                    //积分兑换
                    PaymentSuccessVC * vc = [[PaymentSuccessVC alloc]init];
                    vc.paySn = [NSString stringWithFormat:@"订单编号：%@",self.paySn];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                default:
                    break;
            }

        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        btn.enabled = YES;
        [self.HUDUtil showNetworkErrorInView:self.view];
        TPError;
    }];
}

#pragma mark - 支付宝支付
- (void)paymentSubmitAliPay:(NSString *)pay_sn{
    __block NSDictionary * dic;
    [self.payModel.paywayArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger pay_type = [[obj objectForKey:@"pay_type"] integerValue];
        if (pay_type == PaymentTypeAlipay) {
            dic = [NSDictionary dictionaryWithDictionary:obj];
        }
    }];

    if (!dic.count) {
        return;
    }

    [PaymentWayTool aliPayOrder_name:[NSString stringWithFormat:@"%@-%@",@"汽配猫",pay_sn] order_price:self.payModel.price orderno:pay_sn partner:[dic objectForKey:@"partner"] seller:[dic objectForKey:@"seller_email"] notifyURL:[dic objectForKey:@"notify_url"]];
}


#pragma mark - 微信支付
- (void)paymentSubmitWeixinPay:(NSString *)pay_sn
{
    [PaymentWayTool wxPayOrder_name:[NSString stringWithFormat:@"%@-%@",@"汽配猫",pay_sn] order_price:self.payModel.price orderno:pay_sn];
}


/**
 *
 9000 订单支付成功
 8000 正在处理中
 4000 订单支付失败
 6001 用户中途取消
 6002 网络连接出错
 */
#pragma mark - 支付宝支付回调
-(void) processAliPayResult:(NSNotification*) notification{
    NSDictionary *resultDic=notification.userInfo;
    int statusCode=[[resultDic valueForKey:@"resultStatus"] intValue];
    switch (statusCode) {
        case 9000:{ // 9000 订单支付成功
            PaymentSuccessVC * vc = [[PaymentSuccessVC alloc]init];
            vc.paySn =  [NSString stringWithFormat:@"订单编号：%@",self.paySn];
            [self.navigationController pushViewController:vc animated:NO];
            break;
        }
        case 8000:{ // 8000 正在处理中
            [self.HUDUtil showErrorMBHUDWithText:@"支付处理中，以订单状态为准" inView:self.view delay:3];
            break;
        }
        case 4000:{ // 4000 订单支付失败
            [self.HUDUtil showErrorMBHUDWithText:@"订单支付失败" inView:self.view delay:3];
            break;
        }
        case 6001:{ // 6001 用户中途取消
            [self.HUDUtil showErrorMBHUDWithText:@"已取消支付" inView:self.view delay:3];
            break;
        }
        case 6002:{ // 6002 网络连接出错
            [self.HUDUtil showErrorMBHUDWithText:@"网络连接出错" inView:self.view delay:3];
            break;
        }
        default:
            [self.HUDUtil showErrorMBHUDWithText:@"支付失败" inView:self.view delay:3];
            break;
    }
}


#pragma mark - 微信支付回调
-(void) processWXPayResult:(NSNotification*) notification{
    BaseResp * resp = notification.object;
    switch (resp.errCode) {
        case WXSuccess:{ // 9000 订单支付成功
            PaymentSuccessVC * vc = [[PaymentSuccessVC alloc]init];
            vc.paySn =  [NSString stringWithFormat:@"订单编号：%@",self.paySn];
            [self.navigationController pushViewController:vc animated:NO];
            break;
        }
        case WXErrCodeUserCancel:{ // 6001 用户中途取消
            [self.HUDUtil showErrorMBHUDWithText:@"已取消支付" inView:self.view delay:3];
            break;
        }
        default:
            [self.HUDUtil showErrorMBHUDWithText:@"支付失败" inView:self.view delay:3];
            break;
    }
}

@end
