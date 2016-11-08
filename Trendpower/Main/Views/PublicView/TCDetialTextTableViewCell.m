//
//  TCDetialTextTableViewCell.m
//  ZZBMall
//
//  Created by trendpower on 15/12/2.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import "TCDetialTextTableViewCell.h"

#import <Masonry.h>


@interface TCDetialTextTableViewCell()

@property (nonatomic, weak) UIImageView * rightView;
@property (nonatomic, weak) UILabel * textLbl;
@property (nonatomic, weak) UILabel * detailTextLbl;

@end


@implementation TCDetialTextTableViewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TCDetialTextTableViewCell";
    TCDetialTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TCDetialTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        
        // 0. 白色背影
        self.backgroundColor = [UIColor whiteColor];
        
        // 1.
        self.textLbl = [self getLabel];
        self.textLbl.textColor = [UIColor colorWithRed:0.376f green:0.376f blue:0.376f alpha:1.00f];
        self.textLbl.font = [UIFont boldSystemFontOfSize:17.0];
        
        // 2.
        self.detailTextLbl = [self getLabel];
        self.detailTextLbl.textAlignment = NSTextAlignmentRight;
        self.detailTextLbl.textColor = [UIColor colorWithRed:1.000 green:0.361 blue:0.549 alpha:1.000];
        self.detailTextLbl.font = [UIFont systemFontOfSize:13.0];
        
        // 3.
        UIImageView *rightView = [[UIImageView alloc]init];
        rightView.image = [UIImage imageNamed:@"addressView_arrow"];
        [self addSubview:rightView];
        self.rightView = rightView;
        
    }
    
    return self;
}

- (UILabel *) getLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0.396f green:0.408f blue:0.412f alpha:1.00f];
    [self addSubview:label];
    return label;
}


#pragma mark - 赋值
- (void)setText:(NSString *)text{
    self.textLbl.text = text;
    [self addViewConstraints];
}

- (void)setDetailText:(NSString *)detailText{
    self.detailTextLbl.text = detailText;
    [self addViewConstraints];
}


#pragma mark - 添加约束 【每次重新更新】
-(void) addViewConstraints{
    
    float spacing = 10;
    
    CGSize textSize = [self sizeWithText:self.textLbl.text font:self.textLbl.font maxSize:CGSizeMake(self.frame.size.width *1/3, MAXFLOAT)];
    
    // 1.
    [self.textLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(textSize.width);
    }];
    
    //CGSize detailSize = [self sizeWithText:self.detailTextLbl.text font:self.detailTextLbl.font maxSize:CGSizeMake(self.frame.size.width -textSize.width, MAXFLOAT)];
    // 2.
    [self.detailTextLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightView.mas_left).offset(-spacing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.textLbl.mas_right).offset(spacing);
    }];
    
    
    // 3.
    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-8);
        make.centerY.mas_equalTo(self.mas_centerY).offset(0);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo(@10);
    }];
    
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


@end
