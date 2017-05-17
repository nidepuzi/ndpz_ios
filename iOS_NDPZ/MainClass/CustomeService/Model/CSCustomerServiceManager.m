//
//  CSCustomerServiceManager.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/17.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSCustomerServiceManager.h"
#import "QYSDK.h"

@implementation CSCustomerServiceManager

+ (instancetype)defaultManager {
    static CSCustomerServiceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CSCustomerServiceManager alloc] init];
    });
    return manager;
}

- (void)registerUserInfo:(NSDictionary *)dic {
    if (dic == nil || dic.count == 0) {
        return;
    }
    [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = dic[@"thumbnail"];
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = dic[@"user_id"];
    NSArray *userArr = @[@{
                             @"key":@"real_name",
                             @"value":dic[@"nick"]
                             },
                         @{
                             @"key":@"mobile_phone",
                             //                             @"hidden":@false
                             },
                         @{
                             @"key":@"email",
                             @"value":dic[@"email"]
                             },
                         @{
                             @"index":@0,
                             @"key":@"account",
                             @"label":@"账号",
                             @"value":dic[@"mobile"]
                             },
                         @{
                             @"index":@1,
                             @"key":@"sex",
                             @"label":@"性别",
                             @"value":@"未知"
                             },
                         @{
                             @"index":@5,
                             @"key":@"reg_date",
                             @"label":@"注册日期",
                             @"value":dic[@"created"]
                             },
                         @{
                             @"index":@6,
                             @"key":@"last_login",
                             @"label":@"上次登录时间",
                             @"value":@"未知"
                             },];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userArr options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    userInfo.data = jsonString;
    
    //    userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"你看我存在么?\"},"
    //    "{\"key\":\"mobile_phone\", \"hidden\":true},"
    //    "{\"key\":\"email\", \"value\":\"13800000000@163.com\"},"
    //    "{\"index\":0, \"key\":\"account\", \"label\":\"账号\", \"value\":\"zhangsan\", \"href\":\"http://example.domain/user/zhangsan\"},"
    //    "{\"index\":1, \"key\":\"sex\", \"label\":\"性别\", \"value\":\"先生\"},"
    //    "{\"index\":5, \"key\":\"reg_date\", \"label\":\"注册日期\", \"value\":\"2017-04-27\"},"
    //    "{\"index\":6, \"key\":\"last_login\", \"label\":\"上次登录时间\", \"value\":\"2017-04-27 11:11:11\"}]";
    
    [[QYSDK sharedSDK] setUserInfo:userInfo];
}


@end




















