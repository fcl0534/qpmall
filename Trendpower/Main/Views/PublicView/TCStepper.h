//
//  TCStepper.h
//  Trendpower
//
//  Created by HTC on 15/5/12.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TCStepperDelegate <NSObject>

@optional
//按钮代理
-(void) stepperValueChanged:(NSInteger) currentValue;
-(void) stepperValueEqualMaxValue:(NSInteger) maxValue;
-(void) stepperValueChangIsAdd:(BOOL)isAdd countField:(UITextField*)counteField currentValue:(NSInteger) currentValue;

//文本框代理
- (void) stepperTextBeginEditing:(UITextField*)counteField;
- (void) stepperTextDidEndEditing:(UITextField*)counteField oldText:(NSInteger)oldText;
- (void) stepperTextDidChanged:(UITextField*)counteField;

@end

@interface TCStepper : UIView

/** 最小值 */
@property(nonatomic,assign) NSInteger minValue;
/** 最大值 */
@property(nonatomic,assign) NSInteger maxValue;
/** 当前值 */
@property(nonatomic,assign) NSInteger currentValue;

/** 增加按钮 */
@property(nonatomic,strong) UIButton *addBtn;
/** 减少按钮 */
@property(nonatomic,strong) UIButton *subBtn;
/** 数据框 */
@property(nonatomic,strong) UITextField *countField;

/** 是否是数量先不变操作 【如果操作需要联网请求成功后，才更新数值时，此值设置为YES】*/
@property (nonatomic, assign) BOOL setConstantValue;

@property(nonatomic,strong) id<TCStepperDelegate> delegate;

@end
