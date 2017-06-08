//
//  CSGoodsDetailModel.h
//  iOS_NDPZ
//
//  Created by zhang on 17/6/2.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark ---- 商品详情Model
@class CSGoodsDetailContentModel;
@interface CSGoodsDetailModel : NSObject


@property (nonatomic, copy) NSString *goodsModelID;             // 商品ID
@property (nonatomic, strong) NSArray *sku_info;                // 商品 规格属性
@property (nonatomic, strong) CSGoodsDetailContentModel *detail_content;     // 商品内容
@property (nonatomic, strong) NSDictionary *comparison;         // 商品规格对照表
@property (nonatomic, strong) NSDictionary *custom_info;        // 自定义信息
@property (nonatomic, strong) NSDictionary *teambuy_info;       // 团购信息
@property (nonatomic, copy) NSString *buy_coupon_url;           // 购买优惠券链接
@property (nonatomic, copy) NSString *source_type;              // 未知 ???
@property (nonatomic, copy) NSString *stock;                    // 商品库存
@property (nonatomic, copy) NSString *selling_num;              // 商品售卖人数
@property (nonatomic, strong) NSDictionary *profit;             // 赚取佣金
@property (nonatomic, assign) BOOL is_flashsale;                // 是否为特卖商品





@end


#pragma mark ---- 商品详情内容Model
@interface CSGoodsDetailContentModel : NSObject

@property (nonatomic, copy) NSString *sale_time;                // 售卖时间
@property (nonatomic, assign) BOOL is_boutique;                 // 是否为精品商品
@property (nonatomic, assign) BOOL is_recommend;                // 是否为??? (未知)
@property (nonatomic, strong) NSArray *content_imgs;            // 内容视图 (暂未使用)
@property (nonatomic, copy) NSString *web_url;                  // 网页商品详情
@property (nonatomic, assign) BOOL is_sale_out;                 // 是否已抢光 (直接购买,不可添加购物车)
@property (nonatomic, strong) NSDictionary *category;           // 所属分类?
@property (nonatomic, copy) NSString *model_code;               //
@property (nonatomic, strong) NSArray *head_imgs;               // 头部滚动视图
@property (nonatomic, copy) NSString *lowest_std_sale_price;    // 原价
@property (nonatomic, copy) NSString *lowest_agent_price;       // 现价
@property (nonatomic, assign) BOOL is_saleopen;                 // 是否开售
@property (nonatomic, copy) NSString *sale_state;               // 售卖状态
@property (nonatomic, copy) NSString *offshelf_time;            // 结束售卖时间
@property (nonatomic, copy) NSString *onshelf_time;             // 开始售卖时间
@property (nonatomic, assign) BOOL is_flatten;                  // 未知 ???
@property (nonatomic, strong) NSDictionary *properties;         // 未知 ???
@property (nonatomic, assign) BOOL is_onsale;                   // 是否秒杀
@property (nonatomic, assign) BOOL is_newsales;                 // 未知 ???
@property (nonatomic, copy) NSString *product_type;             // 产品类型
@property (nonatomic, copy) NSString *name;                     // 产品名称
@property (nonatomic, copy) NSString *watermark_op;             // 水印
@property (nonatomic, copy) NSString *refund_tips_url;          // 七天退换货 网页
@property (nonatomic, strong) NSArray *item_marks;              // 包邮
@property (nonatomic, copy) NSString *head_img;                 // 头部滚动视图 (只有一张图 -> 第一张图)





















@end


