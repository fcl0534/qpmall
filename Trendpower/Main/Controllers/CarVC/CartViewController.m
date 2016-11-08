//
//  CartVC.m
//  ZZBMall
//
//  Created by trendpower on 15/7/27.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#define K_PLAY_Bar_Height 50
#define K_Cell_Height  120
#define K_Header_Height 44

#import "CartViewController.h"

//Util
#import "HUDUtil.h"

// vc
#import "ProductDetailVC.h"
#import "QPMOrderConfirmViewController.h"

// view
#import "CartTableviewCell.h"
#import "CartHeaderView.h"
#import "CartPaymentView.h"
#import "EmptyTipsView.h"
#import "QPMPaymentSeparateView.h"

// model
#import "CartModelArray.h"
//#import "PaymentListModel.h"
#import "QPMPaymentSeparateModel.h"

@interface CartViewController()<UITableViewDataSource, UITableViewDelegate, CartTableViewCellDelegate, CartPaymentViewDelegate, HUDAlertViewDelegate, EmptyTipsViewDelegate,QPMPaymentSeparateViewDelegate>

@property (nonatomic, weak) UITableView * tableView;

@property (nonatomic, weak) CartPaymentView * paymentView;

@property (nonatomic, weak) EmptyTipsView * emptyTipsView;

@property (nonatomic, strong) CartModelArray * modelArray;

@property (nonatomic, strong) NSIndexPath * deleteIndexPath;

/** 拆单支付model数组 */
@property (nonatomic, strong) NSMutableArray *separateModels;

/** 拆单view */
@property (nonatomic, strong) QPMPaymentSeparateView *separateView;

/** 是否是拆单结算 */
@property (nonatomic, assign) BOOL isSeparate;

/** 拆单经销商id */
@property (nonatomic, assign) NSInteger sellerId;

@end

@implementation CartViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tableView == nil) [self initTableView];
    self.isUserLogined?[self fetchCartData]:(self.emptyTipsView.hidden = NO);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BackHomeView) name:K_NOTIFI_BACK_HOME object:nil];

    self.isSeparate = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_NOTIFI_BACK_HOME object:nil];
}

- (void)BackHomeView{
    self.tabBarController.selectedIndex = 0;
}

- (void) fetchCartData{
    
    self.emptyTipsView.hidden = YES;
    
   // [self.HUDUtil showLoadingMBHUDInView:self.view];
    
    NSString * url = [API_ROOT stringByAppendingString:API_CART_List];
    url = [url stringByAppendingFormat:@"userId=%@",self.userId];
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    [self.NetworkUtil GET:url header:header inView:self.view success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            self.modelArray = [[CartModelArray alloc]initWithAttributes:responseObject];
            
            // 有数据
            if (self.modelArray.shopArray.count) {
                self.paymentView.price = [self.modelArray.selectTotalPrice stringValue];
                
                self.paymentView.selectBtn.selected = ([self.modelArray.selectTotal isEqualToNumber:self.modelArray.total] && ![self.modelArray.selectTotal isEqualToNumber:@0]);
                
                self.paymentView.hidden = NO;
                self.emptyTipsView.hidden = YES;
                [self.tableView reloadData];
            }else{
                self.paymentView.hidden = YES;
                self.emptyTipsView.hidden = NO;
            }
        }else if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] hasPrefix:@"4217"]){
            [self setUserLogout];
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
        
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];

}


#pragma mark - TableView
- (void)initTableView{
    if (self.tableView == nil) {
        UITableView * tableView;
        if (self.isFromProduct) {
            tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) style:UITableViewStylePlain];
        }else{
            tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64 -49) style:UITableViewStylePlain];
        }
        
        tableView.rowHeight = K_Cell_Height;
        tableView.backgroundColor = K_GREY_COLOR;
        self.tableView = tableView;
        
        self.tableView.sectionFooterHeight = 15;
        self.tableView.sectionHeaderHeight = K_Header_Height;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, K_PLAY_Bar_Height, 0);
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self.view addSubview:tableView];
        tableView.tableFooterView = [[UIView alloc]init];

        //设置上拉刷新
        [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchCartData)];
        [self.tableView.header setTitle:@"正在更新购物车..." forState:MJRefreshHeaderStateRefreshing];
        
        
        //结算栏
        [self initPaymentView];
        
        // 空视图
        [self initEmptyView];
        
    }

}

