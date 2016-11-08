//
//  SearchVC.m
//  Trendpower
//
//  Created by trendpower on 15/5/28.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "SearchVC.h"

#import "KxMenu.h"

#import "GoodsListViewController.h"
#import "RightImageButton.h"

#import "TPSearchStoryWordTool.h"

@interface SearchVC()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, UITextFieldDelegate>

/**  搜索栏 */
@property (nonatomic, weak) RightImageButton * keyBtn;
@property(nonatomic, weak) UITextField *searchField;
@property(nonatomic, weak) UITableView * tableView;

/**  底部清空历史视图 */
@property(nonatomic, weak) UIView * footerView;

/**  搜索词 */
@property(nonatomic, strong) NSString *keyWords;
/**  热词的数组 */
@property(nonatomic, strong) NSMutableArray *hotArray;
/**  历史词的数组 */
@property(nonatomic, strong) NSMutableArray *storyArray;


@end

@implementation SearchVC

- (NSMutableArray *)hotArray{
    if (_hotArray == nil) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}

- (NSMutableArray *)storyArray{
    if (_storyArray == nil) {
        _storyArray = [NSMutableArray array];
    }
    return _storyArray;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initSearchBar];
    [self initTableView];
    [self setTitleSearchBar];
}

#pragma mark - 搜索栏
- (void) initSearchBar{
    
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(50, 7, K_UIScreen_WIDTH -50 -44 -10, 44 -14)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 3;
    searchView.layer.masksToBounds = YES;
    [self.naviBar addSubview:searchView];
    
    RightImageButton * keyBtn = [[RightImageButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [keyBtn setImage:[UIImage imageNamed:@"heise_sanjiao"] forState:UIControlStateNormal];
    [keyBtn setTitleColor:[UIColor colorWithRed:0.131 green:0.129 blue:0.132 alpha:1.000] forState:UIControlStateNormal];
    //    [keyBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 0, 0)];
    [keyBtn addTarget:self action:@selector(clickedKeyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:keyBtn];
    self.keyBtn = keyBtn;
    
    UITextField * searchField = [[UITextField alloc]initWithFrame:CGRectMake(65, 0, CGRectGetWidth(searchView.frame) -70, 30)];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.textAlignment = NSTextAlignmentLeft;
    searchField.font = [UIFont systemFontOfSize:13];
    searchField.textColor = [UIColor colorWithRed:0.224 green:0.220 blue:0.224 alpha:1.000];
    searchField.tintColor = K_MAIN_COLOR;
    searchField.delegate = self;
    [searchView addSubview:searchField];
    self.searchField = searchField;
    
    //搜索按钮
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    searchBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(clickedSearchBtn:) forControlEvents:UIControlEventTouchDown];
    [self.naviRightItem addSubview:searchBtn];
}

#pragma mark - tableView
- (void) initTableView{
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_UIScreen_WIDTH, K_UIScreen_HEIGHT -64) style:UITableViewStylePlain];
    tableView.rowHeight = 44;
    tableView.backgroundColor = K_GREY_COLOR;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self setTableFooterView];
    
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchHotList)];
    [self.tableView.header setTitle:@"下拉刷新热词" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"正在刷新，请稍候..." forState:MJRefreshHeaderStateRefreshing];
    self.tableView.header.updatedTimeHidden = YES;
    
    //
    self.storyArray = [TPSearchStoryWordTool getStoryWords];
    
    [self fetchHotList];
}



