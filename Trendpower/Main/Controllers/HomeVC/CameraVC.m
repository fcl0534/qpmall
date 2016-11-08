//
//  CameraVC.m
//  Trendpower
//
//  Created by 张帅 on 16/6/25.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "CameraVC.h"
#import "CameraConfirmVC.h"
#import "CropOverlay.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+CutImg.h"
#import "UIImage+Orientation.h"
#import "APIStoreSDK.h"

#define OCRApikey @"5baa10f44ee188ddcd9e651a8828a356"

@interface CameraVC ()

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *capturePhoto;

@property (weak, nonatomic) IBOutlet UIImageView *showImgView;

@property (weak, nonatomic) IBOutlet CropOverlay *maskView;

@property (nonatomic, strong) CropOverlay *cropOverlay;

@property (nonatomic, strong) UILabel *errTipLbl; /**< 错误提示 */

//AVFoundation

@property (nonatomic) dispatch_queue_t sessionQueue;
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

@property (nonatomic, assign) CGSize imageSize;

@end

@implementation CameraVC
{
    CameraConfirmVC *vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setHidesNaviBar:YES];

    vc = [[CameraConfirmVC alloc] init];

    [self initAVCaptureSession];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];

    if (self.session) {

        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:YES];

    if (self.session) {

        [self.session stopRunning];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - event response
- (IBAction)capturePhoto:(id)sender {

    __weak typeof(self) weakSelf = self;

    //1.拍照
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    //设置方向
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];

    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];

        //获得照片并设置，将获得照片设置成屏幕缩放比例下的照片
        UIImage *image = [[UIImage alloc] initWithData:jpegData];

        //解决相机获取到的图片自动旋转90°的问题
//        image = [image fixOrientation:image];

        image = [self scaleToSize:image size:CGSizeMake(kScreen_Width, kScreen_Height)];

        self.maskView.hidden = NO;
        self.showImgView.hidden = NO;
        self.showImgView.image = image;

        //根据frame截取图片
        image = [image getCutImage:CGRectMake((kScreen_Width-60)/2, 60, 60, kScreen_Height-200)];

        //将竖直的图片旋转
        UIImage *cutImage = [UIImage image:image rotation:UIImageOrientationLeft];

        NSData *imgData = UIImageJPEGRepresentation(cutImage, 1.0);

        //调用百度识别图片的接口生成VIN码
        [self requestBaiduApi:imgData];

        //2.跳转
        vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];

        vc.cutImg = image;

        __weak typeof(vc) vcWeakSelf = vc;

        vc.confirmClick = ^(NSString *vin) {

            if ([weakSelf.delegate respondsToSelector:@selector(gotoSpecialSearch:)]) {
                [weakSelf.delegate gotoSpecialSearch:vin];
            }

            [weakSelf dismissViewControllerAnimated:YES completion:^{
                //
            }];
        };
        vc.cancelClick = ^() {
            [vcWeakSelf willMoveToParentViewController:weakSelf];
            [vcWeakSelf removeFromParentViewController];
            [vcWeakSelf.view removeFromSuperview];

            weakSelf.showImgView.hidden = YES;
            weakSelf.maskView.hidden = YES;
        };
        vc.returnClicked = ^() {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                //
            }];
        };

        [self addChildViewController:vc];
        [self.view addSubview:vc.view];

        //获取影像数据
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,imageDataSampleBuffer,kCMAttachmentMode_ShouldPropagate);

        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            return ;
        }
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {

        }];

    }];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

#pragma mark - private methods
- (void)initAVCaptureSession{

    self.session = [[AVCaptureSession alloc] init];

    NSError *error;

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];

    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];

    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }

    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    self.previewLayer.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
    [self.backView.layer addSublayer:self.previewLayer];

}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
//    else
//        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

#pragma mark 裁剪图片
- (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size {

    UIGraphicsBeginImageContext(size);

    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];

    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return scaledImage;
}

