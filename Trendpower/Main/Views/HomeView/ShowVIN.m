//
//  ShowVIN.m
//  Trendpower
//
//  Created by 张帅 on 16/6/27.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "ShowVIN.h"

@implementation ShowVIN
{
    UIButton *_temBtn;
}

- (void)awakeFromNib
{
    //设置圆角
    [self makeCorner];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBtn:) name:@"showVIN" object:nil];
}

- (void)makeCorner
{
    NSInteger i = 0;
    for (UIButton *b in self.characterKeys) {

        b.titleLabel.font = [UIFont systemFontOfSize:14.0];

        b.layer.cornerRadius = 4.0;

        b.tag = i + 1;

        i++;
    }
}

- (void)characterPressed:(id)sender {

    UIButton *button = (UIButton *)sender;

//    for (UIButton *btn in _arr){
//        if (btn.tag ==button.tag) {
//
//            button.layer.borderWidth = 0.0;
//        } else {
//
//            button.layer.borderWidth = 1.0;
//            button.layer.borderColor = [UIColor greenColor].CGColor;
//        }
//    }

    //设置
    if(_temBtn == button) {
        //不做处理

    } else {

        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIColor greenColor].CGColor;

        _temBtn.layer.borderColor = 0;
    }
    
    _temBtn = button;

    if ([self.delegate respondsToSelector:@selector(changeBtn:allBtn:isSelected:)]) {
        [self.delegate changeBtn:_temBtn allBtn:[self.characterKeys mutableCopy] isSelected:YES];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    CGPoint location = [[touches anyObject] locationInView:self];

    for (UIButton *b in self.characterKeys) {

        if(CGRectContainsPoint(b.frame, location))
        {
            [self characterPressed:b];
        }
    }
}

- (void)getBtn:(NSNotification *)noti
{
    _temBtn = (UIButton *)noti.object;
}

- (void)setVinStrs:(NSArray *)vinStrs
{
    if (vinStrs.count == 17) {

        for (NSInteger i = 0; i < vinStrs.count; i++) {

            [[_characterKeys objectAtIndex:i] setTitle:[vinStrs objectAtIndex:i] forState:UIControlStateNormal];
        }
    }
    else if (vinStrs.count > 17) {

        for (NSInteger i = 0; i < 17; i ++) {

            [[_characterKeys objectAtIndex:i] setTitle:[vinStrs objectAtIndex:i] forState:UIControlStateNormal];
        }
    }
    else if (vinStrs.count < 17) {

        NSInteger i;

        for (i = 0; i < vinStrs.count; i ++) {

            [[_characterKeys objectAtIndex:i] setTitle:[vinStrs objectAtIndex:i] forState:UIControlStateNormal];
        }

        for (NSInteger j = i; j < 17; j++) {

            [[_characterKeys objectAtIndex:j] setTitle:@"0" forState:UIControlStateNormal];
        }
    }
}

@end