#pragma mark - 请求搜词列表
- (void)fetchHotList{
    
    NSString *hotWordListUrl=[API_ROOT stringByAppendingString:API_KEYWORDS_HOT];
    hotWordListUrl = [hotWordListUrl stringByAppendingFormat:@"limit=%@",@"6"];

    [self.NetworkUtil GET:hotWordListUrl success:^(id responseObject) {
        // 1.
        /**
         *  {
         "data": [
         {
         "searchId": "1",
         "searchName": "蓄电池",
         "searchType": "category"
         },
         {
         "searchId": "161",
         "searchName": "嘉乐驰",
         "searchType": "brand"
         },

         */
        [self.tableView.header endRefreshing];
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            
            [self.hotArray removeAllObjects];
            NSArray * hotArray = [responseObject objectForKey:@"data"];
            [hotArray enumerateObjectsUsingBlock:^(NSDictionary * dic, NSUInteger idx, BOOL *stop) {
                [self.hotArray addObject:dic];
            }];
            
            [self setHotWordList];
            
        }else{
            //[self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        //[self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

- (void)setHotWordList{
    
   self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 170)];
    self.tableView.tableHeaderView = headerView;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, K_UIScreen_WIDTH, 40)];
    titleLabel.text = @"热门搜索";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithWhite:0.145 alpha:1.000];
    [headerView addSubview:titleLabel];
    
    CGFloat viewW = K_UIScreen_WIDTH;
    CGFloat margin = 10;
    CGFloat usableW = viewW;//同一行可用宽度
    CGFloat BtnY = 50;//热词的Y
    CGFloat BtnH = 30;
    CGFloat BtnX = 10;
    CGFloat fontSize = 15;
    
    for(int i=0;i<self.hotArray.count;i++){
        
        NSString *hotWord = [self.hotArray[i] objectForKey:KEY_searchName];
        CGSize nameSize = [self sizeWithText:hotWord font:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        CGFloat BtnW = 4*margin + nameSize.width;//按钮宽
        if (usableW < (BtnW + 2*margin)) {//可用宽度小于按钮宽度，换行，并重设数据
            if (BtnY == 90) {//如果已经是第二行，直接返回
                break;
            }
            BtnY = 90;
            BtnX = 10;
            usableW = viewW;
        }
        
        usableW = usableW - BtnW - margin;//可用宽度
        
        UIButton * hotBtn = [[UIButton alloc]initWithFrame:CGRectMake(BtnX, BtnY, BtnW, BtnH)];
        hotBtn.tag = i;
        hotBtn.backgroundColor = [UIColor whiteColor];
        hotBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [hotBtn setTitle:hotWord forState:UIControlStateNormal];
        [hotBtn setTitleColor:[UIColor colorWithWhite:0.400 alpha:1.000] forState:UIControlStateNormal];
        [hotBtn setTitleColor:self.mainColor forState:UIControlStateHighlighted];
        [hotBtn.layer setBorderColor:[[UIColor colorWithWhite:0.667 alpha:0.670] CGColor]];
        [hotBtn.layer setBorderWidth:0.5f];
        [hotBtn.layer setCornerRadius:15.0f];
        [hotBtn.layer setMasksToBounds:YES];
        [hotBtn addTarget:self action:@selector(clickedHotWord:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:hotBtn];
        
        BtnX = BtnX + BtnW +margin;
    }
    
    
    UIView * whiteLine = [[UIView alloc]initWithFrame:CGRectMake(0, 150, K_UIScreen_WIDTH, 19.5)];
    whiteLine.backgroundColor = [UIColor whiteColor];
    whiteLine.layer.borderWidth = 0.5;
    whiteLine.layer.borderColor = [UIColor colorWithWhite:0.837 alpha:1.000].CGColor;
    [headerView addSubview:whiteLine];
    
}

#pragma mark - 点击热词搜索
- (void)clickedHotWord:(UIButton *)hotBtn
{
    [self searchWithKeyWord:self.hotArray[hotBtn.tag]];
}

#pragma mark - ####　全部搜索处理事件
- (void)searchWithKeyWord:(NSDictionary *)dic
{
    [TPSearchStoryWordTool setStoryWord:dic];
    
    GoodsListViewController * vc = [[GoodsListViewController alloc]init];

    if ([[dic objectForKey:KEY_searchType] isEqualToString:KEY_searchType_brand]) {
        // 品牌
        vc.filterName = [dic objectForKey:KEY_searchName];
        vc.filterType = GoodsFilterTypeBrand;
        vc.brandIds =  [dic objectForKey:KEY_searchId];
    }else if([[dic objectForKey:KEY_searchType] isEqualToString:KEY_searchType_category]){
        // 分类
        vc.filterName = [dic objectForKey:KEY_searchName];
        vc.filterType = GoodsFilterTypeCategory;
        vc.cateId = [dic objectForKey:KEY_searchId];
    }else if([[dic objectForKey:KEY_searchType] isEqualToString:KEY_searchType_VIN]){
        //VIN词
        vc.filterName = [dic objectForKey:KEY_searchName];
        vc.filterType = GoodsFilterTypeVinCode;
        vc.vinCode = [dic objectForKey:KEY_searchName];
        // 设置当前为VIN
        self.currentFilterType = 1;
        [self setTitleSearchBar];
    }
    else{ //搜索词
        vc.filterName = [dic objectForKey:KEY_searchName];
        vc.filterType = GoodsFilterTypeGoodsName;
        vc.goodsName = [dic objectForKey:KEY_searchName];;
    }
    
    [self.navigationController pushViewController:vc animated:YES];

    // 3.
    if (self.storyArray.count) {
        if (![[self.storyArray[0] objectForKey:KEY_searchName] isEqualToString:[dic objectForKey:KEY_searchName]]){
            [self.storyArray insertObject:dic atIndex:0];
            [self.tableView reloadData];
        }
    }else{
        [self.storyArray addObject:dic];
        [self.tableView reloadData];
    }
    
    self.searchField.text = [dic objectForKey:KEY_searchName];
}


/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
#pragma mark - 计算文字尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.storyArray.count) {
        self.footerView.hidden = NO;
    }else{
        self.footerView.hidden = YES;
    }
    
    return self.storyArray.count?(self.storyArray.count +1):0;
}

