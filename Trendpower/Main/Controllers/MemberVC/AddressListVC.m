//
//  AddressListVC.m
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#define K_Address_Bar_Height 70
#define K_Cell_Height 140

#import "AddressListVC.h"
#import "AddressModel.h"
#import "AddressModelArray.h"
#import "AddressListTableViewCell.h"
#import "CustomButtonView.h"
#import "AddressEditVC.h"



@interface AddressListVC ()<UITableViewDataSource,UITableViewDelegate,AddressListCellDelegete,CustomButtonViewDelegate, HUDAlertViewDelegate, EmptyPlaceholderViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) AddressModelArray * addressArray;

/**
 *  新建地址栏
 */
@property (nonatomic, weak) CustomButtonView * addressView;

/**  空视图 */
@property (nonatomic, weak) EmptyPlaceholderView *emptyView;
@end

@implementation AddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    [self setEmptyView];
    [self initTableView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self fetchAddressList];
}

#pragma mark - 空视图
- (void)setEmptyView{
    if (self.emptyView == nil) {
        EmptyPlaceholderView * emptyView = [[EmptyPlaceholderView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT) placeholderText:@"暂无收货地址哦" placeholderIamge:[UIImage imageNamed:@"address_null_bg"] btnName:@"马上创建"];
        self.emptyView = emptyView;
        emptyView.delegate = self;
        [self.view addSubview:emptyView];
    }
    
    self.emptyView.hidden = YES;
}


#pragma mark - 空点击事件
- (void)EmptyPlaceholderViewClickedButton:(UIButton *)btn{
    
    [self CustomButtonClicked:nil];
}

#pragma mark - TableView
- (void)initTableView{
    
    if (self.tableView == nil) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64 -K_Address_Bar_Height) style:UITableViewStylePlain];
        tableView.backgroundColor = K_GREY_COLOR;
        self.tableView = tableView;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView.tableFooterView = [[UIView alloc]init];
        
        [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchAddressList)];
        [self.tableView.header setTitle:@"正在刷新，请稍候..." forState:MJRefreshHeaderStateRefreshing];
        self.tableView.header.updatedTimeHidden = YES;
        
        [self initNewAddressBarView];
    }
}

- (void)initNewAddressBarView{
    
    CustomButtonView * view = [[CustomButtonView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), K_UIScreen_WIDTH, K_Address_Bar_Height)];
    view.delegate = self;
    [view.customBtn setTitle:@" 新建地址" forState:UIControlStateNormal];
    [view.customBtn setImage:[UIImage imageNamed:@"MyAddressManager_button_add"] forState:UIControlStateNormal];
    [self.view addSubview:view];
    view.hidden = YES;
    self.addressView = view;
    
}


#pragma mark - 请求地址列表
- (void)fetchAddressList{
    NSString *nonpaymentListUrl=[API_ROOT stringByAppendingString:API_ADDRESS_LIST];
    nonpaymentListUrl = [nonpaymentListUrl stringByAppendingString:self.userId];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    [self.NetworkUtil GET:nonpaymentListUrl header:header inView:self.view success:^(id responseObject) {
        [self.tableView.header endRefreshing];

        if([[responseObject objectForKey:@"status"] intValue] == 1){
            NSDictionary * dic = [responseObject objectForKey:@"data"];
            self.addressArray = [[AddressModelArray alloc]initWithAttributes:dic];
            
            if(self.addressArray.dataAddressArray.count==0){
                self.tableView.hidden = YES;
                self.addressView.hidden = YES;
                self.emptyView.hidden = NO;
            }else{
                self.tableView.hidden = NO;
                self.addressView.hidden = NO;
                self.emptyView.hidden = YES;
            }
            [self.tableView reloadData];
        }else{
            //[self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
        
    }];
    
    
}


#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger count = self.addressArray.dataAddressArray.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return K_Cell_Height;
}


#pragma mark init cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1.取出模型
    AddressModel * model = self.addressArray.dataAddressArray[indexPath.row];
    
    //2.赋值
    AddressListTableViewCell * cell = [AddressListTableViewCell cellWithTableView:tableView];
    cell.addressModel = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.selected = NO;
    if (self.isFormPayment) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isFormPayment) {
        //1.取出模型
        AddressModel * model = self.addressArray.dataAddressArray[indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFI_SELECT_ADDRESS  object:model];
        });
    }
}



#pragma mark - AddressListCellDelegate
#pragma mark  设置默认收货地址
- (void)clickedDefaultBtn:(UIButton *)btn addressModel:(AddressModel * )addressModel indexPath:(NSIndexPath * )indexPath{
    
    //如果选中则不能在选择
    if (btn.selected) return;
    
    NSString *defaultAddressUrl=[API_ROOT stringByAppendingString:API_ADDRESS_DEFAULT];

    // 1.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:addressModel.addressId forKey:@"addressId"];
    // 2.
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    
    
    
    // 3.
    [self.NetworkUtil POST:defaultAddressUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        if([[responseObject objectForKey:@"status"] intValue] == 1 ){
            [self.addressArray.dataAddressArray enumerateObjectsUsingBlock:^(AddressModel * model, NSUInteger idx, BOOL *stop) {
                
                NSLog(@"isDefaultArress----%d",model.isDefaultArress);
                //把原来默认的选中取消
                if (model.isDefaultArress) {
                    model.isDefaultArress = NO;
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
                //设置默认的
                if (idx == indexPath.row) {
                    model.isDefaultArress = YES;
                }
            }];
            
            btn.selected = YES;
            
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        TPError;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark  点击编辑地址
- (void)clickedEditBtn:(UIButton *)btn addressModel:(AddressModel * )addressModel indexPath:(NSIndexPath * )indexPath{
    AddressEditVC * vc = [[AddressEditVC alloc]init];
    vc.addressModel = addressModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  点击删除地址
- (void)clickedDeleteBtn:(UIButton *)btn addressModel:(AddressModel * )addressModel indexPath:(NSIndexPath * )indexPath{
    self.HUDUtil.delegate = self;
    [self.HUDUtil showActionSheetInView:self.view tag:[addressModel.addressId integerValue] title:@"是否确认删除该地址？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil];
}

#pragma mark 选择是否删除地址
- (void)hudActionSheetClickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag{
    
    switch (buttonIndex) {
        case 0://确认按钮
            [self deleteAddressId:tag];
            break;
        case 1://取消按钮
            break;
        default:
            break;
    }
}

#pragma mark - 删除地址请求
- (void) deleteAddressId:(NSInteger)addressId{
    
    NSString *deleteAddressUrl=[API_ROOT stringByAppendingString:API_ADDRESS_DELETE];
    
    
    // 1.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userId forKey:@"userId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",addressId] forKey:@"addressId"];
    // 2.
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    
    
    
    // 3.
    [self.NetworkUtil POST:deleteAddressUrl header:header parameters:parameters inView:self.view success:^(id responseObject) {
        
        if([[responseObject objectForKey:@"status"] intValue] == 1 ){
            [self.HUDUtil showTextMBHUDWithText:@"地址删除成功!"  delay:1 inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        TPError;
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 新建地址
- (void)CustomButtonClicked:(UIButton *)btn{

    if (self.addressArray.dataAddressArray.count >9) {
        [self.HUDUtil showErrorMBHUDWithText:@"抱歉，地址信息最多10条哦！" inView:self.view delay:2];
        return;
    }
    
    AddressEditVC * vc = [[AddressEditVC alloc]init];
    vc.isFromNewAddress = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
