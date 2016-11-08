//
//  ProductPropView.m
//  Trendpower
//
//  Created by trendpower on 15/5/20.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "ProductPropView.h"

#import "TCStepperView.h"

@interface ProductPropView()

@property (nonatomic, weak) UILabel * nameLabel;
@property (nonatomic, weak) UILabel * priceLabel;

@property (nonatomic, weak) UILabel * stockLabel;
@property (nonatomic, weak) UILabel * tipsLabel;
@property (nonatomic, weak) UIButton * closeBtn;
@property (nonatomic, weak) UIView * midLine;

@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, weak) UILabel * spec1Label;
@property (nonatomic, weak) UILabel * spec2Label;

@property (nonatomic, weak) UIButton * confirmBtn;

/** 当前选中的规格1的按钮 */
@property (nonatomic, weak) UIButton * specBtn1;
/** 当前选中的规格2的按钮 */
@property (nonatomic, weak) UIButton * specBtn2;

/** 规格1的全部按钮对象数组 */
@property (nonatomic, strong) NSMutableArray * spec1BtnArray;
/** 规格2的全部按钮对象数组 */
@property (nonatomic, strong) NSMutableArray * spec2BtnArray;

@property (nonatomic, weak) TCStepperView *stepperView;

@end

@implementation ProductPropView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.
        self.backgroundColor = [UIColor whiteColor];
        //2.
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.layer.borderColor = [UIColor colorWithWhite:0.879 alpha:1.000].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        
        [self addSubview:imageView];
        self.imageView = imageView;
        // 3.
//        self.nameLabel = [self getLabel];
//        self.nameLabel.numberOfLines = 2;
        self.priceLabel = [self getLabel];
        self.priceLabel.font = [UIFont systemFontOfSize:20.0];
        self.priceLabel.textColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
        self.stockLabel = [self getLabel];
        self.tipsLabel = [self getLabel];
        self.tipsLabel.numberOfLines = 2;
        
        // 4.
        UIButton *closeBtn = [[UIButton alloc]init];
        [closeBtn setImage:[UIImage imageNamed:@"close_normal"] forState:UIControlStateNormal];
        [self addSubview:closeBtn];
        self.closeBtn = closeBtn;
        [closeBtn addTarget:self action:@selector(clickedCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.midLine = [self getLineView];
        // 4.
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.alwaysBounceVertical = YES;
        scrollView.scrollEnabled = YES;
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 5.
        UIButton *confirmBtn = [[UIButton alloc]init];
        self.confirmBtn = confirmBtn;
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_square_bg"] forState:UIControlStateNormal];
        [self addSubview:confirmBtn];
        [confirmBtn addTarget:self action:@selector(clickedConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addViewConstraints];
        
    }
    
    return self;
}

#pragma mark 初始化视图
- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0.361f green:0.384f blue:0.424f alpha:1.00f];
    [self addSubview:label];
    return label;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.922f green:0.918f blue:0.922f alpha:1.00f];
    [self addSubview:line];
    return line;
}

- (UIButton *) getBtnTitile:(NSString *)title seleteImage:(UIImage *)seleteImage normalImage:(UIImage *)normalImage {
    UIButton *btn = [[UIButton alloc]init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor colorWithRed:0.843f green:0.843f blue:0.843f alpha:1.00f].CGColor;
    btn.layer.borderWidth = 1;
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:seleteImage forState:UIControlStateSelected];
    //    [btn addTarget:self action:@selector(clickedGenderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

