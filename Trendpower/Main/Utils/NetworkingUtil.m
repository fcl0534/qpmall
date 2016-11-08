//
//  NetworkingUtil.m
//  Trendpower
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "NetworkingUtil.h"
#import "HUDUtil.h"
#import "NetworkStatusUtil.h"
#import "sys/utsname.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@interface NetworkingUtil()

@property (nonatomic, strong) AFHTTPSessionManager * mgr;
@property (nonatomic, strong) HUDUtil * hud;

@end

@implementation NetworkingUtil

// 定义一份变量(整个程序运行过程中, 只有1份)
static id _instance;

- (id)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载资源
            self.mgr = [AFHTTPSessionManager manager];

            [self.mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            self.mgr.requestSerializer.timeoutInterval = 10.f;
            [self.mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            //设置
            AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];

            //将所有 NSNull 的值，都变成了 nil，防止崩溃
            responseSerializer.removesKeysWithNullValues = YES;

            self.mgr.responseSerializer = responseSerializer;

            self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"plain/json",@"text/plain",@"application/json", nil];
            [self addHeaderParameters]; //增加必要头部参数
            self.hud = [HUDUtil sharedHUDUtil];
        });
    }
    return self;
}

/**
 *  重写这个方法 : 控制内存内存
 */
+ (id)allocWithZone:(struct _NSZone *)zone
{
    // 里面的代码永远只执行1次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    // 返回对象
    return _instance;
}

+ (instancetype)sharedNetworkingUtil
{
    // 里面的代码永远只执行1次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    // 返回对象
    return _instance;
}


- (void)cancelAllRequest
{

}


#pragma mark - 是否启用测试环境
- (NSString *)getTestEnvironmentWithURLString:(NSString *)urlstr{
    if (OPEN_Test_Environment) {
        BOOL isOn = [[NSUserDefaults standardUserDefaults] boolForKey:KTP_Test_Environment];
        if (isOn) {
            NSString * testUrl = [urlstr stringByReplacingOccurrencesOfString:API_DOMAIN withString:API_TEST];
            NSLog(@"OPEN_Test_Environment---%@",testUrl);
            return testUrl;
        }else{
            return urlstr;
        }
    }else{
        return urlstr;
    }
    
    return urlstr;
}



#pragma mark - GET
- (void)GET:(NSString *)URLString success:(void (^)(id))success failure:(void (^)(NSError *error))failure{
    [self dynamicHeader];

    [self.mgr GET:[self getTestEnvironmentWithURLString:URLString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        failure(error);
    }];
}

-(void)GET:(NSString *)URLString inView:(UIView *)view success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self.hud dismissMBHUD];
    [self.hud showLoadingMBHUDInView:view];
    [self dynamicHeader];

    [self.mgr GET:[self getTestEnvironmentWithURLString:URLString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [self.hud dismissMBHUD];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        failure(error);
    }];

}

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self dynamicHeader];

    [self.mgr GET:[self getTestEnvironmentWithURLString:URLString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        failure(error);
    }];
}

- (void)GET:(NSString *)URLString parameters:(id)parameters inView:(UIView *)view success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self.hud dismissMBHUD];
    [self.hud showLoadingMBHUDInView:view];
    [self dynamicHeader];
    DLog(@"requestUrl:%@", URLString);

    [self.mgr GET:[self getTestEnvironmentWithURLString:URLString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [self.hud dismissMBHUD];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        [self.hud dismissMBHUD];
        failure(error);
    }];
}

-(void)GET:(NSString *)URLString header:(id)header success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self.mgr.requestSerializer setValue:[header objectForKey:@"value"] forHTTPHeaderField:[header objectForKey:@"key"]];
    [self dynamicHeader];
    DLog(@"requestUrl:%@", URLString);

    [self.mgr GET:[self getTestEnvironmentWithURLString:URLString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        failure(error);
    }];
}

- (void)GET:(NSString *)URLString header:(id)header inView:(UIView *)view success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self.hud dismissMBHUD];
    [self.hud showLoadingMBHUDInView:view];
    
    [self.mgr.requestSerializer setValue:[header objectForKey:@"value"] forHTTPHeaderField:[header objectForKey:@"key"]];
    [self dynamicHeader];

    [self.mgr GET:[self getTestEnvironmentWithURLString:URLString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [self.hud dismissMBHUD];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        [self.hud dismissMBHUD];
        failure(error);
    }];
}


