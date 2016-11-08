
//
//  RegionModel.m
//  EcmallAPP
//
//  Created by zhanghongbo on 14-1-17.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import "RegionModel.h"


@implementation RegionModel


-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
   
        self.regionId = [attributes valueForKey:@"region_id"];
        self.regionName = [attributes valueForKey:@"region_name"];
        self.parentId = [attributes valueForKey:@"parent_id"];
        self.isDefault = [attributes valueForKey:@"is_default"];
        self.level = [attributes valueForKey:@"level"];
        
        //如果是默认地址，就到下一级
        if([self.isDefault intValue] == 1){
            
            NSArray *childArray = [attributes valueForKey:@"child"];
            NSMutableArray *mutilableData = [[NSMutableArray alloc] init];
            [childArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
                
                RegionChildModel *model = [[RegionChildModel alloc] initWithAttributes:dic];
                [mutilableData addObject:model];
                
                if ([[dic valueForKey:@"is_default"] intValue] == 1) {
                    self.defaultRow = idx;
                    //NSLog(@"2---%d",idx);
                }
                
            }];
            
            self.dataChildModelArray = [[NSArray alloc] initWithArray:mutilableData];
            
        }
    }
    return self;
}

@end
/*

     {
             "data": [
             {
                     "child": [
                     {
                                     "child": [
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "3",
                                     "region_name": "东城区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "4",
                                     "region_name": "西城区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "5",
                                     "region_name": "崇文区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "6",
                                     "region_name": "宣武区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "7",
                                     "region_name": "朝阳区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "8",
                                     "region_name": "丰台区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "9",
                                     "region_name": "石景山区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "10",
                                     "region_name": "海淀区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "11",
                                     "region_name": "门头沟区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "12",
                                     "region_name": "房山区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "13",
                                     "region_name": "通州区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "14",
                                     "region_name": "顺义区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "15",
                                     "region_name": "昌平区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "16",
                                     "region_name": "大兴区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "17",
                                     "region_name": "怀柔区"
                                     },
                                     {
                                     "level": "3",
                                     "parent_id": "2",
                                     "region_id": "18",
                                     "region_name": "平谷区"
                                     }
                                     ],
                             "is_default": 1,
                             "level": "2",
                             "parent_id": "1",
                             "region_id": "2",
                             "region_name": "市辖区"
                         },
                         {s
                             "is_default": 0,
                             "level": "2",
                             "parent_id": "1",
                             "region_id": "19",
                             "region_name": "北京周边"
                             }
                         ],
                         "is_default": 1,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "1",
                         "region_name": "北京市"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "22",
                         "region_name": "天津市"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "43",
                         "region_name": "河北省"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "227",
                         "region_name": "山西省"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "358",
                         "region_name": "内蒙古自治区"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "472",
                         "region_name": "辽宁省"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "587",
                         "region_name": "吉林省"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "657",
                         "region_name": "黑龙江省"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "801",
                         "region_name": "上海市"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "823",
                         "region_name": "江苏省"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "943",
                         "region_name": "浙江省"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "1045",
                         "region_name": "安徽省"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "1168",
                         "region_name": "福建省"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "1263",
                         "region_name": "江西省"
                     },
                     {
                         "is_default": 0,
                         "level": "1",
                         "parent_id": "0",
                         "region_id": "1374",
                         "region_name": "山东省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "1532",
                     "region_name": "河南省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "1709",
                     "region_name": "湖北省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "1826",
                     "region_name": "湖南省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "1963",
                     "region_name": "广东省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "2106",
                     "region_name": "广西壮族自治区"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "2230",
                     "region_name": "海南省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "2257",
                     "region_name": "重庆市"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "2301",
                     "region_name": "四川省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "2504",
                     "region_name": "贵州省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "2602",
                     "region_name": "云南省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "2748",
                     "region_name": "西藏自治区"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "2829",
                     "region_name": "陕西省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "2947",
                     "region_name": "甘肃省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "3048",
                     "region_name": "青海省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "3100",
                     "region_name": "宁夏回族自治区"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "3127",
                     "region_name": "新疆维吾尔自治区"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "3242",
                     "region_name": "台湾省"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "3243",
                     "region_name": "香港特别行政区"
                     },
                     {
                     "is_default": 0,
                     "level": "1",
                     "parent_id": "0",
                     "region_id": "3244",
                     "region_name": "澳门特别行政区"
                     }
                     ],
             "msg": "获取成功",
             "status": 1
     }

*/