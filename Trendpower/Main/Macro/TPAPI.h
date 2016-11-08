//
//  TPAPI.h
//  Trendpower
//
//  Created by trendpower on 15/5/5.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#ifndef Trendpower_TPAPI_h
#define Trendpower_TPAPI_h


//################### 网站地址
#define API_HTTP @"http://"
#define API_DOMAIN @"api.qpfww.com"
#define API_ROOT [API_HTTP stringByAppendingString: API_DOMAIN]

#define API_TEST @"apitest.qpfww.com"

//################### 首页
/** 首页 */
#define API_HOME @"/home?"
/** 启动广告 */
#define API_HOME_AD @"/startpage?"


//################### 查找
/** 查找 */
#define API_FIND @"/find?"
/** 分类 */
#define API_CATEGORY @"/goods/categorys?"
/** 品牌(用于搜索列表) */
#define API_BRANDS @"/goods/brands/"
/** 品牌(用于品牌列表) */
#define API_BRANDS_LIST @"/goods/brands?"
/** 车型 */
#define API_CARTYPES @"/carbrands?"
/** 车型三级信息 */
#define API_CARINOFS @"/carinfos?"
/** 分类查找 */
#define API_CATEGORY_Fetch @"/categorys/"


//################### 会员中心
/** 登陆 POST */
#define API_USER_LOGIN @"/user/login"
/** 注册 POST */
#define API_USER_REGISTER @"/user/register"
/** 找回密码 POST */
#define API_FIND_PW @"/user/findpwd"
/** 修改密码 POST */
#define API_UPDATE_PW @"/user/updatepwd"
/** 发送验证码 POST */
#define API_SMS_SEND @"/sms/send"
/** 获取个人信息 */
#define API_USER_INFO @"/user/show?"
/** 用户资料编辑  POST */
#define API_USER_EDIT @"/user/update"
/** 用户头像上传 POST*/
#define API_USER_PORTRAIT @""

/** 用户意见反馈 */
#define API_USER_DEVICE @"/feedback"
/** 客服QQ和电话 */
#define API_USER_COUSTOMER @"/service"
/** 会员 注销*/
#define API_USER_LOGOUT @"/user/logout"

/** 获取企业信息*/
#define API_COMPANY_INFO @"/companyinfo"

/** 获取企业信息*/
#define API_MY_Credits @"/user/credits?"

/** 根据城市id获取经销商*/
#define API__Dealers @"/agents?"


//################### 址址管理
/** 获取地区列表 GET */
#define API_ADDRESS_REGION @"/region/getregion?"
/** 收货地址列表 */
#define API_ADDRESS_LIST  @"/user/addresses?userId="
/** 添加收货地址 POST */
#define API_ADDRESS_ADD @"/user/addaddress"
/** 修改收货地址 POST */
#define API_ADDRESS_EDIT @"/user/updateaddress"
/** 删除收货地址 */
#define API_ADDRESS_DELETE @"/user/deladdress"
/** 设置默认地址 POST */
#define API_ADDRESS_DEFAULT @"/user/setaddress"




//################### 搜索
/** 获取搜索页的热门关键字 */
#define API_KEYWORDS_HOT @"/keyword?"

/** 根据关键字搜索内容 */
#define API_KEYWORDS_SEARCH @"/carinfos?"


//################### 商品
/** 分类商品列表 */
#define API_GOODS_LIST @"/goods/listgoods?"
/** 商品详情 */
#define API_GOODS_DETAIL @"/goodsinfo?"
/** 适用车型 */
#define API_GOODS_CARMODEL @"/carmodel?"
/** 用户收藏操作 */
#define API_GOODS_COLLECTION @"/collection"
/** 收藏列表 */
#define API_GOODS_COLLECTION_LIST @"/collectionlist?"



//################### 购物车
/** 获取购物车总数 */
#define API_CART_QUANTiTY @"/cart/quantity?"
/** 获取购物车列表 */
#define API_CART_List @"/cart?"
/** 加入购物车 */
#define API_CART_AddCart @"/cart/addcart"
/** 更新购物车某件商品购买数量 */
#define API_CART_UpdateCart @"/cart/updatecart"
/** 选定/取消购物车某件商品 */
#define API_CART_Select @"/cart/select"
/** 删除购物车商品 */
#define API_CART_Delete @"/cart/delete"




//################### 订单
/** 提交订单*/
#define API_ORDER_LIST @"/order/show?"
/** 订单生成*/
#define API_ORDER_CREATE @"/order/create"
/** 立即购买*/
#define API_ORDER_DIRECTBUY @"/order/directbuy"
//user_id  用户id  status订单状态（11 等待买家付款 20买家已付款，等待卖家发货  30卖家已发货   40交易成功   0交易已取消 ）
/** 订单列表 */
#define API_ORDER_MyLIST @"/order/myorder?userId="


/** 提交订单  GET|POST */
#define API_ORDER_PAYMENT @"/order/payment"

/** 订单状态更新  GET|POST */
#define API_ORDER_Update @"/order/update"

/** 我的积分 */
#define API_USER_Points @"/user/points?"

/** 积分商城列表 */
#define API_USER_Pointstore @"/user/pointstore?"

/** 积分商品详细 */
#define API_USER_Pointgoods @"/user/pointgoods?"

/** 积分兑换商品立即购买 */
#define API_POINTORDER_Directbuy @"/pointorder/directbuy"

/** 积分生成订单 */
#define API_POINTORDER_Create @"/pointorder/create"

#endif
