//
//  JMFineCouponModel.h
//  XLMM
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMFineCouponModel : NSObject



@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *fineCouponModelID;
@property (nonatomic, copy) NSString *is_saleout;
@property (nonatomic, copy) NSString *lowest_agent_price;
@property (nonatomic, copy) NSString *lowest_std_sale_price;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *offshelf_time;
@property (nonatomic, copy) NSString *onshelf_time;
@property (nonatomic, strong) NSDictionary *profit;
@property (nonatomic, copy) NSString *sale_state;
@property (nonatomic, copy) NSString *watermark_op;
@property (nonatomic, copy) NSString *web_url;
@property (nonatomic, copy) NSString *elite_score;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *selling_num;








@end



/*
 
 {
 "category_id" = 137;
 "elite_score" = 0;
 "head_img" = "http://img.nidepuzi.com/img_1495184281156.jpg";
 id = 175;
 "is_saleout" = 0;
 "lowest_agent_price" = 146;
 "lowest_std_sale_price" = 198;
 name = "\U65e5\U672c\U6811\U4e4b\U60e0\U7f8e\U4eba\U8db3\U8d34-\U827e\U834930\U7247";
 "offshelf_time" = "2021-06-30T23:59:59";
 "onshelf_time" = "2017-05-15T14:34:40";
 profit =             {
 max = "14.6";
 min = "14.6";
 };
 "sale_state" = on;
 "selling_num" = 189;
 stock = 100;
 "watermark_op" = "";
 "web_url" = "https://m.nidepuzi.com/mall/product/details/175";
 }

 
 */