#pragma mark - 初始化数据
- (void)setProductModel:(ProductModel *)productModel{
    _productModel = productModel;
    
    //根据规格种类显示规格属性视图
    if(productModel.specCount == 2){
        [self creatTwoSpec:productModel];
    }else{
        //一种规格
        [self creatOneSpec:productModel];
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",productModel.good_price];
    self.stockLabel.text =  [NSString stringWithFormat:@"库存 %@ 件",productModel.sku];
    self.stepperView.maxValue = [productModel.sku integerValue];
    
}

#pragma mark - ############【只有2种规格时】###################

#pragma mark - 1种规格属性视图
- (void)creatOneSpec:(ProductModel *)prodModel{

    UIFont * nameFont = [UIFont systemFontOfSize:18.0];
    UIFont * specFont = [UIFont systemFontOfSize:15.0];
    
    //规格1名称
    UILabel * spec1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.frame.size.width -15, 25)];
    spec1.font = nameFont;
    spec1.textColor = [UIColor colorWithWhite:0.118 alpha:1.000];
    spec1.text = prodModel.specName1;
    [self.scrollView addSubview:spec1];
    
    
    CGFloat spacingW = 15;
    CGFloat spacingH = 15;
    CGFloat viewW = self.frame.size.width;
    CGFloat margin = 10;
    CGFloat usableW = viewW;//同一行可用宽度
    CGFloat BtnY = CGRectGetMaxY(spec1.frame) +margin;//热词的Y
    CGFloat BtnH = 30;
    CGFloat BtnX = 10;
    CGFloat BtnRadius = 3;
    
    CGRect lastFrame;//记录最后一个按钮的frame
    //规格1属性
    NSDictionary * specDic = prodModel.specNameDic;
    
    for (int i =0; i<specDic.count; i++) {
        // 1.
        NSString *specName = [specDic objectForKey:[NSNumber numberWithInt:i]];
        CGSize specSize = [self sizeWithText:specName font:specFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        // 2.
        CGFloat BtnW = 2*margin + specSize.width;//按钮宽
        if (usableW < (BtnW + 2*spacingW)) {//可用宽度小于按钮宽度，换行，并重设数据
            BtnY = BtnH +spacingH + BtnY;
            BtnX = 10;
            usableW = viewW;
        }
        usableW = usableW - BtnW - spacingW;//可用宽度
        
        UIButton * specBtn = [[UIButton alloc]initWithFrame:CGRectMake(BtnX, BtnY, BtnW, BtnH)];
        specBtn.titleLabel.font =specFont;
        specBtn.layer.cornerRadius = BtnRadius;
        specBtn.layer.masksToBounds = YES;
        [specBtn setTitle:specName forState:UIControlStateNormal];
        [specBtn addTarget:self action:@selector(clickedSpecName1:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:specBtn];
        
        BtnX = BtnX + BtnW +margin;
        
        if (i == 0 && specDic.count == 1) { //只有一个属性，就默认选择
            [self setButtonSelected:specBtn];
            self.specBtn1 = specBtn;
        }else{
            [self setButtonNormal:specBtn];
        }
        lastFrame = specBtn.frame;//记录最后一个btn的frame
    }
    
    //判断提示
    
    if (prodModel.specNameDic.count == 1) {
        self.tipsLabel.text =  [NSString stringWithFormat:@"已选：\"%@\"",prodModel.specName1];
    }else{
        self.tipsLabel.text =  [NSString stringWithFormat:@"请选择：%@",prodModel.specName1];
    }
    
    // 4.1 购物车栏
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(lastFrame) +spacingH, viewW, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.922f green:0.918f blue:0.922f alpha:1.00f];
    [self.scrollView addSubview:line];
    
    UILabel * bottomLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line.frame) +margin, 80, 30)];
    bottomLbl.font = nameFont;
    bottomLbl.textColor = [UIColor colorWithWhite:0.118 alpha:1.000];
    bottomLbl.text = @"购买数量:";
    [self.scrollView addSubview:bottomLbl];
    
    
    TCStepperView *stepperView = [[TCStepperView alloc]initWithFrame:CGRectMake(viewW - 135, CGRectGetMaxY(line.frame) +spacingH, 120, 30)];
    stepperView.currentValue = 1;
    [self.scrollView addSubview:stepperView];
    self.stepperView = stepperView;
    
    // 长度
    self.scrollView.contentSize = CGSizeMake(viewW, CGRectGetMaxY(stepperView.frame) +spacingH);
    
}


