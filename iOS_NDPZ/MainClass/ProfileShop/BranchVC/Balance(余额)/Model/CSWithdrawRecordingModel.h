//
//  CSWithdrawRecordingModel.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSWithdrawRecordingBankCardModel;
@interface CSWithdrawRecordingModel : NSObject

@property (nonatomic, copy) NSString *recordingID;
@property (nonatomic, copy) NSString *customer_id;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *platform_name;
@property (nonatomic, copy) NSString *recipient;
@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *service_fee;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *fail_msg;
@property (nonatomic, strong) CSWithdrawRecordingBankCardModel *bank_card;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *send_time;
@property (nonatomic, copy) NSString *success_time;



@end


@interface CSWithdrawRecordingBankCardModel : NSObject


@property (nonatomic, copy) NSString *recordingBankCardID;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *account_no;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *bank_img;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *recordingBankCardDefault;


@end





/*
 
 {
 id: 8,
 customer_id: 25,
 amount: 10,
 platform: "sandpay",
 platform_name: "银行卡转账",
 recipient: "6",
 receiver: "18621623915",
 service_fee: 1,
 state: "success",
 fail_msg: "",
 bank_card: {
 id: 6,
 user: 40,
 account_no: "6216261000000000018",
 account_name: "全渠道",
 bank_name: "招商银行",
 bank_img: "http://img.nidepuzi.com/banks/bank_zsyh.png",
 created: "2017-05-18T15:33:01.058851",
 default: false
 },
 created: "2017-05-18T15:35:26.733555",
 send_time: "2017-05-18T15:35:28",
 success_time: null
 }
 
 
 */



