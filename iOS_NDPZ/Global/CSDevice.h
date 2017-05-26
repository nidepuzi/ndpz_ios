//
//  CSDevice.h
//  NDPZ
//
//  Created by zhang on 17/4/20.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSDevice : NSObject

+ (CSDevice *)defaultDevice;

- (NSString *)getUserAgent;
- (NSString *)getDeviceName;
- (NSString *)getDeviceAppName;
- (NSString *)getDeviceAppVersion;
- (NSString *)getDeviceAppBuildVersion;
- (NSString *)getPhoneVersion;
- (NSString *)getPhoneModel;
- (NSString *)getDeviceCacheSize;
- (void)clearCache;
- (void)showAlertMessage:(NSString *)messageString;

- (BOOL)userIsLogin;
- (BOOL)userIsSuperVIP;




@end
