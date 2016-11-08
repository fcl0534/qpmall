//
//  HomeAD5CollectionCell.h
//  Trendpower
//
//  Created by 张帅 on 16/7/20.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeAD5CollectionCellDelegate <NSObject>

@optional

- (void)homeAD5CollectionCellClickedImageView:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

@end

@interface HomeAD5CollectionCell : UICollectionViewCell

@property (nonatomic, weak) id<HomeAD5CollectionCellDelegate>delegate;

/** 图片对象数组 */
//@property (nonatomic, strong) NSMutableArray * imagesArray;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSIndexPath * indexPath;

@end
