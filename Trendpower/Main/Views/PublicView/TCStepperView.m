//
//  TCStepperView.m
//  ZZBMall
//
//  Created by trendpower on 15/8/11.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import "TCStepperView.h"

//view
#import <Masonry.h>

@interface TCStepperView()<UITextFieldDelegate>

/** 增加按钮 */
@property(nonatomic,strong) UIButton *addBtn;
/** 减少按钮 */
@property(nonatomic,strong) UIButton *subBtn;
/** 数据框 */
@property(nonatomic,strong) UITextField *countField;

@end

@implementation TCStepperView

-(void)setCurrentValue:(NSInteger)currentValue
{
    _currentValue = currentValue;
    self.countField.text = [NSString stringWithFormat:@"%zi",_currentValue];
    if (currentValue == _minValue) {
        self.subBtn.enabled = NO;
    }else{
        self.subBtn.enabled = YES;
    }
    
    if (currentValue == _maxValue) {
        self.addBtn.enabled = NO;
    }else{
        self.addBtn.enabled = YES;
    }
}

-(void)setMinValue:(NSInteger)minValue
{
    _minValue = minValue;
    if (minValue == _currentValue) {
        self.subBtn.enabled = NO;
    }else{
        self.subBtn.enabled = YES;
    }
}

-(void)setMaxValue:(NSInteger)maxValue
{
    _maxValue = maxValue;
    if (maxValue <= _currentValue) {
        _currentValue = maxValue;
        self.countField.text = [NSString stringWithFormat:@"%ld",maxValue];
        self.addBtn.enabled = NO;
    }else{
        self.addBtn.enabled = YES;
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initView:frame];
        
        //初始化默认值
        self.currentValue=1;
        self.minValue=1;
        self.maxValue = 9999;//最大值
    }
    return self;
}

-(void) initView:(CGRect)frame{
    
    //减少btn
    self.subBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //self.subBtn.frame=CGRectMake(0, 0, height, height);
    //    self.subBtn.layer.masksToBounds=YES;
    //    self.subBtn.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    //    self.subBtn.layer.borderWidth=0.5f;
    //    self.subBtn.layer.cornerRadius=3.0f;
    [self.subBtn setBackgroundImage:[UIImage imageNamed:@"stepper_less_btn_enable"] forState:UIControlStateNormal];
    [self.subBtn setBackgroundImage:[UIImage imageNamed:@"stepper_less_highLight"] forState:UIControlStateHighlighted];
    [self.subBtn setBackgroundImage:[UIImage imageNamed:@"stepper_less_btn_disable"] forState:UIControlStateDisabled];
    self.subBtn.tag=1;
    [self.subBtn addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
    //数量label
    self.countField=[[UITextField alloc] init];
    //self.countField.frame=CGRectMake(height, 0, width-2*height,height);
    self.countField.textAlignment=NSTextAlignmentCenter;
    self.countField.tintColor = [UIColor colorWithRed:0.937 green:0.270 blue:0.214 alpha:1.000];
    self.countField.keyboardType = UIKeyboardTypeNumberPad;
    //self.countField.layer.masksToBounds=YES;
    self.countField.layer.borderColor=[[UIColor colorWithWhite:0.531 alpha:1.000] CGColor];
    self.countField.layer.borderWidth=0.6f;
    //self.countField.layer.cornerRadius=3.0f;
    self.countField.font = [UIFont systemFontOfSize:13.5f];
    self.countField.delegate = self;
    //监听数量改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:self.countField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditing) name:UITextFieldTextDidEndEditingNotification object:self.countField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.countField];
    //增加btn
    self.addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //self.addBtn.frame=CGRectMake(width -height, 0, height, height);
    //    self.addBtn.layer.masksToBounds=YES;
    //    self.addBtn.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    //    self.addBtn.layer.borderWidth=0.5f;
    //    self.addBtn.layer.cornerRadius=3.0f;
    self.addBtn.tag=2;
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"stepper_more_btn_enable"] forState:UIControlStateNormal];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"stepper_more_highLight"] forState:UIControlStateHighlighted];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"stepper_more_btn_disable"] forState:UIControlStateDisabled];
    [self.addBtn addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
    //增加view
    [self addSubview:self.subBtn];
    [self addSubview:self.countField];
    [self addSubview:self.addBtn];
    
    [self addViewConstraints];
}



