//
//  CartTableviewCell.m
//  ZZBMall
//
//  Created by trendpower on 15/8/7.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "CartTableviewCell.h"

//view
#import <Masonry.h>
#import "CartGoodsModel.h"
#import "TCStepperView.h"

//tool
#import "WebImageUtil.h"



@interface CartTableviewCell()<TCStepperViewDelegate>

@property (nonatomic, weak) UIButton * selectBtn;
@property (nonatomic, weak) UIImageView *goodsImage;
@property (nonatomic, weak) UILabel * goodsNameLbl;
@property (nonatomic, weak) UILabel * priceLbl;
@property (nonatomic, weak) TCStepperView * stepperView;

/**
 *  库存问题
 */
@property (nonatomic, weak) UILabel * existLbl;
@property (nonatomic, weak) UIButton * existBtn;
/**
 *  删除按钮
 */
@property (nonatomic, weak) UIButton * deleteBtn;

@end


@implementation CartTableviewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CartTableviewCell";
    CartTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CartTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton * btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"agree_protocol_no"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"agree_protocol_yes"] forState:UIControlStateSelected];
        btn.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:btn];
        self.selectBtn = btn;
        [btn addTarget:self action:@selector(clickedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:imageView];
        self.goodsImage = imageView;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedCell)];
        [imageView addGestureRecognizer:tap1];
        
        self.goodsNameLbl = [self getLabel];
        self.goodsNameLbl.numberOfLines = 2;
        self.goodsNameLbl.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedCell)];
        [self.goodsNameLbl addGestureRecognizer:tap2];
        
        self.priceLbl = [self getLabel];
        self.priceLbl.textColor = K_MAIN_COLOR;
        
        TCStepperView *stepperView = [[TCStepperView alloc]init];
        stepperView.setConstantValue = YES;
        stepperView.delegate = self;
        [self.contentView addSubview:stepperView];
        self.stepperView = stepperView;
        
        // 删除按钮
        UIButton * deleteBtn = [[UIButton alloc]init];
        [deleteBtn setImage:[UIImage imageNamed:@"delete_normal"] forState:UIControlStateNormal];
        deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.contentView addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(clickedDeletcBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn = deleteBtn;
        
        
        self.existLbl = [self getLabel];
        self.existLbl.textColor = [UIColor redColor];
        self.existLbl.font = [UIFont systemFontOfSize:18];
        self.existLbl.textAlignment = NSTextAlignmentRight;
        self.existLbl.text = @"当前库存不足，请修改购买数量";
        [self.contentView addSubview:self.existLbl];
        self.existLbl.hidden = YES;
        
        UIButton *existBtn = [[UIButton alloc] init];
        [existBtn setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.682]];
        [existBtn setImage:[UIImage imageNamed:@"cart_list_sold_out"] forState:UIControlStateNormal];
        [existBtn setImageEdgeInsets:UIEdgeInsetsMake(10, -75, 10, 50)];
        [existBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [existBtn setTitle:@"商品已过期,点击删除" forState:UIControlStateNormal];
        [existBtn setTitleColor:[UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:0.701] forState:UIControlStateNormal];
        [existBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -150, 0, 0)];
        [existBtn addTarget:self action:@selector(clickedDeletcBtn:) forControlEvents:UIControlEventTouchUpInside];
        //字体居左
        existBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        existBtn.hidden = YES;
        [self.contentView addSubview:existBtn];
        self.existBtn = existBtn;
        
        [self addViewConstraints];
    }
    
    return self;
}



- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor =[UIColor colorWithWhite:0.378 alpha:1.000];
    [self.contentView addSubview:label];
    return label;
}


