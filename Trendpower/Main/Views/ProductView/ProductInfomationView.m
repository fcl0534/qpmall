//
//  ProductNameView.m
//  Trendpower
//
//  Created by HTC on 15/5/9.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "ProductInfomationView.h"
#import "ProductStandardMdoel.h"
#import "ProductGoodStandardView.h"

@interface ProductInfomationView()
{
    UIButton *_temBtn;
}

/** 标题上部分割线 */
@property (nonatomic, weak) UIView * lineTopView;
/** 商品名称 label */
@property (nonatomic, strong) UILabel * productNameLabel;
/** 价格 label */
@property (nonatomic, strong) UILabel * priceMemberLabel;
/** 计量单位 label */
@property (nonatomic, strong) UILabel * unitLabel;
/** 品牌 label */
@property (nonatomic, strong) UILabel * brandLabel;
/** 库存 label */
@property (nonatomic, strong) UILabel * stockName;
/** 销量 label */
@property (nonatomic, strong) UILabel *salesNameLabel;
/** 数量两字文本 */
@property (nonatomic, strong) UILabel * countsTextLabel;
/** 库存上部宽分隔条 */
@property (nonatomic, strong) UIView * lineView2;
/** 适用车型下部宽分隔条 */
@property (nonatomic, strong) UIView * lineView3;
/** 适用车型上部分割线 */
@property (nonatomic, strong) UIView * carLine;
/** 适用车型文本 label */
@property (nonatomic, strong) UILabel * carLbl;
/** 指示箭头 */
@property (nonatomic, strong) UIImageView * carImg;

/** 规格view */
@property (nonatomic, strong) UIView *standardView;

@property (nonatomic, strong) UILabel *tipLbl;

@property (nonatomic, strong) UIView *topLine;

@end

const float spacing = 10;

#define halfW (K_UIScreen_WIDTH / 2)

@implementation ProductInfomationView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.productNameLabel];
        [self addSubview:self.priceMemberLabel];
        
        //line
        self.lineTopView = [self getLineView];

        //规格
        [self addSubview:self.standardView];
        [self.standardView addSubview:self.topLine];
        [self.standardView addSubview:self.tipLbl];
        [self layoutStandardViews];
        
        self.countsTextLabel = [self getCommonLabel];
        [self addSubview:self.countsTextLabel];
        self.countsTextLabel.text = @"数量";
        self.countsTextLabel.hidden = YES;
        
        TCStepperView *stepperView = [[TCStepperView alloc]initWithFrame:CGRectMake(0, 0, 110, 28)];
        stepperView.hidden = YES;
        [self addSubview:stepperView];
        self.stepper = stepperView;
        
        self.lineView2 = [self getBigLineView];
        
        self.unitLabel = [self getCommonLabel];
        [self addSubview:self.unitLabel];
        
        self.brandLabel = [self getCommonLabel];
        [self addSubview:self.brandLabel];
        
        self.stockName = [self getCommonLabel];
        [self addSubview:self.stockName];
        
        self.salesNameLabel = [self getCommonLabel];
        [self addSubview:self.salesNameLabel];
        
        // 车型
        self.carLine = [self getLineView];

        self.carLbl = [self getCommonLabel];
        [self addSubview:self.carLbl];
        self.carLbl.text = @"适用车型";
        self.carLbl.font = [UIFont systemFontOfSize:16.5];
        self.carLbl.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedCarTypeBtn:)];
        [self.carLbl addGestureRecognizer:tap];
        
        [self addSubview:self.carImg];
        self.lineView3 = [self getBigLineView];
    }
    return self;
}

/**
 *  设置促销商户信息
 *  @param showing   是否显示促销两字
 *
 */
