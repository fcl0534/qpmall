//
//  CameraConfirmVC.m
//  Trendpower
//
//  Created by 张帅 on 16/6/25.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "CameraConfirmVC.h"
#import "CustomKeyboard.h"
#import "ShowVIN.h"
#import "CropOverlay.h"
#import "UIImage+Orientation.h"

@interface CameraConfirmVC ()<CustomKeyboardDelegate,ShowVINDelegate>

@property (nonatomic, strong) CustomKeyboard *customKeyboard;

@property (nonatomic, strong) ShowVIN *showVIN;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *returnBtn;

@property (nonatomic, strong) UIImageView *photo;

@end

@implementation CameraConfirmVC
{
    BOOL _isSelected;

    BOOL _isClicked;

    UIButton *_selectedBtn;

    NSMutableArray *_vinMArr;

    UIButton *_temBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setHidesNaviBar:YES];

    _isSelected = NO;

    _isClicked = NO;

    _vinMArr = [[NSMutableArray alloc] init];

    [self.view addSubview:self.customKeyboard];
    [self.view addSubview:self.showVIN];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.cancelBtn];
    [self.bottomView addSubview:self.confirmBtn];
    [self.view addSubview:self.returnBtn];
    [self.view addSubview:self.photo];

    //旋转屏幕，但是只旋转当前的View
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    self.view.bounds = CGRectMake(0, 0, kScreen_Height, kScreen_Width);

    [self layoutSubviewsPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Delegate
- (void)characterKeyClick:(NSString *)key
{
    if (_isSelected) {

        [_selectedBtn setTitle:key forState:UIControlStateNormal];

        [_vinMArr replaceObjectAtIndex:(_selectedBtn.tag - 1) withObject:_selectedBtn];

        _isSelected = NO;

        _isClicked = YES;

        _temBtn = _selectedBtn;
    }

    if (!_isClicked) {
        //选中下一个并准备修改
        if (_temBtn.tag < 17) {

            UIButton *btn = (UIButton *)[self.showVIN viewWithTag:(_temBtn.tag + 1)];

            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = [UIColor greenColor].CGColor;

            [[NSNotificationCenter defaultCenter] postNotificationName:@"showVIN" object:btn];

            _temBtn.layer.borderColor = 0;

            [btn setTitle:key forState:UIControlStateNormal];
            [_vinMArr replaceObjectAtIndex:(btn.tag - 1) withObject:btn];

            _temBtn = btn;
        }
    } else {
        _isClicked = NO;
    }
}

- (void)changeBtn:(UIButton *)btn allBtn:(NSMutableArray *)btnMArr isSelected:(BOOL)selected
{
    _isSelected = selected;

    _selectedBtn = btn;

    _vinMArr = btnMArr;
}

#pragma mark - event response
- (void)confirm
{
    NSString *character = @"";
    
    for (UIButton *b in _vinMArr) {

        character = [character stringByAppendingString:b.titleLabel.text];
    }
    NSLog(@"character %@",character);

    if (self.confirmClick) {
        self.confirmClick(character);
    }
}

- (void)cancel
{
    if (self.cancelClick) {
        self.cancelClick();
    }
}

- (void)back
{
    if (self.returnClicked) {
        self.returnClicked();
    }
}

#pragma mark - private method
- (void)layoutSubviewsPage
{
    // 弱引用
    __weak typeof(self) weakSelf = self;

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).with.offset(0);
        make.left.equalTo(weakSelf.view).with.offset(0);
        make.right.equalTo(weakSelf.view).with.offset(0);
        make.height.mas_equalTo(49);
    }];

    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomView).with.offset(40);
        make.centerY.equalTo(weakSelf.bottomView);
        make.size.mas_equalTo(CGSizeMake(80, 49));
    }];

    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bottomView).with.offset(-40);
        make.centerY.equalTo(weakSelf.bottomView);
        make.size.mas_equalTo(CGSizeMake(80, 49));
    }];

    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(15);
        make.left.equalTo(weakSelf.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    [self.customKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(0);
        make.right.equalTo(weakSelf.view).with.offset(0);
        make.bottom.equalTo(weakSelf.bottomView.mas_top).with.offset(0);
        make.height.mas_equalTo(162);
    }];

    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view).offset(10);
        make.left.equalTo(weakSelf.view).offset(100);
        make.right.equalTo(weakSelf.view).offset(-100);
        make.bottom.equalTo(weakSelf.showVIN.mas_top).offset(-10);
        make.height.mas_equalTo(60);
    }];

    [self.showVIN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(20);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.bottom.equalTo(weakSelf.customKeyboard.mas_top).offset(0);
    }];

}

#pragma mark - getter and setter
- (CustomKeyboard *)customKeyboard
{
    if (!_customKeyboard) {
        _customKeyboard = [[CustomKeyboard alloc] init];//[[[NSBundle mainBundle] loadNibNamed:@"CustomKeyboard" owner:self options:nil] objectAtIndex:0];
        _customKeyboard.delegate = self;
    }
    return _customKeyboard;
}

- (ShowVIN *)showVIN
{
    if (!_showVIN) {
        _showVIN = [[[NSBundle mainBundle] loadNibNamed:@"ShowVIN" owner:self options:nil] objectAtIndex:0];
        _showVIN.delegate = self;

        _vinMArr = [_showVIN.characterKeys mutableCopy];
    }
    return _showVIN;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor blackColor];
    }
    return _bottomView;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"重拍" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)returnBtn
{
    if (!_returnBtn) {
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}

- (UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc] init];
    }
    return _photo;
}

- (void)setCutImg:(UIImage *)cutImg
{
//    cutImg = [UIImage imageWithCIImage:cutImg.CGImage scale:1.0 orientation:UIImageOrientationLeft];
    cutImg = [UIImage image:cutImg rotation:UIImageOrientationLeft];
    self.photo.image = cutImg;
}

- (void)setVinStr:(NSMutableArray *)vinStr
{
    self.showVIN.vinStrs = [vinStr mutableCopy];
}

@end