#pragma mark - 点击属性1
- (void)clickedSpecName1:(UIButton *)btn{
    
    // 点击的按钮是当前按钮
    if (btn == self.specBtn1){
        [self setButtonNormal:btn];
        self.specBtn1 = nil;
    }else{
        
        [self setButtonNormal:self.specBtn1];
        [self setButtonSelected:btn];
        self.specBtn1 = btn;
    }
    
    // 重置，获得最新数据
    [self resetProductInfo];
}


#pragma mark - 找到模型里对应的规格
- (void)resetProductInfo{
    
    //没有选中属性
    if(self.specBtn1 == nil){
        self.tipsLabel.text =  [NSString stringWithFormat:@"请选择：%@",self.productModel.specName1];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.productModel.good_price];
        self.stockLabel.text =  [NSString stringWithFormat:@"库存 %@ 件",self.productModel.sku];
        self.stepperView.maxValue = [self.productModel.sku integerValue];
    }else{
        ProductSpecificationModel * productModel = [self featchModelWithSpecName:[self.specBtn1 currentTitle]];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",productModel.good_price];
        self.stockLabel.text =  [NSString stringWithFormat:@"库存 %@ 件",productModel.sku];
        self.stepperView.maxValue = [productModel.sku integerValue];
        self.tipsLabel.text =  [NSString stringWithFormat:@"已选：\"%@\"",productModel.company_name];
    }
}


#pragma mark - 通过规格名获得对应模型所在下标【只有一种规格时】
- (ProductSpecificationModel *) featchModelWithSpecName:(NSString *)specName{
    
    ProductSpecificationModel * productModel;
    for (int i = 0; i < self.productModel.goods_stores.count; i++) {
        ProductSpecificationModel * model = self.productModel.goods_stores[i];
        
        if ([specName isEqualToString:model.company_name]) {
            return model;
            break;
        }
    }
    
    return productModel;
}


#pragma mark - ############【有2种规格时】###################



