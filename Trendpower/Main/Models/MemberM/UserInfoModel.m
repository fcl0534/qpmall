//
//  UserInfoModel.m
//  Trendpower
//
//  Created by trendpower on 15/5/18.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "UserInfoModel.h"
/**
 *
	      "data": {
                     "account": "0.00",
                     "address": "",
                     "age": "0",
                     "alipay_account": "",
                     "audit_status": "1",
                     "audit_time": "0",
                     "birthday": "2015-05-14",
                     "cate_id": "1313",
                     "coin_locked": "0",
                     "coin_total": "0",
                     "email": "yyy@1.com",
                     "freeze": "0.00",
                     "gender": "0",
                     "im_aliww": "",
                     "im_msn": "",
                     "im_qq": "",
                     "is_online": "1",
                     "job": "",
                     "last_buy_time": "0",
                     "last_ip": "2147483647",
                     "last_login": "1431919622",
                     "logins": "119",
                     "password": "d15cdd835588bd294214c95e766360b4",
                     "phone_mob": "",
                     "phone_tel": "",
                     "portrait": "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/5555c0e9b4495.png",
                     "real_name": "",
                     "refuse_reason": "",
                     "reg_time": "1426813143",
                     "register_ip": "0",
                     "resume": "",
                     "salt": "ae2b",
                     "store_id": "81",
                     "token": "",
                     "token_exptime": "0",
                     "type": "0",
                     "user_id": "32153",
                     "user_name": "testing",
                     "user_status": "Y"
                },
        "msg": "获取成功",
        "status": 1
 }
 */
@implementation UserInfoModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        NSDictionary * data = [attributes objectForKey:@"data"];
        NSDictionary * info = [data objectForKey:@"info"];
        NSDictionary * more = [data objectForKey:@"more"];
        
        
        //1.产品详情
        self.userId = [self setNoNull:[info valueForKey:@"userId"]];
        self.userAge = [self setNoNull:[info valueForKey:@"age"]];
        self.usercategoryName = [self setNoNull:[info valueForKey:@"usercategoryName"]];
        self.userPhone = [self setNoNull:[info valueForKey:@"cellphone"]];
        self.userPortraitUrl = [self setNoNull:[info valueForKey:@"portrait"]];
        self.userRealname = [self setNoNull:[info valueForKey:@"truename"]];
        self.userEmail = [self setNoNull:[info valueForKey:@"email"]];
        self.userGender = [self setNoNull:[info valueForKey:@"gender"]];
        self.companyName = [self setNoNull:[info valueForKey:@"companyName"]];
        
        
        self.cityId = [self setNoNull:[info valueForKey:@"cityId"]];
        self.cityName = [self setNoNull:[info valueForKey:@"cityName"]];
        self.provinceId = [self setNoNull:[info valueForKey:@"provinceId"]];
        self.provinceName = [self setNoNull:[info valueForKey:@"provinceName"]];
        self.districtId = [self setNoNull:[info valueForKey:@"districtId"]];
        self.districtName = [self setNoNull:[info valueForKey:@"districtName"]];
        
        self.balanceCredit = [self setNoNull:[more valueForKey:@"balanceCredit"]];
        self.totalCredit = [self setNoNull:[more valueForKey:@"totalCredit"]];
        self.frozenAmount = [self setNoNull:[more valueForKey:@"frozenAmount"]];
        self.collectionCount = [self setNoNull:[more valueForKey:@"collectionCount"]];
    }
    return self;
}

- (id) setNoNull:(id)aValue{
    if (aValue == nil) {
        aValue = @"";//为null时，直接赋空
    } else if ((NSNull *)aValue == [NSNull null]) {
        aValue = @"";
        if ([aValue isEqual:nil]) {
            aValue = @"";
        }
    }
    return [NSString stringWithFormat:@"%@",aValue];
}

/**
data =     {
    info =         {
        address = "";
        cellphone = 18182591970;
        cityId = 311;
        cityName = "西安";
        companyName = xyt;
        districtId = 2597;
        districtName = "新城区";
        email = asd;
        isChecked = 1;
        isDisabled = 0;
        loginAt = 1453719801;
        provinceId = 24;
        provinceName = "陕西";
        tel = "";
        truename = asda;
        userId = 17;
        userLevelId = 3;
        userLevelName = "1级";
        usercategoryId = 3;
        usercategoryName = "普通会员";
    };
    more =         {
        balanceAmount = 900;
        balanceCredit = "10000.00";
        frozenAmount = 100;
        totalAmount = 1000;
        totalCredit = "10000.00";
        totalOrderNum = 0;
    };
};
msg = "";
status = 1;
 */


@end
