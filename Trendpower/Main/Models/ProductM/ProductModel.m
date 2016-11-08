//
//  Goods.m
//  TabBarNavigationDemo
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if([super init]) {

        NSDictionary *data = [attributes objectForKey:@"data"];
        
        if (!data.count) {
            return self;
        }

        //每次都初始为NO
        self.isNoStores = NO;
        
        self.detail_images = [data valueForKey:@"detail_images"];
        
        self.isCollection = [[data valueForKey:@"isCollection"] boolValue];

        NSDictionary *goods_info = [data objectForKey:@"goods_info"];
        
        self.productId = [goods_info valueForKey:@"id"];
        self.brand_title = [goods_info valueForKey:@"brand_title"];
        self.title = [goods_info valueForKey:@"title"];
        self.unit_title = [goods_info valueForKey:@"unit_title"];
        
        // 3.图片列表
        NSArray *imageArray = [data valueForKey:@"goods_images"];
        NSMutableArray *tmpImageArray = [[NSMutableArray alloc] init];
        for (NSDictionary *imageInfo in imageArray) {
            ProductImageModel *imgModel = [[ProductImageModel alloc] initWithAttributes:imageInfo];
            [tmpImageArray addObject:imgModel];
            if (tmpImageArray.count ==1) {
                //默认图片 url
                self.defaultImageUrl = imgModel.file_name;
            }
        }
        
        self.goods_images = [[NSArray alloc] initWithArray:tmpImageArray];
        
        NSArray *goods_storesArray = [data valueForKey:@"goods_stores"];
        
        // 4.2 经销商参数信息
        if (goods_storesArray.count == 0) {
            self.isNoStores = YES;
            self.goods_stores = @[]; //经销商为空
        } else if (goods_storesArray.count == 1) { //只有一家经销商
            self.specCount = 0;
            
            ProductSpecificationModel *model = [[ProductSpecificationModel alloc] initWithAttributes:[goods_storesArray firstObject]];
            
            self.seller_id = model.seller_id;
            self.good_price = model.good_price;
            self.sku = model.sku;
            self.sales_volumn = model.sales_volumn;
            
            self.goods_stores = @[model];
            
        } else { //多个经销商
            
            self.specCount = 1;
            self.good_price = @"10000000"; //标志一个大数
            
            NSMutableArray *tempSpecArray = [[NSMutableArray alloc] init];
            for (NSDictionary *specInfo in goods_storesArray){
                ProductSpecificationModel *model = [[ProductSpecificationModel alloc] initWithAttributes:specInfo];
                [tempSpecArray addObject:model];
                
                // 判断最小价格
                if ([model.good_price floatValue] < [self.good_price floatValue]) {
                    self.good_price = model.good_price;
                    self.sku = model.sku;
                    self.sales_volumn = model.sales_volumn;
                }
            }
            self.goods_stores = [[NSArray alloc] initWithArray:tempSpecArray];
            
            self.specName1 = @"店铺";
            
            //设置规格名称字典
            self.specNameDic = [self spec1NameDic];

        }

        //在登录的情况下才会返回数据
        if ([[UserDefaultsUtils getValueByKey:KTP_ISLOGIN] isEqualToString:@"YES"]) {

            //产品规格
            NSMutableArray *goodStandards = [NSMutableArray array];

            NSArray *goods_standards = [data valueForKey:@"goods_standards"];

            if (goods_standards && goods_standards.count > 0) {
                for (NSDictionary *standardDic in goods_standards) {
                    ProductStandardMdoel *model = [[ProductStandardMdoel alloc] initWithAttributes:standardDic];
                    [goodStandards addObject:model];
                }
                self.goods_standards = [[NSArray alloc] initWithArray:goodStandards];
            }
        }

    }
    return self;
}

/**
 
 *
 */

/**
 得到字典，Key-V 形如：
 "0": "蓝色"
 "1": "黄色"
 */

#pragma mark - 获取规格 属性字典
- (NSMutableDictionary *)spec1NameDic{
    __block NSString *specName = @"";
    __block int counts = 0;
    __block NSMutableDictionary *specDic =[NSMutableDictionary dictionary];
    
    [self.goods_stores enumerateObjectsUsingBlock:^(ProductSpecificationModel * model, NSUInteger idx, BOOL *stop) {
        if (![specName isEqualToString:model.company_name]) {
            specName = model.company_name;
            [specDic setObject:model.company_name forKey:@(counts)];
            counts += 1;//作为key
        }
    }];
    
    return specDic;
}

@end