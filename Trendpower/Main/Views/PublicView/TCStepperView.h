//
//  TCStepperView.h
//  ZZBMall
//
//  Created by trendpower on 15/8/11.
//  Copyright (c) 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCStepperViewDelegate <NSObject>

@optional
//按钮代理
/** 数值改变 */
-(void) stepperViewValueChanged:(NSInteger) currentValue;
/** 达到最大值 */
-(void) stepperViewValueEqualMaxValue:(NSInteger) maxValue;
/** 数值改变 */
-(void) stepperViewValueChangIsAdd:(BOOL)isAdd countField:(UITextField*)counteField currentValue:(NSInteger) currentValue;

//文本框代理
/** 数值框开始输入 */
- (void) stepperViewTextBeginEditing:(UITextField*)counteField;
/** 数值框结束输入 */
- (void) stepperViewTextDidEndEditing:(UITextField*)counteField oldText:(NSInteger)oldText;
/** 数值框将要输入 */
- (void) stepperViewTextDidChanged:(UITextField*)counteField;

@end

@interface TCStepperView : UIView

@property(nonatomic,strong) id<TCStepperViewDelegate> delegate;

/** 最小值 */
@property(nonatomic,assign) NSInteger minValue;
/** 最大值 */
@property(nonatomic,assign) NSInteger maxValue;
/** 当前值 */
@property(nonatomic,assign) NSInteger currentValue;

/** 是否是数量先不变操作 【如果操作需要联网请求成功后，才更新数值时，此值设置为YES】*/
@property (nonatomic, assign) BOOL setConstantValue;

@end
