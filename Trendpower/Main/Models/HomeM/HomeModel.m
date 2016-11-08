//
//  HomeModel.m
//  Trendpower
//
//  Created by trendpower on 15/5/13.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

/** 类型判断:
         0、广告  ads_1
         1、分类  cate_list
         2、精品专区 ads_2
         3、热门品牌  hot_brand
         4、广告位   ads_3
         5、广告位   ads_4
         6、广告位   ads_5
         7、热销商品推荐   recommend_list
 */

#import "HomeModel.h"

@implementation HomeModel
- (instancetype) initWithAttributes:(NSDictionary *)data
{
    if ([super init]) {
        
        self.typeArray = [NSMutableArray array];
        self.dataHomeMedelArray = [NSMutableArray array];
        
        NSDictionary * attributes = [data valueForKey:@"data"];
    
        //1.广告
        NSArray * adArray = [attributes valueForKey:@"ads_1"];
        //有广告数组
        if (adArray.count) {
            NSMutableArray *tempAdsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *tempData in adArray){
                AdvertiseModel *adModel = [[AdvertiseModel alloc] initWithAttributes:tempData];
                [tempAdsArray addObject:adModel];
            }
            
            [self.typeArray addObject:@"0"];
            [self.dataHomeMedelArray addObject:tempAdsArray];
        }
        
        
        //2.分类
        NSArray * cateArray = [attributes valueForKey:@"cate_list"];
        //有分类数组
        if (cateArray.count) {
            NSMutableArray *tempCateArray = [[NSMutableArray alloc] init];
            for (NSDictionary *tempData in cateArray){
                HomeCategoryModel *cateModel = [[HomeCategoryModel alloc] initWithAttributes:tempData];
                [tempCateArray addObject:cateModel];
            }
            
            //【人工增加：更多分类】
            HomeCategoryModel *moreModel = [[HomeCategoryModel alloc] init];
            moreModel.cateName = @"更多";
            [tempCateArray addObject:moreModel];
            
            [self.typeArray addObject:@"1"];
            [self.dataHomeMedelArray addObject:tempCateArray];
        }
        
        //3、精品专区 ads_2
        NSArray * ad2Array = [attributes valueForKey:@"ads_2"];
        //有广告数组
        if (ad2Array.count) {
            //保证有5个数组
            NSMutableArray *tempAdsArray = [NSMutableArray arrayWithCapacity:5];
            for (NSDictionary *tempData in ad2Array){
                AdvertiseModel *adModel = [[AdvertiseModel alloc] initWithAttributes:tempData];
                [tempAdsArray addObject:adModel];
            }
            
            [self.typeArray addObject:@"2"];
            [self.dataHomeMedelArray addObject:tempAdsArray];
        }
        
        
        //4、热门品牌  hot_brand
        NSArray * brandArray = [attributes valueForKey:@"hot_brand"];
        //有品牌数组
        if (brandArray.count) {
            NSMutableArray *tempCateArray = [[NSMutableArray alloc] init];
            for (NSDictionary *tempData in brandArray){
                BrandModel *cateModel = [[BrandModel alloc] initWithAttributes:tempData];
                [tempCateArray addObject:cateModel];
            }
            
            [self.typeArray addObject:@"3"];
            [self.dataHomeMedelArray addObject:tempCateArray];
        }
        
        
        //5、广告位   ads_3
        NSArray * ad3Array = [attributes valueForKey:@"ads_3"];
        //有广告数组
        if (ad3Array.count) {
            //保证有5个数组
            NSMutableArray *tempAdsArray = [NSMutableArray arrayWithCapacity:5];
            for (NSDictionary *tempData in ad3Array){
                AdvertiseModel *adModel = [[AdvertiseModel alloc] initWithAttributes:tempData];
                [tempAdsArray addObject:adModel];
            }
            
            [self.typeArray addObject:@"4"];
            [self.dataHomeMedelArray addObject:tempAdsArray];
        }
        
        
        //6、广告位   ads_4
        NSArray * ad4Array = [attributes valueForKey:@"ads_4"];
        //有广告数组
        if (ad4Array.count) {
            NSMutableArray *tempAdsArray = [NSMutableArray array];
            for (NSDictionary *tempData in ad4Array){
                AdvertiseModel *adModel = [[AdvertiseModel alloc] initWithAttributes:tempData];
                [tempAdsArray addObject:adModel];
            }
            
            [self.typeArray addObject:@"5"];
            [self.dataHomeMedelArray addObject:tempAdsArray];
        }

        //7、广告位   ads_5
        NSArray *ad5Array = [attributes valueForKey:@"ads_5"];
        if (ad5Array.count) {

            NSMutableArray *tempAdsArray = [NSMutableArray array];

            for (NSDictionary *tempData in ad5Array){

                AdvertiseModel *adModel = [[AdvertiseModel alloc] initWithAttributes:tempData];
                [tempAdsArray addObject:adModel];
            }

            [self.typeArray addObject:@"6"];
            [self.dataHomeMedelArray addObject:tempAdsArray];
        }
        
        //8、热销商品推荐   recommend_list
        NSArray * goodsArray = [attributes valueForKey:@"recommend_list"];
        //有促销产品
        if (goodsArray.count) {
            NSMutableArray *tempGoodsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *tempData in goodsArray){
                HomeGoodsModel * goodsModel = [[HomeGoodsModel alloc] initWithAttributes:tempData];
                [tempGoodsArray addObject:goodsModel];
            }
            
            [self.typeArray addObject:@"7"];
            [self.dataHomeMedelArray addObject:tempGoodsArray];
        }

    }
    
    return self;
}