- (UIView *)setupPromotionStoreViewWithStoreName:(NSString *)storeName promotionInfo:(NSString *)info showingTip:(BOOL)showing{
    UIView *container = [[UIView alloc] init];
    
    UILabel *promoTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 28)];
    [container addSubview:promoTextLabel];
    promoTextLabel.font = [UIFont systemFontOfSize:16.0f];
    promoTextLabel.textColor = [UIColor colorWithRed:0.361f green:0.384f blue:0.424f alpha:1.00f];
    promoTextLabel.text = @"促销";
    
    if (!showing) {
        promoTextLabel.hidden = YES;
    }
    
    CGFloat nameLabelX = CGRectGetMaxX(promoTextLabel.frame) + 10;
    UILabel *storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, 12, 80, 20)];
    [container addSubview:storeNameLabel];
    
    storeNameLabel.font = [UIFont systemFontOfSize:16.0f];
    storeNameLabel.backgroundColor = [UIColor redColor];
    storeNameLabel.textAlignment = NSTextAlignmentCenter;
    storeNameLabel.textColor = [UIColor whiteColor];
    storeNameLabel.layer.cornerRadius = 3.0;
    storeNameLabel.layer.masksToBounds = YES;
    storeNameLabel.text = storeName;
    
    CGFloat infoLabelX = CGRectGetMaxX(storeNameLabel.frame) + 10;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoLabelX, 12, 100, 20)];
    [container addSubview:infoLabel];
    infoLabel.font = [UIFont systemFontOfSize:16.0];
    infoLabel.textColor = [UIColor blackColor];
    
    if (info && info.length > 0) {
        infoLabel.text = info;
    } else {
        infoLabel.hidden = YES;
    }
    
    return container;
}


- (NSString *) getString:(NSString *)str1 str2:(NSString *)str2{
    return [NSString stringWithFormat:@"%@%@",str1,str2];
}


- (void) setLbl:(UILabel *)lbl text:(NSString *)titleText boldString:(NSString *)boldText{
    
    if (!titleText.length) {
        return;
    }
    
    if ([boldText.class isSubclassOfClass:[NSNull class]]){
        lbl.text = titleText;
        return;
    }
    
    if (!boldText.length) {
        lbl.text = titleText;
        return;
    }
    
    //重点字
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleText attributes:attributes];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.5] range:[attributedString.string rangeOfString:boldText]];
    lbl.attributedText = attributedString;
}

- (void)clickSpecBtn:(UIButton *)button {

    NSInteger btnTag = button.tag - 101;

    if(button.tag == _temBtn.tag) {
        //选择同一个不做处理

        return;
    } else {
        button.selected = YES;
        button.layer.borderColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000].CGColor;

        _temBtn.selected = NO;
        _temBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }

    _temBtn = button;

    ProductStandardMdoel *model = self.productModel.goods_standards[btnTag];

    if ([self.delegate respondsToSelector:@selector(chooseDifferentSpec:)]) {
        [self.delegate chooseDifferentSpec:model.standardId];
    }
}

#pragma mark - 添加约束

- (void)remakeLineTopViewContraints {
    [self.lineTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void)remakeProductNameLabelContraints {
    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.lineTopView.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@45);
    }];
}

- (void)remakePriceMemberLabelContraints {
    [self.priceMemberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.productNameLabel.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@25);
    }];
}

/**
 *  多商户时无数量加减框约束
 *  要注意登录与未登录时不同
 */
