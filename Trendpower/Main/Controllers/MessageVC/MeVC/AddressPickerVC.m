//
//  AddressPickerVC.m
//  Trendpower
//
//  Created by HTC on 16/1/24.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "AddressPickerVC.h"

@interface AddressPickerVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, strong) NSArray * addressArray;

@end

@implementation AddressPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self initNaviBar];

    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.naviLeftItem.isHidden ? [self initNaviBars] : nil;
    self.addressArray.count ? : [self fetchAddressList];
    
}

- (void)fetchAddressList{
    
    NSString *url=[API_ROOT stringByAppendingString:API_ADDRESS_REGION];
    /**
     *  "parentId": "2",
     "regionId": "52",
     "regionName": "北京"
     */
    switch (self.addressType) {
        case AddressTypeProvince:
            self.title = @"选择所在地";
            self.addressDic = [NSMutableDictionary dictionary];
            break;
        case AddressTypeCity:
            self.title = [self.addressDic objectForKey:@"title1"];
            url = [url stringByAppendingFormat:@"parentId=%@",[self.addressDic objectForKey:@"1"]];
            break;
        case AddressTypeDistrict:
            self.title = [NSString stringWithFormat:@"%@-%@",[self.addressDic objectForKey:@"title1"],[self.addressDic objectForKey:@"title2"]];
            url = [url stringByAppendingFormat:@"parentId=%@",[self.addressDic objectForKey:@"2"]];
            break;
        default:
            break;
    }

    [self.NetworkUtil GET:url success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            self.addressArray = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
            // 判断有几级地址
            if(!self.addressArray.count){
                switch (self.addressType) {
                    case AddressTypeProvince:
                        [self.addressDic setObject:@"" forKey:@"title1"];
                        [self.addressDic setObject:@"" forKey:@"1"];
                        [self.addressDic setObject:@"" forKey:@"title2"];
                        [self.addressDic setObject:@"" forKey:@"2"];
                        [self.addressDic setObject:@"" forKey:@"title3"];
                        [self.addressDic setObject:@"" forKey:@"3"];
                        break;
                    case AddressTypeCity:
                        [self.addressDic setObject:@"" forKey:@"title2"];
                        [self.addressDic setObject:@"" forKey:@"2"];
                        [self.addressDic setObject:@"" forKey:@"title3"];
                        [self.addressDic setObject:@"" forKey:@"3"];
                        break;
                    case AddressTypeDistrict:{
                        [self.addressDic setObject:@"" forKey:@"title3"];
                        [self.addressDic setObject:@"" forKey:@"3"];
                        break;
                    }
                    default:
                        break;
                }
                // 所有控制器
                AddressPickerVC * vc = self.navigationController.childViewControllers.firstObject;
                if (vc.delegate && [vc.delegate respondsToSelector:@selector(addressPickerVC:)]) {
                    [vc.delegate addressPickerVC:self];
                }
            }else{
                [self.tableView reloadData];
            }

        }else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


- (void)initNaviBars{
    UIButton * naviLeftItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    naviLeftItem.backgroundColor = self.mainColor;
    [naviLeftItem setImage:[UIImage imageNamed:@"navi_backBtn"] forState:UIControlStateNormal];
    [naviLeftItem addTarget:self action:@selector(clickedBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviLeftItem addSubview:naviLeftItem];
    self.naviLeftItem.hidden = NO;
}

- (void)initTableView{
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)clickedBackButton:(UIButton * )btn{
    switch (self.addressType) {
        case AddressTypeProvince:
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
        case AddressTypeCity:
        case AddressTypeDistrict:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"AddressCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView * view = [[UIView alloc]initWithFrame:cell.frame];
        view.backgroundColor = self.mainColor;
        cell.selectedBackgroundView = view;
    }
    
    
    NSDictionary * dic = self.addressArray[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"regionName"];
    cell.textLabel.textColor = [UIColor colorWithRed:0.357 green:0.353 blue:0.353 alpha:1.000];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /**
     *  "parentId": "2",
     "regionId": "52",
     "regionName": "北京"
     */
    
    NSDictionary * dic = self.addressArray[indexPath.row];
    AddressPickerVC * vc = [[AddressPickerVC alloc]init];
    vc.addressDic = self.addressDic;
    switch (self.addressType) {
        case AddressTypeProvince:
            vc.addressType = AddressTypeCity;
            [self.addressDic setObject:[dic objectForKey:@"regionName"] forKey:@"title1"];
            [self.addressDic setObject:[dic objectForKey:@"regionId"] forKey:@"1"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case AddressTypeCity:
           [self.addressDic setObject:[dic objectForKey:@"regionName"] forKey:@"title2"];
            [self.addressDic setObject:[dic objectForKey:@"regionId"] forKey:@"2"];
            vc.addressType = AddressTypeDistrict;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case AddressTypeDistrict:{
            [self.addressDic setObject:[dic objectForKey:@"regionName"] forKey:@"title3"];
            [self.addressDic setObject:[dic objectForKey:@"regionId"] forKey:@"3"];
            
//            [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    NSLog(@"---%@",obj.description);
//            }];
            // 所有控制器
            AddressPickerVC * vc = self.navigationController.childViewControllers.firstObject;
            if (vc.delegate && [vc.delegate respondsToSelector:@selector(addressPickerVC:)]) {
                [vc.delegate addressPickerVC:self];
            }
            break;
        }
        default:
            break;
    }

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
