//
//  JMGlobal.m
//  XLMM
//
//  Created by zhang on 17/4/8.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMGlobal.h"
#import "JMStoreManager.h"
#import "JMDevice.h"
#import "JMHTTPManager.h"
#import "JMRepopView.h"
#import "JMPopViewAnimationSpring.h"
#import "JMRefreshLoadView.h"
#import "JMLogInViewController.h"
#import "RootNavigationController.h"
#import "AppDelegate.h"
#import "CSNetFailView.h"
#import <sys/sysctl.h>


static BOOL isNetPrompt;
static NSString *userCustomerID;

@interface JMGlobal () <UIAlertViewDelegate> {
    NSString *httpStatus;
}
@property (nonatomic, strong) JMRefreshLoadView *loadView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) CSNetFailView *netFailView;


@end


@implementation JMGlobal

+ (JMGlobal *)global {
    static JMGlobal *global = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        global = [[JMGlobal alloc] init];
        userCustomerID = nil;
    });
    return global;
}
- (void)clearAllSDCache {
    // 停止所有的下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 删除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}


/*
 弹出登录界面
 */
- (void)showLoginViewController {
    JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
    RootNavigationController *rootNav = [[RootNavigationController alloc] initWithRootViewController:loginVC];
    
    UIViewController *viewController = XLMM_APP.window.rootViewController;
    if ([viewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (id)viewController.presentedViewController;
        if ([navigation.topViewController isKindOfClass:[JMLogInViewController class]]) {
            return;
        }
    }
    if (viewController.presentedViewController) {
        //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
        [viewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [viewController presentViewController:rootNav animated:YES completion:nil];
        }];
    }else {
        [viewController presentViewController:rootNav animated:YES completion:nil];
    }
    
//    [XLMM_APP.window.rootViewController presentViewController:rootNav animated:YES completion:^{
//    }];
}

#pragma mark ---------- 弹出视图 (分享,选择框等) ----------
- (void)showpopBoxType:(popType)type Frame:(CGRect)frame ViewController:(UIViewController *)viewController WithBlock:(void (^)(UIView *maskView))clickBlock {
    JMShareView *cover = [JMShareView show];
    JMPopView *menu = [JMPopView showInRect:frame];
    menu.contentView = viewController.view;
    cover.blcok = ^(JMShareView *coverView) {
        [JMShareView hide];
        [JMPopView hide];
        [MobClick event:@"WebViewController_shareFail_masking"];
    };
    
//    cover.blcok = clickBlock;
}

#pragma mark ==== 显示空页面
- (void)showMessageView:(UIView *)parentView withBlock:(void (^)(UIView* messageView))clickBlock{
    [self showMessageView:parentView message:@"暂无数据" iconImage:[UIImage imageNamed:@"noDataImage"] withBlock:clickBlock];
}
- (void)showNotSignedView:(UIView *)parentView message:(NSString *)message withBlock:(void (^)(UIView *))clickBlock {
    [self showMessageView:parentView message:message iconImage:[UIImage imageNamed:@"无网络"] withBlock:clickBlock];
}
- (void)showMessageView:(UIView *)parentView message:(NSString *)message withBlock:(void (^)(UIView *messageView))clickBlock {
    [self showMessageView:parentView message:message iconImage:[UIImage imageNamed:@"无网络"] withBlock:clickBlock];
}
- (void)showMessageView:(UIView *)parentView message:(NSString *)message iconImage:(UIImage *)image withBlock:(void (^)(UIView *messageView))clickBlock {
    [self hideMessageView]; // 每次都干掉.重新加载
    _netFailView = [[CSNetFailView alloc] initWithFrame:parentView.bounds];
    _netFailView.backgroundColor = [UIColor whiteColor];
    _netFailView.alpha = 1.0;
    _netFailView.frame = parentView.bounds;
    [_netFailView setMessage:message];
    [_netFailView setIconImage:image];
    [parentView  addSubview:_netFailView];
    _netFailView.touchNetFailView = clickBlock;
    
}
- (void)hideMessageView {
    if(_netFailView){
        [_netFailView removeFromSuperview];
        _netFailView = nil;
    }
}



#pragma mark ---- 获取 dayNumber (-前,+后) 的时间 ----
- (BOOL)currentTimeWithBeforeDays:(NSInteger)dayNumber {
    NSString *currentTime = [NSString getCurrentTime];
    [JMStoreManager saveDataFromString:@"caveCurrentTimeWithSDImageCacke.txt" WithString:currentTime];
    NSString *beforeTime = [NSString getBeforeDay:dayNumber];
    NSString *saveCurrentTime = [JMStoreManager getDataString:@"caveCurrentTimeWithSDImageCacke.txt"];
    if ([self compareData:beforeTime SaveData:saveCurrentTime] == -1) {
        [JMStoreManager removeFileByFileName:@"caveCurrentTimeWithSDImageCacke.txt"];
        [JMStoreManager saveDataFromString:@"caveCurrentTimeWithSDImageCacke.txt" WithString:currentTime];
        return YES;
    }
    return NO;
}


#pragma mark ---------- 清除缓存 ----------
- (void)clearCacheWithSDImageCache:(clearCacheBlock)cacheBlock {
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
        NSLog(@"path = %@", path);
        NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        NSLog(@"file size = %@",[dict objectForKey:NSFileSize]);
        float sizeValue = [[dict objectForKey:NSFileSize] integerValue]/200.0f;
        if (sizeValue < 1.0) {
            sizeValue = 0.0f;
        }
        NSString *cacheString = [NSString stringWithFormat:@"%.1fM", sizeValue];
        if (cacheBlock) {
            cacheBlock(cacheString);
        }
    }];
}

