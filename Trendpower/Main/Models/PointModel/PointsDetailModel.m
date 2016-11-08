
//
//  PointsDetailModel.m
//  Trendpower
//
//  Created by HTC on 16/4/26.
//  Copyright © 2016年 trendpower. All rights reserved.
//

#import "PointsDetailModel.h"

@implementation PointsDetailModel

@end
@implementation PointsDetail_Data

+ (NSDictionary *)objectClassInArray{
    return @{@"goods_spec" : [PointsDetail_Goods_Spec class], @"img_list" : [PointsDetail_Img_List class]};
}

@end


@implementation PointsDetail_Info
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"webDescription" : @"description"
             };
}

@end


@implementation PointsDetail_Goods_Spec

@end


@implementation PointsDetail_Img_List

@end


