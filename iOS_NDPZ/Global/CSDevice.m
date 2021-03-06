//
//  CSDevice.m
//  NDPZ
//
//  Created by zhang on 17/4/20.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSDevice.h"
#import "sys/utsname.h"


@implementation CSDevice

+ (CSDevice *)defaultDevice {
    static dispatch_once_t onceToken;
    static CSDevice *device = nil;
    dispatch_once(&onceToken, ^{
        device = [[CSDevice alloc] init];
    });
    return device;
}

- (NSString *)getUserAgent {
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* phoneVersion = SSystemVersion;
    NSString *appCurVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];            // 当前应用版本
    NSString* phoneModel = [[CSDevice defaultDevice] getDeviceName];
    NSString *userAgent =  [NSString stringWithFormat:@"iOS/%@ XLMM/%@ Mobile/(%@)",phoneVersion,appCurVersion,phoneModel];
    
    return userAgent;
}

- (NSString *)getDeviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([machineString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([machineString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([machineString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([machineString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([machineString isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([machineString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([machineString isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([machineString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([machineString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([machineString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([machineString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([machineString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s Plus";
    if ([machineString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s";
    if ([machineString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([machineString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([machineString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([machineString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([machineString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([machineString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([machineString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([machineString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([machineString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([machineString isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([machineString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([machineString isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([machineString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([machineString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([machineString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([machineString isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([machineString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([machineString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([machineString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([machineString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([machineString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([machineString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([machineString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (Cellular)";
    if ([machineString isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    if ([machineString isEqualToString:@"i386"])         return @"Simulator";
    if ([machineString isEqualToString:@"x86_64"])       return @"Simulator";
    return machineString;
    
}


- (NSString *)getDeviceAppName {
    return [[self getDeviceInfo] objectForKey:@"CFBundleDisplayName"];
}
- (NSString *)getDeviceAppVersion {
    return [[self getDeviceInfo] objectForKey:@"CFBundleShortVersionString"];
}
- (NSString *)getDeviceAppBuildVersion {
    return [[self getDeviceInfo] objectForKey:@"CFBundleVersion"];
}
- (NSString *)getPhoneVersion {
    return [[UIDevice currentDevice] systemVersion];
}
- (NSString *)getPhoneModel {
    return [[UIDevice currentDevice] model];
}
- (NSDictionary *)getDeviceInfo {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary;
}
- (NSString *)getDeviceCacheSize {
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    float sizeValue = [[dict objectForKey:NSFileSize] integerValue]/200.0f;
    if (sizeValue < 1.0) {
        sizeValue = 0.0f;
    }
    return [NSString stringWithFormat:@"%.1fM", sizeValue];;
}
- (void)clearCache {
    [[SDImageCache sharedImageCache] clearDisk];
}
- (void)showAlertMessage:(NSString *)messageString {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:messageString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (BOOL)userIsLogin {
    return [JMUserDefaults boolForKey:kIsLogin];
}
- (BOOL)userIsSuperVIP {
    return [JMUserDefaults boolForKey:kISXLMM];
}













@end























































