//
//  HomeAD2CollectionCell.h
//  Trendpower
//
//  Created by HTC on 16/1/25.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeAD2CollectionCellDelegate <NSObject>

@optional

- (void)homeAD2CollectionCellClickedImageView:(NSInteger)index indexPath:(NSIndexPath *) indexPath;

@end


@interface HomeAD2CollectionCell : UICollectionViewCell

@property (nonatomic, weak) id<HomeAD2CollectionCellDelegate>delegate;

/**
 *  图片对象数组
 */
@property (nonatomic, strong) NSMutableArray * imagesArray;

@property (nonatomic, strong) NSIndexPath * indexPath;

@end
