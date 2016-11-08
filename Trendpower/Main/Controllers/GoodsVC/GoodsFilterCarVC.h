//
//  GoodsFilterCarVC.h
//  Trendpower
//
//  Created by HTC on 16/2/4.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "YQViewController.h"

@interface GoodsFilterCarVC : YQViewController

/**  存取选择条件的字典数据 */
@property(nonatomic, strong, nullable) NSMutableArray * arrayselectDics;

@property (nonatomic, copy, nonnull) dispatch_block_t clickedConfirmBlock;
@end
