//
//  QPMGoodsModel.h
//  Trendpower
//
//  Created by hjz on 16/5/8.
//  Copyright © 2016年 www.qpfww.com. All rights reserved.
//

#import "QPMGoodsModel.h"

@implementation QPMGoodsModel

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if(self)
    {
        //1.产品详情
        self.goodsId = [[attributes valueForKey:@"id"] integerValue];
        self.title = [attributes valueForKey:@"title"];
        self.good_price = [attributes valueForKey:@"good_price"];
        self.file_name = [attributes valueForKey:@"file_name"];
        self.isActivity = [[attributes valueForKey:@"isActivity"] integerValue];
        self.is_sell = [attributes valueForKey:@"is_sell"];
    }
    return self;
}

/**
 *

{
    "check_status" = 0;
    "city_id" = 311;
    "company_name" = xz;
    "file_name" = "http://assets.qpfww.com/goods/0000/0355/3603/3553603/22921449125541.jpg";
    "good_price" = "122.00";
    "goods_brand_title" = "\U5feb\U8f66\U9053";
    "goods_code" = 5XV37N5N7;
    "goods_no" = KC0300007;
    "goods_status" = 1;
    id = 3553603;
    "is_source" = 1;
    "province_id" = 24;
    "relation_goods_ids" = "<null>";
    sku = 9999;
    "source_id" = 0;
    title = "\U5feb\U8f66\U9053-35\U2103\U9632\U51bb\U6db2\U7eff\U82729kg \U5feb\U8f66\U9053\U9632\U51bb\U6db2-35\U5ea6\U7eff\U82729\U516c\U65a4 \U5feb\U8f66\U9053\U9632\U51bb\U51b7\U5374\U6db2\U7eff\U8272-35\U5ea6";
    "user_category_id" = 1;
    "warning_sku" = 0;
}
 */

@end
