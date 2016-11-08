//
//  AppDelegate.m
//  Trendpower
//
//  Created by HTC on 15/4/29.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

#import "HomeViewController.h"

// tools
#import "MessageDBUtils.h"

//sdk
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "UMSocialSnsService.h"
#import "JPUSHService.h"

//#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSString *appKey = @"4e4d7c3304097c6be3dddf8b";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate ()<JPUSHRegisterDelegate,WXApiDelegate>

@property (nonatomic,strong) RootViewController *mainNav;

@property (nonatomic, strong) HomeViewController *homeVC;

@property (nonatomic, assign) BOOL isForegroundNoti;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    RootViewController *rootViewController=[[RootViewController alloc] init];
    self.mainNav = rootViewController;
    
    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    navi.navigationBar.hidden = YES;
    
    //状态栏为白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];

    self.window.rootViewController = navi;

    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 开启推送
    if(OPEN_Push_Message){
        //JPush
        [self initJPush:launchOptions];
    }

    self.homeVC = (HomeViewController *)
    [rootViewController.viewControllers objectAtIndex:0];

    //微信支付
    //[WXApi registerApp:@"wx844ccdbb56000063" withDescription:@"汽配猫iOS客户端"];
    
    return YES;
}


#pragma mark 极光推送相关代码
-(void) initJPush:(NSDictionary*) launchOptions{

    //极光催送(jpush)设置
    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;

        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }

    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];

    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);

        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    DLog(@"deviceToken----%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    DLog(@"Failed to get token, error: %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //iOS6
    [self parsePushInfo:userInfo];

    [JPUSHService handleRemoteNotification:userInfo];
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    //IOS7支持
    [self parsePushInfo:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;

    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容

    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        [JPUSHService handleRemoteNotification:userInfo];
        DLog(@"iOS10 前台收到远程通知");

        [self parsePushInfo:userInfo];

        self.isForegroundNoti = YES;
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容

    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        [JPUSHService handleRemoteNotification:userInfo];

        DLog(@"iOS10 收到远程通知");
        if (!self.isForegroundNoti) {

            [self parsePushInfo:userInfo];
        }  else {

            self.isForegroundNoti = NO;
        }

    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

#pragma mark - 摧送连接与消息监听方法
- (void)networkDidReceiveMessage:(NSNotification *)notification {

    //[JPUSHService setAlias:[NSString stringWithFormat:@"110"] callbackSelector:nil object:nil];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:K_NOTIFI_MESSAGE_CENTER];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
}

#pragma mark - 处理收到推送的信息
-(void) parsePushInfo:(NSDictionary *) userInfo{

    if (![userInfo count]) {
        return;
    }
    
    //取数据
    NSString * pushId = [userInfo objectForKey:@"message_id"];
    [MessageDBUtils saveMessageWithPushId:pushId];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:K_NOTIFI_MESSAGE_CENTER];

    self.mainNav.selectedIndex = OPEN_Push_Message_Icon;

    [self.homeVC jpushHandling];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 支付相关
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {

        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayResult" object:self userInfo:resultDic];
        }];
    }

    //微信支付结果
    if ([url.host isEqualToString:@"pay"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {

        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayResult" object:self userInfo:resultDic];
        }];
    }

    if ([url.host isEqualToString:@"pay"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }

    return YES;
}


-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wxpayResult" object:resp userInfo:nil];
    }
}

@end