#pragma mark - 2种规格属性视图[init]
- (void)creatTwoSpec:(ProductModel *)prodModel{
    
    self.spec1BtnArray = [NSMutableArray array];
    self.spec2BtnArray = [NSMutableArray array];
    UIFont * nameFont = [UIFont systemFontOfSize:18.0];
    UIFont * specFont = [UIFont systemFontOfSize:15.0];
    UIColor * specColor = [UIColor colorWithRed:0.208f green:0.231f blue:0.247f alpha:1.00f];
    
    //规格1名称
    UILabel * spec1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.frame.size.width -15, 25)];
    spec1.font = nameFont;
    spec1.textColor = specColor;
    spec1.text = prodModel.specName1;
    [self.scrollView addSubview:spec1];
    
    
    CGFloat spacingW = 15;
    CGFloat spacingH = 15;
    CGFloat viewW = self.frame.size.width;
    CGFloat margin = 10;
    CGFloat usableW = viewW;//同一行可用宽度
    CGFloat BtnY = CGRectGetMaxY(spec1.frame) +margin;//按钮的Y
    CGFloat BtnH = 30;
    CGFloat BtnX = 10;
    CGFloat BtnRadius = 3;
    
    CGRect lastFrame;//记录最后一个按钮的frame
    //规格1属性
    for (int i =0; i<prodModel.spec1NameArray.count; i++) {
        // 1.
        NSString *specName = prodModel.spec1NameArray[i];
        CGSize specSize = [self sizeWithText:specName font:specFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        // 2.
        CGFloat BtnW = 2*margin + specSize.width;//按钮宽
        if (usableW < (BtnW + 2*spacingW)) {//可用宽度小于按钮宽度，换行，并重设数据
            BtnY = BtnH +spacingH + BtnY;
            BtnX = 10;
            usableW = viewW;
        }
        usableW = usableW - BtnW - spacingW;//可用宽度
        
        UIButton * specBtn = [[UIButton alloc]initWithFrame:CGRectMake(BtnX, BtnY, BtnW, BtnH)];
        specBtn.titleLabel.font =specFont;
        specBtn.layer.cornerRadius = BtnRadius;
        specBtn.layer.masksToBounds = YES;
        [specBtn setTitle:specName forState:UIControlStateNormal];
        [specBtn addTarget:self action:@selector(clickedTwoSpecName1:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:specBtn];
        
        [self.spec1BtnArray addObject:specBtn];
        
        BtnX = BtnX + BtnW +margin;
        
        if (i == 0 && prodModel.spec1NameArray.count == 1) { //只有一个属性，就默认选择
            [self setButtonSelected:specBtn];
            self.specBtn1 = specBtn;
        }else{
            [self setButtonNormal:specBtn];
        }
        lastFrame = specBtn.frame;//记录最后一个btn的frame
    }
    
    //属性2
    
    // 分隔线
    UIView * lineView = [self getLineView];
    lineView.frame = CGRectMake(5, CGRectGetMaxY(lastFrame) +spacingH, self.frame.size.width -10, 1);
    [self.scrollView addSubview:lineView];
    
    //规格2名称
    UILabel * spec2 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView.frame) + spacingH, self.frame.size.width -10, 25)];
    spec2.font = nameFont;
    spec2.textColor = specColor;
    spec2.text = prodModel.specName2;
    [self.scrollView addSubview:spec2];
    
    //规格2属性
    BtnX = 10;
    BtnY = CGRectGetMaxY(spec2.frame)+margin;
    usableW = viewW;
    
    
    for (int i =0; i<prodModel.spec2NameArray.count; i++) {
        // 1.
        NSString *specName = prodModel.spec2NameArray[i];
        CGSize specSize = [self sizeWithText:specName font:specFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        // 2.
        CGFloat BtnW = 2*margin + specSize.width;//按钮宽
        if (usableW < (BtnW + 2*spacingW)) {//可用宽度小于按钮宽度，换行，并重设数据
            BtnY = BtnH +spacingH + BtnY;
            BtnX = 10;
            usableW = viewW;
        }
        usableW = usableW - BtnW - margin;//可用宽度
        
        UIButton * specBtn = [[UIButton alloc]initWithFrame:CGRectMake(BtnX, BtnY, BtnW, BtnH)];
        specBtn.titleLabel.font =specFont;
        specBtn.layer.cornerRadius = BtnRadius;
        specBtn.layer.masksToBounds = YES;
        [specBtn setTitle:specName forState:UIControlStateNormal];
        [specBtn addTarget:self action:@selector(clickedTwoSpecName2:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:specBtn];
        
        [self.spec2BtnArray addObject:specBtn];
        
        BtnX = BtnX + BtnW +spacingW;
        
        if (i == 0 && prodModel.spec2NameArray.count == 1) { //只有一个属性，就默认选择
            [self setButtonSelected:specBtn];
            self.specBtn2 = specBtn;
        }else{
            [self setButtonNormal:specBtn];
        }
        lastFrame = specBtn.frame;//记录最后一个btn的frame
    }
    
    //判断提示
    if (prodModel.spec1NameArray.count == 1 && prodModel.spec2NameArray.count == 1 ) {
        self.tipsLabel.text =  [NSString stringWithFormat:@"已选：\"%@\" \"%@\" ",prodModel.spec1NameArray.firstObject,prodModel.spec2NameArray.firstObject];
    }else if(prodModel.specNameDic.count == 1 ){
        self.tipsLabel.text =  [NSString stringWithFormat:@"请选择：%@",prodModel.specName2];
    }else if(prodModel.specName2Dic.count == 1 ){
        self.tipsLabel.text =  [NSString stringWithFormat:@"请选择：%@",prodModel.specName1];
    }else{
        self.tipsLabel.text =  [NSString stringWithFormat:@"请选择：\"%@\" \"%@\"",prodModel.specName1,prodModel.specName2];
    }
    
    // 4.1 购物车栏
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(lastFrame) +spacingH, viewW, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.922f green:0.918f blue:0.922f alpha:1.00f];
    [self.scrollView addSubview:line];
    
    UILabel * bottomLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line.frame) +margin, 80, 30)];
    bottomLbl.font = nameFont;
    bottomLbl.textColor = [UIColor colorWithWhite:0.118 alpha:1.000];
    bottomLbl.text = @"购买数量:";
    [self.scrollView addSubview:bottomLbl];
    
    
    TCStepperView *stepperView = [[TCStepperView alloc]initWithFrame:CGRectMake(viewW - 135, CGRectGetMaxY(line.frame) +spacingH, 120, 30)];
    stepperView.currentValue = 1;
    [self.scrollView addSubview:stepperView];
    self.stepperView = stepperView;
    
    // 长度
    self.scrollView.contentSize = CGSizeMake(viewW, CGRectGetMaxY(stepperView.frame) +spacingH);
    
}


