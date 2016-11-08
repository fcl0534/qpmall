//
//  PaymentOrderCell.m
//  Trendpower
//
//  Created by trendpower on 15/5/15.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//



#import "PaymentOrderCell.h"
#import "OrderGoodsModel.h"
#import "WebImageUtil.h"
#import "TPImageTools.h"

@interface PaymentOrderCell()

/** 订单Id */
@property (nonatomic, weak) UILabel * orderIDLabel;
/** 订单时间 */
@property (nonatomic, weak) UILabel * orderTimeLabel;
/** 订单状态 */
@property (nonatomic, weak) UILabel * orderStateLabel;


/** 显示更多商品箭头 按钮 */
@property (nonatomic, weak) UIButton * arrowButton;

/** LineView */
@property (nonatomic, weak) UIView * orderLine;
/** 商品列表 */
@property (nonatomic, weak) UIView * goodsListView;
///**
// *  商品总价
// */
//@property (nonatomic, weak) UILabel * goodsTotalNameLabel;
///**
// *  商品总价
// */
//@property (nonatomic, weak) UILabel * goodsTotalLabel;
///**
// *  LineView
// */
//@property (nonatomic, weak) UIView * priceLine;
///**
// *  运费
// */
//@property (nonatomic, weak) UILabel * shipNameLabel;
///**
// *  运费
// */
//@property (nonatomic, weak) UILabel * shipCostLabel;
///**
// *  LineView
// */
//@property (nonatomic, weak) UIView * shipLine;
/**
 *  总金额
 */
@property (nonatomic, weak) UILabel * totalNameLabel;
/**
 *  总金额
 */
@property (nonatomic, weak) UILabel * totalPriceLabel;


/**
 *  取消按钮
 */
@property (nonatomic, weak) UIButton * cancelButton;

/**
 *  支付按钮
 */
@property (nonatomic, weak) UIButton * payButton;

/** 确认收货按钮 */
@property (nonatomic, strong) UIButton *confirmBtn;

/**
 *  LineView
 */
@property (nonatomic, weak) UIView * bottomLine;

@property (nonatomic, strong) UILabel *pointTipLbl;


@end

@implementation PaymentOrderCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PaymentOrderCell";
    PaymentOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PaymentOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        //初始全部cell
        [self setBaseView];
    }
    return self;
}


- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithWhite:0.469 alpha:1.000];
    [self addSubview:label];
    return label;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.882 alpha:1.000];
    [self addSubview:line];
     return line;
}

