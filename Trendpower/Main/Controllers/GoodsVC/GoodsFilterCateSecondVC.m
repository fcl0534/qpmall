//
//  GoodsFilterCateSecondVC.m
//  Trendpower
//
//  Created by HTC on 16/2/5.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "GoodsFilterCateSecondVC.h"

// tool

#import "MJRefresh.h"

#import "NetworkingUtil.h"
#import "HUDUtil.h"
#import "WebImageUtil.h"

//model
#import "CateModelArray.h"

// view
#import "CateCollectionViewCell.h"

#define K_Filter_TYPE @"K_Filter_TYPE"
#define K_Filter_NAME @"K_Filetr_NAME"
#define K_Filter_VALVE @"K_FIletr_VALVE"

typedef NS_ENUM(NSUInteger, GoodsFilterType) {
    GoodsFilterTypeNone = 0,  // 没有
    GoodsFilterTypeCategory,  // 商品分类
    GoodsFilterTypeBrand,     // 商品品牌
    GoodsFilterTypeCarSeries, // 车型的惟一号
    GoodsFilterTypeGoodsName, // 搜索名字
    GoodsFilterTypeCarBrand,  // 车型的id
    GoodsFilterTypeCarModel,  // 车型名称
    GoodsFilterTypeEmssion,   // 车排量
    GoodsFilterTypeYear,      // 车年份
};

#define ColCell_Spacing_WIDTH           10
#define ColCell_Item_WIDTH             ((self.collectionView.frame.size.width -3 - 4*ColCell_Spacing_WIDTH)/3)
#define ColCell_Item_HIGHT             70

@interface GoodsFilterCateSecondVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView * collectionView;

@end

@implementation GoodsFilterCateSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.selectCateModel.cateName;
    self.navigationBar.barTintColor = K_MAIN_COLOR;

    [self initCollectionView];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationBar.leftTitle = @"返回";
}

- (void)initCollectionView{
    
    if (!self.collectionView) {
        CGRect frame = self.yqNavigationController.frame;
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        UICollectionView * collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height -64) collectionViewLayout:flowLayout];
        self.collectionView = collectionView;
        self.collectionView.backgroundColor= [UIColor whiteColor];
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.alwaysBounceVertical = YES;
        
        [self.collectionView registerClass:[CateCollectionViewCell class] forCellWithReuseIdentifier:@"CateCollectionViewCell"];
        
        [self.view addSubview:self.collectionView];
        
    }
}

#pragma mark collectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.selectCateModel.cateSubArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CateCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CateCollectionViewCell" forIndexPath:indexPath];
    
    CateSubModel * model = self.selectCateModel.cateSubArray[indexPath.row];
    cell.nameLabel.text = model.cateName;
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"fenlei_all"];
    }else{
        [WebImageUtil setImageWithURL:model.imageUrl placeholderImage:[UIImage imageNamed:@"placeholderImage"] inView:cell.imageView];
    }
    
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(ColCell_Spacing_WIDTH, ColCell_Spacing_WIDTH, ColCell_Spacing_WIDTH, ColCell_Spacing_WIDTH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((int)ColCell_Item_WIDTH, ColCell_Item_HIGHT);;
}


//这个是两行之间的间距（上下cell间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20;
}

#pragma mark  点击collectionView
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * filterName;
    NSString * cateId;
    if (indexPath.row == 0) {
        filterName = self.selectCateModel.cateName;
        cateId = [NSString stringWithFormat:@"%ld",self.selectCateModel.cateId];
    }else{
        CateSubModel * model = self.selectCateModel.cateSubArray[indexPath.row];
        filterName = model.cateName;
        cateId = [NSString stringWithFormat:@"%ld",model.cateId];
    }
    
    BOOL isFild = NO; //标志是否已经存在的类型，存在替换就可以
    for(int i = 0; i<self.arrayselectDics.count; i++) {
        NSMutableDictionary * dic = self.arrayselectDics[i];
        NSInteger type = [[dic valueForKey:K_Filter_TYPE] integerValue];
        switch (type) {
            case GoodsFilterTypeCategory:
                isFild = YES;
                [dic setValue:filterName forKey:K_Filter_NAME];
                [dic setValue:cateId forKey:K_Filter_VALVE];
                [dic setValue:@(GoodsFilterTypeCategory) forKey:K_Filter_TYPE];
                break;
            default:
                break;
        }
    }
    
    if (!isFild) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjects:@[@(GoodsFilterTypeCategory),filterName,cateId] forKeys:@[K_Filter_TYPE,K_Filter_NAME,K_Filter_VALVE]];
        [self.arrayselectDics addObject:dic];
    }
    
    // 返回
    __block typeof(self) weakSelf = self;
    if (self.clickedConfirmBlock) {
        [weakSelf.yqNavigationController popYQViewControllerAnimated:weakSelf.isFirstPush];
        weakSelf.clickedConfirmBlock();
    }
}

@end
