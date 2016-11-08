//
//  HomeVC.m
//  Trendpower
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//



#define Cell_Header_Hight          40

#define Cell_Margin_WIDTH          10
#define Cell_HIGHT(column)   (220 * ((K_UIScreen_WIDTH - (column -1)* Cell_Margin_WIDTH)/column) /170)

//150/320
#define ADCell_VIEW_HIGHT          (K_UIScreen_WIDTH * 200/400)


#import "HomeViewController.h"

//tool
#import "NetworkStatusUtil.h"
#import "MessageDBUtils.h"
#import "JPUSHService.h"

//View
#import "SDCycleScrollView.h"
#import "AdView.h"
#import "ImageTextButton.h"
#import "RightImageButton.h"
#import "NewVersionView.h"

//Cell
#import "IndexSubViewCell.h"
#import "IndexADViewCell.h"
#import "IndexCategoryViewCell.h"
#import "RecoHeaderView.h"
#import "IndexLineHeaderView.h"

#import "HomeAD2CollectionCell.h"
#import "HomeAD3CollectionCell.h"
#import "HomeAD4CollectionCell.h"
#import "HomeAD5CollectionCell.h"
#import "HomeAD6CollectionCell.h"

#import "HomeBrandCollectionCell.h"
#import "HomeRecommendHeaderView.h"


//数据模型
#import "HomeModel.h"

//VC
#import "GoodsListViewController.h"
#import "ProductDetailVC.h"
#import "SearchVC.h"
#import "BrandVC.h"
#import "MessageVC.h"
#import "BaseWebVC.h"
#import "CateVC.h"
#import "CameraVC.h"
#import "GoodsListViewController.h"
#import "PointsMallVC.h"
#import "MessageListVC.h"

@interface HomeViewController()<UISearchBarDelegate, SDCycleScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate, HUDAlertViewDelegate, AdViewDelegate, HomeAD2CollectionCellDelegate, HomeAD3CollectionCellDelegate, HomeAD5CollectionCellDelegate, UIScrollViewDelegate,CameraVCDelegate>

/** 回到顶部按钮 */
@property (nonatomic,strong) UIButton *toTopBtn;
/** CollectionView */
@property(nonatomic,strong) UICollectionView *mainCollection;

/** 商品模型数据 */
@property(nonatomic,strong) HomeModel *homeModel;

/** 广告视图 */
@property (nonatomic, weak) AdView * adView;

@property (nonatomic, strong) MessageListVC *msgVC;

@end

@implementation HomeViewController

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    [self initCollection];
    [self initTopBtn];
    [self initNaviBarView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //监听新消息通知
    /**
    if(OPEN_Push_Message){
        
        // 有未读消息
        if ([[NSUserDefaults standardUserDefaults] boolForKey:K_NOTIFI_MESSAGE_CENTER]) {

            //通知有新信息事件
            [self jpushHandling];

            //[[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
        }
    }
     */

    NSString *key = @"CFBundleShortVersionString";
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];

    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if (![currentVersion isEqualToString:lastVersion] || lastVersion == nil)
    {
        // 新版本
        // 1.1 隐藏tabbar
        self.tabBarController.tabBar.hidden = YES;
        // 1.2 显示新版本
        NewVersionView * view = [[NewVersionView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:view];

        // 1.3 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];

        // 1.4 加载首页数据
        [self reloadIndexData];

        // 1.5 回调确认
        __block typeof(view) weakView = view;

        view.clickedStartBtn = ^(){

            [UIView animateWithDuration:1.2 animations:^{

                self.tabBarController.tabBar.hidden = NO;

                CGAffineTransform scaleTransform = CGAffineTransformMakeScale(3, 3);
                weakView.transform = scaleTransform;
                weakView.alpha = 0.0;

            } completion:^(BOOL finished) {
                [weakView removeFromSuperview];
            }];
        };
    }
    else {
        //
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //展示广告
            if (!self.homeModel) {
                [self showAdView];
            }
        });

        //如果登陆或注销后，刷新数据，显示价格状态
        if ([[UserDefaultsUtils getValueByKey:@"is_change_user_state"] isEqualToString:@"YES"]) {

            [self reloadIndexData];
            //[self.mainCollection reloadData];

            [UserDefaultsUtils setValue:@"NO" byKey:@"is_change_user_state"];

        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NEW_PUSH_MESSAGE" object:nil];
}

#pragma mark - 广告
- (void)showAdView{
    
    self.tabBarController.tabBar.hidden = YES;
    
    AdView * adView = [[AdView alloc]initWithFrame:self.view.bounds];
    adView.delegate = self;
    adView.adImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"launch-%d",(int)[UIScreen mainScreen].bounds.size.height]];
    [self.view addSubview:adView];
    self.adView = adView;
    
    NSString * url = [API_ROOT stringByAppendingString:API_HOME_AD];

    [self.NetworkUtil GET:url success:^(id responseObject) {
        
        /**
         *  {
         "data": {
         "ad_id": "13",
         "addtime": "1442988821",
         "end_time": "1446336000",
         "picInfo": [
         "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/560242e5d866f.jpg",
         "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/560242eab4c5c.jpg",
         "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/560242eeca02f.png",
         "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/560242f4b7af8.png"
         ],
         "showTime": "3",
         "start_time": "1442332800",
         "status": "1",
         "store_id": "81",
         "title": "广告测试1"
         },
         "msg": "获取广告成功.",
         "status": "1"
         }
         */
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            @try {
                NSString * url = [[[responseObject objectForKey:@"data"] objectForKey:@"picInfo"] objectAtIndex:[self getPhoneModel]];
                adView.adUrl = url;
                adView.AdTime = [[[responseObject objectForKey:@"data"] objectForKey:@"showTime"] intValue];
                [adView startAnimation];
            }
            @catch (NSException *exception) {
                [adView endAnimation];
            }
            @finally {
                
            }
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [adView endAnimation];
            });
        }
    }failure:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [adView endAnimation];
        });
    }];
    
}

