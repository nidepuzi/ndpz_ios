//
//  JMMaMaCenterModel.h
//  XLMM
//
//  Created by zhang on 17/4/1.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSMamaExtraFigures,CSMamaExtraInfo;
@interface JMMaMaCenterModel : NSObject
/**
 *  活跃值
 */
@property (nonatomic, copy) NSString *active_value_num;
/**
 *  可提取现金
 */
@property (nonatomic, copy) NSString *carry_cashout_display;
/**
 *  确定可以使用
 */
@property (nonatomic, copy) NSString *carry_confirmed_display;
/**
 *  未确定可以使用
 */
@property (nonatomic, copy) NSString *carry_pending_display;
/**
 *  自购佣金
 */
@property (nonatomic, copy) NSString *cash_self_display;
/**
 *  分享佣金
 */
@property (nonatomic, copy) NSString *cash_share_display;

/**
 *  可用金额 (收益金额)
 */
@property (nonatomic, copy) NSString *carry_value;
/**
 *  现金金额(账户余额)
 */
@property (nonatomic, copy) NSString *cash_value;

@property (nonatomic, copy) NSString *created;
/**
 *  每日推送未读标记
 */
@property (nonatomic, copy) NSString *current_dp_turns_num;
/**
 *  粉丝数量
 */
@property (nonatomic, copy) NSString *fans_num;

@property (nonatomic, copy) NSString *history_last_day;
/**
 *  邀请数量
 */
@property (nonatomic, copy) NSString *invite_num;
@property (nonatomic, copy) NSString *invite_all_num;
@property (nonatomic, copy) NSString *invite_trial_num;

/**
 *  精品活动链接
 */
@property (nonatomic, copy) NSString *mama_event_link;

@property (nonatomic, copy) NSString *mama_id;

@property (nonatomic, copy) NSString *mama_level;
/**
 *  妈妈等级显示
 */
@property (nonatomic, copy) NSString *mama_level_display;

@property (nonatomic, copy) NSString *mama_name;

@property (nonatomic, copy) NSString *modified;
/**
 *  订单数量
 */
@property (nonatomic, copy) NSString *order_num;
/**
 *  今日访问数量
 */
@property (nonatomic, copy) NSString *today_visitor_num;

@property (nonatomic, strong) CSMamaExtraInfo *extra_info;

@property (nonatomic, strong) CSMamaExtraFigures *extra_figures;

@end



@interface CSMamaExtraFigures : NSObject

@property (nonatomic, copy) NSString *month_duration_total;
@property (nonatomic, copy) NSString *personal_total_rank;
@property (nonatomic, copy) NSString *task_percentage;
@property (nonatomic, copy) NSString *team_total_rank;
@property (nonatomic, copy) NSString *today_carry_record;
@property (nonatomic, copy) NSString *week_duration_rank;
@property (nonatomic, copy) NSString *week_duration_total;



@end

@interface CSMamaExtraInfo : NSObject

@property (nonatomic, copy) NSString *agencylevel;
@property (nonatomic, copy) NSString *agencylevel_display;
@property (nonatomic, copy) NSString *cashout_reason;
@property (nonatomic, copy) NSString *could_cash_out;
@property (nonatomic, copy) NSString *his_confirmed_cash_out;
@property (nonatomic, copy) NSString *invite_url;
@property (nonatomic, copy) NSString *next_agencylevel;
@property (nonatomic, copy) NSString *next_agencylevel_display;
@property (nonatomic, copy) NSString *next_level_exam_url;
@property (nonatomic, copy) NSString *surplus_days;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *total_rank;



@end


/**
 *  (lldb) po responseObject
 {
 "mama_fortune" =     {
 "active_value_num" = 51;
 "carry_cashout_display" = 2600;
 "carry_confirmed_display" = "28127.23";
 "carry_pending_display" = "1883.31";
 "carry_value" = "30010.54";
 "cash_value" = "25527.23";
 created = "2016-03-17T14:57:40";
 "extra_info" =         {
 agencylevel = 2;
 "agencylevel_display" = VIP1;
 "invite_url" = "http://staging.xiaolumeimei.com/pages/agency-invitation-res.html";
 "next_agencylevel" = 12;
 "next_agencylevel_display" = VIP2;
 "next_level_exam_url" = "http://m.xiaolumeimei.com/mall/activity/exam";
 "surplus_days" = 0;
 };
 "fans_num" = 2272;
 "history_last_day" = "<null>";
 "invite_all_num" = 1;
 "invite_num" = 0;
 "invite_trial_num" = 1;
 "mama_event_link" = "http://staging.xiaolumeimei.com/static/wap/pages/featuredEvent.html";
 "mama_id" = 44;
 "mama_level" = 0;
 "mama_level_display" = "\U65b0\U624b\U5988\U5988";
 "mama_name" = "";
 modified = "2016-06-02T16:28:48";
 "order_num" = 9697;
 "today_visitor_num" = 0;
 };
 }
 */
