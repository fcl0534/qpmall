//
//  HomeAD3CollectionCell.h
//  Trendpower
//
//  Created by HTC on 16/1/25.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeAD3CollectionCellDelegate <NSObject>

@optional

- (void)homeAD3CollectionCellClickedImageView:(NSInteger)index  indexPath:(NSIndexPath *) indexPath;

@end


@interface HomeAD3CollectionCell : UICollectionViewCell

@property (nonatomic, weak) id<HomeAD3CollectionCellDelegate>delegate;

/**
 *  图片对象数组
 */
@property (nonatomic, strong) NSMutableArray * imagesArray;

@property (nonatomic, strong) NSIndexPath * indexPath;

@end