#pragma mark - 点击属性1
- (void)clickedTwoSpecName1:(UIButton *)btn{
    // 点击的按钮是当前按钮
    if (btn == self.specBtn1){
        [self setButtonNormal:btn];
        self.specBtn1 = nil;
        [self deSelectAllSpecBtn];
    }else{
        
        [self setButtonNormal:self.specBtn1];
        [self setButtonSelected:btn];
        self.specBtn1 = btn;
        
        // 遍历数组，如果没有的属性不能按钮，有的属性保留，并能按
        [self resetBtnStatesWithBtn:1];
    }
    
    // 重置，获得最新数据
    [self resetSpecTwoListInfo];
}



#pragma mark - 点击属性2
- (void)clickedTwoSpecName2:(UIButton *)btn{
    if (btn == self.specBtn2){
        [self setButtonNormal:btn];
        self.specBtn2 = nil;
        [self deSelectAllSpecBtn];
    }else{
        [self setButtonNormal:self.specBtn2];
        [self setButtonSelected:btn];
        self.specBtn2 = btn;
        
        // 遍历数组，如果没有的属性不能按钮，有的属性保留，并能按
        [self resetBtnStatesWithBtn:2];
    }
    
    // 重置，获得最新数据
    [self resetSpecTwoListInfo];
}

#pragma mark - 重置没有选中的按钮
- (void)deSelectAllSpecBtn{
    
    if(self.spec2BtnArray.count){
        [self.spec2BtnArray enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL *stop) {
            if (btn != self.specBtn2) {
                btn.enabled = YES;
                [self setButtonNormal:btn];
            }
        }];
    }
    
    
    if (self.spec1BtnArray.count) {
        [self.spec1BtnArray enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL *stop) {
            if (btn != self.specBtn1){
                btn.enabled = YES;
                [self setButtonNormal:btn];
            }
        }];
    }
}

- (void)resetBtnStatesWithBtn:(NSInteger)BtnIndex{
    // 遍历按钮数组2
    if (BtnIndex == 1) {
        NSString * spec1Name = [self.specBtn1 currentTitle];
        NSDictionary * spec2Dics = [self.productModel.dataSpec1Dic objectForKey:spec1Name];
        NSArray * spec2Names = spec2Dics.allKeys;
        
        [self.spec2BtnArray enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL *stop) {
            //属性1有对应的属性2
            if ([self isExistSepcWithTitle:[btn currentTitle] fromTitltes:spec2Names]) {
                if (![[btn currentTitle] isEqualToString:[self.specBtn2 currentTitle]]) {
                    btn.enabled = YES;
                    [self setButtonNormal:btn];
                }
            }else{
                // 属性1没有对应属性2，并且属性2为选中状态时，取消选中
                if ([[btn currentTitle] isEqualToString:[self.specBtn2 currentTitle]]) {
                    [self setButtonNormal:btn];
                    self.specBtn2 = nil;
                }
                btn.enabled = NO;
            }
        }];
        
    }else if(BtnIndex == 2){
        // 遍历按钮数组1
        NSString * spec2Name = [self.specBtn2 currentTitle];
        NSDictionary * spec1Dics = [self.productModel.dataSpec2Dic objectForKey:spec2Name];
        NSArray * spec1Names = spec1Dics.allKeys;
        
        [self.spec1BtnArray enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL *stop) {
            //属性2有对应的属性1
            if ([self isExistSepcWithTitle:[btn currentTitle] fromTitltes:spec1Names]) {
                // 属性1没有对应属性2，并且属性2为选中状态时，取消选中
                if (![[btn currentTitle] isEqualToString:[self.specBtn1 currentTitle]]) {
                    btn.enabled = YES;
                    [self setButtonNormal:btn];
                }
                
            }else{
                if ([[btn currentTitle] isEqualToString:[self.specBtn1 currentTitle]]) {
                    [self setButtonNormal:btn];
                    self.specBtn1 = nil;
                }
                btn.enabled = NO;
            }
        }];
        
    }
    
}

