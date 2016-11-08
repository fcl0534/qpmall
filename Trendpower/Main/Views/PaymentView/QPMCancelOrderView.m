//
//  QPMCancelOrderView.m
//  Trendpower
//
//  Created by 张帅 on 16/7/18.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "QPMCancelOrderView.h"

@interface QPMCancelOrderView ()
{
    UIButton *_tempBtn;
}

@property (weak, nonatomic) IBOutlet UIScrollView *showReason;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vWidth;

@property (weak, nonatomic) IBOutlet UILabel *tipView;

@end

@implementation QPMCancelOrderView

- (void)awakeFromNib {
    self.hHeight.constant = 0.5;

    self.vWidth.constant = 0.5;
}

#pragma mark - event response
- (void)clickChooseReason:(UIButton *)button {
    //设置
    if(_tempBtn == button) {
        //不做处理

    } else {
        button.selected = YES;

        _tempBtn.selected = NO;
    }

    _tempBtn = button;
}

- (IBAction)clickCancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancel)]) {
        [self.delegate cancel];
    }
}

- (IBAction)clickSubmit:(id)sender {

    if (_tempBtn.isSelected) {
        if ([self.delegate respondsToSelector:@selector(submit:)]) {

            NSDictionary *params = @{@"reason":_tempBtn.titleLabel.text};

            [self.delegate submit:params];
        }
    } else {
        //没选择时提示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //
            self.tipView.hidden = NO;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tipView.hidden = YES;
            });
        });
    }
}


#pragma mark - setter
- (void)setReasons:(NSArray *)reasons {
    CGFloat yOffset = 0;

    for (NSInteger i=0; i<reasons.count; i++) {
        UIButton *chooseReason = [self getBtnTitle:reasons[i] image:[UIImage imageNamed:@"agree_protocol_no"] select:[UIImage imageNamed:@"agree_protocol_yes"] frame:CGRectZero];

        chooseReason.frame = CGRectMake(0, yOffset, self.showReason.frame.size.width, 30);
        [chooseReason addTarget:self action:@selector(clickChooseReason:) forControlEvents:UIControlEventTouchUpInside];

        yOffset += 30;
    }

    self.showReason.contentSize = CGSizeMake(self.frame.size.width-75, 30*reasons.count);
}

- (UIButton *)getBtnTitle:(NSString *)title image:(UIImage *)image select:(UIImage *)select frame:(CGRect)frame {
    UIButton * btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:select forState:UIControlStateSelected];
    [btn setTitleColor: [UIColor colorWithWhite:0.635 alpha:1.000] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.5f]];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.showReason addSubview:btn];
    return btn;
}

@end
