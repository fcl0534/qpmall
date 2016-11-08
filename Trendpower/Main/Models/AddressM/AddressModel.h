//
//  AddressModel.h
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-2.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

/** 用户地址 */
@property (nonatomic,strong) NSString * cityId;
@property (nonatomic,strong) NSString * districtId;
@property (nonatomic,strong) NSString * provinceId;

/** 地址id */
@property (nonatomic, copy) NSString * addressId;
/** 用户id */
@property (nonatomic, copy) NSString * userId;
/** 地区id */
@property (nonatomic, copy) NSString * regionId;
/** 收货人名称 */
@property (nonatomic, copy) NSString * custommerName;
/** 所在地区：省份，城市 */
@property (nonatomic, copy) NSString * regionName;
/** 详情地址： 街道 */
@property (nonatomic, copy) NSString * address;
/** 详情地址： 街道 */
@property (nonatomic, copy) NSString * fullAddress;
/** 是否删除 0 正常 1已 删除 */
@property (nonatomic, assign) BOOL isDeleted;
/** 电话号码 */
@property (nonatomic, copy) NSString * telephone;
/** 手机号码 */
@property (nonatomic, copy) NSString * cellPhone;

/** 是否为默认地址 是否为默认地址 0 否 1是 */
@property (nonatomic, assign) BOOL isDefaultArress;


-(instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