- (void)addViewConstraintsWithSeveralStore{

    [self remakeLineTopViewContraints];
    [self remakeProductNameLabelContraints];
    [self remakePriceMemberLabelContraints];
    
    UIView *priceSeperator = [[UIView alloc] init];
    [self addSubview:priceSeperator];
    priceSeperator.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    [priceSeperator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceMemberLabel.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
    
    //标记最下面的促销标识
    UIView *bottomPromotionView = nil;
    
    ProductSpecificationModel *firstModel = [self.productModel.goods_stores firstObject];
    NSString *firstPromotionInfo = nil;
    if (firstModel.goodsPromotions.count > 0) {
        firstPromotionInfo = firstModel.goodsPromotions[@"rule"];
    }
    
    UIView *firstPromotionView = [self setupPromotionStoreViewWithStoreName:firstModel.company_name promotionInfo:firstPromotionInfo showingTip:YES];
    //促销信息不为空
    if (firstPromotionInfo) {
        [self addSubview:firstPromotionView];
        
        [firstPromotionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(priceSeperator.mas_bottom);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(@28);
        }];
        
        //标记为最下面的促销 view
        bottomPromotionView = firstPromotionView;
    }
    
    ProductSpecificationModel *secondModel = self.productModel.goods_stores[1];
    NSString *secondPromotionInfo = nil;
    if (secondModel.goodsPromotions.count > 0) {
        secondPromotionInfo = secondModel.goodsPromotions[@"rule"];
    }
    
    UIView *secondPromotionView = nil;
    
    if (secondPromotionInfo) {
        
        if (bottomPromotionView) {
            secondPromotionView = [self setupPromotionStoreViewWithStoreName:secondModel.company_name promotionInfo:secondPromotionInfo showingTip:NO];
            
            [self addSubview:secondPromotionView];
            
            [secondPromotionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left);
                make.top.mas_equalTo(firstPromotionView.mas_bottom);
                make.right.mas_equalTo(self.mas_right);
                make.height.mas_equalTo(@28);
            }];
            
        } else {
            secondPromotionView = [self setupPromotionStoreViewWithStoreName:secondModel.company_name promotionInfo:secondPromotionInfo showingTip:YES];
            [self addSubview:secondPromotionView];
            
            [secondPromotionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left);
                make.top.mas_equalTo(priceSeperator.mas_bottom);
                make.right.mas_equalTo(self.mas_right);
                make.height.mas_equalTo(@28);
            }];
        }
        bottomPromotionView = secondPromotionView;
    }
    
    //需要判断是否有促销 view，未登录时没有,隐藏一条分割线
    if (!bottomPromotionView) {
        bottomPromotionView = priceSeperator;
        bottomPromotionView.hidden = YES;
    }

    //规格
    if (self.productModel.goods_standards.count > 1) {
    [self.standardView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(bottomPromotionView.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);

        if (self.productModel.goods_standards.count%2 == 0) {
            make.height.mas_equalTo((self.productModel.goods_standards.count/2)*40);
        } else {
            make.height.mas_equalTo((self.productModel.goods_standards.count/2+1)*40);
        }
    }];
    }

    [self.lineView2 mas_remakeConstraints:^(MASConstraintMaker *make) {

        if (self.productModel.goods_standards.count > 1) {
            make.top.mas_equalTo(self.standardView.mas_bottom).offset(spacing);
        } else {
            make.top.mas_equalTo(bottomPromotionView.mas_bottom).offset(spacing);
        }

        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@15);
    }];
    
    [self.stockName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.lineView2.mas_bottom).offset(spacing);
        make.width.mas_equalTo(halfW);
        make.height.mas_equalTo(@15);
    }];

    [self.salesNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView2.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.width.mas_equalTo(halfW);
        make.height.mas_equalTo(@15);
    }];
    
    if (_productModel.unit_title && _productModel.unit_title.length > 0) {
        self.unitLabel.hidden = NO;
        
        // 品牌
        [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.stockName.mas_bottom).offset(spacing);
            make.right.mas_equalTo(self.mas_right).offset(-spacing);
            make.left.mas_equalTo(self.mas_left).offset(spacing);
            make.height.mas_equalTo(@15);
        }];
        
        // 分类
        [self.brandLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.unitLabel.mas_bottom).offset(spacing);
            make.right.mas_equalTo(self.mas_right).offset(-spacing);
            make.left.mas_equalTo(self.mas_left).offset(spacing);
            make.height.mas_equalTo(@15);
        }];
    } else {
        self.unitLabel.hidden = YES;
        // 分类
        [self.brandLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.stockName.mas_bottom).offset(spacing);
            make.right.mas_equalTo(self.mas_right).offset(-spacing);
            make.left.mas_equalTo(self.mas_left).offset(spacing);
            make.height.mas_equalTo(@15);
        }];
    }
    
    // car
    [self.carLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.brandLabel.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.height.mas_equalTo(@0.8);
    }];
    
    [self.carLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.carLine.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.height.mas_equalTo(@50);
    }];
    
    [self.carImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.carLbl.mas_centerY);
        make.width.mas_equalTo(@15);
        make.height.mas_equalTo(@15);
    }];
    
    [self.lineView3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.carLbl.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@15);
    }];
}

