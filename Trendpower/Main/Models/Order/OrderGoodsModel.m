//
//  OrderGoodsModel.m
//  EcmallAPP
//
//  Created by zhanghongbo on 14-2-20.
//  Copyright (c) 2014年 tendpower. All rights reserved.
//

#import "OrderGoodsModel.h"

@implementation OrderGoodsModel

-(instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if([super init])
    {
        self.recId = [[attributes valueForKey:@"goodsCode"] longLongValue];
//        self.userId = [[attributes valueForKey:@"user_id"] longLongValue];
//        self.sessionId = [attributes valueForKey:@"session_id"];
//        self.storeId = [[attributes valueForKey:@"store_id"] intValue];
        self.productId = [[attributes valueForKey:@"goodsId"] longLongValue];
        self.productName = [attributes valueForKey:@"goodsTitle"];
//        self.specification = [attributes valueForKey:@"memo"];
        self.price = [attributes valueForKey:@"goodsUnitPrice"];
        self.priceMember = [attributes valueForKey:@"payUnitPrice"];
        self.subtotal = [attributes valueForKey:@"goodsAmount"];
        self.quantity = [[attributes valueForKey:@"goodsQuantity"] intValue];
        self.productImageURL = [attributes valueForKey:@"defaultImg"];
//        self.exist = [[attributes valueForKey:@"exist"] intValue];
        self.goodsPoint = [[attributes valueForKey:@"goodsPoint"] integerValue];
        
    }
    return self;
}

/**
 *  	"data": [
                 {
                 "add_time": "2015-04-28 14:59:57",
                 "address": "去哪了吧",
                 "adjust_fee": "0.00",
                 "buyer_email": "yyy@1.com",
                 "buyer_id": "32153",
                 "buyer_name": "testing",
                 "coin_money": "0.00",
                 "consignee": "天气",
                 "coupon_fee": "0.00",
                 "discount": "0.00",
                 "evaluation_status": "0",
                 "extend_params": "",
                 "extension": "normal",
                 "finish_time": "1970-01-01 08:00:00",
                 "finished_time": "0",
                 "goods_amount": "4467.00",
                 "invoice_no": "",
                 "item_id": "0",
                 "order_amount": "4477.00",
                 "order_id": "2763",
                 "order_sn": "2015042880130",
                 "out_trade_sn": "",
                 "pay_message": "",
                 "pay_time": "1970-01-01 08:00:00",
                 "payment_code": "wxpay",
                 "payment_id": "683",
                 "payment_name": "微支付",
                 "phone_mob": "13000000000",
                 "phone_tel": "1111111",
                 "postscript": "0",
                 "region_id": "41",
                 "region_name": "天津市天津周边静海县",
                 "seller_id": "0",
                 "seller_name": "广东泰兴隆润滑油有限公司",
                 "seller_note": "",
                 "ship_time": "1970-01-01 08:00:00",
                 "shipping_fee": "10.00",
                 "shipping_id": "303",
                 "shipping_name": "圆通",
                 "source": "0",
                 "status": "11",
                 "store_id": "81",
                 "surplus_money": "0.00",
                 "terminal": "app",
                 "total": "9",
                 "total_net_turnover": "0.00",
                 "type": "0",
                 "updated_at": "2015-05-15 08:39:40",
                 "zipcode": "123456"
                 "order_goods": [
                                 {
                                     "discount": "0.00",
                                     "discount_info": "",
                                     "extension_param": "",
                                     "goods_id": "50323",
                                     "goods_image": "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/553af5f756c30.jpg",
                                     "goods_name": "嘉乐驰（绿牌）55B24L细(S/T大) , 6-QW-45（45Ah）",
                                     "memo": "",
                                     "order_id": "2763",
                                     "original_price": "450.00",
                                     "price": "450.00",
                                     "quantity": "1",
                                     "rec_id": "3013",
                                     "spec_id": "0",
                                     "specification": "",
                                     "store_id": "81",
                                     "subtotal": "450.00"
                                 },
                                 {
                                     "discount": "0.00",
                                     "discount_info": "",
                                     "extension_param": "",
                                     "goods_id": "26373",
                                     "goods_image": "http://pic.qushiyun.com/taixinlongmall.tpsite.qushiyun.com/5526388a74cf2.jpg",
                                     "goods_name": "壳牌施倍力齿轮油S2 A85W-140 4L 波箱油 18L 大桶变速箱油209L",
                                     "memo": "",
                                     "order_id": "2763",
                                     "original_price": "458.00",
                                     "price": "458.00",
                                     "quantity": "1",
                                     "rec_id": "3023",
                                     "spec_id": "117333",
                                     "specification": "规格1:S2 A85W-140 18L ",
                                     "store_id": "81",
                                     "subtotal": "458.00"
                                 }
                                ]
                 },
 */

@end