#pragma mark - 获得手机型号
- (int)getPhoneModel{
    int phoneModel = 0;
    int height = (int)[UIScreen mainScreen].bounds.size.height;
    switch (height) {
        case 480:
            phoneModel = 0;
            break;
        case 568:
            phoneModel = 1;
            break;
        case 667:
            phoneModel = 2;
            break;
        case 736:
            phoneModel = 3;
            break;
        default:
            break;
    }
    
    return phoneModel;
}


#pragma mark - 广告结束
- (void)AdViewClickedSkipBtn:(UIButton *)btn{
    [self.adView endAnimation];
}

- (void)AdViewEndAnimation{
    [self initBaseData];
}

- (void)AdViewHidedAnimation{
    // 从消息推送进来
    if(self.adView.tag == 100) return;
    
    // 网络监听
    [NetworkStatusUtil startMonitoringNetworkStatus];
    // 检查更新
    [self checkUpdate];
}

- (void)initBaseData{
    self.tabBarController.tabBar.hidden = NO;
    [self.mainCollection.header beginRefreshing];

}

#pragma mark - 首页数据请求
-(void) reloadIndexData{
    
    // 读缓存
    NSData * homeData = [UserDefaultsUtils getValueByKey:KTP_HOME_Cache];
    if (homeData) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:homeData options:NSJSONReadingMutableContainers error:nil];
        self.homeModel = [[HomeModel alloc]initWithAttributes:dictionary];
        [self.mainCollection reloadData];
    }

    NSString *homeListUrl=[API_ROOT stringByAppendingString:API_HOME];

    self.isUserLogined?homeListUrl = [homeListUrl stringByAppendingFormat:@"user_id=%@",self.userId]:@"";

    NSMutableDictionary * header = [NSMutableDictionary dictionary];
    [header setObject:self.apiKey forKey:@"value"];
    [header setObject:KTP_KEY forKey:@"key"];
    
    [self.NetworkUtil GET:homeListUrl header:header success:^(id responseObject) {
        
        [self.mainCollection.header endRefreshing];

        if ([[responseObject objectForKey:@"status"] intValue] == 1) {

            self.homeModel = [[HomeModel alloc]initWithAttributes:responseObject];
            
            [self.mainCollection reloadData];
            
            // 缓存
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            [UserDefaultsUtils setValue:data byKey:KTP_HOME_Cache];
            
            [self.mainCollection.footer setHidden:NO];
            [self.mainCollection.footer noticeNoMoreData];
        
        }else if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] hasPrefix:@"4217"]){
            [self setUserLogout];
        }
        else{
            [self.HUDUtil showTextMBHUDWithText:[responseObject objectForKey:KTP_MSG]  delay:1.5 inView:self.view];
        }
    } failure:^(NSError *error) {
        [self.mainCollection.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
    
}


#pragma mark - UICollectionViewDataSource
//有多少个区域
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.homeModel.typeArray.count;
}

// 共有多少个Item(就是格子Cube)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger counts;
    /** 类型判断:
     0、广告  ads_1
     1、分类  cate_list
     2、精品专区 ads_2
     3、热门品牌  hot_brand
     4、广告位   ads_3
     5、广告位   ads_4
     6、广告位   ads_5
     7、热销商品推荐   recommend_list
     */

    NSInteger type = [self.homeModel.typeArray[section] integerValue];
    
    switch (type) {
        case 0:
        case 2:
        case 4:
        case 5:

            counts = [self.homeModel.dataHomeMedelArray[section] count] ? 1 : 0;
            break;
        case 1:
        case 3:
        {
            if ([self.homeModel.dataHomeMedelArray[section] count] > 0) {
                NSInteger fillBlanks = ([self.homeModel.dataHomeMedelArray[section] count]) % 4;

                counts = [self.homeModel.dataHomeMedelArray[section] count] + (fillBlanks ? 4-fillBlanks : 0);
            } else {
                counts = 0;
            }

            break;
        }
        case 6:

            counts = [self.homeModel.dataHomeMedelArray[section] count];

            break;
        case 7:
        {
            counts = [self.homeModel.dataHomeMedelArray[section] count];

            break;
        }
        default:
            counts = 0;
            break;
    }
    
    return counts;
}