#pragma mark ---------- 监听网络状态 ----------
- (void)monitoringNetworkStatus {
    isNetPrompt = YES;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                httpStatus = @"other";
                NSLog(@"未知网络状态");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            {
                httpStatus = @"noNet";
                NSLog(@"无网络");
                if (isNetPrompt) {
                    isNetPrompt = NO;
                    UIAlertView *alterView = [[UIAlertView alloc]  initWithTitle:nil message:@"无网络连接，请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alterView show];
                }
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                httpStatus = @"2G|3G|4G";
                NSLog(@"蜂窝数据网");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"WiFi网络");
                httpStatus = @"wifi";
                break;
            }
            default:
                break;
        }
        NSString* phoneModel = [[JMDevice defaultDecice] getUserAgent];
        NSString *userAgent = [NSString stringWithFormat:@"%@ NetType/%@",phoneModel,httpStatus];
        [[JMHTTPManager shareManager].requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }] ;
    [manager startMonitoring];
    
}
#pragma mark ======== 请求个人信息,保存登录信息 ========
- (void)upDataLoginStatusSuccess:(void (^)(id responseObject))success
                         failure:(void (^)(NSInteger errorCode))failure {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        BOOL kIsLoginStatus = ([responseObject objectForKey:@"id"] != nil)  && ([[responseObject objectForKey:@"id"] integerValue] != 0);
        BOOL kIsXLMMStatus = [[responseObject objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]];
        
        BOOL kIsVIP = NO;
        if (kIsXLMMStatus) {
            NSDictionary *xlmmDict = responseObject[@"xiaolumm"];
            if (![NSString isStringEmpty:xlmmDict[@"renew_time"]]) {
                [JMUserDefaults setValue:xlmmDict[@"renew_time"] forKey:@"huiyuanshijian"];
            }
            NSString *last = [NSString stringWithFormat:@"%@",xlmmDict[@"last_renew_type"]];
            [JMUserDefaults setValue:last forKey:kUserVipStatus];
            kIsVIP = [xlmmDict[@"status"] isEqual:@"effect"] ? YES : NO;
        }else {
            NSMutableDictionary *dic = [responseObject mutableCopy];
            dic[@"xiaolumm"] = @{};
            responseObject = [dic copy];
        }
        [JMUserDefaults setBool:kIsVIP forKey:kISNDPZVIP];
        [JMUserDefaults setBool:kIsLoginStatus forKey:kIsLogin];
        [JMUserDefaults synchronize];
        
        if (![[responseObject objectForKey:@"user_budget"] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dic = [responseObject mutableCopy];
            dic[@"user_budget"] = @{};
            responseObject = [dic copy];
        }
        if ([JMStoreManager isFileExist:@"userProfile"]) {
            [JMStoreManager removeFileByFileName:@"userProfile"];
        }
        [JMStoreManager saveDataFromDictionary:@"userProfile" WithData:responseObject];
        NSLog(@"%@",[JMStoreManager getDataDictionary:@"userProfile"]);
        
        
//        if (!responseObject){
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLogin];
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kISXLMM];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            return;
//        }
//        if (([responseObject objectForKey:@"id"] != nil)  && ([[responseObject objectForKey:@"id"] integerValue] != 0)) {
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLogin];
//            if (![userCustomerID isEqual:responseObject[@"id"]]) {
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRefreshFine"];
//            }
//            userCustomerID = responseObject[@"id"];
//        }else {
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLogin];
//        }
//        if([[responseObject objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]]){
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kISXLMM];
//        }else {
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kISXLMM];
//        }
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [JMStoreManager removeFileByFileName:@"usersInfo.plist"];
//        [JMStoreManager saveDataFromDictionary:@"usersInfo.plist" WithData:responseObject];
        if (success) {
            success(responseObject);
        }
    } WithFail:^(NSError *error) {
        NSInteger statusCode = 200;
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kISXLMM];
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLogin];
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRefreshFine"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        if (response) {
            if (response.statusCode) {
                statusCode = response.statusCode;
                if (statusCode == 403) {
                    NSLog(@"%ld",statusCode);
                    [JMUserDefaults removeObjectForKey:kIsLogin];
//                    [JMUserDefaults removeObjectForKey:kISNDPZVIP];
                }
            }
        }
        [JMUserDefaults synchronize];
        if (failure) {
            failure(statusCode);
        }
    } Progress:^(float progress) {
    }];
}