#pragma mark - 一个规格属性找全部规格里是否存在
- (BOOL) isExistSepcWithTitle:(NSString *)title fromTitltes:(NSArray *)array{
    BOOL isExist = NO;
    for (NSString * specName in array) {
        if ([title isEqualToString:specName]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}


#pragma mark - 两个属性时设置数据
- (void)resetSpecTwoListInfo{
    
    //两个属性都没有选中
    if(self.specBtn1 == nil && self.specBtn2 == nil){
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.productModel.price];
        self.stockLabel.text =  [NSString stringWithFormat:@"库存 %@ 件",self.productModel.sku];
        self.stepperView.maxValue = [self.productModel.sku integerValue];
        self.tipsLabel.text =  [NSString stringWithFormat:@"请选择：\"%@\" \"%@\"",self.productModel.specName1,self.productModel.specName2];
    }else if(self.specBtn1 == nil){
        self.tipsLabel.text =  [NSString stringWithFormat:@"请选择：%@",self.productModel.specName1];
    }else if(self.specBtn2 == nil){
        self.tipsLabel.text =  [NSString stringWithFormat:@"请选择：%@",self.productModel.specName2];
    }else{
        ProductSpecificationModel * productModel = [self featchModelWithTwoSpec];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",productModel.good_price];
        self.stockLabel.text =  [NSString stringWithFormat:@"库存 %@ 件",productModel.sku];
        self.stepperView.maxValue = [productModel.sku integerValue];
        self.tipsLabel.text =  [NSString stringWithFormat:@"已选：\"%@\" \"%@\"",productModel.company_name,productModel.specName2];
    }
    
}

#pragma mark - 通过规格名获得对应模型所在下标【有两个规格时】
- (ProductSpecificationModel *) featchModelWithTwoSpec{
    NSString * spec1Name = [self.specBtn1 currentTitle];
    NSString * spec2Name = [self.specBtn2 currentTitle];
    NSDictionary * spec2Dics = [self.productModel.dataSpec1Dic objectForKey:spec1Name];
    ProductSpecificationModel * productModel = [spec2Dics objectForKey:spec2Name];
    return productModel;
}


/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}



#pragma mark - 规格按钮 颜色改变方法
- (void)setButtonNormal:(UIButton *)btn{
    [btn.layer setBorderColor:[UIColor colorWithRed:0.875f green:0.875f blue:0.875f alpha:1.00f].CGColor];
    [btn.layer setBorderWidth:0.5];
    [btn setTitleColor:[UIColor colorWithRed:0.361f green:0.380f blue:0.416f alpha:1.00f] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0.875f green:0.875f blue:0.875f alpha:1.00f] forState:UIControlStateDisabled];
    [btn setBackgroundColor:[UIColor whiteColor]];
}


- (void)setButtonSelected:(UIButton *)btn{
    [btn.layer setBorderColor:[UIColor colorWithRed:0.933 green:0.281 blue:0.281 alpha:1.000].CGColor];
    [btn.layer setBorderWidth:0.5];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0.875f green:0.875f blue:0.875f alpha:1.00f] forState:UIControlStateDisabled];
    [btn setBackgroundColor:[UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000]];
}



