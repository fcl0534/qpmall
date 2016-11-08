//
//  UserInfoModel.h
//  Trendpower
//
//  Created by trendpower on 15/5/18.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
/** 用户ID */
@property (nonatomic,strong) NSString * userId;
/** 公司名称 */
@property (nonatomic,strong) NSString * companyName;
/** 用户年龄 */
@property (nonatomic,strong) NSString * userAge;
/** 用户等级 */
@property (nonatomic,strong) NSString * usercategoryName;
/** 用户手机号码 */
@property (nonatomic,strong) NSString * userPhone;
/** 用户头像URL */
@property (nonatomic,strong) NSString * userPortraitUrl;
/** 用户真实名称 */
@property (nonatomic,strong) NSString * userRealname;
/** 用户邮箱 */
@property (nonatomic,strong) NSString * userEmail;
/** 用户性别 */
@property (nonatomic,strong) NSString * userGender;
/** 用户地址 */
@property (nonatomic,strong) NSString * cityId;
@property (nonatomic,strong) NSString * cityName;
@property (nonatomic,strong) NSString * districtId;
@property (nonatomic,strong) NSString * districtName;
@property (nonatomic,strong) NSString * provinceId;
@property (nonatomic,strong) NSString * provinceName;
/** 帐单期 */
@property (nonatomic,strong) NSString * frozenAmount;
/** 总信用分 */
@property (nonatomic,strong) NSString * totalCredit;
/** 可用信用 */
@property (nonatomic,strong) NSString * balanceCredit;
/** 客服电话 */
@property (nonatomic,strong) NSString * phone_400;
/** 我的收藏 */
@property (nonatomic,strong) NSString * collectionCount;

/** 模型init */
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