- (void) setBaseView{
    // 1.
    self.orderIDLabel = [self getLabel];
    
    // 2.
    self.orderTimeLabel = [self getLabel];
    
    //状态
    self.orderStateLabel = [self getLabel];
    self.orderStateLabel.textAlignment = NSTextAlignmentRight;
    self.orderStateLabel.font = [UIFont boldSystemFontOfSize:14.5f];
    self.orderStateLabel.textColor = [UIColor colorWithRed:0.937 green:0.286 blue:0.286 alpha:1.000];
    
    // 3.更多箭头
    UIButton * arrowButton = [[UIButton alloc]init];
    [self addSubview:arrowButton];
    self.arrowButton = arrowButton;
    [self.arrowButton setBackgroundImage:[UIImage imageNamed:@"arrow_downTap_normal"] forState:UIControlStateNormal];
    [self.arrowButton setBackgroundImage:[UIImage imageNamed:@"arrow_upTap_select"] forState:UIControlStateSelected];
    [self.arrowButton addTarget:self action:@selector(clickedArrowBtn:) forControlEvents:UIControlEventTouchDown];
    
    
    // 3.
    self.orderLine = [self getLineView];
    
//    // 4.商品列表
//    UIView * goodsListView = [[UIView alloc]init];
//    [self addSubview:goodsListView];
//    self.goodsListView = goodsListView;
//    
//    // 5.商品总价
//    self.goodsTotalNameLabel = [self getLabel];
//    self.goodsTotalNameLabel.text = @"商品合计";
//    
//    self.goodsTotalLabel = [self getLabel];
//    self.goodsTotalLabel.textAlignment = NSTextAlignmentRight;
//    self.goodsTotalLabel.textColor = [UIColor colorWithRed:0.949 green:0.141 blue:0.092 alpha:1.000];
//    
//    self.priceLine = [self getLineView];
//    
//    // 6.运费
//    self.shipNameLabel = [self getLabel];
//    self.shipNameLabel.text = @"配送方式：";
    
//    self.shipCostLabel = [self getLabel];
//    self.shipCostLabel.textAlignment = NSTextAlignmentRight;
//    self.shipCostLabel.textColor = [UIColor colorWithRed:0.937f green:0.286f blue:0.286f alpha:1.00f];
//    
//    self.shipLine = [self getLineView];
    
    // 7.
    self.totalNameLabel = [self getLabel];
    self.totalNameLabel.text = @"配送方式：";
    self.totalNameLabel.font = [UIFont systemFontOfSize:16.5];
    //自动缩放字体
    self.totalNameLabel.adjustsFontSizeToFitWidth = YES;
    self.totalNameLabel.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
    
    self.totalPriceLabel = [self getLabel];
    self.totalPriceLabel.textAlignment = NSTextAlignmentRight;
    self.totalPriceLabel.textColor = [UIColor colorWithRed:0.949 green:0.141 blue:0.092 alpha:1.000];
    self.totalPriceLabel.font = [UIFont systemFontOfSize:17.5];
    //自动缩放字体
    self.totalPriceLabel.adjustsFontSizeToFitWidth = YES;
    self.totalPriceLabel.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
    
    UIButton * cancelButton = [[UIButton alloc]init];
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:0.357 green:0.353 blue:0.353 alpha:1.000] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.cancelButton addTarget:self action:@selector(clickedCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * payButton = [[UIButton alloc]init];
    [self addSubview:payButton];
    self.payButton = payButton;
    self.payButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.payButton setBackgroundImage:[UIImage imageNamed:@"back_red"] forState:UIControlStateNormal];
    [self.payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(clickedPayBtn:) forControlEvents:UIControlEventTouchUpInside];

    //确认收货
    UIButton * confirmBtn = [[UIButton alloc]init];
    [self addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"back_red"] forState:UIControlStateNormal];
    [self.confirmBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(clickedConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];

    //积分兑换提示
    UILabel *pointTipLbl = [[UILabel alloc] init];
    [self addSubview:pointTipLbl];
    self.pointTipLbl = pointTipLbl;
    self.pointTipLbl.text = @"积分兑换";
    self.pointTipLbl.textColor = [UIColor colorWithRed:0.949 green:0.141 blue:0.092 alpha:1.000];
    self.pointTipLbl.font = [UIFont systemFontOfSize:17.5];
    
    self.bottomLine = [self getLineView];
    self.bottomLine.backgroundColor = [UIColor colorWithWhite:0.889 alpha:1.000];
    self.bottomLine.layer.borderColor = [UIColor colorWithWhite:0.663 alpha:1.000].CGColor;
    self.bottomLine.layer.borderWidth = 0.3;
}