#pragma mark- POST
- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self dynamicHeader];

    [self.mgr POST:[self getTestEnvironmentWithURLString:URLString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        failure(error);
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters inView:(UIView *)view success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    if (view != nil) {
        [self.hud dismissMBHUD];
    }
    [self.hud showLoadingMBHUDInView:view];
    [self dynamicHeader];

    [self.mgr POST:[self getTestEnvironmentWithURLString:URLString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [self.hud dismissMBHUD];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        [self.hud dismissMBHUD];
        failure(error);
    }];
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
     success:(void (^)(AFHTTPRequestSerializer *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestSerializer *operation, NSError *error))failure{
    [self dynamicHeader];

    [self.mgr POST:[self getTestEnvironmentWithURLString:URLString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        success(nil,responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        failure(nil,error);
    }];

//    [self.mgr POST:[self getTestEnvironmentWithURLString:URLString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        block(formData);
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        success(task,responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        failure(operation,error);
//    }];
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters inView:(UIView *)view
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
     success:(void (^)(AFHTTPRequestSerializer *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestSerializer *operation, NSError *error))failure{
    [self.hud dismissMBHUD];
    [self.hud showLoadingMBHUDInView:view];
    [self dynamicHeader];

    [self.mgr POST:[self getTestEnvironmentWithURLString:URLString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        block(formData);
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [self.hud dismissMBHUD];
        success(nil,responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        [self.hud dismissMBHUD];
        failure(nil,error);
    }];

//    [self.mgr POST:[self getTestEnvironmentWithURLString:URLString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//           block(formData);
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        [self.hud dismissMBHUD];
//        success(operation,responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.hud dismissMBHUD];
//        failure(operation,error);
//    }];
}


- (void)POST:(NSString *)URLString header:(id)header parameters:(id)parameters inView:(UIView *)view success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self.hud dismissMBHUD];
    [self.hud showLoadingMBHUDInView:view];
    [self.mgr.requestSerializer setValue:[header objectForKey:@"value"] forHTTPHeaderField:[header objectForKey:@"key"]];
    [self dynamicHeader];

    [self.mgr POST:[self getTestEnvironmentWithURLString:URLString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [self.hud dismissMBHUD];
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        [self.hud dismissMBHUD];
        failure(error);
    }];
}

- (void)POST:(NSString *)URLString header:(id)header parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self.mgr.requestSerializer setValue:[header objectForKey:@"value"] forHTTPHeaderField:[header objectForKey:@"key"]];
    [self dynamicHeader];

    [self.mgr POST:[self getTestEnvironmentWithURLString:URLString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        failure(error);
    }];
}


- (void)addHeaderParameters{
        [self.mgr.requestSerializer setValue:@"2" forHTTPHeaderField:@"appId"];
        NSString *key = @"CFBundleShortVersionString";
        // 获得当前软件的版本号
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = infoDict[key];
        [self.mgr.requestSerializer setValue:currentVersion forHTTPHeaderField:@"clientVer"];
        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [self.mgr.requestSerializer setValue:identifierForVendor forHTTPHeaderField:@"imei"];
        //[self.mgr.requestSerializer setValue:@"" forHTTPHeaderField:@"macAddr"];
        // 需要#import "sys/utsname.h"
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        [self.mgr.requestSerializer setValue:deviceString forHTTPHeaderField:@"model"];
        NSString* versionNum =[UIDevice currentDevice].systemVersion;
        [self.mgr.requestSerializer setValue:versionNum forHTTPHeaderField:@"osVer"];
        [self.mgr.requestSerializer setValue:@"200" forHTTPHeaderField:@"chanId"];
        [self.mgr.requestSerializer setValue:[self checkCarrier] forHTTPHeaderField:@"operator"];
//        [self.mgr.requestSerializer setValue:@"" forHTTPHeaderField:@"secretKey"];
        [self.mgr.requestSerializer setValue:identifierForVendor forHTTPHeaderField:@"uuid"];
}


- (void)dynamicHeader{
    [self.mgr.requestSerializer setValue:[self getNetType] forHTTPHeaderField:@"nettype"];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];//转为字符型取整数部分
    [self.mgr.requestSerializer setValue:timeString forHTTPHeaderField:@"pKey"];
}

// 生成惟一随机数
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


/* 关于获取运营商信息，需通过 CoreTelephony Framework 中的 CTTelephonyNetworkInfo 和 CTCarrier 类型。这些都在 iOS 4.0 后就有了。
 
 import 必要的 header ：
 
 #import <CoreTelephony/CTCarrier.h>
 
 #import <CoreTelephony/CTTelephonyNetworkInfo.h>
 
 何判断当前网络的运营商
 
 */

// 用来辨别设备所使用网络的运营商

- ( NSString *)checkCarrier
{
    NSString *ret = [[ NSString alloc ] init ];
    CTTelephonyNetworkInfo *info = [[ CTTelephonyNetworkInfo alloc ] init ];
    CTCarrier *carrier = [info subscriberCellularProvider ];
    
    if (carrier == nil ) {
        return @"4";//@"未知" ;
    }
    
    NSString *code = [carrier mobileNetworkCode];
    
    if ([code  isEqual : @"" ]) {
        return @"4";//@"未知" ;
    }
    
    if ([code isEqualToString : @"00" ] || [code isEqualToString : @"02" ] || [code isEqualToString : @"07" ]) {
        ret = @"1";//@"中国移动" ;
    }
    
    if ([code isEqualToString : @"01" ]|| [code isEqualToString : @"06" ] ) {
        ret = @"2";//@"中国联通" ;
    }
    
    if ([code isEqualToString : @"03" ]|| [code isEqualToString : @"05" ] ) {
        ret = @"3";//@"中国电信" ;;
    }
    
//    NSLog ( @"%@" ,ret);
    return ret;
}


- (NSString *)getNetType{
    NSString * netType = [NetworkStatusUtil getNetWorkStates];
    if ([netType isEqualToString:@"WIFI"]) {
        return @"1";
    }else if([netType isEqualToString:@"2G"]){
        return @"2";
    }else if([netType isEqualToString:@"3G"]){
        return @"3";
    }else if([netType isEqualToString:@"4G"]){
        return @"4";
    }else{
        return @"9";
    }
}
/**

appId	应用编号	int		2：iPhone
clientVer	客户端版本号	int
imei	客户端唯一标识	string
macAddr	客户端mac地址	string
model	客户端设备型号	string
osVer	操作系统版本	string
chanId	渠道ID 	int  200：appstore
operator	运营商	int		1:移动, 2:联通, 3:电信, 4:其他
nettype	网络类型 int		1：WIFI，2：2G，3：3G，4：4G，9：其它
secretKey	密钥	String	Md5产生字符串
pKey	公钥	String	时间戳
uuid	设备唯一标识	String
 */
@end
