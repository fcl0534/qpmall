//
//  CustomKeyboard.m
//  SkfSwiftCammer
//
//  Created by 张帅 on 16/6/20.
//  Copyright © 2016年 Kevin Sun. All rights reserved.
//

#import "CustomKeyboard.h"

#define kFont [UIFont systemFontOfSize:14.0]
#define kChar @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",\
                @"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",\
                @"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",\
                @"Z",@"X",@"C",@"V",@"B",@"N",@"M"]

@implementation CustomKeyboard

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CustomKeyboard" owner:self options:nil] lastObject];
    }

    [self loadCharactersWithArray:kChar];

    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)loadCharactersWithArray:(NSArray *)paras
{
    NSInteger i = 0;
    for (UIButton *b in self.characterKeys) {
        [b setTitle:[paras objectAtIndex:i] forState:UIControlStateNormal];
        b.titleLabel.font = kFont;

        i++;
    }
}

- (void)characterPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *character = [NSString stringWithString:button.titleLabel.text];

    if ([self.delegate respondsToSelector:@selector(characterKeyClick:)]) {
        [self.delegate characterKeyClick:character];
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

@end
