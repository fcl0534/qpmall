//
//  GoodsFilterListVC.h
//  Trendpower
//
//  Created by HTC on 16/2/2.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "YQViewController.h"

#define K_Filter_TYPE @"K_Filter_TYPE"
#define K_Filter_NAME @"K_Filetr_NAME"
#define K_Filter_VALVE @"K_FIletr_VALVE"

@interface GoodsFilterListVC : YQViewController

/**  存取选择条件的字典数据 */
@property(nonatomic, strong, nullable) NSMutableArray * arrayselectDics;

@property (nonatomic, copy, nonnull) dispatch_block_t clickedConfirmBlock;

@end