@end

/**
{
    "data": {
        "ads_1": [
                  {
                      "ad_type": "1",
                      "ad_value": "1",
                      "file_name": "http://assets.qpfww.com/adsement/14281452656582.jpg",
                      "remark": "",
                      "title": "App首页顶部轮播广告1"
                  },
                  {
                      "ad_type": "3",
                      "ad_value": "",
                      "file_name": "http://assets.qpfww.com/adsement/24181452656597.jpg",
                      "remark": "",
                      "title": "App首页顶部轮播广告2"
                  }
                  ],
        "ads_2": [
                  {
                      "ad_type": "2",
                      "ad_value": "2",
                      "file_name": "",
                      "remark": "",
                      "title": "App首页精品专区大图"
                  },
                  {
                      "ad_type": "2",
                      "ad_value": "",
                      "file_name": "",
                      "remark": "",
                      "title": "App首页精品专区小图"
                  },
                  {
                      "ad_type": "2",
                      "ad_value": "2",
                      "file_name": null,
                      "remark": null,
                      "title": "App首页精品专区小图"
                  },
                  {
                      "ad_type": "2",
                      "ad_value": "3",
                      "file_name": null,
                      "remark": null,
                      "title": "App首页精品专区小图"
                  },
                  {
                      "ad_type": "2",
                      "ad_value": "3",
                      "file_name": null,
                      "remark": null,
                      "title": "App首页精品专区小图"
                  }
                  ],
        "cate_list": [
                      {
                          "icon": "",
                          "id": "1",
                          "parent_id": "0",
                          "title": "蓄电池"
                      },
                      {
                          "icon": null,
                          "id": "2",
                          "parent_id": "1",
                          "title": "免维护蓄电池"
                      },
                      {
                          "icon": null,
                          "id": "8",
                          "parent_id": "7",
                          "title": "刹车盘"
                      },
                      {
                          "icon": null,
                          "id": "18",
                          "parent_id": "17",
                          "title": "变速箱滤清器"
                      },
                      {
                          "icon": null,
                          "id": "25",
                          "parent_id": "24",
                          "title": "火花塞"
                      },
                      {
                          "icon": null,
                          "id": "30",
                          "parent_id": "29",
                          "title": "HID氙气车灯"
                      },
                      {
                          "icon": null,
                          "id": "39",
                          "parent_id": "38",
                          "title": "机油"
                      }
                      ],
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
                      {
                          "brand_type": "3",
                          "file_name": "http://assets.qpfww.com/goodsbrand/92641450084941.png",
                          "goods_brand_code": "Y8345V4XC",
                          "id": "3852962",
                          "initial": "3",
                          "title": "3M"
                      },
                      {
                          "brand_type": "3",
                          "file_name": "http://assets.qpfww.com/goodsbrand/44241450140623.jpg",
                          "goods_brand_code": "568XN4WX8",
                          "id": "3852963",
                          "initial": "N",
                          "title": "nova"
                      },
                      {
                          "brand_type": "3",
                          "file_name": "http://assets.qpfww.com/goodsbrand/56621450140945.png",
                          "goods_brand_code": "A38T348U4",
                          "id": "3852964",
                          "initial": "T",
                          "title": "TRW"
                      },
                      {
                          "brand_type": "3",
                          "file_name": "http://assets.qpfww.com/goodsbrand/89441450141038.jpg",
                          "goods_brand_code": "7N4A837A5",
                          "id": "3852965",
                          "initial": "A",
                          "title": "阿波罗"
                      },
                      {
                          "brand_type": "3",
                          "file_name": "http://assets.qpfww.com/goodsbrand/56391450141256.jpg",
                          "goods_brand_code": "NU46X7CW7",
                          "id": "3852966",
                          "initial": "D",
                          "title": "德尔福"
                      },
                      {
                          "brand_type": "3",
                          "file_name": "http://assets.qpfww.com/goodsbrand/39591450141290.png",
                          "goods_brand_code": "XK47YK3U3",
                          "id": "3852967",
                          "initial": "F",
                          "title": "飞利浦"
                      }
                      ],
        "hot_list": [
        ],
        "new_list": [
        ],
        "recommend_list": [
                           {
                               "check_status": "0",
                               "cost_price": "0.00",
                               "file_name": null,
                               "goods_code": "U67883YW6",
                               "goods_no": "FPCH8158",
                               "goods_status": "1",
                               "id": "26113",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "方牌机油滤清器CH8158进口奥迪：Q7 进口大众：辉腾 途锐 FPCH8158",
                               "vip_lowest_price": null,
                               "vip_price": null
                           },
                           {
                               "check_status": "0",
                               "cost_price": "0.00",
                               "file_name": "http://assets.qpfww.com/goods/0000/0002/7393/27393/77981449305749.jpg",
                               "goods_code": "YVY38U736",
                               "goods_no": "JL0100001",
                               "goods_status": "1",
                               "id": "27393",
                               "is_source": "1",
                               "source_id": "0",
                               "title": "嘉乐驰（绿牌）36B20R(细) , 6-QW-36（36Ah）嘉乐驰绿牌蓄电池 嘉乐驰蓄电池 嘉乐驰电池",
                               "vip_lowest_price": "0.00",
                               "vip_price": "299.00"
                           },
                           {
                               "check_status": "0",
                               "cost_price": "0.00",
                               "file_name": null,
                               "goods_code": "C46A44353",
                               "goods_no": "WBP23945A",
                               "goods_status": "1",
                               "id": "31233",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "WBP23945A 瓦格纳前刹车片车型奔驰C 200 CGI Kompressor (W203)排量1.8年份2003/",
                               "vip_lowest_price": null,
                               "vip_price": null
                           },
                           {
                               "check_status": "0",
                               "cost_price": "0.00",
                               "file_name": "http://assets.qpfww.com/goods/0000/0003/2513/32513/63711451898609.jpg",
                               "goods_code": "885XUV36T",
                               "goods_no": "TEXTAR92115103",
                               "goods_status": "1",
                               "id": "32513",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "TEXTAR92115103 泰明顿刹车盘, 前奔驰 E (W211) 汽车零配件",
                               "vip_lowest_price": "0.00",
                               "vip_price": "653.00"
                           },
                           {
                               "check_status": "0",
                               "cost_price": "0.00",
                               "file_name": "http://assets.qpfww.com/goods/0000/0003/3793/33793/97281451976645.jpg",
                               "goods_code": "U57AK368X",
                               "goods_no": "TEXTAR92160703",
                               "goods_status": "1",
                               "id": "33793",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "TEXTAR92160703 泰明顿刹车盘, 后奔驰 S (W221) 汽车零配件",
                               "vip_lowest_price": "0.00",
                               "vip_price": "724.00"
                           },
                           {
                               "check_status": "0",
                               "cost_price": "0.00",
                               "file_name": "http://assets.qpfww.com/goods/0000/0003/5073/35073/16601449891014.jpg",
                               "goods_code": "8U48UKW5C",
                               "goods_no": "TEXTAR2327907",
                               "goods_status": "1",
                               "id": "35073",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "TEXTAR2327907 泰明顿刹车片, 前福特蒙迪欧 品牌汽车零配件",
                               "vip_lowest_price": "0.00",
                               "vip_price": "418.00"
                           },
                           {
                               "check_status": "0",
                               "cost_price": "0.00",
                               "file_name": "http://assets.qpfww.com/goods/0000/0003/6353/36353/91101449907468.jpg",
                               "goods_code": "W8W855U87",
                               "goods_no": "TEXTAR2423105",
                               "goods_status": "1",
                               "id": "36353",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "TEXTAR2423105 泰明顿刹车片, 后东风本田 CRV， 广汽本田 歌诗图 品牌汽车零配件",
                               "vip_lowest_price": "0.00",
                               "vip_price": "289.00"
                           },
                           {
                               "check_status": "0",
                               "cost_price": "0.00",
                               "file_name": "http://assets.qpfww.com/goods/0000/0003/7633/37633/54371451726336.jpg",
                               "goods_code": "3683688V3",
                               "goods_no": "TEXTAR2577001",
                               "goods_status": "1",
                               "id": "37633",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "TEXTAR2577001 泰明顿刹车片, 前广汽传祺 GA3 品牌汽车零配件",
                               "vip_lowest_price": "0.00",
                               "vip_price": "419.00"
                           },
                           {
                               "check_status": "0",
                               "cost_price": "0.00",
                               "file_name": null,
                               "goods_code": "N738N7TU8",
                               "goods_no": "WBP24491A-D",
                               "goods_status": "1",
                               "id": "38913",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "WBP24491A-D 瓦格纳后刹车片车型起亚佳乐排量2.0年份2006/09 佳乐排量1.6年份2009",
                               "vip_lowest_price": null,
                               "vip_price": null
                           },
                           {
                               "check_status": "1",
                               "cost_price": "0.00",
                               "file_name": "http://assets.qpfww.com/goods/0000/0004/1473/41473/30331452416444.jpg",
                               "goods_code": "38A6A7754",
                               "goods_no": "MPW 610/1",
                               "goods_status": "1",
                               "id": "41473",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "曼牌机油滤清器MPW 610/1,利亚纳,北斗星 铃木天语SX4 1.6(07-10)1.8(09-)超级维特拉1.6 2.0 2.4(02-)",
                               "vip_lowest_price": "0.00",
                               "vip_price": "41.00"
                           },
                           {
                               "check_status": "1",
                               "cost_price": "0.00",
                               "file_name": "http://assets.qpfww.com/goods/0000/0004/2753/42753/97991452849271.jpg",
                               "goods_code": "N866347C4",
                               "goods_no": "MPC 2695/2",
                               "goods_status": "1",
                               "id": "42753",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "曼牌空气滤清器MPC 2695/2,奔驰S600 M137",
                               "vip_lowest_price": "0.00",
                               "vip_price": "171.00"
                           },
                           {
                               "check_status": "0",
                               "cost_price": "0.00",
                               "file_name": null,
                               "goods_code": "5T7643KTN",
                               "goods_no": "MPCU 24 004",
                               "goods_status": "1",
                               "id": "44033",
                               "is_source": "2",
                               "source_id": "10",
                               "title": "曼牌空调滤清器MPCU 24 004,ix35,途胜",
                               "vip_lowest_price": null,
                               "vip_price": null
                           }
                           ]
    },
    "msg": "请求成功",
    "status": 1
}

 */