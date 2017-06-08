//
//  CSLoginManager.m
//  iOS_NDPZ
//
//  Created by zhang on 17/6/7.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSLoginManager.h"
#import "MiPushSDK.h"
#import "JMVerificationCodeController.h"
#import "AESEncryption.h"


#define SECRET @"a894a72567440fa7317843d76dd7bf03"


@implementation CSLoginManager

+ (CSLoginManager *)loginInstance {
    static CSLoginManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CSLoginManager alloc] init];
    });
    return manager;
}
- (void)wechatLoginWithViewController:(UIViewController *)viewController Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure {
    NSDictionary *wechatInfo = [JMUserDefaults objectForKey:kWxLoginUserInfo];
    NSMutableString *randomString = [NSMutableString string];
    NSArray *randomArray = [self randomArray];
    unsigned long count = (unsigned long)randomArray.count;
    int index = 0;
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);
    __unused long time = [timeSp integerValue];
    NSLog(@"time = %ld", (long)time);
    for (int i = 0; i<8; i++) {
        index = arc4random()%count;
        NSString *string = [randomArray objectAtIndex:index];
        [randomString appendString:string];
    }
    NSLog(@"%@%@",timeSp ,randomString);
    NSString *noncestr = [NSString stringWithFormat:@"%@%@", timeSp, randomString];
    //获得参数，升序排列
    NSString* sign_params = [NSString stringWithFormat:@"noncestr=%@&secret=%@&timestamp=%@",noncestr, SECRET,timeSp];
    NSLog(@"1.————》%@", sign_params);
    NSString *sign = [sign_params sha1];
    NSLog(@"sign = %@", sign);
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/weixinapplogin?noncestr=%@&timestamp=%@&sign=%@", Root_URL,noncestr, timeSp, sign];
    NSDictionary *newDic = @{@"headimgurl":[wechatInfo objectForKey:@"headimgurl"],
                             @"nickname":[wechatInfo objectForKey:@"nickname"],
                             @"openid":[wechatInfo objectForKey:@"openid"],
                             @"unionid":[wechatInfo objectForKey:@"unionid"],
                             @"devtype":LOGINDEVTYPE};
    [MBProgressHUD showLoading:@""];
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_semaphore_t semaphoer = dispatch_semaphore_create(0);
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:newDic WithSuccess:^(id responseObject) {
            if (!responseObject) return ;
            dispatch_semaphore_signal(semaphoer);
            NSLog(@"responseObject --> 微信回调请求成功");
//            [MBProgressHUD hideHUD];
            if ([responseObject[@"rcode"] integerValue] != 0) {
                [MBProgressHUD showMessage:responseObject[@"msg"]];
                return;
            }
            [JMUserDefaults setObject:@"wxlogin" forKey:kWeiXinauthorize];
            [JMUserDefaults synchronize];
            if (success) {
                success(responseObject);
            }
        } WithFail:^(NSError *error) {
            dispatch_semaphore_signal(semaphoer);
            [MBProgressHUD showError:@"登录失败，请重试"];
            if (failure) {
                failure(error);
            }
        } Progress:^(float progress) {
            
        }];
        dispatch_semaphore_wait(semaphoer, DISPATCH_TIME_FOREVER);
        
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadTaskUserAccount];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadTaskUserInfo:viewController];
    
    }];
    
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation2, operation1, operation3] waitUntilFinished:NO];
    
    
//    dispatch_queue_t queue = dispatch_queue_create("CSLoginManager", NULL);
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_semaphore_t semaphoer = dispatch_semaphore_create(0);
//    
//    dispatch_group_async(group, queue, ^{
//        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:newDic WithSuccess:^(id responseObject) {
//            if (!responseObject) return ;
//            dispatch_semaphore_signal(semaphoer);
//            NSLog(@"responseObject --> 微信回调请求成功");
//            [MBProgressHUD hideHUD];
//            if ([responseObject[@"rcode"] integerValue] != 0) {
//                [MBProgressHUD showMessage:responseObject[@"msg"]];
//                return;
//            }
//            [JMUserDefaults setObject:@"wxlogin" forKey:kWeiXinauthorize];
//            [JMUserDefaults synchronize];
//            if (success) {
//                success(responseObject);
//            }
//        } WithFail:^(NSError *error) {
//            dispatch_semaphore_signal(semaphoer);
//            [MBProgressHUD showError:@"登录失败，请重试"];
//            if (failure) {
//                failure(error);
//            }
//        } Progress:^(float progress) {
//            
//        }];
//        dispatch_semaphore_wait(semaphoer, DISPATCH_TIME_FOREVER);
//    });
//    dispatch_group_async(group, queue, ^{
//        NSDictionary *params = [JMUserDefaults objectForKey:@"MiPush"];
//        NSString *urlString1 = [NSString stringWithFormat:@"%@/rest/v1/push/set_device", Root_URL];
//        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString1 WithParaments:params WithSuccess:^(id responseObject) {
//            NSString *user_account = responseObject[@"user_account"];
//            if (![NSString isStringEmpty:user_account]) {
//                [MiPushSDK setAccount:user_account];
//                //保存user_account
//                [JMUserDefaults setObject:user_account forKey:@"user_account"];
//                [JMUserDefaults synchronize];
//            }
//            dispatch_semaphore_signal(semaphoer);
//        } WithFail:^(NSError *error) {
//            dispatch_semaphore_signal(semaphoer);
//        } Progress:^(float progress) {
//            
//        }];
//        dispatch_semaphore_wait(semaphoer, DISPATCH_TIME_FOREVER);
//    });
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"请求完成");
//    });
    
    
}
- (void)accountLoginWithViewController:(UIViewController *)viewController Account:(NSString *)account Pwd:(NSString *)pwd Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure {
    
    [MBProgressHUD showLoading:@""];
    NSDictionary *parameters = @{@"username":account,
                                 @"password":pwd,
                                 @"devtype":LOGINDEVTYPE};
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_semaphore_t semaphoer = dispatch_semaphore_create(0);
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:TPasswordLogin_URL WithParaments:parameters WithSuccess:^(id responseObject) {
            dispatch_semaphore_signal(semaphoer);
            if ([[responseObject objectForKey:@"rcode"] integerValue] != 0) {
                [MBProgressHUD showError:[responseObject objectForKey:@"msg"]];
                return ;
            }
            NSString *encryptionStr = [AESEncryption encrypt:pwd password:account];
            [JMUserDefaults setObject:account forKey:kUserName];
            [JMUserDefaults setObject:encryptionStr forKey:kPassWord];
            [JMUserDefaults setObject:kPhoneLogin forKey:kLoginMethod];
            [JMUserDefaults synchronize];
        } WithFail:^(NSError *error) {
            dispatch_semaphore_signal(semaphoer);
            [MBProgressHUD showError:@"登录失败，请重试"];
        } Progress:^(float progress) {
        }];
        dispatch_semaphore_wait(semaphoer, DISPATCH_TIME_FOREVER);
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadTaskUserAccount];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadTaskUserInfo:viewController];
        
    }];
    
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation2, operation1, operation3] waitUntilFinished:NO];
    
    
    

}

