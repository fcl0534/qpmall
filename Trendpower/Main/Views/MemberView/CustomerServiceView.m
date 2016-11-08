//
//  CustomerServiceView.m
//  Trendpower
//
//  Created by HTC on 15/6/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "CustomerServiceView.h"

@interface CustomerServiceView()

@property (nonatomic, weak) UITextField * titleField;

@property (nonatomic, weak) CustomTextView * contentView;

@property (nonatomic, weak) UIButton * submitBtn;


@property (nonatomic, weak) UIView * leftLine;

@property (nonatomic, weak) UIView * rightLine;

@property (nonatomic, weak) UILabel * tipsLabel;

@property (nonatomic, weak) UIButton * qqBtn;

@property (nonatomic, weak) UIButton * telBtn;

@end


@implementation CustomerServiceView
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        [self initBaseView];
    }
    
    return self;
}

- (void)initBaseView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleField = [self getTextField:@" 标题"];
    self.titleField.layer.cornerRadius = 1;
    self.titleField.layer.masksToBounds = YES;
    self.titleField.layer.borderWidth = 0.8;
    self.titleField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.titleField];
    
    CustomTextView * contentView = [[CustomTextView alloc]init];
    contentView.font = [UIFont systemFontOfSize:16];
    contentView.textColor = [UIColor colorWithWhite:0.141 alpha:1.000];
    contentView.tintColor = [UIColor colorWithRed:0.949 green:0.280 blue:0.226 alpha:1.000];
    [self addSubview:contentView];
    self.contentView = contentView;
    self.contentView.placeholder = @"意见反馈";
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 0.8;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    self.submitBtn = [self getBtn:@"提交"];
    [self.submitBtn addTarget:self action:@selector(clickedSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.leftLine = [self getLineView];
    
    self.rightLine = [self getLineView];
    
    
    self.tipsLabel = [self getLabel:@"你还可以"];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.qqBtn = [self getBtn:@"QQ客服"];
    [self.qqBtn addTarget:self action:@selector(clickedQQBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.telBtn = [self getBtn:@"电话客服"];
    [self.telBtn addTarget:self action:@selector(clickedTelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addViewConstraints];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldTextDidChange
{
    if(self.titleField.text.length > 50 ){
        NSRange range = NSMakeRange(0, 50);
        self.titleField.text = [self.titleField.text substringWithRange:range];
        [self endEditing:YES];
        HUDUtil * hud = [HUDUtil sharedHUDUtil];
        [hud showTextMBHUDWithText:@"标题不能多于50个字符" delay:1.0 inView:self];
    }
}

- (UILabel *) getLabel:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1];
    label.tintColor = [UIColor colorWithRed:0.949 green:0.280 blue:0.226 alpha:1.000];
    [self addSubview:label];
    return label;
}

- (UITextField *) getTextField:(NSString *)placeholder{
    UITextField *field = [[UITextField alloc]init];
    field.placeholder = placeholder;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.font = [UIFont systemFontOfSize:16.0f];
    field.textAlignment = NSTextAlignmentLeft;
    field.textColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1];
    field.tintColor = [UIColor colorWithRed:0.949 green:0.280 blue:0.226 alpha:1.000];
    [self addSubview:field];
    return field;
}


- (UIButton *) getBtn:(NSString *)title{
    UIButton * confirmButton = [[UIButton alloc]init];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"back_red"] forState:UIControlStateNormal];
    [confirmButton setTitle:title forState:UIControlStateNormal];
    [self addSubview:confirmButton];
    
    return confirmButton;
}

- (UIView *) getLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:0.914f green:0.910f blue:0.910f alpha:1.00f];
    [self addSubview:line];
    return line;
}


#pragma mark - 添加约束
-(void) addViewConstraints{
    
    float spacing = 10;
    
    // 1.
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.mas_top).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@30);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.top.mas_equalTo(self.titleField.mas_bottom).offset(spacing);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@120);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(20);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@150);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.submitBtn.mas_bottom).offset(60);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@80);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(spacing);
        make.centerY.mas_equalTo(self.tipsLabel.mas_centerY);
        make.right.mas_equalTo(self.tipsLabel.mas_left).offset(-spacing);
        make.height.mas_equalTo(@0.8);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipsLabel.mas_right).offset(spacing);
        make.centerY.mas_equalTo(self.tipsLabel.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-spacing);
        make.height.mas_equalTo(@0.8);
    }];
    
    
    [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(@35);
        make.width.mas_equalTo(@120);
        make.centerX.mas_equalTo(self.mas_centerX).offset(-80);
    }];
    
    
    [self.telBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(@35);
        make.width.mas_equalTo(@120);
        make.centerX.mas_equalTo(self.mas_centerX).offset(80);
    }];
    
}


#pragma mark - 代理
- (void)clickedSubmitBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(customerServiceViewClickedButton:titileField:contentView:)]) {
        [self.delegate customerServiceViewClickedButton:btn titileField:self.titleField contentView:self.contentView];
    }
}


- (void)clickedQQBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(customerServiceViewclickedQQBtn:)]) {
        [self.delegate customerServiceViewclickedQQBtn:btn];
    }
}

- (void)clickedTelBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(customerServiceViewclickedTelBtn:)]) {
        [self.delegate customerServiceViewclickedTelBtn:btn];
    }
}



@end