- (void) addViewConstraints{
    
    // 1.
    [self.subBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.width.mas_equalTo(self.subBtn.mas_height);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.countField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.subBtn.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.right.mas_equalTo(self.addBtn.mas_left);
    }];
    
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.width.mas_equalTo(self.subBtn.mas_height);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}


-(void) changeValue:(UIButton*) btn{
    
    //如果设置了不允许增加
    if (self.setConstantValue) {
        switch (btn.tag) {
            case 1://减
                [self setStepperValueChangIsAdd:NO];
                break;
            case 2://加
                [self setStepperValueChangIsAdd:YES];
                break;
        }
        return;
    }
    
    //改变值
    switch (btn.tag) {
        case 1://减
            if(_currentValue>_minValue){
                _currentValue-=1;
            }
            [self setStepperValueChangIsAdd:NO];
            break;
        case 2://加
            if (_currentValue<_maxValue) {
                _currentValue+=1;
                [self setStepperValueChangIsAdd:YES];
            }else{
                _currentValue = _maxValue;
                if ([self.delegate respondsToSelector:@selector(stepperViewValueEqualMaxValue:)]) {
                    [self.delegate stepperViewValueEqualMaxValue:_maxValue];
                }
            }
            break;
    }
    self.countField.text=[NSString stringWithFormat:@"%zi",_currentValue];
    
    [self checkEnabled];
    
    //改变后的代理
    if([self.delegate respondsToSelector:@selector(stepperViewValueChanged:)]){
        [self.delegate stepperViewValueChanged:_currentValue];
    }
}

#pragma mark -
- (void)setStepperValueChangIsAdd:(BOOL)isAdd{
    if ([self.delegate respondsToSelector:@selector(stepperViewValueChangIsAdd:countField: currentValue:)]) {
        [self.delegate stepperViewValueChangIsAdd:isAdd countField:self.countField currentValue:_currentValue];
    }
}



#pragma mark - 只允许输入数字
#define NUMBERS @"0123456789"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //不允许输入第一个是0
    if (!textField.text.length && ![string intValue]) {
        return NO;
    }
    
    //只允许输入数据
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest){
        //@"请输入数字"
        return NO;
    }
    
    //最大四位数字
    if (range.location >3) {
        return NO;
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
}


#pragma mark - 监听数量框的改变
- (void)textFieldTextBeginEditing{
    if([self.delegate respondsToSelector:@selector(stepperViewTextBeginEditing:)]){
        [self.delegate stepperViewTextBeginEditing:self.countField];
    }
}

- (void)textFieldTextDidEndEditing{
    
    //如果为空设置原来的值，否则赋新值
    if (!self.countField.text.length) {
        self.countField.text = [NSString stringWithFormat:@"%zi",_currentValue];
        if([self.delegate respondsToSelector:@selector(stepperViewTextDidEndEditing: oldText:)]){
            [self.delegate stepperViewTextDidEndEditing:self.countField oldText:_currentValue];
        }
    }else{
        
        // 最大值不超过当前值
        if (self.maxValue < [self.countField.text integerValue]) {
            self.countField.text = [NSString stringWithFormat:@"%ld",self.maxValue];
        }
        
        if([self.delegate respondsToSelector:@selector(stepperViewTextDidEndEditing: oldText:)]){
            [self.delegate stepperViewTextDidEndEditing:self.countField oldText:_currentValue];
        }
        _currentValue = [self.countField.text intValue];
    }
    
    [self checkEnabled];
}

- (void)textFieldTextDidChange{
    if([self.delegate respondsToSelector:@selector(stepperViewTextDidChanged:)]){
        [self.delegate stepperViewTextDidChanged:self.countField];
    }
}


#pragma mark - 检查按钮可用
- (void)checkEnabled{
    
    //设置左右按钮是否可用
    if (_currentValue == _minValue) {
        self.subBtn.enabled = NO;
    }else{
        self.subBtn.enabled = YES;
    }
    
    if (_currentValue == _maxValue) {
        self.addBtn.enabled = NO;
    }else{
        self.addBtn.enabled = YES;
    }
}

@end
