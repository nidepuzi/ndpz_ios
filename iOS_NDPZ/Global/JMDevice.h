//
//  JMDevice.h
//  XLMM
//
//  Created by zhang on 17/4/4.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMYWebView;
@interface JMDevice : NSObject

+ (instancetype)defaultDecice;

- (NSString *)getUserAgent;

- (NSString *)getDeviceName;

- (void)cerateUserAgent:(IMYWebView *)webView;

- (void)getServerIP;

@end
