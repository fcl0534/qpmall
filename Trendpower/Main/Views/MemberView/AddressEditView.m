//
//  AddressEditView.m
//  Trendpower
//
//  Created by HTC on 15/5/17.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#define K_ToolBar_Height 44

#import "AddressEditView.h"

#import "NetworkingUtil.h"
#import "HUDUtil.h"
#import "UserDefaultsUtils.h"
#import "Utility.h"
#import "RegionModelArray.h"


@interface AddressEditView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic)  UILabel *consigneeLabel;
@property (weak, nonatomic)  UILabel *mobphoneLabel;
@property (weak, nonatomic)  UILabel *regionNameLabel;
@property (weak, nonatomic)  UILabel *addressLabel;

/**
 *  consignee（收货人）phone_mob（手机），region_name（地区名称），region_id（地区ID，最后一级），address（地址）
 */

/** 收货人 */
@property (weak, nonatomic)  UITextField *consigneeField;
/** 手机号码 */
@property (weak, nonatomic)  UITextField *mobphoneField;
/** 地区 */
@property (weak, nonatomic)  UITextField *regionNameField;
/** 详情地址栏 */
@property (weak, nonatomic)  CustomTextView *addressView;

@property (nonatomic, weak)  UIButton * defaultAddrBtn;

/** 确认按钮 */
@property (weak, nonatomic)  UIButton * confirmButton;


@property (nonatomic, weak) UIView * line1;
@property (nonatomic, weak) UIView * line2;
@property (nonatomic, weak) UIView * line3;
@property (nonatomic, weak) UIView * line4;

/**
 *  /所在地区 只能点击按钮
 */
@property (nonatomic, weak) UIButton * tapBtn;

/**
 *  黑色背影
 */

@property (nonatomic, weak) UIView* blackBgView;

@property (nonatomic, weak) UIPickerView * pickerView;
@property (nonatomic, weak) UIView * toolBar;

@property (nonatomic, strong) NSArray * regionArray;
@property (nonatomic, strong) NSArray * regionChildArray;
@property (nonatomic, strong) NSArray * regionSubChildArray;

/** 地区ID，最后一级 */
@property (nonatomic, copy) NSString *  regionId;

@end


@implementation AddressEditView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        [self initBaseView];
    }
    
    return self;
}

- (void)initBaseView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 1.
    self.line1 = [self getLineView];
    self.line2 = [self getLineView];
    self.line3 = [self getLineView];
    self.line4 = [self getLineView];

    // 2.
    self.consigneeLabel = [self getLabel:@"收货人:"];
    self.mobphoneLabel = [self getLabel:@"联系方式:"];
    self.regionNameLabel = [self getLabel:@"所在地区:"];
    self.addressLabel = [self getLabel:@"详细地址:"];
    
    // 3.
    self.consigneeField = [self getTextField:@"名字"];
    self.mobphoneField = [self getTextField:@"11位手机号"];
    self.mobphoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.regionNameField = [self getTextField:@"点击选择"];
    self.regionNameField.enabled = NO;
    //让所在地区 只能点击
    UIButton * tapBtn = [[UIButton alloc]init];
    tapBtn.backgroundColor = [UIColor clearColor];
    [tapBtn addTarget:self action:@selector(clickedRegionNameField:) forControlEvents:UIControlEventTouchUpInside];
    self.tapBtn = tapBtn;
    [self addSubview:tapBtn];
    
    
    // 4.
    CustomTextView * addressView = [[CustomTextView alloc]init];
    addressView.font = [UIFont systemFontOfSize:16];
    addressView.textColor = [UIColor colorWithWhite:0.141 alpha:1.000];
    addressView.tintColor = [UIColor colorWithRed:0.949 green:0.280 blue:0.226 alpha:1.000];
    [self addSubview:addressView];
    self.addressView = addressView;
    self.addressView.placeholder = @"详情地址";
    
    self.defaultAddrBtn = [self getBtnTitile:@"设为默认地址" seleteImage:[UIImage imageNamed:@"flight_butn_check_select"] normalImage:[UIImage imageNamed:@"flight_butn_check_unselect"]];
    
    // 5.
    UIButton * confirmButton = [[UIButton alloc]init];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"back_red"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(clickedConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    self.confirmButton = confirmButton;
    
    // 6.pickerView
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    bgView.hidden = YES;
    [self addSubview:bgView];
    self.blackBgView = bgView;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [bgView addGestureRecognizer:tap];
    
    
    UIPickerView * pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) -K_ToolBar_Height, self.frame.size.width, 216)];
    pickerView.delegate = self;
    self.pickerView = pickerView;
    [self addSubview:pickerView];
    pickerView.backgroundColor = [UIColor whiteColor];
    
    //  7.
    [self setToolBarView];
    
    [self addViewConstraints];
}