- (void)setGoodsModel:(CartGoodsModel *)goodsModel{
    _goodsModel = goodsModel;
    
    
    [WebImageUtil setImageWithURL:goodsModel.goodsImage placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:self.goodsImage];
    self.goodsNameLbl.text = goodsModel.goodsName;
    self.priceLbl.text = [NSString stringWithFormat:@"¥ %@",goodsModel.price];
 
    self.selectBtn.selected = goodsModel.is_check;
    
    self.stepperView.currentValue = [goodsModel.quantity integerValue];
    // 人工判断大于库存只取最大库存
    if([goodsModel.quantity integerValue]<=[goodsModel.goodsAgentSku integerValue]){
        self.stepperView.maxValue = [goodsModel.goodsAgentSku integerValue];
    }
    
    // 库存不足
    if([goodsModel.quantity integerValue]>[goodsModel.goodsAgentSku integerValue]){
        self.existLbl.hidden = NO;
        self.priceLbl.hidden = YES;
    }else{
        self.existLbl.hidden = YES;
        self.priceLbl.hidden = NO;
    }
    
    // 无货或下架
    if ([goodsModel.overSku integerValue]==1) {
        self.existBtn.hidden = NO;
    }else{
        self.existBtn.hidden = YES;
    }

}

- (void) addViewConstraints{
    
    // 1.
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(@40);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(self.goodsImage.mas_height);
    }];
    
    [self.goodsNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.goodsImage.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.height.mas_equalTo(@40);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsNameLbl.mas_bottom).offset(8);
        make.left.mas_equalTo(self.goodsImage.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.height.mas_equalTo(@20);
    }];
    
    [self.existLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsNameLbl.mas_bottom).offset(2);
        make.left.mas_equalTo(self.goodsImage.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(@30);
    }];
    
    [self.stepperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-12);
        make.left.mas_equalTo(self.goodsImage.mas_right).offset(5);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@25);
    }];
    
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-12);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    
    [self.existBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}


#pragma mark - 代理
- (void)clickedSelectBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(shopCartCellClickedSelectButton:shopCartModel:indexPath:)]){
        [self.delegate shopCartCellClickedSelectButton:btn shopCartModel:self.goodsModel indexPath:self.indexPath];
    }
}


-(void)stepperViewValueChangIsAdd:(BOOL)isAdd countField:(UITextField *)counteField currentValue:(NSInteger)currentValue{
    if([self.delegate respondsToSelector:@selector(shopCartCellStepperValueChangIsAdd:countField:currentValue:shopCartModel:indexPath:)]){
        [self.delegate shopCartCellStepperValueChangIsAdd:isAdd countField:counteField currentValue:currentValue shopCartModel:self.goodsModel indexPath:self.indexPath];
    }
}

- (void)stepperViewTextBeginEditing:(UITextField *)counteField{
    if([self.delegate respondsToSelector:@selector(shopCartCellStepperTextBeginEditing:shopCartModel:indexPath:)]){
        [self.delegate shopCartCellStepperTextBeginEditing:counteField shopCartModel:self.goodsModel indexPath:self.indexPath];
    }
}


- (void)stepperViewTextDidEndEditing:(UITextField *)counteField oldText:(NSInteger)oldText{
    if([self.delegate respondsToSelector:@selector(shopCartCellStepperTextDidEndEditing:oldText:shopCartModel:indexPath:)]){
        [self.delegate shopCartCellStepperTextDidEndEditing:counteField oldText:oldText shopCartModel:self.goodsModel indexPath:self.indexPath];
    }
}

- (void)stepperViewTextDidChanged:(UITextField *)counteField{
    if([self.delegate respondsToSelector:@selector(shopCartCellStepperTextDidChanged:shopCartModel:indexPath:)]){
        [self.delegate shopCartCellStepperTextDidChanged:counteField shopCartModel:self.goodsModel indexPath:self.indexPath];
    }
}


- (void)clickedCell{
    if([self.delegate respondsToSelector:@selector(shopCartCellClickedImageViewOrGoodsNameWithShopCartModel:indexPath:)]){
        [self.delegate shopCartCellClickedImageViewOrGoodsNameWithShopCartModel:self.goodsModel indexPath:self.indexPath];
    }
}


- (void)clickedDeletcBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(shopCartCellClickedDeletcBtn:shopCartModel:indexPath:)])
    {
        [self.delegate shopCartCellClickedDeletcBtn:btn shopCartModel:self.goodsModel indexPath:self.indexPath];
    }
}


@end