/*
 (lldb) po goodsDetailDic
 {
 "buy_coupon_url" = "";
 comparison =     {
 attributes =         (
 {
 name = "\U5546\U54c1\U7f16\U7801";
 value = SP0035;
 },
 {
 name = "\U4fdd\U8d28\U671f";
 value = "\U6682\U65e0";
 }
 );
 metrics =         {
 };
 tables =         (
 );
 };
 "custom_info" =     {
 "is_favorite" = 0;
 };
 "detail_content" =     {
 category =         {
 id = 103;
 };
 "content_imgs" =         (
 "http://img.nidepuzi.com/img_1494311006234.jpg",
 "http://img.nidepuzi.com/img_1494311006242.jpg",
 "http://img.nidepuzi.com/img_1494311006251.jpg",
 "http://img.nidepuzi.com/img_1494311006263.jpg",
 "http://img.nidepuzi.com/img_1494311006271.jpg",
 "http://img.nidepuzi.com/img_1494311006289.jpg",
 "http://img.nidepuzi.com/img_1494311006299.jpg",
 "http://img.nidepuzi.com/img_1494311006310.jpg",
 "http://img.nidepuzi.com/img_1494311006321.gif",
 "http://img.nidepuzi.com/img_1494311006328.jpg",
 "http://img.nidepuzi.com/img_1494311006337.jpg",
 "http://img.nidepuzi.com/img_1494311006356.jpg",
 "http://img.nidepuzi.com/img_1494311006363.jpg"
 );
 "head_img" = "http://img.nidepuzi.com/img_1494310977938.jpg";
 "head_imgs" =         (
 "http://img.nidepuzi.com/img_1494310990902.jpg"
 );
 "is_boutique" = 0;
 "is_flatten" = 0;
 "is_newsales" = 0;
 "is_onsale" = 0;
 "is_recommend" = 0;
 "is_sale_out" = 0;
 "is_saleopen" = 0;
 "item_marks" =         (
 "\U5305\U90ae"
 );
 "lowest_agent_price" = 59;
 "lowest_std_sale_price" = 79;
 "model_code" = SP0035;
 name = "\U3010\U70eb\U8863\U795e\U5668 \U629a\U5e73\U8936\U76b1\U3011\U73b0\U4ee3\U624b\U6301\U5f0f\U84b8\U6c7d\U71a8\U70eb\U673a  XT-F8211";
 "offshelf_time" = "2021-05-31T19:00:23";
 "onshelf_time" = "2017-05-11T20:00:00";
 "product_type" = 0;
 properties =         {
 };
 "refund_tips_url" = "http://mp.weixin.qq.com/s/yZLmaCV8rTGUlJfSohn--Q";
 "sale_state" = on;
 "sale_time" = "2017-05-11T20:00:00";
 "watermark_op" = "watermark/1/image/aHR0cDovL29wMDR5eGV0ci5ia3QuY2xvdWRkbi5jb20vd2F0ZXJtYXJrMTcwNjAyeDEwLnBuZz9pbWFnZU1vZ3IyL3N0cmlwL2Zvcm1hdC9wbmcvaW50ZXJsYWNlLzEvdGh1bWJuYWlsLzY0MC8=/dissovle/80/gravity/Center/dx/0/dy/0/ws/1";
 "web_url" = "https://m.nidepuzi.com/mall/product/details/200";
 };
 extras =     {
 };
 id = 200;
 "is_flashsale" = 1;
 profit =     {
 max = 10;
 min = 10;
 };
 "selling_num" = 56;
 "sku_info" =     (
 {
 "agent_price" = 59;
 "elite_score" = 0;
 "is_saleout" = 0;
 "lowest_price" = 59;
 name = "\U7edf\U4e00\U89c4\U683c";
 "outer_id" = SP00355;
 "product_id" = 364;
 "product_img" = "http://img.nidepuzi.com/img_1494310990902.jpg";
 "sku_items" =             (
 {
 "agent_price" = 59;
 "free_num" = 1000;
 "is_saleout" = 0;
 name = "\U7ecf\U5178";
 "sku_id" = 426;
 "std_sale_price" = 79;
 type = size;
 }
 );
 "std_sale_price" = 79;
 type = color;
 }
 );
 "source_type" = 1;
 stock = 1000;
 "teambuy_info" =     {
 teambuy = 0;
 };
 }
 */