- (void)setOrderModel:(OrderModel *)orderModel{

    _orderModel = orderModel;

    self.confirmBtn.hidden = YES;
    self.payButton.hidden = YES;
    self.cancelButton.hidden = YES;
    self.pointTipLbl.hidden = YES;

    // 1.先移除商品列表view
    [self.goodsListView removeFromSuperview];
    
    // 2..商品列表
    UIView * goodsListView = [[UIView alloc]init];
    [self addSubview:goodsListView];
    self.goodsListView = goodsListView;
    // 加一个手势来关闭
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGoodsList)];
    [self.goodsListView addGestureRecognizer:tap];
    
    // 3.
    self.orderIDLabel.text = [NSString stringWithFormat:@"订单编号  %@",orderModel.orderSn];
    
    //时间戳转时间的方法:
    long long int date1 = (long long int)[orderModel.orderTime intValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSString * dateStr = [formatter stringFromDate:date2];
    
    self.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间  %@",dateStr];

    /**
     *                       
     "express": {
     "agentId": "10",
     "distributionType": "0",
     "isFree": "1",
     "price": "0.00"
     },

     */
    
    if ([[orderModel.expressDic objectForKey:@"distributionType"] integerValue] == 0 ) {
        if ([[orderModel.expressDic objectForKey:@"isFree"] integerValue] == 1 ) {
            self.totalNameLabel.text = @"配送方式：普通(包配送)";
        }else{
             self.totalNameLabel.text = [NSString stringWithFormat:@"配送方式：普通(￥%@)",[orderModel.expressDic objectForKey:@"price"]];
        }
        
    }else if([[orderModel.expressDic objectForKey:@"distributionType"] integerValue] == 1 ) {
        if ([[orderModel.expressDic objectForKey:@"isFree"] integerValue] == 1 ) {
            self.totalNameLabel.text = @"配送方式：加急(包配送)";
        }else{
            self.totalNameLabel.text = [NSString stringWithFormat:@"配送方式：加急(￥%@)",[orderModel.expressDic objectForKey:@"price"]];
        }
    }

//    if (orderModel.isPointOrder) {
//
//
//    } else {

        [self setLbl:self.totalPriceLabel text:[NSString stringWithFormat:@"总计：¥%@",orderModel.orderAmount] boldString:@"总计："];
//    }

    //空为全部  10货到付款  11等待买家付款 20买家已付款，等待卖家发货  30卖家已发货   40交易成功  0交易已取消
    switch (orderModel.status) {
        case 6:
            self.orderStateLabel.text = @"已取消";
            break;
        case 1:
            self.orderStateLabel.text = @"待付款";
            break;
        case 2:
            self.orderStateLabel.text = @"待发货";
            break;
        case 3:
            self.orderStateLabel.text = @"待收货";
            break;
        case 7:
            self.orderStateLabel.text = @"已完成";
            break;
        case 4:
            self.orderStateLabel.text = @"已收货";
            break;
        case 5:
            self.orderStateLabel.text = @"已评论";
            break;
        case 8:
            self.orderStateLabel.text = @"已关闭";
            break;
        case 101:
            self.orderStateLabel.text = @"申请退款";
            break;
        case 102:
            self.orderStateLabel.text = @"已退款";
            break;
        case 103:
            self.orderStateLabel.text = @"拒绝退款";
            break;
        case 201:
            self.orderStateLabel.text = @"申请退货";
            break;
        case 202:
            self.orderStateLabel.text = @"已退货";
            break;
        case 203:
            self.orderStateLabel.text = @"拒绝退货";
            break;
        case 301:
            self.orderStateLabel.text = @"申请换货";
            break;
        case 302:
            self.orderStateLabel.text = @"已换货";
            break;
        case 303:
            self.orderStateLabel.text = @"拒绝换货";
            break;
        default:
            self.orderStateLabel.text = @" ";
            break;
    }
    
    // 4.
    for (int i = 0; i < orderModel.dataGoodsArray.count; i ++) {
        OrderGoodsModel *model = orderModel.dataGoodsArray[i];

        OrderGoodsListView * goodsView = [[OrderGoodsListView alloc]initWithFrame:CGRectMake(0, i * K_Cell_Goods_Height, [UIScreen mainScreen].bounds.size.width, K_Cell_Goods_Height)];
        goodsView.nameLabel.text = model.productName;
        [WebImageUtil setImageWithURL:model.productImageURL placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:goodsView.imagesView];

        if (orderModel.isPointOrder) {

            goodsView.priceMemberLabel.text = [NSString stringWithFormat:@"积分:%ld",(long)model.goodsPoint];
        } else {
            goodsView.priceMemberLabel.text = [NSString stringWithFormat:@"会员价:¥ %@",model.price];
        }

        goodsView.subTotalLabel.text = [NSString stringWithFormat:@"x%d",model.quantity];
        [self.goodsListView addSubview:goodsView];
        
        if (!self.isShowAllGoods) {
            self.arrowButton.selected = NO;
            break;
        }else{
            self.arrowButton.selected = YES;
        }
    }
    
    // 5.
    if(orderModel.dataGoodsArray.count>1){
        self.arrowButton.hidden = NO;
    }else{
        self.arrowButton.hidden = YES;
    }

    //增加约束
    [self addViewConstraints];
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
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.5] range:[attributedString.string rangeOfString:boldText]];
   [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.357 green:0.353 blue:0.353 alpha:1.000] range:[attributedString.string rangeOfString:boldText]];
    lbl.attributedText = attributedString;
}


/**
 *  添加约束【每次都会更新约束条件】
 */