#pragma mark - 结算栏
- (void)initPaymentView{
    
    CartPaymentView *paymetView = [[CartPaymentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame) -K_PLAY_Bar_Height, K_UIScreen_WIDTH, K_PLAY_Bar_Height)];
    paymetView.delegate = self;
    paymetView.hidden = YES;
    [self.view addSubview:paymetView];
    self.paymentView = paymetView;
    
}

#pragma mark - 空视图
- (void)initEmptyView{
    EmptyTipsView * view = [[EmptyTipsView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT) tipsIamge:[UIImage imageNamed:@"shop_car_null_bg"] tipsTitle:@"购物车还是空空如也" tipsDetail:@"主人快给我挑点宝贝吧" btnName:@"去逛逛"];
    view.hidden = YES;
    view.delegate = self;
    [self.view addSubview:view];
    self.emptyTipsView = view;
}


- (void)EmptyTipsViewClickedButton:(UIButton *)btn{
    if(self.isFromProduct){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        self.tabBarController.selectedIndex = 0;
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.shopArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CartShopModel * shopModel = self.modelArray.shopArray[section];
    return shopModel.goodsArray.count;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - UIScrollViewDelegate
/**
 *  不要这句子，第一个头部就出问题
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return K_Header_Height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (self.modelArray.shopArray.count-1)==section?0:15;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 15)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.layer.borderColor = [UIColor colorWithWhite:0.868 alpha:1.000].CGColor;
    view.layer.borderWidth = 0.2;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CartHeaderView * header = [[CartHeaderView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, K_Header_Height)];
    CartShopModel * shopModel = self.modelArray.shopArray[section];
    header.shopNameLbl.text = shopModel.companyName;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // 1.
    CartTableviewCell *cell = [CartTableviewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    // 2.
    CartShopModel * shopModel = self.modelArray.shopArray[indexPath.section];
    CartGoodsModel * goodsModel = shopModel.goodsArray[indexPath.row];
    cell.goodsModel = goodsModel;

    return cell;
}

#pragma mark 列表的编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_iOS8) {
        return YES;
    }else{
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击删除商品
    if (editingStyle == UITableViewCellEditingStyleDelete && IS_iOS8)
    {
        self.deleteIndexPath = indexPath;
        self.HUDUtil.delegate = self;
        [self.HUDUtil showAlertViewWithTitle:@"确定要删除该商品吗" mesg:nil cancelTitle:@"删除" confirmTitle:@"保留" tag:10];
    }
}

#pragma mark - 删除商品
- (void)hudAlertViewClickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag{
    
    switch (buttonIndex) {
        case 0: //删除
            [self deleteShopAtRow:tag];
        case 1: //取消
            [self.tableView reloadRowsAtIndexPaths:@[self.deleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

- (void)deleteShopAtRow:(NSInteger)btnTag{
    //1.取出对应模型
    CartShopModel * shopModel = self.modelArray.shopArray[self.deleteIndexPath.section];
    CartGoodsModel * goodsModel = shopModel.goodsArray[self.deleteIndexPath.row];
    
    //2.请求
    NSString *cartDeleteUrl=[API_ROOT stringByAppendingString:API_CART_Delete];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:goodsModel.cartId forKey:@"cartId"];

    [self.NetworkUtil POST:cartDeleteUrl header:header parameters:parameters inView:self.view success:^(id responseObject)  {
        
        //删除成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {

            NSDictionary *data = [responseObject objectForKey:@"data"];
            self.modelArray.selectTotal = [data objectForKey:@"selectTotal"];
            self.modelArray.selectTotalPrice = [data objectForKey:@"selectTotalPrice"];
            self.modelArray.total = [data objectForKey:@"total"];
            self.modelArray.totalPrice = [data objectForKey:@"totalPrice"];
            // 更新总价
            self.paymentView.price = [self.modelArray.selectTotalPrice stringValue];
            
            if(shopModel.goodsArray.count == 1){
                // 删除整个店铺
                [self.modelArray.shopArray removeObjectAtIndex:self.deleteIndexPath.section];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.deleteIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }else{
                [shopModel.goodsArray removeObjectAtIndex:self.deleteIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[self.deleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                if (btnTag == 20) { //由于点击删除按钮后，删除的cell对应的下标变化了，所以要重新刷新一下下标
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.deleteIndexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    });
                }
            }
            
            [self updateSelectBtnState:YES];
            
            // 无数据
            if (!self.modelArray.shopArray.count) {
                self.paymentView.hidden = YES;
                self.emptyTipsView.hidden = NO;
            }
            
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}


#pragma mark - ShopCartCell Delegate
#pragma mark - 删除商品
- (void)shopCartCellClickedDeletcBtn:(UIButton *)btn shopCartModel:(CartGoodsModel *)shopCartModel indexPath:(NSIndexPath *)indexPath{
    self.deleteIndexPath = indexPath;
    self.HUDUtil.delegate = self;
    [self.HUDUtil showAlertViewWithTitle:@"确定要删除该商品吗" mesg:nil cancelTitle:@"删除" confirmTitle:@"保留" tag:20];
}


#pragma mark 商品数据增加或减少
- (void)shopCartCellStepperValueChangIsAdd:(BOOL)isAdd countField:(UITextField *)counteField currentValue:(NSInteger)currentValue shopCartModel:(CartGoodsModel *)shopCartModel indexPath:(NSIndexPath *)indexPath{
    
    NSString *quantity;
    //增加数量
    if (isAdd) {
        quantity = [NSString stringWithFormat:@"%ld",currentValue +1];
    }else{
        quantity = [NSString stringWithFormat:@"%ld",currentValue -1];
    }
    
    // 人工判断大于库存只取最大库存
    if([quantity integerValue]>[shopCartModel.goodsAgentSku integerValue]){
        quantity = [shopCartModel.goodsAgentSku stringValue];
    }
    
    NSString *cartUpdateUrl=[API_ROOT stringByAppendingString:API_CART_UpdateCart];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:shopCartModel.sellerId forKey:@"sellerId"];
    [parameters setObject:quantity forKey:@"quantity"];
    [parameters setObject:shopCartModel.goodsId forKey:@"goodsId"];

    //增加规格id
    [parameters setObject:@(shopCartModel.goodsStandardId) forKey:@"goodsStandardId"];
    
    [self.NetworkUtil POST:cartUpdateUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        //添加成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            shopCartModel.quantity = quantity;

            NSDictionary *data = [responseObject objectForKey:@"data"];
            self.modelArray.selectTotal = [data objectForKey:@"selectTotal"];
            self.modelArray.selectTotalPrice = [data objectForKey:@"selectTotalPrice"];
            self.modelArray.total = [data objectForKey:@"total"];
            self.modelArray.totalPrice = [data objectForKey:@"totalPrice"];
            
            // 更新总价
             self.paymentView.price = [self.modelArray.selectTotalPrice stringValue];
            
            // 更新选中状态
//            shopCartModel.isSelected = YES;
            
//            [self updateSelectBtnState:YES];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            //counteField.text = quantity;
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


#pragma mark  商品数据编辑
- (void)shopCartCellStepperTextDidEndEditing:(UITextField *)counteField oldText:(NSInteger)oldText shopCartModel:(CartGoodsModel *)shopCartModel indexPath:(NSIndexPath *)indexPath {
    
    //如果不改变就不请求
    if ([counteField.text integerValue] == oldText) {
        return;
    }
    
    NSString * quantity = counteField.text;
    // 人工判断大于库存只取最大库存
    if([quantity integerValue]>[shopCartModel.goodsAgentSku integerValue]){
        quantity = [shopCartModel.goodsAgentSku stringValue];
    }
    
    NSString *cartUpdateUrl=[API_ROOT stringByAppendingString:API_CART_UpdateCart];
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:shopCartModel.sellerId forKey:@"sellerId"];
    [parameters setObject:quantity forKey:@"quantity"];
    [parameters setObject:shopCartModel.goodsId forKey:@"goodsId"];

    //增加规格id
    [parameters setObject:@(shopCartModel.goodsStandardId) forKey:@"goodsStandardId"];
    
    [self.NetworkUtil POST:cartUpdateUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        //添加成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            shopCartModel.quantity = quantity;

            NSDictionary *data = [responseObject objectForKey:@"data"];
            self.modelArray.selectTotal = [data objectForKey:@"selectTotal"];
            self.modelArray.selectTotalPrice = [data objectForKey:@"selectTotalPrice"];
            self.modelArray.total = [data objectForKey:@"total"];
            self.modelArray.totalPrice = [data objectForKey:@"totalPrice"];
            
            // 更新总价
            self.paymentView.price = [self.modelArray.selectTotalPrice stringValue];

            
            // 更新选中状态
//            shopCartModel.isSelected = YES;
//            
//            [self updateSelectBtnState:YES];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            //counteField.text = quantity;
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
             //counteField.text = [NSString stringWithFormat:@"%ld",oldText];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        //counteField.text = [NSString stringWithFormat:@"%ld",oldText];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //[self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark 商品选择状态
- (void)shopCartCellClickedSelectButton:(UIButton *)btn shopCartModel:(CartGoodsModel *)shopCartModel indexPath:(NSIndexPath *)indexPath{
    
    /**
     *  1 单一商品 选中或取消选中     2、全部选中  3、全部取消选中（只有全选中返，全不选中）
     */
    btn.enabled = NO;
 
    NSString *cartUpdateUrl=[API_ROOT stringByAppendingString:API_CART_Select];
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:shopCartModel.cartId forKey:@"cartId"];
    [parameters setObject:@"1" forKey:@"type"];

    [self.NetworkUtil POST:cartUpdateUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        btn.enabled = YES;
        //添加成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            // 更新选中状态
            btn.selected = !btn.isSelected;
            shopCartModel.is_check = btn.isSelected;
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            self.modelArray.selectTotal = [data objectForKey:@"selectTotal"];
            self.modelArray.selectTotalPrice = [data objectForKey:@"selectTotalPrice"];
            self.modelArray.total = [data objectForKey:@"total"];
            self.modelArray.totalPrice = [data objectForKey:@"totalPrice"];
            
            // 更新总价
            self.paymentView.price = [self.modelArray.selectTotalPrice stringValue];
            
            // 更新选择状态
            [self updateSelectBtnState:btn.isSelected];

        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        btn.enabled = YES;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}


#pragma mark - 更新全选按钮的状态
- (void)updateSelectBtnState:(BOOL)isSelect{
    
    __block BOOL isAllSelect = YES;
    
    if (isSelect) {
        [self.modelArray.shopArray enumerateObjectsUsingBlock:^(CartShopModel * shopModel, NSUInteger idx, BOOL *stop) {
            [shopModel.goodsArray enumerateObjectsUsingBlock:^(CartGoodsModel * goodsModel, NSUInteger idx, BOOL *stop) {
                if (!goodsModel.is_check) {
                    self.paymentView.selectBtn.selected = NO;
                    isAllSelect = NO;
                    return ;
                }
            }];
        }];
        
        if (isAllSelect) {
            self.paymentView.selectBtn.selected = YES;
        }
        
    }else{
        self.paymentView.selectBtn.selected = NO;
    }
}



#pragma mark 商品详情页面
-(void) shopCartCellClickedImageViewOrGoodsNameWithShopCartModel:(CartGoodsModel * )shopCartModel indexPath:(NSIndexPath * )indexPath{
    
    ProductDetailVC * vc = [[ProductDetailVC alloc]init];
    vc.productId = shopCartModel.goodsId;
    //vc.productName = shopCartModel.goods_name;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - QPMPaymentSeparateViewDelegate
- (void)toSettleAccounts:(NSInteger)sellerId {

    [[HUDUtil sharedHUDUtil] showLoadingMBHUDInView:self.separateView];

    self.isSeparate = YES;

    self.sellerId = sellerId;

    [self cartPaymentViewClickedSumbitBtn:self.paymentView.payBtn];
}

#pragma mark - 结算栏
#pragma mark - 全选或取消选中
- (void)cartPaymentViewClickedSelectBtn:(UIButton *)btn{

    /**
     *  1 单一商品 选中或取消选中     2、全部选中  3、全部取消选中（只有全选中返，全不选中）
     */
    
    btn.enabled = NO;
    
    NSString *cartSelectAllUrl=[API_ROOT stringByAppendingString:API_CART_Select];
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.userId forKey:@"userId"];
//    [parameters setObject:shopCartModel.cartId forKey:@"cartId"];
//    [parameters setObject:@"1" forKey:@"type"];

    if (btn.isSelected) {
        [parameters setObject:@"3" forKey:@"type"];
    }else{
        [parameters setObject:@"2" forKey:@"type"];
    }
    
    [self.NetworkUtil POST:cartSelectAllUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        btn.enabled = YES;
        //添加成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            // 更新选中状态
            btn.selected = !btn.isSelected;
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            self.modelArray.selectTotal = [data objectForKey:@"selectTotal"];
            self.modelArray.selectTotalPrice = [data objectForKey:@"selectTotalPrice"];
            self.modelArray.total = [data objectForKey:@"total"];
            self.modelArray.totalPrice = [data objectForKey:@"totalPrice"];
            
            // 更新总价
            self.paymentView.price = [self.modelArray.selectTotalPrice stringValue];
            
            //全部列表的选择状态
            [self updateSelectState:btn.isSelected];
            
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        btn.enabled = YES;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}

// 更新全部选中或没有选中
- (void)updateSelectState:(BOOL)isSelect{
    
    [self.modelArray.shopArray enumerateObjectsUsingBlock:^(CartShopModel * shopModel, NSUInteger idx, BOOL *stop) {
        [shopModel.goodsArray enumerateObjectsUsingBlock:^(CartGoodsModel * goodsModel, NSUInteger idx, BOOL *stop) {
            if ([goodsModel.overSku integerValue]==1) {
                goodsModel.is_check = NO;
            }else{
                goodsModel.is_check = isSelect;
            }
        }];
    }];
    
    [self.tableView reloadData];
}


#pragma mark - 提交订单
- (void)cartPaymentViewClickedSumbitBtn:(UIButton *)btn{
    
    // 没有初始化完商品时
    if(self.modelArray.shopArray.count == 0) return;
    
    // 没有选中商品
    if([self.modelArray.selectTotal integerValue] == 0){
        [self.HUDUtil showTextMBHUDWithText:@"当前没有选中商品，请选择" delay:2.0 inView:self.view];
        return;
    }

    // 库存不足
    if([self hasUnderstock]){
        [self.HUDUtil showTextMBHUDWithText:@"当前库存不足，请修改购买数量" delay:2.0 inView:self.view];
        return;
    }
    
    // 无货或下架
    if ([self hasOverSku]) {
        [self.HUDUtil showTextMBHUDWithText:@"有商品无货或下架，请先删除" delay:2.0 inView:self.view];
        return;
    }
    
   btn.enabled = NO;
    
    NSString *orderListUrl=[API_ROOT stringByAppendingString:API_ORDER_LIST];
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.userId forKey:@"userId"];

    UIView *view = self.view;

    if (self.isSeparate) {
        [parameters setObject:@(self.sellerId) forKey:@"sellerId"];
        view = nil;
    }

    [self.NetworkUtil POST:orderListUrl parameters:parameters inView:view success:^(id responseObject) {

        btn.enabled = YES;
        //添加成功
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {

            [self.separateView removeFromSuperview];
            self.separateView = nil;

            // 更新选中状态
            PaymentListModel * model = [[PaymentListModel alloc]initWithAttributes:responseObject];
            
            QPMOrderConfirmViewController * vc = [[QPMOrderConfirmViewController alloc]init];
            vc.payModel = model;

            if (self.isSeparate) {
                vc.sellerId = self.sellerId;
            }

            [self.navigationController pushViewController:vc animated:YES];

        }
        else if ([[responseObject objectForKey:@"status"] intValue] == 2) {
            //拆单支付
            [self.separateModels removeAllObjects];

            NSArray *datas = [responseObject objectForKey:@"data"];

            for (NSDictionary *dataDic in datas) {
                QPMPaymentSeparateModel *model = [[QPMPaymentSeparateModel alloc] initWithAttributes:dataDic];
                [self.separateModels addObject:model];
            }

            [self.view.window addSubview:self.separateView];
            self.separateView.models = self.separateModels;
            [self.separateView show];
        }
        else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {

        btn.enabled = YES;

        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 查找购物车选中状态的库存不足
-(BOOL)hasUnderstock{
    __block BOOL understock = NO;
    [self.modelArray.shopArray enumerateObjectsUsingBlock:^(CartShopModel * shopModel, NSUInteger idx, BOOL *stop) {
        [shopModel.goodsArray enumerateObjectsUsingBlock:^(CartGoodsModel * goodsModel, NSUInteger idx, BOOL *stop) {
            if ([goodsModel.quantity integerValue]>[goodsModel.goodsAgentSku integerValue] && goodsModel.is_check) {
                understock = YES;
                *stop = YES;
            }
        }];
        *stop = YES;
    }];
    return understock;
}

#pragma mark - 查找购物车无货或下架
-(BOOL)hasOverSku{
    __block BOOL hasOverSku = NO;
    [self.modelArray.shopArray enumerateObjectsUsingBlock:^(CartShopModel * shopModel, NSUInteger idx, BOOL *stop) {
        [shopModel.goodsArray enumerateObjectsUsingBlock:^(CartGoodsModel * goodsModel, NSUInteger idx, BOOL *stop) {
            if ([goodsModel.overSku integerValue]==1) {
                hasOverSku = YES;
                *stop = YES;
            }
        }];
        *stop = YES;
    }];
    return hasOverSku;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    //1. Setup the CATransform3D structure
//    CATransform3D rotation;
//    rotation                = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
//    rotation.m34            = 1.0/ -600;
//
//
//    //2. Define the initial state (Before the animation)
//    cell.layer.shadowColor  = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha              = 0;
//
//    cell.layer.transform    = rotation;
//    cell.layer.anchorPoint  = CGPointMake(0, 0.5);
//
//
//    //3. Define the final state (After the animation) and commit the animation
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.8];
//    cell.layer.transform    = CATransform3DIdentity;
//    cell.alpha              = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
//
//}

#pragma mark - setters and getters
- (NSMutableArray *)separateModels {
    if (!_separateModels) {
        _separateModels = [NSMutableArray array];
    }
    return _separateModels;
}

- (QPMPaymentSeparateView *)separateView {
    if (!_separateView) {
        _separateView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QPMPaymentSeparateView class]) owner:nil options:nil] lastObject];
        _separateView.frame = CGRectMake(0, 0, K_UIScreen_WIDTH, K_UIScreen_HEIGHT);
        _separateView.delegate = self;
    }
    return _separateView;
}

@end