#pragma mark init cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * searchCell = @"searchCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell];
        cell.backgroundColor = K_GREY_COLOR;
    }
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"历史搜索";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor colorWithRed:0.145f green:0.145f blue:0.145f alpha:1.00f];
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.text = [self.storyArray[indexPath.row-1] objectForKey:KEY_searchName];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = [UIColor colorWithRed:0.357f green:0.353f blue:0.353f alpha:1.00f];
    }
    return cell;
}


#pragma mark Select Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
#pragma mark - 点击历史词
    [self searchWithKeyWord:self.storyArray[indexPath.row -1]];
    
}


#pragma mark - 清空历史搜索 视图
- (void)setTableFooterView{
    
    if (self.footerView == nil) {
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 120)];
        UIButton * clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 35, K_UIScreen_WIDTH -60, 40)];
        [clearBtn setTitle:@"清空历史搜索" forState:UIControlStateNormal];
        clearBtn.backgroundColor = [UIColor whiteColor];
        [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [clearBtn setTitleColor:[UIColor colorWithRed:0.357 green:0.353 blue:0.353 alpha:1.000] forState:UIControlStateNormal];
        clearBtn.layer.borderColor = [UIColor colorWithWhite:0.192 alpha:1.000].CGColor;
        clearBtn.layer.borderWidth = 1.0;
        clearBtn.layer.cornerRadius = 3;
        clearBtn.layer.masksToBounds = YES;
        [view addSubview:clearBtn];
        [clearBtn addTarget:self action:@selector(clearStoryWord:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_UIScreen_WIDTH, 0.5)];
        topLine.backgroundColor = [UIColor colorWithWhite:0.667 alpha:0.670];
        [view addSubview:topLine];
        
        self.tableView.tableFooterView = view;
        self.footerView = view;
    }
}

#pragma mark - 清空历史操作
- (void)clearStoryWord:(UIButton *)btn{
    
//    NSMutableArray * array = [NSMutableArray array];
//    for (int i = 1; i <=self.storyArray.count; i++) {
//        NSIndexPath * path = [NSIndexPath indexPathForRow:i inSection:0];
//        [array addObject:path];
//    }
    
    [self.storyArray removeAllObjects];
    
    [TPSearchStoryWordTool removeAllStoryWord];
    
    self.footerView.hidden = YES;
    [self.tableView reloadData];
    
//    [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - 点击筛选

- (void)clickedKeyBtn:(UIButton *)btn{
    TPTapLog;
    NSArray *titleArray=@[@"关键词",@"VIN"];
    
    //生成菜单项
    NSMutableArray *menuItems=[NSMutableArray array];
    for (int i=0; i<titleArray.count; i++) {
        KxMenuItem *menuItem=[KxMenuItem menuItem:titleArray[i] index:i image:nil target:self action:@selector(menuItemSelected:)];
        [menuItems addObject:menuItem];
    }
    
    KxMenuItem *first = menuItems[self.currentFilterType];
    first.foreColor = self.mainColor;
//    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(65, 38, 30, 20)
                 menuItems:menuItems];
}


