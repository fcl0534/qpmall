//
//  BrandModel.h
//  Trendpower
//
//  Created by trendpower on 15/9/28.
//  Copyright © 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandModel : NSObject

@property (nonatomic,strong) NSString *brand_id;
@property (nonatomic,strong) NSString *brand_name;
@property (nonatomic,strong) NSString *brand_logo;

- (instancetype) initWithAttributes:(NSDictionary *)attributes;

/**
"hot_brand": [
              {
                  "brand_type": "1",
                  "file_name": "http://assets.qpfww.com/carbrand/73661451462784.png",
                  "goods_brand_code": "3T55Y4684",
                  "id": "3852960",
                  "initial": "S",
                  "title": "赛威驰"
              },
              {
                  "brand_type": "3",
                  "file_name": "http://assets.qpfww.com/goodsbrand/32591450081011.jpg",
                  "goods_brand_code": "XC43XY634",
                  "id": "3852961",
                  "initial": "X",
                  "title": "宣顶"
              },



  */
               
@end