/**
 *  只有一个商户时显示数量加减框的约束
 */
- (void)addViewConstraintsOnlyOneStore {

    [self remakeLineTopViewContraints];
    [self remakeProductNameLabelContraints];
    [self remakePriceMemberLabelContraints];

    ProductSpecificationModel *model = [self.productModel.goods_stores firstObject];
    NSString *promotionInfo = nil;
    if (model.goodsPromotions.count > 0) {
        promotionInfo = model.goodsPromotions[@"rule"];
    }
    
    UIView *underPriceView = self.priceMemberLabel;
    //有促销
    if (promotionInfo && promotionInfo.length > 0) {
        UIView *priceSeperator = [[UIView alloc] init];
        [self addSubview:priceSeperator];
        priceSeperator.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
        [priceSeperator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.priceMemberLabel.mas_bottom).offset(spacing);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.height.mas_equalTo(@0.5);
        }];
        
        UIView *promotionView = [self setupPromotionStoreViewWithStoreName:model.company_name promotionInfo:promotionInfo showingTip:YES];
        [self addSubview:promotionView];
        
        [promotionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(priceSeperator.mas_bottom);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(@28);
        }];
        //有促销信息时改变价格底部 view 标识
        underPriceView = promotionView;
    }

    if (self.productModel.goods_standards.count > 1) {
        
        [self.standardView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(underPriceView.mas_bottom).offset(20);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);

            if (self.productModel.goods_standards.count%2 == 0) {
                make.height.mas_equalTo((self.productModel.goods_standards.count/2)*40);
            } else {
                make.height.mas_equalTo((self.productModel.goods_standards.count/2+1)*40);
            }
        }];
    }

    //数量上部之间分割线
    UIView *promotionSeperator1 = [[UIView alloc] init];
    [self addSubview:promotionSeperator1];
    promotionSeperator1.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    [promotionSeperator1 mas_remakeConstraints:^(MASConstraintMaker *make) {

        if (self.productModel.goods_standards.count > 1) {
            make.top.mas_equalTo(self.standardView.mas_bottom).offset(0);
            make.height.mas_equalTo(@0.5);
        } else {
            make.top.mas_equalTo(underPriceView.mas_bottom).offset(20);
            make.height.mas_equalTo(@0.5);
        }

        make.right.mas_equalTo(self.mas_right).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
    }];

    [self.countsTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@80);
        make.top.mas_equalTo(promotionSeperator1.mas_bottom).offset(spacing);
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.height.mas_equalTo(@28);
    }];
    
    [self.stepper mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@110);
        make.top.mas_equalTo(promotionSeperator1.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@28);
    }];
    
    [self.lineView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.stepper.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@15);
    }];
    
    [self.stockName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.lineView2.mas_bottom).offset(spacing);
        make.width.mas_equalTo(halfW);
        make.height.mas_equalTo(@15);
    }];
    
    [self.salesNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView2.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.width.mas_equalTo(halfW);
        make.height.mas_equalTo(@15);
    }];

    //判断单位是否存在
    if (self.productModel.unit_title && self.productModel.unit_title.length > 0) {
        self.unitLabel.hidden = NO;

        // 单位
        [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.stockName.mas_bottom).offset(spacing);
            make.right.mas_equalTo(self.mas_right).offset(-spacing);
            make.left.mas_equalTo(self.mas_left).offset(spacing);
            make.height.mas_equalTo(@15);
        }];
        
        // 品牌
        [self.brandLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.unitLabel.mas_bottom).offset(spacing);
            make.right.mas_equalTo(self.mas_right).offset(-spacing);
            make.left.mas_equalTo(self.mas_left).offset(spacing);
            make.height.mas_equalTo(@15);
        }];
        
    } else {
        self.unitLabel.hidden = YES;
        // 品牌
        [self.brandLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.stockName.mas_bottom).offset(spacing);
            make.right.mas_equalTo(self.mas_right).offset(-spacing);
            make.left.mas_equalTo(self.mas_left).offset(spacing);
            make.height.mas_equalTo(@15);
        }];
    }

    // car
    [self.carLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.brandLabel.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.height.mas_equalTo(@0.8);
    }];
    
    [self.carLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.carLine.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.height.mas_equalTo(@50);
    }];
    
    
    [self.carImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.carLbl.mas_centerY);
        make.width.mas_equalTo(@15);
        make.height.mas_equalTo(@15);
    }];
    
    [self.lineView3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.carLbl.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@15);
    }];

}

