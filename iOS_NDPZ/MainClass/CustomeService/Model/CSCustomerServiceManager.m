//
//  CSCustomerServiceManager.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/17.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSCustomerServiceManager.h"
#import "QYPOPSDK.h"
#import "JMStoreManager.h"
#import "WebViewController.h"


@interface CSCustomerServiceManager () <QYConversationManagerDelegate, QYSessionViewDelegate>

@end

@implementation CSCustomerServiceManager

+ (instancetype)defaultManager {
    static CSCustomerServiceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CSCustomerServiceManager alloc] init];
    });
    return manager;
}

- (void)showCustomerService:(UIViewController *)vc {
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    NSDictionary *dic = [JMStoreManager getDataDictionary:@"userProfile"];
    if (dic == nil || dic.count == 0) {
        [[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite = NO;
        QYUserInfo *userInfo = [[QYUserInfo alloc] init];
        userInfo.userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [[QYSDK sharedSDK] setUserInfo:userInfo];
    }else {
        [self registerUserInfo:dic];
    }
    
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
    [sessionViewController.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    sessionViewController.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain
                                    target:self action:@selector(onBack:)];
    
    [vc.navigationController pushViewController:sessionViewController animated:NO];
    
    [QYCustomActionConfig sharedInstance].linkClickBlock = ^(NSString *linkAddress) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:linkAddress forKey:@"web_url"];
        WebViewController *activity = [[WebViewController alloc] init];
        activity.webDiction = dict;
        activity.isShowNavBar = YES;
        activity.isShowRightShareBtn = NO;
        [vc.navigationController pushViewController:activity animated:YES];
        
    };
    
}


- (void)registerUserInfo:(NSDictionary *)dic {
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
    if (self.popBlock) {
        self.popBlock();
    }
}



- (NSString *)dictionaryToJson:(id)dataSource {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataSource options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}



@end




















