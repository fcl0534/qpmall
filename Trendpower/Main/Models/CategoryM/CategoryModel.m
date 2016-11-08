//
//  CategoryModelArray.m
//  EcmallAPP
//
//  Created by HTC on 15/5/4.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import "CategoryModel.h"
#import "SubCategoryModel.h"


@implementation CategoryModel


-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.cateId = [[attributes valueForKey:@"cate_id"] intValue];
        self.cateName = [attributes valueForKey:@"cate_name"];
        self.parentId = [[attributes valueForKey:@"parent_id"] intValue];
        self.picture = [attributes valueForKey:@"picture"];
        self.isChild  = [[attributes valueForKey:@"is_child"] intValue];
        NSArray *dataFromServer = [attributes valueForKey:@"sub_cate_list"];
        NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
        
        for (NSDictionary *categoryDic in dataFromServer)
        {
            SubCategoryModel *model = [[SubCategoryModel alloc] initWithAttributes:categoryDic];
            [mutilableData addObject:model];
        }
        self.dataSubCategoryArray = [[NSArray alloc] initWithArray:mutilableData];
    
    }
    return self;
}

/**
 *  二级目录 - 三级目录
 
         "is_child": 1,
         "list_template": "",
         "parent_id": "0",
         "picture": "",
         "sort_order": "255",
         "store_id": "81",
         "sub_cate_list": [
                          {
                             "cate_id": "25173",
                             "cate_name": "壳牌",
                             "conten_template": "",
                             "content": "",
                             "if_show": "1",
                             "index_template": "",
                             "is_child": 1,
                             "list_template": "",
                             "parent_id": "25163",
                             "picture": "",
                             "sort_order": "255",
                             "store_id": "81",
                             "sub_cate_list": [
                                             {
                                                 "cate_id": "25183",
                                                 "cate_name": "喜力",
                                                 "conten_template": "",
                                                 "content": "",
                                                 "if_show": "1",
                                                 "index_template": "",
                                                 "list_template": "",
                                                 "parent_id": "25173",
                                                 "picture": "",
                                                 "sort_order": "255",
                                                 "store_id": "81"
                                             },
                                             {
                                                 "cate_id": "25193",
                                                 "cate_name": "劲霸",
                                                 "conten_template": "",
                                                 "content": "",
                                                 "if_show": "1",
                                                 "index_template": "",
                                                 "list_template": "",
                                                 "parent_id": "25173",
                                                 "picture": "",
                                                 "sort_order": "254",
                                                 "store_id": "81"
                                             },
                                             {
                                                 "cate_id": "25203",
                                                 "cate_name": "其他",
                                                 "conten_template": "",
                                                 "content": "",
                                                 "if_show": "1",
                                                 "index_template": "",
                                                 "list_template": "",
                                                 "parent_id": "25173",
                                                 "picture": "",
                                                 "sort_order": "1",
                                                 "store_id": "81"
                                             }
                                         ]
                         }
                        ]
         },
         {
                         "cate_id": "25213",
                         "cate_name": "自动波箱油",
                         "conten_template": "",
                         "content": "",
                         "if_show": "1",
                         "index_template": "",
                         "is_child": 1,
                         "list_template": "",
                         "parent_id": "0",
                         "picture": "",
                         "sort_order": "20",
                         "store_id": "81",
                         "sub_cate_list": [
                                         {
                                             "cate_id": "50543",
                                             "cate_name": "壳牌",
                                             "conten_template": "",
                                             "content": "",
                                             "if_show": "1",
                                             "index_template": "",
                                             "is_child": 0,
                                             "list_template": "",
                                             "parent_id": "25213",
                                             "picture": "",
                                             "sort_order": "255",
                                             "store_id": "81"
                                         },
                                         {
                                             "cate_id": "25223",
                                             "cate_name": "采埃孚",
                                             "conten_template": "",
                                             "content": "",
                                             "if_show": "1",
                                             "index_template": "",
                                             "is_child": 0,
                                             "list_template": "",
                                             "parent_id": "25213",
                                             "picture": "",
                                             "sort_order": "255",
                                             "store_id": "81"
                                         }
                         ]
         },
 
 */


@end
