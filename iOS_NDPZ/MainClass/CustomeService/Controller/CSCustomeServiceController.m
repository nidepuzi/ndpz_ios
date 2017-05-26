//
//  CSCustomeServiceController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSCustomeServiceController.h"
#import "QYPOPSDK.h"
#import "CSCustomerServiceManager.h"
#import "JMStoreManager.h"



@interface CSCustomeServiceController () <QYConversationManagerDelegate, QYSessionViewDelegate>



@end

@implementation CSCustomeServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"客服" selecotr:nil];
    

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    [self updateUserInfo:[JMStoreManager getDataDictionary:@"userProfile"]];
    
    
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"你的铺子";
    source.urlString = @"https://m.nidepuzi.com";
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.delegate = self;
    sessionViewController.sessionTitle = @"你的铺子";
    sessionViewController.source = source;
    
    sessionViewController.navigationController.navigationBar.translucent = NO;
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    sessionViewController.navigationController.navigationBar.titleTextAttributes = dict;
    [sessionViewController.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:0x62a8ea]];
    
    sessionViewController.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain
                                    target:self action:@selector(onBack:)];
    
    [self.navigationController pushViewController:sessionViewController animated:NO];
    
    
}

- (void)updateUserInfo:(NSDictionary *)dic {
    if (dic == nil || dic.count == 0) {
        return;
    }
    [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = dic[@"thumbnail"];
    [[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite = NO;
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = dic[@"id"];
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
    
    userInfo.data = [self dictionaryToJson:userArr];
    
//    userInfo.data = @"[{\"key\":\"real_name\", \"value\":\"你看我存在么?\"},"
//    "{\"key\":\"mobile_phone\", \"hidden\":true},"
//    "{\"key\":\"email\", \"value\":\"13800000000@163.com\"},"
//    "{\"index\":0, \"key\":\"account\", \"label\":\"账号\", \"value\":\"zhangsan\", \"href\":\"http://example.domain/user/zhangsan\"},"
//    "{\"index\":1, \"key\":\"sex\", \"label\":\"性别\", \"value\":\"先生\"},"
//    "{\"index\":5, \"key\":\"reg_date\", \"label\":\"注册日期\", \"value\":\"2017-04-27\"},"
//    "{\"index\":6, \"key\":\"last_login\", \"label\":\"上次登录时间\", \"value\":\"2017-04-27 11:11:11\"}]";
    
    [[QYSDK sharedSDK] setUserInfo:userInfo];
    
    
    
    
    
//    NSString *nick_name = @"测试账号";
//    NSString *sdk_token = @"123456";
//    if (dic.count == 0) {
//        NSLog(@"用户信息失败,使用测试数据");
//    }else {
//        nick_name = dic[@"nick"];
//        sdk_token = [NSString stringWithFormat:@"%@",dic[@"id"]];
//    }
//    NSDictionary *parameters = @{
//                                 @"user": @{
//                                         @"sdk_token":sdk_token,
//                                         @"nick_name":nick_name,
//                                         }
//                                 };
//    [UdeskManager createCustomerWithCustomerInfo:parameters];

}
- (NSString *)dictionaryToJson:(id)dataSource {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataSource options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


/**
 *  点击商铺入口按钮回调
 */
- (void)onTapShopEntrance {
    NSLog(@"\n 点击商铺入口按钮回调");
}

/**
 *  点击聊天窗口右边或左边会话列表按钮回调
 */
- (void)onTapSessionListEntrance {
    NSLog(@"\n 点击聊天窗口右边或左边会话列表按钮回调");
}
- (void)onReceiveMessage:(QYMessageInfo *)message {
    NSLog(@"%@",message);
}
- (void)onSessionListChanged:(NSArray<QYSessionInfo*> *)sessionList {
    NSLog(@"%@",sessionList);
}

- (void)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [JMNotificationCenter postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
}


@end







































