//
//  GoodsFilterCarStep2VC.h
//  Trendpower
//
//  Created by HTC on 16/2/29.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "YQViewController.h"

@interface GoodsFilterCarStep2VC : YQViewController

@property (nonatomic, copy, nonnull) NSString * filterName;

@property (nonatomic, copy, nonnull) NSString * titleName;

@property (nonatomic, copy, nonnull) NSString * fetchUrl;
//
@property (nonatomic, strong, nonnull) NSMutableArray * rowModelArray;

/**  存取选择条件的字典数据 */
@property(nonatomic, strong, nullable) NSMutableArray * arrayselectDics;

@property (nonatomic, copy, nonnull) dispatch_block_t clickedConfirmBlock;


@end
