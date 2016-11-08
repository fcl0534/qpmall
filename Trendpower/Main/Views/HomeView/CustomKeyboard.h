//
//  CustomKeyboard.h
//  SkfSwiftCammer
//
//  Created by 张帅 on 16/6/20.
//  Copyright © 2016年 Kevin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CustomKeyboardDelegate <NSObject>

- (void)characterKeyClick:(NSString *)key;

@end

@interface CustomKeyboard : UIView

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *characterKeys;

@property (nonatomic, weak) id<CustomKeyboardDelegate> delegate;

@end
