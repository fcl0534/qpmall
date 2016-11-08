//
//  AddressModel.m
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-2.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
/**
 *  {
     data =     (
                 {
                     "addressId": 3,
                     "userId": "8",
                     "provinceId": "24",
                     "cityId": "311",
                     "districtId": "2599",
                     "pcdName": "陕西 西安 雁塔区",
                     "address": "唐延南路 8 号",
                     "fullAddress": "陕西 西安 雁塔区 唐延南路 8 号", "postcode": "",
                     "recipient": "阿辉",
                     "recipientMobile": "18392955877",
                     "fixedTel": "",
                     "isDefault": 0,
                     "isDeleted": 0
                 }
                );
     msg = "\U83b7\U53d6\U6210\U529f";
     status = 1;
 }
 */


-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.addressId = [attributes valueForKey:@"addressId"];
        self.userId = [attributes valueForKey:@"userId"];
        self.provinceId = [attributes valueForKey:@"provinceId"];
        self.cityId = [attributes valueForKey:@"cityId"];
        self.districtId = [attributes valueForKey:@"districtId"];
        self.custommerName = [attributes valueForKey:@"recipient"];
        self.regionName = [attributes valueForKey:@"pcdName"];
        self.address = [attributes valueForKey:@"address"];
        self.fullAddress = [attributes valueForKey:@"fullAddress"];
        self.isDeleted = [[attributes valueForKey:@"isDeleted"] boolValue];
        self.telephone = [attributes valueForKey:@"fixedTel"];
        self.cellPhone = [attributes valueForKey:@"recipientMobile"];
        self.isDefaultArress = [[attributes valueForKey:@"isDefault"] boolValue];
        
    }
    return self;
}
@end
