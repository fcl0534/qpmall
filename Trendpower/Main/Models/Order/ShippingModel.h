//
//  ShipWayModel.h
//  EcmallAPP
//
//  Created by zhanghongbo on 13-12-31.
//  Copyright (c) 2013年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShippingModel : NSObject

@property (nonatomic,copy) NSString * shipingId;
@property (nonatomic,copy) NSString * shippingName;
@property (nonatomic,copy) NSString * price;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
