//
//  AppDelegate.m
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AppDelegate.h"
#import "JMStoreManager.h"
#import "QYPOPSDK.h"
#import "JMPayment.h"
#import "JMMiPushManager.h"
#import "JMRootTabBarController.h"
#import "XHLaunchAd.h"
#import "JMLogInViewController.h"
#import "CSNewFeatureController.h"
#import "RootNavigationController.h"
#import "CSDataBase.h"


#define login @"login"

#define appleID @"com.danlai.nidepuzi"

@interface AppDelegate () <XHLaunchAdDelegate> {
    NSString *_imageUrl;
}

@end

@implementation AppDelegate

#pragma mark ======== 友盟统计/分享.uDesk ========
- (void)udeskInit{
    [[QYSDK sharedSDK] registerAppId:@"6df3367932bd8e384f359611ea48e90b" appName:@"你的铺子"];
}
- (void)umengTrackInit {
    //[MobClick setLogEnabled:YES];
    //version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    UMConfigInstance.appKey = @"58e1a333e88bad47760008dc";
    [MobClick startWithConfigure:UMConfigInstance];
}


- (void)umengShareInit{  // weibo App Key： 1433464940   App Secret： f53fea3cee88a57a19578cdeff0e239d
    @try {
        [UMSocialData setAppKey:@"58e1a333e88bad47760008dc"]; // 5665541ee0f55aedfc0034f4
        //qq分享 
        [UMSocialQQHandler setQQWithAppId:@"1106160060" appKey:@"aQjYEJmGje73bBGW" url:@"https://www.umeng.com/social"]; // QQ41dd19a6 // 1105009062 // V5H2L8ij9BNx6qQw
        //微信分享
        [UMSocialWechatHandler setWXAppId:@"3c7b4e3eb5ae4cfb132b2ac060a872ee" appSecret:@"wxa6e8010fa0b31eb3" url:@"https://www.umeng.com/social"]; // wx25fcb32689872499
        //微博分享
        [WeiboSDK registerApp:@"1433464940"];   //2475629754
        [WXApi registerApp:@"wxa6e8010fa0b31eb3" withDescription:@"weixin"];
    } @catch (NSException *exception) {
        NSLog(@"DEBUG: failure to batch update.  %@", exception.description);
    } @finally {
    }
}
#pragma mark ======== 获取启动图数据 ========
- (void)getLaunchImage {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/activitys/startup_diagrams",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ; // @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg";
        _imageUrl = responseObject[@"picture"];
        if ([NSString isStringEmpty:_imageUrl]) {
            [self newFeature];
            return ;
        }
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
        imageAdconfiguration.duration = 3;
        imageAdconfiguration.frame = [UIScreen mainScreen].bounds;
        imageAdconfiguration.imageNameOrURLString = _imageUrl;
        imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
        imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
        imageAdconfiguration.showFinishAnimate = ShowFinishAnimateLite;
        imageAdconfiguration.skipButtonType = SkipTypeTimeText;
        imageAdconfiguration.showEnterForeground = NO;
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        
        [self newFeature];
    } WithFail:^(NSError *error) {
        [self newFeature];
    } Progress:^(float progress) { 
        
    }];
}

#pragma mark ======== 设置根控制器 ========
- (void)fetchRootVC {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    JMRootTabBarController *tabBarVC = [[JMRootTabBarController alloc] init];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    NSInteger netWorkStatus = [AFNetworkReachabilityManager manager].networkReachabilityStatus;
    if (netWorkStatus == 0) {
        [[JMGlobal global] showLoginViewController];
        return ;
    }
    [self lodaUserInfo];
    [XHLaunchAd setWaitDataDuration:2];
}
- (void)newFeature {
    //1.获取当前版本号
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    //2.获取上一次版本号
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
//    if (![currentVersion isEqualToString:lastVersion]) { // 没有新的版本号
//        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"version"];
        CSNewFeatureController *loginVC = [[CSNewFeatureController alloc] init];
        RootNavigationController *rootNav = [[RootNavigationController alloc] initWithRootViewController:loginVC];
        [XLMM_APP.window.rootViewController presentViewController:rootNav animated:YES completion:^{
        }];
//    }
    
}
- (void)showNewFeatureView {
//    if (!isSureLogin) {
//        [[JMGlobal global] showLoginViewController];
//    }
}
- (void)lodaUserInfo {
    [[JMGlobal global] upDataLoginStatusSuccess:^(id responseObject) {
        [self cancleWaitTimerAndReuestLaunchImage];
        if ([responseObject[@"check_xiaolumm"] integerValue] != 1) {
            return ;
        }
        
        BOOL kIsBindPhone = [NSString isStringEmpty:[responseObject objectForKey:@"mobile"]];
        BOOL kIsVIP = [JMUserDefaults boolForKey:kISNDPZVIP];
        if (kIsVIP) {
            if (!kIsBindPhone) {
                return ;
            }else {
                [[JMGlobal global] showLoginViewController];
            }
        }else {
            [[JMGlobal global] showLoginViewController];
        }
//        [self showNewFeatureView];
    } failure:^(NSInteger errorCode) {
        [self cancleWaitTimerAndReuestLaunchImage];
//        [self showNewFeatureView];
        [[JMGlobal global] showLoginViewController];
    }];
}
- (void)cancleWaitTimerAndReuestLaunchImage {
    [XHLaunchAd cancelWatiTimer]; // 取消等待后,维持两秒去请求启动图...
    [self getLaunchImage];
}
#pragma mark ======== 程序开始启动 ========
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //注意!!!umeng必须要在udesk初始化之后，否则umeng crasklog会不生效，可能udesk自己捕获了一些crash信号处理
    [self udeskInit];
    [self umengTrackInit];
    [[JMGlobal global] monitoringNetworkStatus];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JMNotificationCenter addObserver:self selector:@selector(openPushMessage) name:@"openPushMessageSwitch" object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(showNewFeatureView) name:@"showNewFeatureView" object:nil];
    
    // 创建数据库表
    CSDataBase *db = [[CSDataBase alloc] init];
    [db initDatabase];
    /**
     *  检测是否是第一次打开  -- 并且记录打开的次数
     */
    [JMStoreManager recoderAppLoadNum];
    NSString *string = [JMUserDefaults objectForKey:kIsReceivePushTZ];
    if ([string isEqual:@"1"] || string == nil) {
        [self openPushMessage];
    }else { }
    
    [self umengShareInit];
    [[JMMiPushManager miPushManager] finishLaunchingWithOptions:launchOptions First:YES];
    // -- 添加UserAgent
    [self createUserAgent];
    // 是否清除缓存的判断,这里处理每隔2天清除自动清除一次
    if ([[JMGlobal global] currentTimeWithBeforeDays:-2]) {
        [[JMGlobal global] clearCacheWithSDImageCache:^(NSString *sdImageCacheString) {
        }];
    }
    //创建导航控制器，添加根视图控制器
    [self fetchRootVC];
    return YES;
}
- (void)openPushMessage {
    [MiPushSDK registerMiPush:[JMMiPushManager miPushManager] type:0 connect:YES];
}
#pragma mark UIApplicationDelegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[JMMiPushManager miPushManager] registerForRemoteNotificationsWithDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[JMMiPushManager miPushManager] application:application ReceiveRemoteNotification:userInfo];
}
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
//    [application registerForRemoteNotifications];
//}

// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[JMMiPushManager miPushManager] presentNotification:notification];
}
// 点击通知进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [[JMMiPushManager miPushManager] receiveNotificationResponse:response];
//    completionHandler();
}
#pragma mark ======== 监听系统事件 application启动过程 ========
// 添加你自己的挂起前准备代码
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive ---> 添加你自己的挂起前准备代码");
}
// 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground ---> 程序进入后台");
//    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}
// 程序从后台回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground ---> 程序进入前台");
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}
// 添加你的恢复代码
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive ---> 添加你的恢复代码");
    application.applicationIconBadgeNumber = 0;
//    [self updateLoginState];
    if ([JMMiPushManager miPushManager]) {
        [[JMMiPushManager miPushManager] didBecomeActive];
    }
}
// 接收到内存警告时候调用
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"applicationDidReceiveMemoryWarning ---> 接收到内存警告时候调用");
    [[JMGlobal global] clearAllSDCache];
}
- (void)dealloc {
    NSLog(@"dealloc ---> dealloc调用");
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [JMNotificationCenter removeObserver:self name:@"openPushMessageSwitch" object:nil];
}
// 程序即将退出 -- > 在这里添加退出前的清理代码以及其他工作代码
- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"程序即将退出 -- > 在这里添加退出前的清理代码以及其他工作代码");
}

#pragma mark ======== 支付,分享 回调 ========
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([url.host isEqual:@"pay"] || [url.host isEqual:@"oauth"] || [url.host isEqual:@"safepay"]) {
        return [self xiaoluPay:url];
    }else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.host isEqual:@"pay"] || [url.host isEqual:@"oauth"] || [url.host isEqual:@"safepay"]) {
        return [self xiaoluPay:url];
    }else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    if ([url.host isEqual:@"pay"] || [url.host isEqual:@"oauth"] || [url.host isEqual:@"safepay"]) {
        return [self xiaoluPay:url];
    }else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}
- (BOOL)xiaoluPay:(NSURL *)url {
    return [JMPayment handleOpenURL:url WithErrorCodeBlock:^(JMPayError *error) {
        if (error.errorStatus == payMentErrorStatusSuccess) {
            [JMNotificationCenter postNotificationName:@"ZhifuSeccessfully" object:nil];
        }else if (error.errorStatus == payMentErrorStatusFail) {
            [JMNotificationCenter postNotificationName:@"CancleZhifu" object:nil];
        }else { }
    }];
    
}

#pragma mark ======== User_Agent ========
//从webview获得浏览器中的useragent，并进行更新
- (void)createUserAgent {
    [[JMDevice defaultDecice] cerateUserAgent:nil];
}
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    self.backgroundSessionCompletionHandler = completionHandler;
    [self presentNotification];
}
-(void)presentNotification {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"下载完成!";
    localNotification.alertAction = @"后台传输下载已完成!";
    //提示音
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //icon提示加1
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}


@end













/*
 
 //七鱼客服推送消息相关处理
 if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
 UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
 UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
 [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
 [[UIApplication sharedApplication] registerForRemoteNotifications];
 }else {
 UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
 [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
 }

 */









//
//
//
//
//#pragma mark ======== RESideMenu Delegate ========
//- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
//{
//    //  NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
//    [JMNotificationCenter postNotificationName:@"presentLeftMenuVC" object:nil];
//}
//
//- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
//{
//    // NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
//    
//}
//
//- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
//{
//    // NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
//}
//
//- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
//{
//    // NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
//}
//
//
//