#pragma mark cell布局
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self switchToTopBtn:indexPath];
    
    IndexCategoryViewCell * categoryCell; //分类cell
    IndexSubViewCell * productCell; //产品cell
    
    /** 类型判断:
     0、广告  ads_1
     1、分类  cate_list
     2、精品专区 ads_2
     3、热门品牌  hot_brand
     4、广告位   ads_3
     5、广告位   ads_4
     6、广告位   ads_5
     7、热销商品推荐   recommend_list
     */

    NSInteger type = [self.homeModel.typeArray[indexPath.section] integerValue];
    
    switch (type) {
        case 0:{
            IndexADViewCell *adCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexADViewCell" forIndexPath:indexPath];

//            if (adCell.subviews.count > 1)//已经创建了
//                return adCell;

            adCell = [self getADCellView:adCell AtIndexPath:(NSIndexPath *)indexPath cellHeight:ADCell_VIEW_HIGHT];
            return adCell;
            break;
        }
        case 1:{//分类
            categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexCategoryViewCell" forIndexPath:indexPath];
            NSInteger counts = [self.homeModel.dataHomeMedelArray[indexPath.section] count];
            if (indexPath.row < counts) {
                HomeCategoryModel * categoryModel =[self.homeModel.dataHomeMedelArray[indexPath.section] objectAtIndex:indexPath.row];
                categoryCell.nameLabel.text = categoryModel.cateName;
                indexPath.row == 7 ? categoryCell.iconView.image = [UIImage imageNamed:@"category_more"] : [WebImageUtil setImageWithURL:categoryModel.imageURL placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:categoryCell.iconView];
                categoryCell.nameLabel.hidden = NO;
                categoryCell.iconView.hidden = NO;
            }else{
                categoryCell.nameLabel.hidden = YES;
                categoryCell.iconView.hidden = YES;
            }
            categoryCell.backgroundColor = [UIColor whiteColor];
            
            return categoryCell;
            break;
        }
        case 2:{
            HomeAD2CollectionCell * adCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeAD2CollectionCell" forIndexPath:indexPath];
            adCell.delegate = self;
            adCell.indexPath = indexPath;
            NSArray * imageModels = self.homeModel.dataHomeMedelArray[indexPath.section];
            for (int i = 0 ; i < MIN(imageModels.count, adCell.imagesArray.count); i++) {
                UIImageView * imageView = adCell.imagesArray[i];
                AdvertiseModel * adModel =imageModels[i];
                [WebImageUtil setImageWithURL:adModel.ad_image placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:imageView];
            }
            return adCell;
            break;
        }
        case 3:{
            HomeBrandCollectionCell * brandCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBrandCollectionCell" forIndexPath:indexPath];
            NSInteger counts = [self.homeModel.dataHomeMedelArray[indexPath.section] count];
            if (indexPath.row < counts) {
                BrandModel * brandModel =[self.homeModel.dataHomeMedelArray[indexPath.section] objectAtIndex:indexPath.row];
                [WebImageUtil setImageWithURL:brandModel.brand_logo placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:brandCell.imageView];
                brandCell.imageView.hidden = NO;
            }else{
                brandCell.imageView.hidden = YES;
            }
            return brandCell;
            break;
        }
        case 4:{
            //跟ads_1一样
            HomeAD6CollectionCell *adCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeAD6CollectionCell" forIndexPath:indexPath];
            if (adCell.subviews.count > 1)//已经创建了
                return adCell;
            adCell = [self getADCellView:adCell AtIndexPath:(NSIndexPath *)indexPath cellHeight:K_UIScreen_WIDTH/3.5];
            return adCell;
            break;
        }
        case 5:{
            //AD5
            HomeAD5CollectionCell * adCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeAD5CollectionCell" forIndexPath:indexPath];
            adCell.delegate = self;
            adCell.indexPath = indexPath;
            NSArray * imageModels = self.homeModel.dataHomeMedelArray[indexPath.section];
            for (int i = 0 ; i < MIN(imageModels.count, adCell.imagesArray.count); i++) {
                UIImageView * imageView = adCell.imagesArray[i];
                AdvertiseModel * adModel =imageModels[i];
                [WebImageUtil setImageWithURL:adModel.ad_image placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:imageView];
            }
            return adCell;
            break;
        }
        case 6:{
            HomeAD4CollectionCell * adCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeAD4CollectionCell" forIndexPath:indexPath];
            NSArray * imageModels = self.homeModel.dataHomeMedelArray[indexPath.section];

            AdvertiseModel * adModel =imageModels[indexPath.row];
            [WebImageUtil setImageWithURL:adModel.ad_image placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:adCell.imageView];

            return adCell;
            break;
        }
        case 7:{//产品cell
            productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexSubViewCell" forIndexPath:indexPath];

            HomeGoodsModel * goodsModel =[self.homeModel.dataHomeMedelArray[indexPath.section] objectAtIndex:indexPath.row];
            productCell = [self setProductCellWithProductModel:goodsModel collectionViewCell:productCell];
            return productCell;
            break;
        }
        default:
            break;
    }
    
    return nil;
}

