//
//  ShipWayModel.h
//  EcmallAPP
//
//  Created by zhanghongbo on 13-12-31.
//  Copyright (c) 2013年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShippingModel : NSObject
@property (nonatomic) int shipingId;
@property (nonatomic,strong) NSString *shippingName;
@property (nonatomic) CGFloat price;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