- (UILabel *) getLabel:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1];
    label.tintColor = [UIColor colorWithRed:0.949 green:0.280 blue:0.226 alpha:1.000];
    [self addSubview:label];
    return label;
}

- (UITextField *) getTextField:(NSString *)placeholder{
    UITextField *field = [[UITextField alloc]init];
    field.placeholder = placeholder;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.font = [UIFont systemFontOfSize:16.0f];
    field.textAlignment = NSTextAlignmentLeft;
    field.textColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1];
    field.tintColor = [UIColor colorWithRed:0.949 green:0.280 blue:0.226 alpha:1.000];
    [self addSubview:field];
    return field;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    [self addSubview:line];
    return line;
}


- (UIButton *) getBtnTitile:(NSString *)title seleteImage:(UIImage *)seleteImage normalImage:(UIImage *)normalImage {
    UIButton *btn = [[UIButton alloc]init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [btn setTitleColor:[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:seleteImage forState:UIControlStateSelected];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedDefaultAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addSubview:btn];
    return btn;
}

//选择器上的工具项
- (void)setToolBarView{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.frame), self.frame.size.width, 40)];
    topView.backgroundColor = [UIColor colorWithRed:0.933f green:0.933f blue:0.933f alpha:1.00f];
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [leftBtn setTitle:@"关闭" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn setTitleColor:[UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000] forState:UIControlStateNormal];
    
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 60 , 0, 60, 40)];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:[UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(cancelSeleted) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn addTarget:self action:@selector(finishSeleted) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:leftBtn];
    [topView addSubview:rightBtn];
    
    [self addSubview:topView];
    self.toolBar = topView;
}

     
     
#pragma mark - 添加约束
-(void) addViewConstraints{
    
     float spacing = 10;
     NSNumber * labelWidth = @85;
     NSNumber * labelHeight = @55;
    
     // 1.
     [self.consigneeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.mas_left).offset(spacing);
         make.top.mas_equalTo(self.mas_top).offset(0);
         make.width.mas_equalTo(labelWidth);
         make.height.mas_equalTo(labelHeight);
     }];
     
    [self.consigneeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.consigneeLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.consigneeLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
     
     // 2.
    [self.mobphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.consigneeLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.mobphoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mobphoneLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.consigneeLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.mobphoneLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
     // 3.
    [self.regionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.mobphoneLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.regionNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mobphoneLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.mobphoneLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mobphoneLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.mobphoneLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.regionNameLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    
    // 4.
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.regionNameLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(labelHeight);
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addressLabel.mas_right).offset(0);
        make.top.mas_equalTo(self.line3.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.bottom.mas_equalTo(self.addressLabel.mas_bottom);
    }];
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.addressView.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.defaultAddrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.line4.mas_bottom).offset(0);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(labelHeight);
    }];
    
    // 5.
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.height.mas_equalTo(@38);
    }];
}


#pragma mark - 初始化
- (void)setAddressModel:(AddressModel *)addressModel{
    _addressModel = addressModel;
    
    self.consigneeField.text = addressModel.custommerName;
    self.mobphoneField.text = addressModel.cellPhone;
    self.regionNameField.text = addressModel.regionName;
    self.addressView.text = addressModel.address;
    self.regionId = addressModel.regionId;
    
    self.defaultAddrBtn.selected = addressModel.isDefaultArress;
}

- (void)setIsFromNewAddress:(BOOL)isFromNewAddress{
    _isFromNewAddress = isFromNewAddress;
    
    if (isFromNewAddress) {
        [self.confirmButton setTitle:@"保存地址" forState:UIControlStateNormal];
    }else{
        [self.confirmButton setTitle:@"确认修改" forState:UIControlStateNormal];
    }
}

- (void)setArea:(NSString *)area{
    self.regionNameField.text = area;
    
}

#pragma mark - 代理
- (void) clickedDefaultAddressBtn:(UIButton *)btn{
    btn.selected = !btn.isSelected;
}

- (void) clickedRegionNameField:(UIGestureRecognizer *)tap{
    
    [self endEditing:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddressEditViewClickedRegionArea)]) {
        [self.delegate AddressEditViewClickedRegionArea];
    }
    
//    if (self.isFromNewAddress) {
//        if (self.regionArray.count == 0) {
//            [self featchAddressListParentId:@"1" level:@"1" editURL:NO];
//        }else{
//            [self popPickerView];
//        }
//    }else{
//        if (self.regionArray.count == 0) {
//            [self featchAddressListParentId:self.regionId level:@"1" editURL:YES];
//        }else{
//            [self popPickerView];
//        }
//    }
    
}