#pragma mark cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    /** 类型判断:
     0、广告  ads_1
     1、分类  cate_list
     2、精品专区 ads_2
     3、热门品牌  hot_brand
     4、广告位   ads_3
     5、广告位   ads_4
     6、广告位   ads_5
     7、热销商品推荐   recommend_list
     */

    
    NSInteger type = [self.homeModel.typeArray[indexPath.section] integerValue];
    
    switch (type) {
        case 0:
            size = CGSizeMake(K_UIScreen_WIDTH,ADCell_VIEW_HIGHT);
            break;
        case 1:
            size = CGSizeMake(K_UIScreen_WIDTH/4, 85);
            break;
        case 2:
            size = CGSizeMake(K_UIScreen_WIDTH, K_UIScreen_WIDTH/2);
            break;
        case 3:
            size = CGSizeMake(K_UIScreen_WIDTH/4, 50);
            break;
        case 4:
            size = CGSizeMake(K_UIScreen_WIDTH,K_UIScreen_WIDTH/3.5);
            break;
        case 5:
            size = CGSizeMake(K_UIScreen_WIDTH, K_UIScreen_WIDTH/3*2);
            break;
        case 6:
            size = CGSizeMake(K_UIScreen_WIDTH, K_UIScreen_WIDTH/2);
            break;
        case 7:
            size = CGSizeMake((self.view.frame.size.width - 3 *10 )/2, Cell_HIGHT(2));
            break;
        default:
            size = CGSizeMake(0, 0);
            break;
    }
    
    return size;
}

//定义每个Section 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 20, 10);
    UIEdgeInsets insets;
    /** 类型判断:
     0、广告  ads_1
     1、分类  cate_list
     2、精品专区 ads_2
     3、热门品牌  hot_brand
     4、广告位   ads_3
     5、广告位   ads_4
     6、广告位   ads_5
     7、热销商品推荐   recommend_list
     */

    NSInteger type = [self.homeModel.typeArray[section] integerValue];

    switch (type) {
        case 0:
        case 1:
            insets = UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
            break;
        case 2:
            insets = UIEdgeInsetsMake(0, 0, 10, 0);//分别为上、左、下、右
            break;
        case 3:
            insets = UIEdgeInsetsMake(0, 0, 0, 0);
            break;
        case 4:
        case 5:
        case 6:
            insets = UIEdgeInsetsMake(10, 0, 0, 0);//分别为上、左、下、右
            break;
        case 7:
            insets = UIEdgeInsetsMake(0, 10, 20, 10);
            break;
        default:
            insets = UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
            break;
    }
    
    return insets;
}


//这个是两行之间的间距（上下cell间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat spacing;
    /** 类型判断:
     0、广告  ads_1
     1、分类  cate_list
     2、精品专区 ads_2
     3、热门品牌  hot_brand
     4、广告位   ads_3
     5、广告位   ads_4
     6、广告位   ads_5
     7、热销商品推荐   recommend_list
     */

    NSInteger type = [self.homeModel.typeArray[section] integerValue];
    switch (type) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            spacing = 0;
            break;
        case 7:
            spacing = 10;
            break;
        default:
            spacing = 0;
            break;
    }
    
    return spacing;
}

//这个方法是两个之间的间距（同一行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat spacing;
    /** 类型判断:
     0、广告  ads_1
     1、分类  cate_list
     2、精品专区 ads_2
     3、热门品牌  hot_brand
     4、广告位   ads_3
     5、广告位   ads_4
     6、广告位   ads_5
     7、热销商品推荐   recommend_list
     */

    
    NSInteger type = [self.homeModel.typeArray[section] integerValue];
    
    switch (type) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            spacing = 0;
            break;
        case 7:
            spacing = 10;
            break;
        default:
            spacing = 0;
            break;
    }
    
    return spacing;
}


#pragma mark 头headerView的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    /** 类型判断:
     0、广告  ads_1
     1、分类  cate_list
     2、精品专区 ads_2
     3、热门品牌  hot_brand
     4、广告位   ads_3
     5、广告位   ads_4
     6、广告位   ads_5
     7、热销商品推荐   recommend_list
     */
    
    NSInteger type = [self.homeModel.typeArray[section] integerValue];
    
    switch (type) {
        case 0:
        case 1:
        case 4:
        case 5:
        case 6:
            size = CGSizeMake(0, 0);
            break;
        case 2:
        case 3:
        case 7:
            size = CGSizeMake(K_UIScreen_WIDTH, Cell_Header_Hight);
            break;
        default:
            size = CGSizeMake(0, 0);
            break;
    }
    
    return size;
}

