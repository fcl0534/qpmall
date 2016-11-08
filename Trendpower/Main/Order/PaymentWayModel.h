//
//  DeliverDateModel.h
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-2.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentWayModel : NSObject

@property (nonatomic) int paymentId;
@property (nonatomic,strong) NSString *paymentName;

-(instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