- (void)phoneLoginWithViewController:(UIViewController *)viewController Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure {
    
    [MBProgressHUD showLoading:@""];
    [self loadTaskUserAccount];
    [self loadTaskUserInfo:viewController];
    
    
    
}


- (void)loadTaskUserAccount {
    NSDictionary *params = [JMUserDefaults objectForKey:@"MiPush"];
    NSString *urlString1 = [NSString stringWithFormat:@"%@/rest/v1/push/set_device", Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString1 WithParaments:params WithSuccess:^(id responseObject) {
        NSString *user_account = responseObject[@"user_account"];
        if (![NSString isStringEmpty:user_account]) {
            [MiPushSDK setAccount:user_account];
            //保存user_account
            [JMUserDefaults setObject:user_account forKey:@"user_account"];
            [JMUserDefaults synchronize];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)loadTaskUserInfo:(UIViewController *)viewController {
    [[JMGlobal global] upDataLoginStatusSuccess:^(id responseObject) {
        if ([responseObject[@"check_xiaolumm"] integerValue] != 1) {
            [viewController dismissViewControllerAnimated:YES completion:nil];
            [JMNotificationCenter postNotificationName:@"WeChatLoginSuccess" object:nil];
            [MBProgressHUD hideHUD];
            return ;
        }
        BOOL kIsBindPhone = [NSString isStringEmpty:[responseObject objectForKey:@"mobile"]];
        BOOL kIsVIP = [JMUserDefaults boolForKey:kISNDPZVIP];
        
        [JMUserDefaults setObject:kWeiXinLogin forKey:kLoginMethod];
        [JMUserDefaults synchronize];
        
        if (kIsVIP) {
            if (!kIsBindPhone) {
                [viewController dismissViewControllerAnimated:YES completion:nil];
                [JMNotificationCenter postNotificationName:@"WeChatLoginSuccess" object:nil];
            }else {
                JMVerificationCodeController *vc = [[JMVerificationCodeController alloc] init];
                vc.verificationCodeType = SMSVerificationCodeWithBind;
                vc.userLoginMethodWithWechat = YES;
                [viewController.navigationController pushViewController:vc animated:YES];
            }
        }else {
            JMVerificationCodeController *verfyCodeVC = [[JMVerificationCodeController alloc] init];
            verfyCodeVC.verificationCodeType = SMSVerificationCodeWithLogin;
            verfyCodeVC.userLoginMethodWithWechat = YES;
            verfyCodeVC.userNotXLMM = YES;
            [viewController.navigationController pushViewController:verfyCodeVC animated:YES];
        }
        
        [MBProgressHUD hideHUD];
    } failure:^(NSInteger errorCode) {
        
    }];
}

- (NSArray *)randomArray{
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithCapacity:62];
    
    for (int i = 0; i<10; i++) {
        // NSLog(@"%d", i);
        NSString *string = [NSString stringWithFormat:@"%d",i];
        [mutable addObject:string];
    }
    for (char i = 'a'; i<='z'; i++) {
        // NSLog(@"%c", i);
        NSString *string = [NSString stringWithFormat:@"%c", i];
        
        [mutable addObject:string];
    }
    NSArray *array = [NSArray arrayWithArray:mutable];
    
    NSLog(@"array = %@", array);
    return array;
}






@end



























































































































