//
//  AdvertiseModel.m
//  广告数据model（全部图片的数据）
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "AdvertiseModelArray.h"
#import "AdvertiseModel.h"
@implementation AdvertiseModelArray

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if ([super init]) {
        NSArray *dataFromServer =[attributes valueForKey:@"data"];
        
        NSMutableArray *tempImagesArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *tempData in dataFromServer)
        {
            AdvertiseModel *imageModel = [[AdvertiseModel alloc] initWithAttributes:tempData];
            
            [tempImagesArray addObject:imageModel];
        }
        
        self.dataAD = [[NSArray alloc] initWithArray:tempImagesArray];
        self.counts = self.dataAD.count;
        self.type = 0;
        
    }
    
    return self;
}
@end