- (void)clickedCarTypeBtn:(UIButton *)btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(productNameViewClickedCloseBtn:productModel:)]){
        [self.delegate productNameViewClickedCloseBtn:btn productModel:self.productModel];
    }
}

#pragma mark - setter
- (void) setProductModel:(ProductModel *)productModel {

    _productModel = productModel;
    
    self.productNameLabel.text = productModel.title;
    self.priceMemberLabel.text = [[UserDefaultsUtils getUserId] integerValue] ? [NSString stringWithFormat:@"会员价：¥ %@",productModel.good_price] : @"会员价：会员可见";

    //规格
    /**
     *  1.未登录状态下不显示（接口也没有返回）。
     *  2.要判断如果goods_standards个数大于1才显示，如果为1，就隐藏，但默认选中。
     */
    [self layoutStandardBtn:productModel.goods_standards];

    [self setLbl:self.stockName text:[NSString stringWithFormat:@"库存：%@",productModel.sku] boldString:productModel.sku];
    [self setLbl:self.salesNameLabel text:[NSString stringWithFormat:@"销量：%@",productModel.sales_volumn] boldString:productModel.sales_volumn];
    [self setLbl:self.unitLabel text:[NSString stringWithFormat:@"单位：%@",productModel.unit_title] boldString:productModel.unit_title];
    [self setLbl:self.brandLabel text:[NSString stringWithFormat:@"品牌：%@",productModel.brand_title] boldString:productModel.brand_title];
    
    // 没在卖商户
    if (productModel.goods_stores.count == 0) {
        self.salesNameLabel.hidden = YES;
        [self setLbl:self.stockName text:[NSString stringWithFormat:@"库存：%@",@"暂无库存"] boldString:@"暂无库存"];
        self.priceMemberLabel.text = @"暂无库存";
    }
    
    // 只有一个商户时显示数量选择
    if (self.productModel.goods_stores.count <= 1) {
        [self addViewConstraintsOnlyOneStore];
        self.countsTextLabel.hidden = NO;
        self.stepper.hidden = NO;
        self.stepper.maxValue = [productModel.sku integerValue];
    } else {
        [self addViewConstraintsWithSeveralStore];
    }
}

#pragma mark - getter
- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    [self addSubview:line];
    return line;
}


- (UIView *)getBigLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    line.layer.borderColor = [UIColor colorWithWhite:0.827 alpha:1.000].CGColor;
    line.layer.borderWidth = 0.5;
    [self addSubview:line];
    return line;
}

- (UIImageView *)carImg {
    if (!_carImg) {
        _carImg = [[UIImageView alloc]init];
        _carImg.contentMode = UIViewContentModeScaleAspectFit;
        _carImg.image = [UIImage imageNamed:@"C_list_arrow_1"];
    }
    return _carImg;
}

- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [[UILabel alloc] init];
        _productNameLabel.numberOfLines = 2;
        _productNameLabel.textColor = [UIColor colorWithWhite:0.165 alpha:1.000];
        _productNameLabel.font = [UIFont systemFontOfSize:18.0];
    }
    return _productNameLabel;
}

- (UILabel *)priceMemberLabel {
    if (!_priceMemberLabel) {
        _priceMemberLabel = [[UILabel alloc] init];
        _priceMemberLabel.textColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
        _priceMemberLabel.font = [UIFont systemFontOfSize:23.0];
    }
    return _priceMemberLabel;
}

- (UILabel *)getCommonLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0.361f green:0.384f blue:0.424f alpha:1.00f];
    return label;
}

#pragma mark - private method
- (void)layoutStandardViews {
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.standardView.mas_left).offset(0);
        make.top.equalTo(self.standardView.mas_top).offset(0);
        make.right.equalTo(self.standardView.mas_right).offset(0);
        make.height.mas_equalTo(0.5);
    }];

    [self.tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.standardView.mas_top).offset(10);
        make.left.equalTo(self.standardView.mas_left).offset(10);
    }];
}

- (void)layoutStandardBtn:(NSArray *)standardModels {

    //规格
    /**
     *  1.未登录状态下不显示（接口也没有返回）。
     *  2.要判断如果goods_standards个数大于1才显示，如果为1，就隐藏，但默认选中。
     */

    CGFloat cellWidth = self.frame.size.width;
    //距左边距
    CGFloat marginLeft = 100;
    //x偏移量
    CGFloat xOffset = marginLeft;
    //y偏移量
    CGFloat yOffset = 7;
    //下一个x偏移量
    CGFloat xNextOffset = marginLeft;
    //item之间的间隔
    CGFloat spacing = 20;
    //item宽度
    CGFloat itemWidth = (cellWidth-marginLeft-60)/2;//90

    //先移除按钮
    for (UIView *view in self.standardView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }

    if (standardModels.count <= 1) {

        self.standardView.hidden = YES;
    } else {
        self.tipLbl.text = @"选择规格：";

        for (NSInteger i = 0; i < standardModels.count; i++) {

            ProductStandardMdoel *model = standardModels[i];

            UIButton *specBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [specBtn setTitle:model.title forState:UIControlStateNormal];
            [specBtn setTitleColor:[UIColor colorWithRed:0.361f green:0.384f blue:0.424f alpha:1.00f] forState:UIControlStateNormal];
            specBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            specBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            specBtn.layer.borderWidth = 1.0;
            specBtn.layer.cornerRadius = 4.0;
            specBtn.tag = 101 + i;

            if (model.isSelected) {
                specBtn.layer.borderColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000].CGColor;
                _temBtn = specBtn;
            } else {
                specBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }

            [specBtn addTarget:self action:@selector(clickSpecBtn:) forControlEvents:UIControlEventTouchUpInside];

            //根据item宽度一行排列多少个
            xNextOffset += itemWidth + spacing;

            if (xNextOffset > cellWidth) {

                xOffset = marginLeft;

                xNextOffset = itemWidth + marginLeft + spacing;

                yOffset += 26 + 14;

            } else {
                
                xOffset = xNextOffset - (itemWidth + spacing);
            }
            
            specBtn.frame = CGRectMake(xOffset, yOffset, itemWidth, 26);
            
            [self.standardView addSubview:specBtn];
            
        }
    }
}

#pragma mark - getters and setters
- (UIView *)standardView {
    if (!_standardView) {

        _standardView = [[UIView alloc] init];
        _standardView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return  _standardView;
}

- (UILabel *)tipLbl {
    if (!_tipLbl) {
        _tipLbl = [[UILabel alloc] init];
//        _tipLbl.text = @"选择规格：";
        _tipLbl.textColor = [UIColor colorWithRed:0.361f green:0.384f blue:0.424f alpha:1.00f];
        _tipLbl.font = [UIFont systemFontOfSize:16.0f];
    }
    return _tipLbl;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    }
    return _topLine;
}

@end
