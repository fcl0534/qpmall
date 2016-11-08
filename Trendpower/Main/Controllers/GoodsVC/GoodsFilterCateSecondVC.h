//
//  GoodsFilterCateSecondVC.h
//  Trendpower
//
//  Created by HTC on 16/2/5.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "YQViewController.h"
#import "CateModel.h"

@interface GoodsFilterCateSecondVC : YQViewController

/**  第一个push进入 */
@property (nonatomic, assign) BOOL isFirstPush;

@property (nonatomic, strong, nonnull) CateModel * selectCateModel;

/**  存取选择条件的字典数据 */
@property(nonatomic, strong, nullable) NSMutableArray * arrayselectDics;

@property (nonatomic, copy, nonnull) dispatch_block_t clickedConfirmBlock;

@property (nonatomic, copy, nonnull) NSString *cateId;

@end
