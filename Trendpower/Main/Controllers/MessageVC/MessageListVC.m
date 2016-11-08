//
//  MessageListVC.m
//  Trendpower
//
//  Created by trendpower on 15/12/28.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import "MessageListVC.h"

#import "MessageDBUtils.h"

// model
#import "MessageModel.h"

// vc
#import "MessageDetailViewController.h"

@interface MessageListVC ()<UIScrollViewDelegate ,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) UICollectionView *mainCollection;
/**  无消息时的背景图 */
@property(nonatomic,strong) UIView *backView;
/**  存储全部消息的数组（包括时间） */
@property (nonatomic, strong) NSMutableArray *msgArray;
@property (nonatomic, assign) NSUInteger page;//当前页数
@property (nonatomic, assign) NSUInteger limit;//条数

@property (nonatomic, assign) BOOL isLoadOldMsg;
@property (nonatomic, assign) BOOL noMoreMsg;

@end

@implementation MessageListVC

#pragma mark - Life cycle   ###
#pragma mark viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //监听新消息通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFromServer) name:@"NEW_PUSH_MESSAGE" object:nil];
    
    //如果应用在运行，并收到消息的情况下要刷新
//    if([[[self.tabBarController.tabBar.items objectAtIndex:3] badgeValue] intValue] >0 || self.mainMsgArray.count == 0){
//        [self featchMessageList];
//    }
    
 //   [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:K_NOTIFI_MESSAGE_CENTER];
    
    //[self initTipView];
    
    [self initCollectionView];
    //加载数据
    [self featchMessageList];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    //移除通知
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"NEW_PUSH_MESSAGE" object:nil];
}

#pragma mark - Interface   ###
#pragma mark - init
-(void) initCollectionView{
    
    if (self.mainCollection == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.mainCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:flowLayout];
        UINib *cellNib=[UINib nibWithNibName:@"MessageCollectionCellView" bundle:[NSBundle mainBundle]];
        [self.mainCollection registerNib:cellNib forCellWithReuseIdentifier:@"cell"];
        self.mainCollection.alwaysBounceVertical = YES;
        self.mainCollection.backgroundColor=[UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
        self.mainCollection.delegate=self;
        self.mainCollection.dataSource=self;
        [self.view addSubview:self.mainCollection];
        
        [self.mainCollection addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(featchMessageList)];
        [self.mainCollection.header setTitle:@"更新消息中..." forState:MJRefreshHeaderStateRefreshing];
        self.mainCollection.header.updatedTimeHidden = YES;
    }
}


-(void) initTipView{
    _backView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    _backView.backgroundColor = [UIColor whiteColor];

    UIImageView *backImg=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-120, 100, 100)];
    [backImg setImage:[UIImage imageNamed:@"message_null"]];

    [_backView addSubview:backImg];

    //添加提示语
    UILabel *tipLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-70, self.view.frame.size.height/2, 140, 20)];
    tipLabel.text=@"还没有消息哦";
    tipLabel.textAlignment=NSTextAlignmentCenter;
    tipLabel.textColor=[UIColor lightGrayColor];
    [_backView addSubview:tipLabel];

    [self.view addSubview:_backView];
}


#pragma mark - Event response   ###