#pragma mark - 地址数据请求方式【为了重用，全部调用这个方法】
/**
 *  地址请求方式
 *
 *  @param regionId 本级id
 *  @param level    本级
 *  @param isEdit   是不是编辑地址
 */
- (void)featchAddressListParentId:(NSString *)regionId level:(NSString *)level editURL:(BOOL)isEdit{
    NetworkingUtil * networkUtil = [NetworkingUtil sharedNetworkingUtil];
    
    // 1.请求参数
    NSString *areaListUrl;
    if (isEdit) {
        areaListUrl = [API_ROOT stringByAppendingString:API_ROOT];
    }else{
        areaListUrl = [API_ROOT stringByAppendingString:API_ROOT];
    }
    
    areaListUrl = [areaListUrl stringByAppendingString:regionId];
    areaListUrl = [areaListUrl stringByAppendingString:@"&level="];
    areaListUrl = [areaListUrl stringByAppendingString:level];
    areaListUrl = [areaListUrl stringByAppendingString:@"&userId="];
    areaListUrl = [areaListUrl stringByAppendingString:[UserDefaultsUtils getUserId]];
    
   // NSLog(@"AREA_LIST_API---%@",areaListUrl);
    
    // 2.
    [networkUtil GET:areaListUrl inView:self success:^(id responseObject) {
        // 
        // 3.
        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
            // 4.1.滚动2级地址 只要三级更新
            if ([level intValue] == 2) {
                
                NSArray *subChildArray = [responseObject valueForKey:@"data"];
                NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
                for (NSDictionary * dic in subChildArray) {
                    
                    RegionSubchildModel *model = [[RegionSubchildModel alloc] initWithAttributes:dic];
                    [mutilableData addObject:model];
                }
                self.regionSubChildArray = [[NSArray alloc] initWithArray:mutilableData];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                
            }else{
            // 4.2 返回三级地址列表
                // 1.
                RegionModelArray * model = [[RegionModelArray alloc]initWithAttributes:responseObject];
                self.regionArray = model.dataRegionArray;
                // 2.
                NSInteger childRow = 0;
                NSInteger subChildRow = 0;
                // 4.2.1
                if (model.dataRegionArray.count) {
                    RegionModel * regionModel = model.dataRegionArray[model.defaultRow];
                    self.regionChildArray = regionModel.dataChildModelArray;
                    childRow = regionModel.defaultRow;
                     // 4.2.1.1
                    if (regionModel.dataChildModelArray.count) {
                        RegionChildModel * childModel = regionModel.dataChildModelArray[regionModel.defaultRow];
                        self.regionSubChildArray = childModel.dataSubChildModelArray;
                        subChildRow = childModel.defaultRow;
                        
                    }else{   // 4.2.1.2
                        self.regionSubChildArray = nil;
                        subChildRow = 0;
                    }
                }else{ //4.2.2
                    self.regionChildArray = nil;
                    childRow = 0;
                }
                
                // 4.3
                [self.pickerView reloadAllComponents];

                if (isEdit) {
                    //选中默认的
                    [self.pickerView selectRow:model.defaultRow inComponent:0 animated:NO];
                    [self.pickerView selectRow:childRow inComponent:1 animated:NO];
                    [self.pickerView selectRow:subChildRow inComponent:2 animated:NO];
                }else{
                    [self.pickerView selectRow:0 inComponent:1 animated:YES];
                    [self.pickerView selectRow:0 inComponent:2 animated:YES];
                }
               
            }
            
            // 4.
            [self popPickerView];
  
        }else{
            HUDUtil * hud = [HUDUtil sharedHUDUtil];
            [hud showTextMBHUDWithText:[responseObject objectForKey:@"msg"]  delay:1.5 inView:self];
        }
    } failure:^(NSError *error) {
        HUDUtil * hud = [HUDUtil sharedHUDUtil];
        [hud showNetworkErrorInView:self];
    }];
}


#pragma mark - 点击确认按钮
- (void) clickedConfirmButton:(UIButton *)btn{
    
    HUDUtil * hud = [HUDUtil sharedHUDUtil];
    
    // 判断数据格式是否正确
    if(self.consigneeField.text.length == 0){
        [hud showTextMBHUDWithText:@"请填写收件人" delay:1 inView:self];
        return;
    }
    
    if(self.mobphoneField.text.length == 0){
        [hud showTextMBHUDWithText:@"请填写手机号码" delay:1 inView:self];
        return;
    }else if([Utility isValidatePhoneNumber:self.mobphoneField.text]){
        [hud showTextMBHUDWithText:@"手机号码格式有误" delay:1 inView:self];
        return;
    }
    
    if(self.regionNameField.text.length == 0){
        [hud showTextMBHUDWithText:@"请选择所在地区" delay:1 inView:self];
        return;
    }
    
    if(self.addressView.text.length == 0){
        [hud showTextMBHUDWithText:@"详细地址不能为空" delay:1 inView:self];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(AddressEditViewClickedButton:consigneeField:mobphoneField:regionNameField:addressView:regionId:defaultBtn:)]) {
        [self.delegate AddressEditViewClickedButton:btn consigneeField:self.consigneeField mobphoneField:self.mobphoneField regionNameField:self.regionNameField addressView:self.addressView regionId:self.regionId defaultBtn:self.defaultAddrBtn];
    }
}

