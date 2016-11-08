//
//  MeOrderTableViewCell.m
//  EcoDuo
//
//  Created by trendpower on 15/11/9.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import "MeOrderTableViewCell.h"

#import <Masonry.h> //autoLayout
#import "LineView.h"


@interface MeOrderTableViewCell()

@property (nonatomic, weak) UIImageView * rightImageView;
@property (nonatomic, weak) LineView * midLine;

@property (nonatomic, weak) MeOrderButton * topButton;

@property (nonatomic, weak) MeOrderButton * button0;
@property (nonatomic, weak) MeOrderButton * button1;
@property (nonatomic, weak) MeOrderButton * button2;
@property (nonatomic, weak) MeOrderButton * button3;
@property (nonatomic, weak) MeOrderButton * button4;

@end


@implementation MeOrderTableViewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MeOrderTableViewCell";
    MeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MeOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    //self.leftImageView = [self getImageView];
    
    self.nameLbl = [self getLabel];
    self.nameLbl.font = [UIFont systemFontOfSize:15.0];
    self.nameLbl.textColor = [UIColor colorWithWhite:0.114 alpha:1.000];
    
    self.detailLbl = [self getLabel];
    self.detailLbl.font = [UIFont systemFontOfSize:13.0f];
    self.detailLbl.textAlignment = NSTextAlignmentRight;
    
    
    self.rightImageView = [self getImageView];
    self.rightImageView.image = [UIImage imageNamed:@"arrow-right"];
    
    self.midLine = [self getLineView];
    
    /**
     * type= 0 全部订单
     * type= 1 待付款订单 11
     * type= 2 待发货订单 20
     * type= 3 已发货订单 30
     * type= 4 已收货订单 40
     * type= 5 退换货订单 31
     */
    NSArray * orderName = [NSArray arrayWithObjects:@"",@"待付款",@"待发货",@"待收货", nil];
    
    // 全部订单按钮
    self.topButton = [self getTextUpDownButtonWithTag:0 title:orderName[0] image:nil];
    
    self.button0 = [self getTextUpDownButtonWithTag:1 title:orderName[1] image:[UIImage imageNamed:@"my_home_packge"]];
    self.button1 = [self getTextUpDownButtonWithTag:2 title:orderName[2] image:[UIImage imageNamed:@"my_home_daifahuo"]];
    self.button2 = [self getTextUpDownButtonWithTag:3 title:orderName[3] image:[UIImage imageNamed:@"my_home_daishouhuo"]];
    
    self.badegView0 = [self getJSBadgeView:self.button0];
    self.badegView1 = [self getJSBadgeView:self.button1];
    self.badegView2 = [self getJSBadgeView:self.button2];
    
    [self addViewConstraints];
}


- (JSBadgeView *) getJSBadgeView:(MeOrderButton *)btn{
    JSBadgeView * jsb = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
    //在父控件（parentView）上显示，显示的位置TopRight
    CGFloat W =  [UIScreen mainScreen].bounds.size.width /3 /2;
    jsb.badgeTextFont = [UIFont systemFontOfSize:10.0];
    jsb.badgePositionAdjustment = CGPointMake(-W +10, 8);  //如果显示的位置不对，可以自己调整，超爽啊！
    jsb.badgeBackgroundColor = [UIColor colorWithRed:0.962 green:0.167 blue:0.069 alpha:1.000];
    //    jsb.badgeStrokeColor = [UIColor colorWithRed:1.000 green:0.361 blue:0.549 alpha:1.000];
    //    jsb.badgeStrokeWidth = 1;
    jsb.badgeTextColor = [UIColor colorWithWhite:0.937 alpha:1.000];
    return jsb;
}

- (MeOrderButton *) getTextUpDownButtonWithTag:(NSInteger)tag title:(NSString *)title image:(UIImage *)image{
    MeOrderButton * btn = [[MeOrderButton alloc]init];
    btn.tag = tag;
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_black"] forState:UIControlStateHighlighted];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedTextBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    [self.contentView addSubview:btn];
    return btn;
}

- (LineView *)getLineView{
    LineView * line = [[LineView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.816 alpha:1.000];
    [self.contentView addSubview:line];
    return line;
}

- (UIImageView *) getImageView{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];
    return imageView;
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0.627 green:0.631 blue:0.639 alpha:1.000];
    [self.contentView addSubview:label];
    return label;
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


- (void) addViewConstraints{
    
    CGFloat space = 10;
    CGFloat height = 48;
    
//    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo((height-22)/2);
//        make.left.mas_equalTo(self.mas_left).offset(space);
//        make.width.mas_equalTo(@22);
//        make.height.mas_equalTo(@22);
//    }];
    
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(space);
        make.width.mas_equalTo(@80);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(@48);
    }];
    
    
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLbl.mas_right).offset(space);
        make.right.mas_equalTo(self.rightImageView.mas_left).offset(-5);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(@48);
    }];
    
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((height-16)/2);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(@13);
        make.height.mas_equalTo(@13);
    }];
    
    [self.midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLbl.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(@0.3);
    }];
    
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.midLine.mas_bottom).offset(0);
    }];
    
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    uint counts = 3;
    
    [self.button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.midLine.mas_bottom).offset(0);
        make.width.mas_equalTo(@(W/counts));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
    
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.button0.mas_right).offset(0);
        make.top.mas_equalTo(self.midLine.mas_bottom).offset(0);
        make.width.mas_equalTo(@(W/counts));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
    
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.button1.mas_right).offset(0);
        make.top.mas_equalTo(self.midLine.mas_bottom).offset(0);
        make.width.mas_equalTo(@(W/counts));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
    
//    [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.button2.mas_right).offset(0);
//        make.top.mas_equalTo(self.midLine.mas_bottom).offset(5);
//        make.width.mas_equalTo(@(W/counts));
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
//    }];
//    
//    [self.button4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.button3.mas_right).offset(0);
//        make.top.mas_equalTo(self.midLine.mas_bottom).offset(5);
//        make.width.mas_equalTo(@(W/counts));
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
//    }];
    
}

#pragma - mark 代理
- (void)clickedTextBtn:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(meOrderCellClickedBtn:withIndexPath:)]){
        [self.delegate meOrderCellClickedBtn:btn withIndexPath:self.indexPath];
    }
}

@end
