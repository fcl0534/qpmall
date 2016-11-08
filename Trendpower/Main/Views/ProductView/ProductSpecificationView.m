//
//  ProductSpecificationView.m
//  Trendpower
//
//  Created by HTC on 15/5/9.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "ProductSpecificationView.h"
//规格模型
#import "ProductSpecificationModel.h"

@interface ProductSpecificationView()

//因为选择不同属性时，价格和库存都不一样，需要动态更新
@property (nonatomic, strong) ProductModel * productModel;
@property (nonatomic, weak) UILabel * price;
@property (nonatomic, weak) UILabel * stock;

/** 当前选中的规格1的按钮 */
@property (nonatomic, strong) UIButton * specBtn1;
/** 当前选中的规格2的按钮 */
@property (nonatomic, strong) UIButton * specBtn2;

@end

@implementation ProductSpecificationView

- (instancetype) initWithFrame:(CGRect)frame productModel:(ProductModel *)productModel
{
    self = [super initWithFrame:frame];
    if (self) {
        //价格
        self.productModel = productModel;
        UILabel * price = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, frame.size.width -10, 35)];
        self.price = price;
        price.font = [UIFont systemFontOfSize:20.0f];
        price.textColor = [UIColor colorWithRed:0.921 green:0.000 blue:0.102 alpha:1.000];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *isLogin=  [defaults objectForKey:@"isLogin"];
        BOOL isLogined=NO;
        if([isLogin isEqualToString:@"YES"]){
            isLogined=YES;
        }
        price.text = isLogined?[NSString stringWithFormat:@"会员价 ¥ %@",productModel.good_price]:[NSString stringWithFormat:@"¥ %@",productModel.price];
        [self addSubview:price];
        //库存
        UILabel * stock = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(price.frame), frame.size.width -10, 25)];
        self.stock = stock;
        stock.font = [UIFont systemFontOfSize:14.0f];
        stock.textColor = [UIColor colorWithWhite:0.555 alpha:1.000];
        stock.text = [NSString stringWithFormat:@"库存: %@",productModel.sku];
        [self addSubview:stock];
        
        //根据规格种类显示规格属性视图
        if(productModel.specCount){
            [self creatSpec:productModel];
        }
        
    }
    return self;
}

#pragma mark - 规格属性视图
- (void)creatSpec:(ProductModel *)prodModel{
    
    NSArray * specArray = prodModel.goods_stores;
    ProductSpecificationModel * firstSpec = [specArray firstObject];
    //因为默认选择属性1，所以设置对应的价格和数量
    self.price.text = [NSString stringWithFormat:@"¥ %@",firstSpec.price];
    self.stock.text = [NSString stringWithFormat:@"库存: %@",firstSpec.sku];
    
    //规格1名称
    UILabel * spec1 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.stock.frame), self.frame.size.width -10, 25)];
    spec1.font = [UIFont systemFontOfSize:15.0f];
    spec1.textColor = [UIColor colorWithWhite:0.276 alpha:1.000];
    spec1.text = prodModel.specName1;
    [self addSubview:spec1];
    
    float H = 30;
    float spacingW = 25;
    float spacingH = 13;
    CGRect lastFrame;//记录最后一个按钮的frame
    //规格1属性
    NSDictionary * specDic = prodModel.specNameDic;
    for (int i =0; i<specDic.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(spacingW, i*(H +spacingH) + CGRectGetMaxY(spec1.frame) +5, self.frame.size.width - 2*spacingW, H)];
        btn.titleLabel.font =[UIFont systemFontOfSize:16.0f];
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        [btn setTitle:[specDic objectForKey:[NSNumber numberWithInt:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickedSpecName1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (i == 0) {
            [self setButtonSelected:btn];
            self.specBtn1 = btn;
        }else{
            [self setButtonNormal:btn];
        }
        lastFrame = btn.frame;//记录最后一个btn的frame
    }
    
    //如果有属性2
    if(prodModel.specCount == 2){
        //规格2名称
        UILabel * spec2 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lastFrame) +10, self.frame.size.width -10, 25)];
        spec2.font = [UIFont systemFontOfSize:15.0f];
        spec2.textColor = [UIColor colorWithWhite:0.276 alpha:1.000];
        spec2.text = prodModel.specName2;
        [self addSubview:spec2];
        
        //规格2属性
        NSDictionary * specDic = prodModel.specName2Dic;
        for (int i =0; i<specDic.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(spacingW, i*(H +spacingH) + CGRectGetMaxY(spec2.frame) +5, self.frame.size.width - 2*spacingW, H)];
            btn.titleLabel.font =[UIFont systemFontOfSize:16.0f];
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            [btn setTitle:[specDic objectForKey:[NSNumber numberWithInt:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickedSpecName2:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            if (i == 0) {
                [self setButtonSelected:btn];
                self.specBtn2 = btn;
            }else{
                [self setButtonNormal:btn];
            }
        }
    }

    
}




#pragma mark - 点击属性1
- (void)clickedSpecName1:(UIButton *)btn{
    if (btn == self.specBtn1) return;
    
    [self setButtonNormal:self.specBtn1];
    [self setButtonSelected:btn];
    self.specBtn1 = btn;
    
}


#pragma mark - 点击属性2
- (void)clickedSpecName2:(UIButton *)btn{
    if (btn == self.specBtn2) return;
    
    [self setButtonNormal:self.specBtn2];
    [self setButtonSelected:btn];
    self.specBtn2 = btn;

}



- (void)setButtonNormal:(UIButton *)btn{
    [btn.layer setBorderColor:[UIColor colorWithWhite:0.555 alpha:1.000].CGColor];
    [btn.layer setBorderWidth:0.5];
    [btn setTitleColor:[UIColor colorWithWhite:0.555 alpha:1.000] forState:UIControlStateNormal];
}


- (void)setButtonSelected:(UIButton *)btn{
    [btn.layer setBorderColor:[UIColor colorWithRed:0.949 green:0.141 blue:0.092 alpha:1.000].CGColor];
    [btn.layer setBorderWidth:0.5];
    [btn setTitleColor:[UIColor colorWithRed:0.949 green:0.141 blue:0.092 alpha:1.000] forState:UIControlStateNormal];
}





@end