//
- (void)requestBaiduApi:(NSData *)imgData
{
    __block NSString *vinStr = nil;

    APISCallBack *callBack = [APISCallBack alloc];

    callBack.onSuccess = ^(long status,NSString *responseString) {
        if (responseString != nil) {

            NSDictionary *responseDic = [self dictionaryWithJsonString:responseString];

            NSArray *retData = responseDic[@"retData"];

            if (retData.count > 0) {

                NSDictionary *item = retData[0];

                NSString *word = item[@"word"];

                vinStr = word;
                vinStr = [vinStr stringByReplacingOccurrencesOfString:@" " withString:@""];

                if (vinStr.length == 17) {
                    vc.vinStr = [self stringIntoArray:vinStr];
                } else {
                    //进行错误处理
                    [self errTip];

                    vc.vinStr = [self stringIntoArray:vinStr];
                }
            } else {
                [self errTip];

                vc.vinStr = [self stringIntoArray:@"000000000000000000000000"];
            }
        }
    };

    callBack.onError = ^(long status, NSString *responseString) {
        //错误提示
        [self errTip];

        vc.vinStr = [self stringIntoArray:@"000000000000000000000000"];
    };

    callBack.onComplete = ^() {
        //完成处理

    };

    NSString *uri = @"http://apis.baidu.com/idl_baidu/baiduocrpay/idlocrpaid";
    NSString *method = @"post";

    NSString* base64 = [imgData base64EncodedStringWithOptions:0];
    NSString* imgStr = [self urlencode:base64];

    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@"iPhone" forKey:@"fromdevice"];
    [parameter setObject:@"10.10.10.0" forKey:@"clientip"];
    [parameter setObject:@"LocateRecognize" forKey:@"detecttype"];
    [parameter setObject:@"1" forKey:@"imagetype"];
    [parameter setObject:imgStr forKey:@"image"];

    //请求API
    [ApiStoreSDK executeWithURL:uri method:method apikey:OCRApikey parameter:parameter callBack:callBack];
}

- (NSString *)urlencode:(NSString*) data {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = [data UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

//将JSON格式的字符串转换为JSON格式的字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

//遍历一个字符串并添加到数组中
- (NSMutableArray *)stringIntoArray:(NSString *)str
{
    NSMutableArray *strs = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < str.length; i++){
        NSString *s = [str substringWithRange:NSMakeRange(i, 1)];

        [strs addObject:s];
    }

    return strs;
}

- (void)errTip
{
    [UIView animateWithDuration:0.5 animations:^{

        [self.view.window addSubview:self.errTipLbl];
        self.errTipLbl.hidden = NO;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [UIView animateWithDuration:0.5 animations:^{
                self.errTipLbl.hidden = YES;
            }];

        });
    }];
}

#pragma mark - getter and setter
- (CropOverlay *)cropOverlay
{
    if (!_cropOverlay) {
        _cropOverlay = [[[NSBundle mainBundle] loadNibNamed:@"CropOverlay" owner:nil options:nil] lastObject];
        _cropOverlay.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    }
    return _cropOverlay;
}

- (UILabel *)errTipLbl
{
    if (!_errTipLbl) {
        _errTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2 - 130/2, kScreen_Height - 80, 140, 20)];
        _errTipLbl.text = @"识别失败，请重新拍摄";
        _errTipLbl.textColor = [UIColor whiteColor];
        _errTipLbl.textAlignment = NSTextAlignmentCenter;
        _errTipLbl.font = [UIFont systemFontOfSize:13.0];
        _errTipLbl.alpha = 0.8;
        _errTipLbl.backgroundColor = [UIColor blackColor];
        _errTipLbl.hidden = YES;
        _errTipLbl.layer.masksToBounds = YES;
        _errTipLbl.layer.cornerRadius = 2.0;
    }
    return _errTipLbl;
}

@end