#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float top = 20;
    NSNumber * imageWH = @110;
    float spacing = 10;
    float shopCartHeight = 50;
    
    // 1.
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(-top);
        make.width.mas_equalTo(imageWH);
        make.height.mas_equalTo(imageWH);
    }];
    
    // 2.
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.imageView.mas_right).offset(spacing);
//        make.top.mas_equalTo(self.mas_top).offset(spacing);
//        make.right.mas_equalTo(self.closeBtn.mas_left).offset(spacing);
//        make.height.mas_equalTo(@35);
//    }];
    
    
    // 4.
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@55);
    }];
    
    
    // 5.
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@20);
    }];
    
    
    // 3.
    [self.stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(spacing);
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@15);
    }];
    
    
    // 4.
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(spacing);
        make.top.mas_equalTo(self.stockLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@35);
    }];
    
    // 5.
    [self.midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.height.mas_equalTo(@1);
    }];
    
    // 6.
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.midLine.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top).offset(0);
    }];
    
    // 7.
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(-5);
        make.right.mas_equalTo(self.mas_right).offset(5);
        make.height.mas_equalTo(shopCartHeight);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
}




#pragma mark - 代理
- (void)clickedCloseBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(productPropViewClickedCloseBtn:)])
    {
        [self.delegate productPropViewClickedCloseBtn:btn];
    }
    
}

- (void)clickedConfirmBtn:(UIButton *)btn{
    
    //没有规格
    if (self.productModel.specCount == 0) {
        if([self.delegate respondsToSelector:@selector(productPropViewClickedShopCartBtn:specId:cartCounts:)]){
            [self.delegate productPropViewClickedShopCartBtn:btn specId:@"" cartCounts:self.stepperView.currentValue];
        }
        return;
    }
    
    //判断提示
    if (self.productModel.specCount == 1) {
        NSString * specName = [self.specBtn1 currentTitle];
        
        if (specName.length == 0) { //没有选中规格
            if([self.delegate respondsToSelector:@selector(productPropViewShowError:)]){
                [self.delegate productPropViewShowError:[NSString stringWithFormat:@"请选择：%@",self.productModel.specName1]];
            }
        }else{
            ProductSpecificationModel * model = [self featchModelWithSpecName:[self.specBtn1 currentTitle]];
            if([self.delegate respondsToSelector:@selector(productPropViewClickedShopCartBtn:specId:cartCounts:)]){
                [self.delegate productPropViewClickedShopCartBtn:btn specId:model.seller_id cartCounts:self.stepperView.currentValue];
            }
        }
        
    }else{
        
        NSString * spec1Name = [self.specBtn1 currentTitle];
        NSString * spec2Name = [self.specBtn2 currentTitle];
        if (spec1Name.length == 0 && spec2Name.length == 0) { //没有选中规格
            if([self.delegate respondsToSelector:@selector(productPropViewShowError:)]){
                [self.delegate productPropViewShowError:[NSString stringWithFormat:@"请选择：\"%@\" \"%@\"",self.productModel.specName1,self.productModel.specName2]];
            }
        }else if(spec1Name.length == 0){
            if([self.delegate respondsToSelector:@selector(productPropViewShowError:)]){
                [self.delegate productPropViewShowError:[NSString stringWithFormat:@"请选择：%@",self.productModel.specName1]];
            }
        }else if(spec2Name.length == 0){
            if([self.delegate respondsToSelector:@selector(productPropViewShowError:)]){
                [self.delegate productPropViewShowError:[NSString stringWithFormat:@"请选择：%@",self.productModel.specName2]];
            }
        }else{
            ProductSpecificationModel * model = [self featchModelWithTwoSpec];
            if([self.delegate respondsToSelector:@selector(productPropViewClickedShopCartBtn:specId:cartCounts:)]){
                [self.delegate productPropViewClickedShopCartBtn:btn specId:model.seller_id cartCounts:self.stepperView.currentValue];
            }
        }
        
    }
}




@end
