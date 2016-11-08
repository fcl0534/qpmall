//
//  TCStepper.m
//  Trendpower
//
//  Created by HTC on 15/5/12.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "TCStepper.h"

@interface TCStepper()<UITextFieldDelegate>

@end

@implementation TCStepper

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
    if (maxValue == _currentValue) {
        self.addBtn.enabled = NO;
    }else{
        self.addBtn.enabled = YES;
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
            //初始化默认值
            _currentValue=1;
            _minValue=1;
            _maxValue = MAXFLOAT;//最大值

            [self initView:frame];
      }
    return self;
}

-(void) initView:(CGRect)frame{
    
    
    float spacingH = 3;
    float spacingW = 1;
    
    float height = frame.size.height;
    
    //计算Frame，保证宽度足够为高度的4倍
    if (frame.size.width < (height)*4) {
        height = frame.size.width /4;
        self.frame = CGRectMake(frame.origin.x , frame.origin.y , frame.size.width, height);
    }
    //
    float WH = height - 2*spacingH;
    
    //减少btn
    self.subBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.subBtn.frame=CGRectMake(spacingW, spacingH, WH, WH);
//    self.subBtn.layer.masksToBounds=YES;
//    self.subBtn.layer.borderColor=[[UIColor lightGrayColor] CGColor];
//    self.subBtn.layer.borderWidth=0.5f;
//    self.subBtn.layer.cornerRadius=3.0f;
    [self.subBtn setImage:[UIImage imageNamed:@"ShopCart_Remove"] forState:UIControlStateNormal];
    [self.subBtn setImage:[UIImage imageNamed:@"ShopCart_Remove_Unselect"] forState:UIControlStateDisabled];
    self.subBtn.tag=1;
    [self.subBtn addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
    //数量label
    self.countField=[[UITextField alloc] init];
    self.countField.frame=CGRectMake(WH+2*spacingW, spacingH, 2*WH,WH);
    self.countField.textAlignment=NSTextAlignmentCenter;
    self.countField.layer.masksToBounds=YES;
    self.countField.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.countField.layer.borderWidth=0.5f;
    self.countField.layer.cornerRadius=3.0f;
    self.countField.text=[NSString stringWithFormat:@"%zi",_currentValue];
    self.countField.delegate = self;
    //监听数量改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:self.countField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditing) name:UITextFieldTextDidEndEditingNotification object:self.countField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.countField];
    //增加btn
    self.addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame=CGRectMake(3*WH + 3*spacingW, spacingH, WH, WH);
//    self.addBtn.layer.masksToBounds=YES;
//    self.addBtn.layer.borderColor=[[UIColor lightGrayColor] CGColor];
//    self.addBtn.layer.borderWidth=0.5f;
//    self.addBtn.layer.cornerRadius=3.0f;
    self.addBtn.tag=2;
    [self.addBtn setImage:[UIImage imageNamed:@"ShopCart_Add"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"ShopCart_Add_Unselect"] forState:UIControlStateDisabled];
    [self.addBtn addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
    //增加view
    [self addSubview:self.subBtn];
    [self addSubview:self.countField];
    [self addSubview:self.addBtn];
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
                if ([self.delegate respondsToSelector:@selector(stepperValueEqualMaxValue:)]) {
                    [self.delegate stepperValueEqualMaxValue:_maxValue];
                }
            }
            break;
    }
    self.countField.text=[NSString stringWithFormat:@"%zi",_currentValue];
    
    [self checkEnabled];
    
    //改变后的代理
    if([self.delegate respondsToSelector:@selector(stepperValueChanged:)])
    {
        [self.delegate stepperValueChanged:_currentValue];
    }
}

#pragma mark - 
- (void)setStepperValueChangIsAdd:(BOOL)isAdd{
    if ([self.delegate respondsToSelector:@selector(stepperValueChangIsAdd:countField: currentValue:)]) {
        [self.delegate stepperValueChangIsAdd:isAdd countField:self.countField currentValue:_currentValue];
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
    //其他的类型不需要检测，直接写入
    return YES;
}


#pragma mark - 监听数量框的改变
- (void)textFieldTextBeginEditing{

    if([self.delegate respondsToSelector:@selector(stepperTextBeginEditing:)])
    {
        [self.delegate stepperTextBeginEditing:self.countField];
    }
}

- (void)textFieldTextDidEndEditing{
    
    //如果为空设置原来的值，否则赋新值
    if (!self.countField.text.length) {
        self.countField.text = [NSString stringWithFormat:@"%zi",_currentValue];
        if([self.delegate respondsToSelector:@selector(stepperTextDidEndEditing: oldText:)])
        {
            [self.delegate stepperTextDidEndEditing:self.countField oldText:_currentValue];
        }
    }else{
        // 最大值不超过当前值
        if (self.maxValue < [self.countField.text integerValue]) {
            self.countField.text = [NSString stringWithFormat:@"%ld",self.maxValue];
        }
        
        if([self.delegate respondsToSelector:@selector(stepperTextDidEndEditing: oldText:)])
        {
            [self.delegate stepperTextDidEndEditing:self.countField oldText:_currentValue];
        }
        _currentValue = [self.countField.text intValue];
    }
    
    [self checkEnabled];
}

- (void)textFieldTextDidChange{

    if([self.delegate respondsToSelector:@selector(stepperTextDidChanged:)])
    {
        [self.delegate stepperTextDidChanged:self.countField];
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
