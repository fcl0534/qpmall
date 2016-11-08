//
//  RegionSubchildModel.h
//  Trendpower
//
//  Created by trendpower on 15/5/22.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionSubchildModel : NSObject



@property (nonatomic, copy) NSString * regionId;
@property (nonatomic, copy) NSString * regionName;
@property (nonatomic, copy) NSString * parentId;
@property (nonatomic, copy) NSString * isDefault;
@property (nonatomic, copy) NSString * level;


- (instancetype) initWithAttributes:(NSDictionary *)attributes;


@end
