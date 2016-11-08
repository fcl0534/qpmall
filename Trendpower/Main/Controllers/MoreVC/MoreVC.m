//
//  MoreVC.m
//  Trendpower
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "MoreVC.h"
#import "CompanyInfoModel.h"
#import "AboutInfoVC.h"
#import "SettingVC.h"
#import "BaseWeb.h"
#import "SearchVC.h"

@interface MoreVC()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

/** 列表数据 */
@property (nonatomic, strong) NSArray * settingArray;
/** 内容数据 */
@property (nonatomic, strong) CompanyInfoModel * infoModel;

@end
@implementation MoreVC
- (NSArray *)settingArray{
    if (_settingArray == nil) {
        _settingArray = @[@[@"企业介绍",@"联系我们"],@[@"搜索产品",@"关于应用"]];
    }
    return _settingArray;
}


#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //没有数据 每次请求
    if (!self.infoModel.companyName.length) {
        [self fetchCompanyInfo];
    }
}

#pragma mark - initView
- (void)initView{
    self.title = @"关于我们";
}

- (void)initTableView{
    if (self.tableView) {
        return;
    }
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) style:UITableViewStyleGrouped];
    tableView.separatorColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchCompanyInfo)];
    [self.tableView.header setTitle:@"正在刷新，请稍候..." forState:MJRefreshHeaderStateRefreshing];
    self.tableView.header.updatedTimeHidden = YES;
}

- (void)fetchCompanyInfo{
    
    NSString *companyInfoUrl=[API_ROOT stringByAppendingString:API_COMPANY_INFO];
    DLog(@"API_COMPANY_INFO---%@",companyInfoUrl);
    
    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    
    [self.NetworkUtil GET:companyInfoUrl header:header success:^(id responseObject) {
        [self initTableView];
        
        [self.tableView.header endRefreshing];
//        //"status": 0 表示列表为空
//        if([[responseObject objectForKey:@"status"] intValue] == 0 ){
//            [self.HUDUtil showErrorMBHUDWithText:@"加载失败，请下拉重新刷新" inView:self.view delay:2];
//            return;
//        }
        
        self.infoModel = [[CompanyInfoModel alloc]initWithAttributes:responseObject];
  
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.HUDUtil showErrorMBHUDWithText:@"加载失败，请重新刷新" inView:self.view delay:2];
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.settingArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = [self.settingArray[section] count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"MoreVcCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.settingArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.276 alpha:1.000];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * header;
    switch (section) {
        case 0:
            header = @"企业信息";
            break;
        case 1:
            header = @"应用信息";
            break;
    }
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{//企业介绍
                    [self webViewWithTitle:@"企业介绍" content:self.infoModel.companyProfile];
                    break;
                }
                case 1:{//联系我们
                    [self webViewWithTitle:@"联系我们" content:self.infoModel.contactUs];
                    break;
                }
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:{
                    SearchVC *vc = [[SearchVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 1:{
                    AboutInfoVC * VC=[[AboutInfoVC alloc]init];
                    VC.infoModel = self.infoModel;
                    [self.navigationController pushViewController:VC animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    
}


#pragma mark - 跳转到网页
- (void) webViewWithTitle:(NSString *)title content:(NSString *)content{
    
    BaseWeb * web = [[BaseWeb alloc]init];
    web.titleName = title;
    [web displayContent:content];
    [self.navigationController pushViewController:web animated:YES];
}

@end
