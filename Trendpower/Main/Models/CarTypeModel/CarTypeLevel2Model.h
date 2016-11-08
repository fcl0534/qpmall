//
//  CarTypeLevel2Model.h
//  Trendpower
//
//  Created by trendpower on 15/9/29.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarTypeLevel2Model : NSObject

@property (nonatomic,strong) NSString *brand_id;
@property (nonatomic,strong) NSString *brand_name;
@property (nonatomic,strong) NSString *brand_logo;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;
@end