#pragma mark ======== 跳转页面等待动画 ========
- (void)showWaitLoadingInView:(UIView *)viewController {
    if (self.loadView) {
        [self removeView];
    }
    if (!self.loadView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = viewController.bounds;
        maskView.backgroundColor = [UIColor whiteColor];
        [viewController addSubview:maskView];
        self.maskView = maskView;
        self.loadView = [[JMRefreshLoadView alloc] initWithFrame:CGRectMake(maskView.mj_w / 2 - 18, maskView.mj_h / 2 - 18, 36, 36)];
        [maskView addSubview:self.loadView];
    }
    [self.loadView setLineLayerStrokeWithProgress:100];
    [self.loadView startLoading];
}
- (void)hideWaitLoading {
    if (!self.loadView) {
        return ;
    }
    [self.loadView endLoading];
    if (self.loadView) {
        [self removeView];
    }
}
- (void)removeView {
    [self.loadView removeFromSuperview];
    [self.maskView removeFromSuperview];
    self.loadView = nil;
    self.maskView = nil;
}



/*
    befoData -- > 获取的当前时间几天 前/后 的时间 .
    saveData -- > 需要判断的时间(保存的时间)
 */
- (NSInteger)compareData:(NSString *)befoData SaveData:(NSString *)saveData {
    NSInteger compCount;
    NSComparisonResult result = [befoData compare:saveData];
    if (result == NSOrderedSame) {
        compCount = 0;
    }else if (result == NSOrderedAscending) {
        // saveData 大
        compCount = 1;
    }else if (result == NSOrderedDescending) {
        compCount = -1;
    }else { }
    return compCount;
}

- (int)secondOFCurrentTimeInEndtimeInt:(int)endTime {
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  // 设置时间格式
    NSString *currentTime = [dateFormatter stringFromDate:lastDate];
    return [self secondOfCurrentTimeInEndTime:currentTime];
}
- (int)secondOfCurrentTimeInEndTime:(NSString *)endTime {
    if ([NSString isStringEmpty:endTime]) {
        return 0;
    }
//    endTime = @"2017-05-06 14:44:08";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  // 设置时间格式
    //    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    //    [dateFormatter setTimeZone:timeZone]; //设置时区 ＋8:00
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *someDayDate = [dateFormatter dateFromString:currentTime];
    NSDate *date = [dateFormatter dateFromString:endTime]; // 结束时间
    NSTimeInterval time = [date timeIntervalSinceDate:someDayDate];  //结束时间距离当前时间的秒数
    NSLog(@"结束时间距离当前时间的秒数: %lld 秒",(long long int)time);
    return time;
}
- (BOOL)userVerificationXLMM {
    return [JMUserDefaults boolForKey:kISNDPZVIP];
}
- (BOOL)userVerificationLogin {
    return [JMUserDefaults boolForKey:kIsLogin];
}

- (BOOL)validateIdentityCard:(NSString *)value {
    // 简单判断 (前17位为数字,后一位可以是数字可以是x)
    //    NSString *pattern = @"(^[0-9]{15})|([0−9]17([0−9]|X))";
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    //    BOOL isMatch = [pred evaluateWithObject:value];
    //    return isMatch;
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

#pragma mark - sdwebImageCache 获取图片

- (NSData *)getCacheImageWithKey:(NSString *)key {
    
    NSData *imageData = nil;
    __block BOOL isExit = YES;
    [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:key] completion:^(BOOL isInCache) {
        isExit = isInCache;
    }];
    
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:key]];
        if (cacheImageKey.length) {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length) {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if (!imageData) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:key]];
    }
    
    return imageData;
}
-(int)getCurrentDeviceModel {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone5,1"]) return 1;
    if ([platform isEqualToString:@"iPhone5,2"]) return 1;
    if ([platform isEqualToString:@"iPhone5,3"]) return 1;
    if ([platform isEqualToString:@"iPhone5,4"]) return 1;
    if ([platform isEqualToString:@"iPhone6,1"]) return 1;
    if ([platform isEqualToString:@"iPhone6,2"]) return 1;
    if ([platform isEqualToString:@"iPhone7,1"]) return 3;
    if ([platform isEqualToString:@"iPhone7,2"]) return 2;
    
    if ([platform isEqualToString:@"iPod5,1"])   return 1;
    
    if ([platform isEqualToString:@"i386"])      return 0;
    if ([platform isEqualToString:@"x86_64"])    return 0;
    return 0;
}



@end








































































































