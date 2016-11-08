//
//  PointsInfoModel.m
//  Trendpower
//
//  Created by 张帅 on 16/10/24.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "PointsInfoModel.h"

#import "MyPointsModel.h"

@implementation PointsInfoModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        NSDictionary * data = [attributes objectForKey:@"data"];

        self.totalPoint = [[data objectForKey:@"totalPoint"] floatValue];

        self.totalBalancePoint = [[data objectForKey:@"totalBalancePoint"] floatValue];

        NSMutableArray *mutilableData = [[NSMutableArray alloc] init];

        NSArray * points = [data valueForKey:@"list"];

        for (NSDictionary *pointDic in points){

            MyPointsModel *model = [[MyPointsModel alloc] initWithAttributes:pointDic];
            [mutilableData addObject:model];
        }

        self.myPoints = [[NSArray alloc] initWithArray:mutilableData];
    }
    return self;
}

@end