#pragma mark - 关闭选择器
- (void)cancelSeleted{
    [self hiddenPickerView];
}

#pragma mark - 完成地址选择，记录当前 名字和id
- (void)finishSeleted{
    [self hiddenPickerView];
    
    // 1.
    NSString * addressStr;
    NSInteger rowComponent1 = [self.pickerView selectedRowInComponent:0];
    NSInteger rowComponent2 = [self.pickerView selectedRowInComponent:1];
    NSInteger rowComponent3 = [self.pickerView selectedRowInComponent:2];
    
    // 2.
    // 2.1
    RegionModel * model = self.regionArray[rowComponent1];
    self.regionId = model.regionId;
    addressStr = model.regionName;
    
    if (self.regionChildArray.count) { // 2.2.1 有二级
        RegionChildModel * childModel = self.regionChildArray[rowComponent2];
        self.regionId = childModel.regionId;
        addressStr = [addressStr stringByAppendingString:childModel.regionName];
        
        if (self.regionSubChildArray.count) { // 2.2.1.1 有三级
            RegionSubchildModel * subChildModel = self.regionSubChildArray[rowComponent3];
            self.regionId = subChildModel.regionId;
            addressStr = [addressStr stringByAppendingString:subChildModel.regionName];
        }else{ // 2.2.1.2 无三级
            
        }
        
    }else{ // 2.2.2 无二级
        
    }
    
    //NSLog(@"-----%@",self.regionId);
    
    self.regionNameField.text = addressStr;
}


#pragma mark - UIPickerViewDelegate

//包含多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 0;
    switch (component) {
        case 0:
            rows = self.regionArray.count;
            break;
        case 1:{
            rows = self.regionChildArray.count;
            break;
        }
        case 2:{
            rows = self.regionSubChildArray.count;
            break;
        }
        default:
            break;
    }
    
    return rows;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    if (view == nil) {
        // 没有重用
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width/3, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        view = label;
    }
    
    NSString * title = @"";
    switch (component) {
        case 0:{
            RegionModel * model = self.regionArray[row];
            title = model.regionName;
            break;
        }
        case 1:{
            RegionChildModel * model = self.regionChildArray[row];
            title = model.regionName;
            break;
        }
        case 2:{
            RegionSubchildModel * model = self.regionSubChildArray[row];
            title = model.regionName;
            break;
        }
        default:
            break;
    }
    
    UILabel * label = (UILabel *)view;
    label.text = title;
    
    return view;
    
}

//选中列表时，激发
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            RegionModel * model = self.regionArray[row];
            //NSLog(@"0---%@----%@",model.regionName,model.regionId);
            [self featchAddressListParentId:model.regionId level:@"1" editURL:NO];
            break;
        }
        case 1:{
            if (self.regionChildArray.count) {
                RegionChildModel * model = self.regionChildArray[row];
                [self featchAddressListParentId:model.regionId level:@"2" editURL:NO];
               // NSLog(@"1---%@----%@",model.regionName,model.regionId);
            }
            break;
        }
        case 2:{
//            if (self.regionChildArray.count) {
//                RegionSubchildModel * model = self.regionSubChildArray[row];
//                //NSLog(@"2---%@----%@",model.regionName,model.regionId);
//            }
            break;
        }
        default:
            break;
    }
    
}




//显示选择器
-(void) popPickerView
{
    self.blackBgView.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.blackBgView.alpha = 0.5;
        self.toolBar.frame = CGRectMake(0, self.frame.size.height - 216 -K_ToolBar_Height, self.frame.size.width, K_ToolBar_Height);
        self.pickerView.frame = CGRectMake(0, self.frame.size.height - 216, self.frame.size.width, 216);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}


//隐藏选择器
-(void) hiddenPickerView
{
    [UIView animateWithDuration:0.35 animations:^{
        self.blackBgView.alpha = 0;
        self.toolBar.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, K_ToolBar_Height);
        self.pickerView.frame = CGRectMake(0, self.frame.size.height+K_ToolBar_Height, self.frame.size.width, 216);
    } completion:^(BOOL finished) {
          self.blackBgView.hidden = YES;
    }];
    
}

#pragma mark - 点击了黑色地址区背影
- (void)tapBgView{
    [self hiddenPickerView];
}

@end