-(void) addViewConstraints{
    
    float spacing = 10;
    
    // 0.
    NSNumber * goodsListHeight;
    if (self.isShowAllGoods) {
       goodsListHeight = [NSNumber numberWithInteger:self.orderModel.dataGoodsArray.count * K_Cell_Goods_Height];
    }else{
        goodsListHeight = self.orderModel.dataGoodsArray.count?[NSNumber numberWithInteger:K_Cell_Goods_Height]:@0;
    }
    
    // 1.
    [self.orderIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.height.mas_equalTo(@20);
    }];
    
    // 订单状态
    [self.orderStateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.height.mas_equalTo(@20);
    }];
    
    // 2.
    [self.orderTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.orderIDLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@20);
    }];
    
    // 2.
    [self.arrowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderIDLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@20);
    }];
    
    // 3.
    [self.orderLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.orderTimeLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(@(0.3));
    }];
    
    // 4.
    [self.goodsListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.orderTimeLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(goodsListHeight);
    }];
    
    
    // 7.
    [self.totalNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.goodsListView.mas_bottom).offset(15);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(@33);
    }];
    
    [self.totalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.totalNameLabel.mas_right).offset(spacing);
        make.top.mas_equalTo(self.goodsListView.mas_bottom).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(@33);
    }];
    
    
    // 11 等待买家付款 显示取消和支付按钮
    if (self.orderModel.status == 1) {

        self.payButton.hidden = NO;
        self.cancelButton.hidden = NO;

        if (self.orderModel.isPointOrder) {
            self.pointTipLbl.hidden = NO;

            [self.pointTipLbl mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.left.mas_equalTo(self.mas_left).offset(10);
                make.top.mas_equalTo(self.totalNameLabel.mas_bottom).offset(5);
                make.width.mas_equalTo(@100);
                make.height.mas_equalTo(@36);
            }];
        }
        
        [self.payButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.top.mas_equalTo(self.totalNameLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(@100);
            make.height.mas_equalTo(@36);
        }];
        
        [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.payButton.mas_left).offset(-10);
            make.top.mas_equalTo(self.totalNameLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(@100);
            make.height.mas_equalTo(@36);
        }];
        
        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.top.mas_equalTo(self.payButton.mas_bottom).offset(12);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];

    } else if (self.orderModel.status == 2) {
        //订单状态在未发货之前都可以取消订单

        self.cancelButton.hidden = NO;

        if (self.orderModel.isPointOrder) {
            self.pointTipLbl.hidden = NO;

            [self.pointTipLbl mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.left.mas_equalTo(self.mas_left).offset(10);
                make.top.mas_equalTo(self.totalNameLabel.mas_bottom).offset(5);
                make.width.mas_equalTo(@100);
                make.height.mas_equalTo(@36);
            }];
        }

        [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.top.mas_equalTo(self.totalNameLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(@100);
            make.height.mas_equalTo(@36);
        }];

        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.top.mas_equalTo(self.cancelButton.mas_bottom).offset(12);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];

    } else if (self.orderModel.status == 3) {
        //待收货
        self.confirmBtn.hidden = NO;

        [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.top.mas_equalTo(self.totalNameLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(@100);
            make.height.mas_equalTo(@36);
        }];

        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.top.mas_equalTo(self.confirmBtn.mas_bottom).offset(12);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];

    } else {

        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.top.mas_equalTo(self.totalNameLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];

    }
}

#pragma mark - 代理
- (void)tapGoodsList{
    // 1.
    if (self.orderModel.dataGoodsArray.count <2) {
        return;
    }
    
    // 2.
    //状态取反
    self.arrowButton.selected = !self.arrowButton.isSelected;
    // 3.
    if ([self.delegate respondsToSelector:@selector(paymentOrderCellClickedArrowBtn:indexPath:)]) {
        [self.delegate paymentOrderCellClickedArrowBtn:self.arrowButton indexPath:self.indexPath];
    }
}

- (void)clickedArrowBtn:(UIButton *)btn{
    //状态取反
    btn.selected = !btn.selected;
    
   if ([self.delegate respondsToSelector:@selector(paymentOrderCellClickedArrowBtn:indexPath:)]) {
        [self.delegate paymentOrderCellClickedArrowBtn:btn indexPath:self.indexPath];
    }
}

//取消订单
- (void)clickedCancelBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(paymentOrderCellClickedCancelBtn:indexPath:)]) {
        [self.delegate paymentOrderCellClickedCancelBtn:btn indexPath:self.indexPath];
    }
}

//支付
- (void)clickedPayBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(paymentOrderCellClickedPayBtn:indexPath:)]) {
        [self.delegate paymentOrderCellClickedPayBtn:btn indexPath:self.indexPath];
    }
}

//确认收货
- (void)clickedConfirmBtn:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(paymentOrderCellClickedConfirmBtn:indexPath:)]) {
        [self.delegate paymentOrderCellClickedConfirmBtn:btn indexPath:self.indexPath];
    }
}

@end
