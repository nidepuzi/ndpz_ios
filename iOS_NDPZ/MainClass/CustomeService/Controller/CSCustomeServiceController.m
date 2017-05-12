//
//  CSCustomeServiceController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSCustomeServiceController.h"
#import "Udesk.h"
#import "QYSDK.h"

@interface CSCustomeServiceController ()
@property (nonatomic, strong) QYSessionViewController *sessionViewController;

@end

@implementation CSCustomeServiceController
- (QYSessionViewController *)sessionViewController {
    if (_sessionViewController == nil) {
        QYSource *source = [[QYSource alloc] init];
        source.title =  @"你的铺子";
        source.urlString = @"https://m.nidepuzi.com";
        _sessionViewController = [[QYSDK sharedSDK] sessionViewController];
        _sessionViewController.sessionTitle = @"你的铺子";
        _sessionViewController.source = source;
        //    sessionViewController.hidesBottomBarWhenPushed = NO;
        
        _sessionViewController.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain
                                        target:self action:@selector(onBack:)];
    }
    return _sessionViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"客服" selecotr:nil];
    
    
//    UIButton *kefuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:kefuButton];
//    [kefuButton setTitle:@"进入客服" forState:UIControlStateNormal];
//    kefuButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//    kefuButton.frame = CGRectMake(SCREENWIDTH / 2 - 50, 200, 100, 50);
//    
//    [kefuButton addTarget:self action:@selector(kefuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [[QYSDK sharedSDK] sessionViewController];
    
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self kefuButtonClick];
    [self setUserInfo];
    [self.navigationController pushViewController:self.sessionViewController animated:NO];
    
}
// 个人信息请求
- (void)setUserInfo{
    [[JMGlobal global] upDataLoginStatusSuccess:^(id responseObject) {
        [self updateUserInfo:responseObject];
    } failure:^(NSInteger errorCode) {
        [self updateUserInfo:nil];
        if (errorCode == 403) {
        }else {
            [MBProgressHUD showError:@"请求失败,请手动刷新"];
        }
    }];
}
- (void)updateUserInfo:(NSDictionary *)dic {
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


//- (void)waitButtonStatus:(UIButton *)button {
//    button.enabled = YES;
//}
- (void)kefuButtonClick {
//    button.enabled = NO;
//    [self performSelector:@selector(waitButtonStatus:) withObject:button afterDelay:1.];
//    UdeskSDKManager *chatViewManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle defaultStyle]];
//    [chatViewManager pushUdeskViewControllerWithType:UdeskRobot viewController:self];
    
    
    [self.navigationController pushViewController:self.sessionViewController animated:NO];
    

    
}
- (void)onBack:(id)sender {
    [JMNotificationCenter postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end







