#pragma mark 头headerView的布局
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader){
        /** 类型判断:
         0、广告  ads_1
         1、分类  cate_list
         2、精品专区 ads_2
         3、热门品牌  hot_brand
         4、广告位   ads_3
         5、广告位   ads_4
         6、广告位   ads_5
         7、热销商品推荐   recommend_list
         */

        NSInteger type = [self.homeModel.typeArray[indexPath.section] integerValue];
        switch (type) {
            case 0:
                return nil;
                break;
            case 1:{
                IndexLineHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"IndexLineHeaderView" forIndexPath:indexPath];
                return headerView;
                break;
            }
            case 2:{
                RecoHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RecoHeaderView" forIndexPath:indexPath];
                headerView.layer.borderColor = K_LINEBD_COLOR.CGColor;
                headerView.layer.borderWidth = 0.5;
                headerView.titleLabel.textColor = K_MAIN_COLOR;
                headerView.imageView.hidden = YES;
                headerView.titleLabel.text = @"精品专区";
                headerView.rightBtn.hidden = YES;
                return headerView;
                break;
            }
            case 3:{
                RecoHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RecoHeaderView" forIndexPath:indexPath];
                headerView.layer.borderColor = K_LINEBD_COLOR.CGColor;
                headerView.layer.borderWidth = 0.5;
                headerView.titleLabel.textColor = K_MAIN_COLOR;
                headerView.imageView.hidden = YES;
                headerView.titleLabel.text = @"热门品牌";
                headerView.layer.borderWidth = 0.0;
                headerView.rightBtn.hidden = NO;
                [headerView.rightBtn addTarget:self action:@selector(clickedMordBrand:) forControlEvents:UIControlEventTouchUpInside];
                return headerView;
                break;
            }
            case 4:
            case 5:
            case 6:{
                return nil;
                break;
            }
            case 7:{
                HomeRecommendHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeRecommendHeaderView" forIndexPath:indexPath];
                headerView.title = @"热销商品推荐";
                return headerView;
                break;
            }
            default:
                return nil;
                break;
        }
        return nil;
        
    }else if (kind == UICollectionElementKindSectionFooter){
        // 尾部
        NSInteger type = [self.homeModel.typeArray[indexPath.section] integerValue];
        switch (type) {
            case 0:
                return  nil;
                break;
            case 1:
            case 3:{
                IndexLineHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"IndexLineHeaderView" forIndexPath:indexPath];
                return headerView;
                break;
            }
            case 2:
            case 4:
            case 5:
            default:
                break;
        }
        return  nil;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size;
    /** 类型判断:
     0、广告  ads_1
     1、分类  cate_list
     2、精品专区 ads_2
     3、热门品牌  hot_brand
     4、广告位   ads_3
     5、广告位   ads_4
     6、广告位   ads_5
     7、热销商品推荐   recommend_list
     */
    
    NSInteger type = [self.homeModel.typeArray[section] integerValue];
    
    switch (type) {
        case 0:
        case 2:
        case 4:
        case 5:
        case 6:
            size = CGSizeMake(0, 0);
            break;
        case 1:
            size = CGSizeMake(K_UIScreen_WIDTH, 10);
            break;
        case 3:
            size = CGSizeMake(K_UIScreen_WIDTH, 0.5);
            break;
        default:
            size = CGSizeMake(0, 0);
            break;
    }
    
    return size;
}


