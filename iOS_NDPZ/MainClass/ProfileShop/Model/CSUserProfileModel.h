//
//  CSUserProfileModel.h
//  iOS_NDPZ
//
//  Created by zhang on 17/6/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSUserVIP,CSUserBudget;
@interface CSUserProfileModel : NSObject

+ (CSUserProfileModel *)sharInstance;
- (void)loginOut;

@property (nonatomic, copy) NSString *profileID;                // 用户id
@property (nonatomic, copy) NSString *url;                      //
@property (nonatomic, copy) NSString *user_id;                  // 用户注册ID
@property (nonatomic, copy) NSString *username;                 // 用户姓名
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *modified;

@property (nonatomic, strong) CSUserVIP *xiaolumm;
@property (nonatomic, copy) NSString *has_usable_password;
@property (nonatomic, copy) NSString *has_password;
@property (nonatomic, strong) CSUserBudget *user_budget;
@property (nonatomic, copy) NSString *is_attention_public;
@property (nonatomic, copy) NSString *coupon_num;
@property (nonatomic, copy) NSString *waitpay_num;
@property (nonatomic, copy) NSString *waitgoods_num;
@property (nonatomic, copy) NSString *refunds_num;
@property (nonatomic, copy) NSString *xiaolu_coin;
@property (nonatomic, copy) NSString *check_xiaolumm;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthday_display;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;




@end

@interface CSUserVIP : NSObject

@property (nonatomic, copy) NSString *UserVipID;
@property (nonatomic, copy) NSString *cash;
@property (nonatomic, copy) NSString *agencylevel;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *referal_from;
@property (nonatomic, copy) NSString *last_renew_type;
@property (nonatomic, copy) NSString *charge_status;
@property (nonatomic, copy) NSString *elite_score;
@property (nonatomic, copy) NSString *renew_time;


@end


@interface CSUserBudget : NSObject

@property (nonatomic, copy) NSString *budget_cash;
@property (nonatomic, assign) BOOL *is_cash_out;
@property (nonatomic, copy) NSString *cash_out_limit;

@end










/*
 (lldb) po responseObject
 {
 birthday_display = "";
 "check_xiaolumm" = 0;
 city = "";
 "coupon_num" = 0;
 created = "2017-04-24T17:08:31.825465";
 district = "";
 email = "";
 "has_password" = 0;
 "has_usable_password" = 0;
 id = 5;
 "is_attention_public" = 1;
 mobile = 13916255844;
 modified = "2017-06-04T17:19:34.888475";
 nick = "\U6768\U519b";
 phone = "";
 province = "";
 "refunds_num" = 0;
 score = 116;
 sex = 0;
 status = 1;
 thumbnail = "http://wx.qlogo.cn/mmopen/m2mF3ZhFpL6Vq7WLzBqoPBMfXA14SE1nP1k3tPibxzmcMy6rcI5t8ZzwqQkSxtZoJn2YYiayTGpRELbaG9FAFtEeJZNthX4Vvm/0";
 url = "";
 "user_budget" =     {
 "budget_cash" = "2097.9";
 "cash_out_limit" = 2;
 "is_cash_out" = 1;
 };
 "user_id" = 19;
 username = oDifH0wVTjj9NoFOtxpNNLDNW9ag;
 "waitgoods_num" = 2;
 "waitpay_num" = 0;
 "xiaolu_coin" = 0;
 xiaolumm =     {
 agencylevel = 3;
 cash = 0;
 "charge_status" = charged;
 created = "2017-05-10T13:38:12.753941";
 "elite_score" = 0;
 id = 600010;
 "last_renew_type" = 365;
 "referal_from" = DIRECT;
 "renew_time" = "2018-05-17T10:57:31.745833";
 status = effect;
 };
 }
 
 */


