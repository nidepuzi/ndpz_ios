//
//  CSFansModel.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/20.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSFansModel : NSObject

@property (nonatomic, copy) NSString *award;
// 邀请时间
@property (nonatomic, copy) NSString *charge_time;
// 粉丝ID
@property (nonatomic, copy) NSString *fansID;
// 姓名
@property (nonatomic, copy) NSString *nick;
// 头像
@property (nonatomic, copy) NSString *thumbnail;
// 试用期或者正式
@property (nonatomic, copy) NSString *referal_type;


@property (nonatomic, copy) NSString *invitee_mobile;
@property (nonatomic, copy) NSString *invitee_status;




@end









/**
 *  {
 award = "<null>";
 "charge_time" = "2017-05-16T15:19:27.110558";
 id = 170;
 "referal_type" = 15;
 nick = "\U9171\U9c7c\U996d@\U5c0f\U9e7f\U7f8e\U7f8e";
 thumbnail = "http://wx.qlogo.cn/mmopen/X9FqH2tVtChE3BicYA3fYo2AmD2mliboe3xW4cld3TmhxNCZZGX3czXslzFvLNic5vpSvE8Z79s3IWtU4AbVRe0yg/0";
 }
 */