#pragma mark 点击更多
- (void)clickedMordBrand:(UIButton *)btn{
    BrandVC * vc = [[BrandVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 点击Collection处理事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /** 类型判断:
     0、广告  ads_1
     1、分类  cate_list
     2、精品专区 ads_2
     3、热门品牌  hot_brand
     4、广告位   ads_3
     5、广告位   ads_4
     6、广告位   ads_5
     7、热销商品推荐   recommend_list
     */

    
    NSInteger type = [self.homeModel.typeArray[indexPath.section] integerValue];

    switch (type) {
        case 0:
            break;
        case 1:{//分类
            NSInteger counts = [self.homeModel.dataHomeMedelArray[indexPath.section] count];
            if(indexPath.row >= counts) break;
            HomeCategoryModel * cateModel =[self.homeModel.dataHomeMedelArray[indexPath.section] objectAtIndex:indexPath.row];
            if ([cateModel.cateName isEqualToString:@"更多"]) {
                CateVC * vc = [[CateVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self productListViewTitle:cateModel.cateName cateId:[NSString stringWithFormat:@"%d",cateModel.cateId] isUnShowFilterName:NO];
            }
            break;
        }
        case 2:{
            break;
        }
        case 3:{
            // 热门品牌
            NSInteger counts = [self.homeModel.dataHomeMedelArray[indexPath.section] count];
            if(indexPath.row >= counts) break;
            BrandModel * brandModel =[self.homeModel.dataHomeMedelArray[indexPath.section] objectAtIndex:indexPath.row];
            GoodsListViewController * vc = [[GoodsListViewController alloc]init];
            vc.filterName = brandModel.brand_name;
            vc.filterType = GoodsFilterTypeBrand;
            vc.brandIds = brandModel.brand_id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6:{// 单一广告
            NSArray * imageModels = self.homeModel.dataHomeMedelArray[indexPath.section];
            AdvertiseModel * adModel =imageModels[indexPath.row];
            [self adViewHaddler:adModel isUnShowFilterName:YES];
            break;
        }
        case 7:{//产品
            HomeGoodsModel * goodsModel =[self.homeModel.dataHomeMedelArray[indexPath.section] objectAtIndex:indexPath.row];
            [self productDetailWithProductId:[NSString stringWithFormat:@"%ld",(long)goodsModel.goodsId]];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 跳转到商品列表
- (void) productListViewTitle:(NSString *)title cateId:(NSString *)cateId isUnShowFilterName:(BOOL)isUnShowFilterName{

    GoodsListViewController * vc = [[GoodsListViewController alloc]init];
    vc.isUnShowFilterName = isUnShowFilterName;
    vc.filterName = title;
    vc.filterType = GoodsFilterTypeCategory;
    vc.cateId = cateId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 跳转到商品详情
- (void) productDetailWithProductId:(NSString *)productId{
    ProductDetailVC *productVC=[[ProductDetailVC alloc] init];
    productVC.productId = productId;
    productVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark - 广告栏
-(id)getADCellView:(id)cell AtIndexPath:(NSIndexPath *)indexPath cellHeight:(CGFloat)cellHeight {

    //reloadData会执行什么操作
    UIView *adCell = (UIView *)cell;

    for (UIView *view in adCell.subviews) {

        [view removeFromSuperview];
    }

    // 采用网络图片实现
    NSMutableArray * imagesArray =[NSMutableArray array];

    for (AdvertiseModel *adModel in self.homeModel.dataHomeMedelArray[indexPath.section]) {
        NSString * url = adModel.ad_image;

        [imagesArray addObject:[NSURL URLWithString:url]];
    }
    
    UIView * adView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, cellHeight)];
    [cell addSubview:adView];
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, cellHeight) imageURLsGroup:imagesArray];
    cycleScrollView.tag = indexPath.section;
    cycleScrollView.autoScrollTimeInterval = 3.5;
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
    //cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.delegate = self;
    cycleScrollView.dotColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000]; // 自定义分页控件小圆标颜色
    [adView addSubview:cycleScrollView];
    
    return cell;
}


#pragma mark - 点击广告栏  SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSArray * adArray = self.homeModel.dataHomeMedelArray[cycleScrollView.tag];
    AdvertiseModel *adModel = adArray[index];
    [self adViewHaddler:adModel isUnShowFilterName:YES];
}

#pragma mark - 点击广告栏
- (void)homeAD2CollectionCellClickedImageView:(NSInteger)index indexPath:(NSIndexPath *)indexPath{
    TPTapLog;
    NSArray * imageModels = self.homeModel.dataHomeMedelArray[indexPath.section];
    if(index>(imageModels.count -1)) return;//没有图片直接返回
    AdvertiseModel * adModel =imageModels[index];
    [self adViewHaddler:adModel isUnShowFilterName:YES];
}

- (void)homeAD3CollectionCellClickedImageView:(NSInteger)index indexPath:(NSIndexPath *)indexPath{
    TPTapLog;
    NSArray * imageModels = self.homeModel.dataHomeMedelArray[indexPath.section];
    if(index>(imageModels.count -1)) return;//没有图片直接返回
    AdvertiseModel * adModel =imageModels[index];
    [self adViewHaddler:adModel isUnShowFilterName:YES];
}

- (void)homeAD5CollectionCellClickedImageView:(NSInteger)index indexPath:(NSIndexPath *)indexPath
{
    NSArray * imageModels = self.homeModel.dataHomeMedelArray[indexPath.section];
    if(index>(imageModels.count -1)) return;//没有图片直接返回
    AdvertiseModel * adModel =imageModels[index];
    [self adViewHaddler:adModel isUnShowFilterName:YES];
}

#pragma mark - 广告处理事件
- (void)adViewHaddler:(AdvertiseModel *)adModel isUnShowFilterName:(BOOL)isUnShowFilterName{
    /**
     * 广告类别 1.网址  2.商品分类ID  3.商品ID 4.商品品牌ID  6.积分
     */
    NSInteger type = [adModel.ad_type integerValue];
    switch (type) {
        case 1:{
            BaseWebVC * vc = [[BaseWebVC alloc]init];
            vc.title = adModel.ad_title;
            vc.url = adModel.ad_value;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            [self productListViewTitle:adModel.ad_title cateId:adModel.ad_value isUnShowFilterName:YES];
            break;
        }
        case 3:{
            [self productDetailWithProductId:adModel.ad_value];
            break;
        }
        case 4:{
            GoodsListViewController * vc = [[GoodsListViewController alloc]init];
            vc.isUnShowFilterName = isUnShowFilterName;
            vc.filterName = adModel.ad_title;
            vc.filterType = GoodsFilterTypeBrand;
            vc.brandIds = adModel.ad_value;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6: {
            PointsMallVC *vc = [[PointsMallVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - set分类栏
-(IndexCategoryViewCell*)getCategoryWithCategoryModel:(HomeCategoryModel *)cateModel cellView:(IndexCategoryViewCell*) cell{
    cell.nameLabel.text = cateModel.cateName;
    [WebImageUtil setImageWithURL:cateModel.imageURL placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:cell.iconView];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


#pragma mark - set商品Cell
- (IndexSubViewCell *)setProductCellWithProductModel:(HomeGoodsModel *)goodsModel collectionViewCell:(IndexSubViewCell *)collectionViewCell{
    

    collectionViewCell.goodsNameLabel.text = goodsModel.goodsName;
    [WebImageUtil setImageWithURL:goodsModel.goodsImageUrl placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:collectionViewCell.imageView];
    collectionViewCell.priceLabel.text = self.isUserLogined?((([[goodsModel.goodsPrice class] isSubclassOfClass:[NSNull class]]) || goodsModel.goodsPrice == nil)?@"暂无库存":[NSString stringWithFormat:@"价格：¥%@",goodsModel.goodsPrice]):@"价格：会员可见";
    collectionViewCell.priceLabel.textColor = K_MAIN_COLOR;
    
    if (goodsModel.is_activity) {
        collectionViewCell.promotionImageView.hidden = NO;
    } else {
        collectionViewCell.promotionImageView.hidden = YES;
    }
    
    DashLineView * line=[[DashLineView alloc] initWithFrame:CGRectMake(0, 0, collectionViewCell.frame.size.width -20, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    if (collectionViewCell.lineView.subviews.count < 1)
        [collectionViewCell.lineView addSubview:line];
    
    collectionViewCell.layer.masksToBounds=YES;
    collectionViewCell.layer.cornerRadius = 3;
//    collectionViewCell.layer.borderColor=[[UIColor colorWithWhite:0.667 alpha:0.500] CGColor];
//    collectionViewCell.layer.borderWidth=0.60f;
    collectionViewCell.backgroundColor=[UIColor whiteColor];
    
    return collectionViewCell;
}

#pragma mark - CameraVCDelegate 跳转到特殊搜索页面
- (void)gotoSpecialSearch:(NSString *)vin
{
    GoodsListViewController * vc = [[GoodsListViewController alloc]init];
    vc.filterName = vin;
    vc.filterType = GoodsFilterTypeVinCode;
    vc.vinCode = vin;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 初始化Collection
-(void) initCollection{

    //1.创建一个流布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.mainCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49) collectionViewLayout:flowLayout];
    self.mainCollection.delegate = self;
    self.mainCollection.dataSource = self;
    
    self.mainCollection.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    
    // 1.设置collectionView的背景色
    self.mainCollection.backgroundColor = K_GREY_COLOR;
    //self.mainCollection.backgroundColor = [UIColor whiteColor];
    
    // 2.注册cell
    [self.mainCollection registerNib:[UINib nibWithNibName:@"IndexADViewCell" bundle:nil] forCellWithReuseIdentifier:@"IndexADViewCell"];
    [self.mainCollection registerNib:[UINib nibWithNibName:@"IndexCategoryViewCell" bundle:nil] forCellWithReuseIdentifier:@"IndexCategoryViewCell"];
    [self.mainCollection registerNib:[UINib nibWithNibName:@"IndexSubViewCell" bundle:nil] forCellWithReuseIdentifier:@"IndexSubViewCell"];
    
    [self.mainCollection registerClass:[HomeAD2CollectionCell class] forCellWithReuseIdentifier:@"HomeAD2CollectionCell"];
    [self.mainCollection registerClass:[HomeAD3CollectionCell class] forCellWithReuseIdentifier:@"HomeAD3CollectionCell"];
    [self.mainCollection registerClass:[HomeAD4CollectionCell class] forCellWithReuseIdentifier:@"HomeAD4CollectionCell"];
    [self.mainCollection registerNib:[UINib nibWithNibName:NSStringFromClass([HomeAD5CollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"HomeAD5CollectionCell"];
    [self.mainCollection registerNib:[UINib nibWithNibName:NSStringFromClass([HomeAD6CollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"HomeAD6CollectionCell"];
    [self.mainCollection registerClass:[HomeBrandCollectionCell class] forCellWithReuseIdentifier:@"HomeBrandCollectionCell"];
    
    
    //3.注册headerView Nib的view需要继承UICollectionReusableView
    [self.mainCollection registerNib:[UINib nibWithNibName:@"RecoHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RecoHeaderView"];
    [self.mainCollection registerClass:[IndexLineHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"IndexLineHeaderView"];
    [self.mainCollection registerClass:[IndexLineHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"IndexLineHeaderView"];
    
    [self.mainCollection registerClass:[HomeRecommendHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeRecommendHeaderView"];
    
    //4.设置collectionView显示垂直滚动
    self.mainCollection.showsVerticalScrollIndicator= YES;
    
    //设置上拉刷新
    [self.mainCollection addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(reloadIndexData)];
    [self.mainCollection.header setTitle:@"请稍候..." forState:MJRefreshHeaderStateRefreshing];
    [self.view addSubview:self.mainCollection];
    [self.view insertSubview:self.mainCollection atIndex:0];
    
    [self.mainCollection addLegendFooterWithRefreshingTarget:self refreshingAction:nil];
    [self.mainCollection.footer setTitle:@"加载更多中..." forState:MJRefreshFooterStateRefreshing];
    [self.mainCollection.footer setHidden:YES];
}

#pragma mark - 回到顶部按钮
-(void) initTopBtn{
    //添加回到顶部btn
    self.toTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(K_UIScreen_WIDTH - 60, K_UIScreen_HEIGHT-120, 40, 40)];
    [self.toTopBtn setBackgroundImage:[UIImage imageNamed:@"scrolls_to_top"] forState:UIControlStateNormal];
    self.toTopBtn.hidden=YES;
    [self.toTopBtn addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toTopBtn];
    [self.view bringSubviewToFront:self.toTopBtn];
}

#pragma mark 判断显示和隐藏返回按钮
-(void) switchToTopBtn:(NSIndexPath*) indexPath{
    if(indexPath.section>1){
        self.toTopBtn.hidden=NO;
    }else{
        self.toTopBtn.hidden=YES;
    }
}

#pragma mark 点击回到顶部的按扭
-(void) scrollToTop{
    self.toTopBtn.hidden=YES;
    NSIndexPath *bottomIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    [self.mainCollection scrollToItemAtIndexPath:bottomIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - 点击扫一扫按钮
- (void)clickedCamera {
    CameraVC *vc = [[CameraVC alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        //
    }];
}

#pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView == self.mainCollection){
        // 导航栏设置
        CGFloat offsetY = scrollView.contentOffset.y;
        
        if (offsetY>-64) {
                self.naviView.backgroundColor = [UIColor clearColor];
                self.naviTitleView.hidden = YES;
                [self.naviView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.backgroundColor = [obj.backgroundColor colorWithAlphaComponent:0.9];
                }];
        }else{
            self.naviBackgroundColor = K_MAIN_COLOR;
        }
    }
    
}


#pragma mark - 检查版本更新
-(void) checkUpdate{
    
    if (Apple_ID.length == 0) {
        return;
    }
    
    NSString * appURL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",Apple_ID];
    
    [self.NetworkUtil GET:appURL success:^(id responseObject) {
        
        NSString * resultCount = [responseObject objectForKey:@"resultCount"];
        
        if ([resultCount intValue] == 0) {
            return ;
        }
        
        NSString * serverVersion =[[[responseObject objectForKey:@"results"] objectAtIndex:0] valueForKey:@"version"];
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        NSString * localVersion = [infoDic valueForKey:@"CFBundleShortVersionString"];
        
        //以"."分隔数字然后分配到不同数组
        NSArray * serverArray = [serverVersion componentsSeparatedByString:@"."];
        NSArray * localArray = [localVersion componentsSeparatedByString:@"."];
        
        for (int i = 0; i < MIN(serverArray.count, localArray.count); i++) {
            
            //判断本地版本位数小于服务器版本时，直接返回（并且判断为新版本，比如 本地为1.5 服务器1.5.1）
            if(localArray.count < serverArray.count ){
                [self showAlerView:serverVersion resultDic:responseObject];
                break;
            }
            
            //有新版本，服务器版本对应数字大于本地
            if ( [serverArray[i] intValue] > [localArray[i] intValue]) {
                [self showAlerView:serverVersion resultDic:responseObject];
                break;
            }else if( [serverArray[i] intValue] < [localArray[i] intValue]){
                break;
            }
        }
    } failure:^(NSError *error) {
        ;
    }];
}

- (void)showAlerView:(NSString *)version resultDic:(NSDictionary *)dic{
    NSString *title = [@"发现新版本v" stringByAppendingString:version];
    NSString *mesg = [[[dic objectForKey:@"results"] objectAtIndex:0] valueForKey:@"releaseNotes"];
    
    self.HUDUtil.delegate = self;
    [self.HUDUtil showAlertViewWithTitle:title mesg:mesg cancelTitle:@"稍后再说"  confirmTitle:@"立即去更新" tag:1];
}

- (void)hudAlertViewClickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag{
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:{
            NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/duo-shang-wang/id%@?mt=8&uo=4",Apple_ID];;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            break;
        }
        default:
            break;
    }
}



#pragma mark - initNaviBarView
- (void)initNaviBarView{
    //Logo
    //self.title = @"汽配猫";
    
    ImageTextButton * shareBtn = [[ImageTextButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"navi_message_normal"] forState:UIControlStateNormal];
    [shareBtn setTitle:@"消息" forState:UIControlStateNormal];
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:10.5]];
    [shareBtn addTarget:self action:@selector(clickedMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:shareBtn];
    self.shareBtn = shareBtn;

    //拍照
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftItem setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(clickedCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:leftItem];

    UIView * searchView = [[UIView alloc]init];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 3;
    searchView.layer.masksToBounds = YES;
    [self.naviBar addSubview:searchView];
    
    RightImageButton * keyBtn = [[RightImageButton alloc]init];
    [keyBtn setImage:[UIImage imageNamed:@"heise_sanjiao"] forState:UIControlStateNormal];
    [keyBtn setTitleColor:[UIColor colorWithRed:0.131 green:0.129 blue:0.132 alpha:1.000] forState:UIControlStateNormal];
    [keyBtn setTitle:@"关键词" forState:UIControlStateNormal];
//    [keyBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 0, 0)];
    [keyBtn addTarget:self action:@selector(clickedKeyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:keyBtn];
    
    //搜索栏
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(65, 0, CGRectGetWidth(searchView.frame) -70, 30)];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchBtn setTitle:@"商品名称、规格型号、分类、品牌、车型" forState:UIControlStateNormal];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [searchBtn setTitleColor:[UIColor colorWithWhite:0.710 alpha:1.000] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(clickedSearchBtn:) forControlEvents:UIControlEventTouchDown];
    [searchView addSubview:searchBtn];

    //布局
    [leftItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviBar).offset(12);
        make.centerY.equalTo(self.naviBar);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];

    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.naviBar).offset(0);
        make.centerY.equalTo(self.naviBar);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftItem.mas_right).offset(12);
        make.centerY.equalTo(self.naviBar);
        make.right.equalTo(self.shareBtn.mas_left).offset(0);
        make.height.mas_equalTo(30);
    }];

    [keyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).offset(0);
        make.centerY.equalTo(searchView);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];

    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(keyBtn.mas_right).offset(5);
        make.right.equalTo(searchView.mas_right).offset(-5);
        make.centerY.equalTo(searchView);
        make.height.equalTo(searchView);
    }];
}

- (void)jpushHandling {

    self.msgVC = [[MessageListVC alloc] init];
    self.msgVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.msgVC animated:YES];
}

#pragma mark - 消息
- (void)clickedMessageBtn:(UIButton *)btn{
    //[self.shareBtn clearBadge];

    if(self.isUserLogined){

        self.msgVC = [[MessageListVC alloc] init];
        self.msgVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:self.msgVC animated:YES];
    }else{
        [self gotoLogin];
    }
}

- (void)clickedKeyBtn:(UIButton *)btn{
    [self clickedSearchBtn:nil];

}

- (void)clickedSearchBtn:(UIButton *)btn{
    SearchVC *vc = [[SearchVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

//#pragma mark - 搜索栏点击
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    SearchVC *vc = [[SearchVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    return NO;
//}

#pragma mark -
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
//}

@end
