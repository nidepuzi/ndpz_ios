//
//  CSLoginManager.h
//  iOS_NDPZ
//
//  Created by zhang on 17/6/7.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSLoginManager : NSObject

+ (CSLoginManager *)loginInstance;

/*
    微信登录回调请求
 */
- (void)wechatLoginWithViewController:(UIViewController *)viewController Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;


/*
    账号登录回调请求
 */
- (void)accountLoginWithViewController:(UIViewController *)viewController Account:(NSString *)account Pwd:(NSString *)pwd Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;


/*
    手机登录回调请求
 */
- (void)phoneLoginWithViewController:(UIViewController *)viewController Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;




@end