#pragma mark - Private method   ###
- (void)featchMessageList{
    
    //1、直接把未读的标记删除
    [MessageDBUtils finishMessageRead];
    
    //2、取最新列表，比较数据库，如果没有，就插入
    //http://tgtmall.local.qushiyun.com/mobile/index.php?app=message&act=get_message_list&user_id=1524&page=1&size=2
    
    self.page = 1;
    self.limit = 10;
    
    NSString *requestUrl = [API_ROOT stringByAppendingString:@"/jpush/lists?page="];
    requestUrl = [requestUrl stringByAppendingFormat:@"%lu",(unsigned long)self.page];
    requestUrl = [requestUrl stringByAppendingString:@"&pageSize="];
    requestUrl = [requestUrl stringByAppendingFormat:@"%lu",(unsigned long)self.limit];
    requestUrl = [[requestUrl stringByAppendingString:@"&userId="] stringByAppendingString:[UserDefaultsUtils getUserId]];
    
    [self.NetworkUtil GET:requestUrl inView:self.view success:^(id responseObject) {

        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            
            [self.mainCollection addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [self.mainCollection.footer resetNoMoreData];
            
            [self.msgArray removeAllObjects];

            NSArray *dataArray =[[responseObject objectForKey:@"data"] valueForKey:@"list"];

            for (NSDictionary * dic in dataArray) {
                MessageModel * model = [[MessageModel alloc]initWithAttributes:dic];
                model.message_type = 0;
                
                MessageModel * time = [[MessageModel alloc]init];
                time.message_type = 99;//时间类型
                time.add_time = model.add_time;
                
                [self.msgArray addObject:time];
                [self.msgArray addObject:model];
            }
            
            if (dataArray.count <10) {
                [self.mainCollection.footer noticeNoMoreData];
            }
            
            
            [self addNoGoodsView];
            [self.mainCollection reloadData];
            
        }else{
            [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
        [self.mainCollection.header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.mainCollection.header endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}


- (void)loadMoreData{

    self.page += 1;
    
    NSString *requestUrl = [API_ROOT stringByAppendingString:@"/jpush/lists?page="];
    requestUrl = [requestUrl stringByAppendingFormat:@"%lu",(unsigned long)self.page];
    requestUrl = [requestUrl stringByAppendingString:@"&pageSize="];
    requestUrl = [requestUrl stringByAppendingFormat:@"%lu",(unsigned long)self.limit];
    requestUrl = [[requestUrl stringByAppendingString:@"&userId="] stringByAppendingString:[UserDefaultsUtils getUserId]];
    
    [self.NetworkUtil GET:requestUrl inView:self.view success:^(id responseObject) {
        [self.mainCollection.footer endRefreshing];
        
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            NSArray *dataArray =[[responseObject objectForKey:@"data"] objectForKey:@"list"];
            //如果没有更多消息
            if ([[[dataArray class] description] isEqualToString:@"__NSCFString"]) {
                [self.mainCollection.footer noticeNoMoreData];
                return ;
            }
            
            for (NSDictionary * dic in dataArray) {
                MessageModel * model = [[MessageModel alloc]initWithAttributes:dic];
                model.message_type = 0;
                MessageModel * time = [[MessageModel alloc]init];
                time.message_type = 99;//时间类型
                time.add_time = model.add_time;
                
                [self.msgArray addObject:time];
                [self.msgArray addObject:model];
            }
            
            if (dataArray.count <10) {
                [self.mainCollection.footer noticeNoMoreData];
            }
            
            [self addNoGoodsView];
            [self.mainCollection reloadData];
            
        }else{
            self.page -= 1;
             [self.HUDUtil showErrorMBHUDWithText:[responseObject objectForKey:KTP_MSG] inView:self.view delay:2];
        }
        
    } failure:^(NSError *error) {
        self.page -= 1;
        [self.mainCollection.footer endRefreshing];
        [self.HUDUtil showNetworkErrorInView:self.view];
    }];
}

#pragma mark - 背影和cell切换
-(void) addNoGoodsView{

    if(self.msgArray.count==0){

        if(_backView==nil){
            [self initTipView];
        }
        // [_mainCollection addSubview:_backView];
    }else{
        [_backView removeFromSuperview];
    }
}

#pragma mark - 点击文本标题
-(void) textViewBtnClicked:(UIButton*) btn{
    //    /mobile/index.php?app=message&act=get_message&message_id=2
    //    请求参数
    //    message_id 消息ID (必填)
    //    user_id 用户ID（选填）
    NSString *requestUrl=[API_ROOT stringByAppendingString:@"/jpush/detail?pushId="];

    requestUrl=[requestUrl stringByAppendingString:[NSString stringWithFormat:@"%zi",btn.tag]];

    requestUrl = [[requestUrl stringByAppendingString:@"&userId="] stringByAppendingString:[UserDefaultsUtils getUserId]];

    MessageDetailViewController *detailVC=[[MessageDetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed=YES;
    detailVC.messageTitle=btn.titleLabel.text;
    detailVC.requestUrl=requestUrl;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Delegate   ###

#pragma mark - collectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.msgArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insets;
    MessageModel *message = [self.msgArray objectAtIndex:section];
    switch (message.message_type) {
        case 0:
            insets=UIEdgeInsetsMake(8, 10, 25, 10);
            break;
        case 99:
            insets=UIEdgeInsetsMake(10, 10, 0, 10);
            break;
        default:
            break;
    }
    return insets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //type为0和1时计算Cell的高度
    CGFloat H = 148 * self.view.frame.size.width/320;// H:148.0f;
    CGFloat paddingTop=5.0f;
    MessageModel *message = [self.msgArray objectAtIndex:indexPath.section];
    //计算高度

    CGFloat height=0.0f;
    if(message.message_type!=99){
        height = H + 2* paddingTop;
    }
    //Cell宽度
    CGFloat cellW = self.view.frame.size.width-20;
    CGSize viewSize;
    switch (message.message_type) {
        case 0:
            viewSize=CGSizeMake(cellW, height);
            break;
        case 99:
            viewSize=CGSizeMake(K_UIScreen_WIDTH, 19);
            break;

        default:
            break;
    }
    return viewSize;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=5;
    cell.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    for (UIView *subView in cell.subviews) {
        [subView removeFromSuperview];
    }
    
    // type :0为推送的文本，1为产品，2为订单，3为上架，4为下架，99为时间
    MessageModel *message = [self.msgArray objectAtIndex:indexPath.section];
    switch (message.message_type) {
        case 0:{
            cell.backgroundColor = [UIColor whiteColor];
            cell.layer.borderWidth=0.5f;
            cell=[self createTextView:message withCell:cell];
            break;
        }
        case 99:{
            cell.backgroundColor = [UIColor clearColor];
            cell.layer.borderWidth=0.0f;
            cell=[self createTimeVuew:message withCell:cell];
            break;
        }

        default:
            break;
    }
    return cell;
}

#pragma mark - 创建文本Cell
-(UICollectionViewCell*) createTextView:(MessageModel*) message withCell:(UICollectionViewCell*) cell{
    CGFloat topH=148.0f;
    CGFloat ScreenW = self.view.frame.size.width;
    //取头部View并设置值
    UIView *view=[[[NSBundle mainBundle] loadNibNamed:@"MessageCellView" owner:self options:nil] objectAtIndex:0];
    view.frame=CGRectMake(5, 5, ScreenW -30, topH *ScreenW/320); //280-148
    UIImageView *topImage=(UIImageView*)[view viewWithTag:1];
    UILabel *topLabel=(UILabel*)[view viewWithTag:2];
    UIButton *topBtn=(UIButton*)[view viewWithTag:3];
    topBtn.tag=[message.message_id intValue];

    [topBtn addTarget:self action:@selector(textViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topImage sd_setImageWithURL:[NSURL URLWithString:message.img_url] placeholderImage:[UIImage imageNamed:@"image_loading_message"]];
    topLabel.text=message.message_title;
    topBtn.titleLabel.text=message.message_title;
    [cell addSubview:view];
    return cell;
}

#pragma mark - 时间View
-(UICollectionViewCell*) createTimeVuew:(MessageModel*) message withCell:(UICollectionViewCell*) cell{
    //取头部View并设置值
    UIView *view=[[[NSBundle mainBundle] loadNibNamed:@"MessageCellView" owner:self options:nil] objectAtIndex:1];
    view.frame=CGRectMake(0, 0, K_UIScreen_WIDTH, 19);
    view.backgroundColor = [UIColor clearColor];
    UILabel *timeLabel=(UILabel*)[view viewWithTag:1];
    timeLabel.text=message.add_time;
    timeLabel.layer.masksToBounds = YES;
    timeLabel.layer.cornerRadius = 5;
    [cell addSubview:view];
    return cell;
}



#pragma mark - Getters and Setters   ###
- (NSMutableArray *)msgArray
{
    if (_msgArray == nil) {
        _msgArray = [NSMutableArray array];
    }
    return _msgArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