-(void) menuItemSelected:(KxMenuItem*) item{
    
    //设置当前类型
    self.currentFilterType = item.index;
    
    [self setTitleSearchBar];
}


- (void)setTitleSearchBar{
    
    if (self.currentFilterType == 1) {
        [self.keyBtn setTitle:@"VIN" forState:UIControlStateNormal];
        self.searchField.placeholder = @"输入VIN查询";
    }else{
        [self.keyBtn setTitle:@"关键词" forState:UIControlStateNormal];
        self.searchField.placeholder = @"商品名称、规格型号、分类、品牌、车型";
    }
}


- (void)clickedSearchBtn:(UIButton *)btn{
    TPTapLog;
    
    if (self.currentFilterType == 1) {
        if (self.searchField.text.length == 17) {
            [self.view endEditing:YES];

//            [self requestVINInfo];

            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:self.searchField.text forKey:KEY_searchId];
            [dic setValue:self.searchField.text forKey:KEY_searchName];
            [dic setValue:KEY_searchType_VIN forKey:KEY_searchType];
            [self searchWithKeyWord:dic];

            
        }else if(self.searchField.text.length != 0){
            [self.HUDUtil showTextJGHUDWithText:@"车架号格式有误" delay:1.0 inView:self.view];
        }else{
            [self.HUDUtil showTextJGHUDWithText:@"请输入17位车架号" delay:1.0 inView:self.view];
        }
        
    }else{
        
        if (self.searchField.text.length == 0) {
            [self.HUDUtil showTextJGHUDWithText:@"请输入搜索词" delay:1.5 inView:self.view];
            return;
        }
        
        [self.view endEditing:YES];
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:self.searchField.text forKey:KEY_searchName];
        [dic setValue:KEY_searchType_word forKey:KEY_searchType];
        [self searchWithKeyWord:dic];
    }

}

#pragma mark - 搜索按钮事件

#pragma makr - textfild
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.currentFilterType == 1) {
        if (self.searchField.text.length == 17) {
            [self.view endEditing:YES];

//            [self requestVINInfo];

            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:self.searchField.text forKey:KEY_searchId];
            [dic setValue:self.searchField.text forKey:KEY_searchName];
            [dic setValue:KEY_searchType_VIN forKey:KEY_searchType];
            [self searchWithKeyWord:dic];

        }else if(self.searchField.text.length != 0){
            [self.HUDUtil showTextJGHUDWithText:@"车架号格式有误" delay:1.0 inView:self.view];
        }else{
            [self.HUDUtil showTextJGHUDWithText:@"请输入17位车架号" delay:1.0 inView:self.view];
        }
        
    }else{
        
        if (self.searchField.text.length == 0) {
            [self.HUDUtil showTextJGHUDWithText:@"请输入搜索词" delay:1.5 inView:self.view];
        }else{
            [self.view endEditing:YES];
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:self.searchField.text forKey:KEY_searchName];
            [dic setValue:KEY_searchType_word forKey:KEY_searchType];
            [self searchWithKeyWord:dic];
        }
    }
    
    return YES;
}

- (void)requestVINInfo {

    NSString *url=[API_ROOT stringByAppendingString:API_GOODS_LIST];

    url = [url stringByAppendingFormat:@"&vin=%@",self.searchField.text];

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    //

    [self.NetworkUtil GET:url header:header inView:self.view success:^(id responseObject) {
        //
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {

            NSDictionary * dataDic = [responseObject objectForKey:@"data"];

            NSArray * goodsArray = [dataDic objectForKey:@"list"];

            NSString *filterName = @"";
            if (goodsArray.count > 0) {
                filterName = [dataDic objectForKey:@"car_mode_name"]?[dataDic objectForKey:@"car_mode_name"]:self.searchField.text;
            }

            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:self.searchField.text forKey:KEY_searchId];
            [dic setValue:self.searchField.text forKey:KEY_searchName];
            [dic setValue:KEY_searchType_VIN forKey:KEY_searchType];
            [dic setValue:filterName forKey:KEY_searchVINResult];

            [self searchWithKeyWord:dic];

        } else {
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }

    } failure:^(NSError *error) {
        //
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


@end
