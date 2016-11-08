//
//  CateModelArray.m
//  Trendpower
//
//  Created by HTC on 16/1/17.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "CateModelArray.h"

@implementation CateModelArray

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(self)
    {
        NSArray *dataFromServer = [attributes valueForKey:@"data"];
        NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
        for (NSDictionary *categoryDic in dataFromServer){
            CateModel *model = [[CateModel alloc] initWithAttributes:categoryDic];
            [mutilableData addObject:model];
        }
        self.cateArray = [[NSArray alloc] initWithArray:mutilableData];
    }
    return self;
}
@end
