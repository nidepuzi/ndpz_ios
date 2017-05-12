//
//  MMClass.h
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "UIColor+RGBColor.h"
#import "UIImage+ImageWithUrl.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <Masonry.h>
#import "UIViewController+NavigationBar.h"
#import "NSString+URL.h"
#import <MJRefresh.h>
#import "JMHTTPManager.h"
#import "MBProgressHUD+JMHUD.h"
#import "UMMobClick/MobClick.h"
#import "NSString+CSCommon.h"
#import "MJAnimationHeader.h"
#import "JMGlobal.h"
#import "JMDevice.h"
#import "UITableView+CSTableViewPlaceHolder.h"
#import "UICollectionView+CSCollectionViewPlaceHolder.h"
#import "UIView+RGSize.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


//#import "NSDictionary+Log.h"


#ifndef XLMM_MMClass_h
#define XLMM_MMClass_h

//#ifndef __OPTIMIZE__
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...) {}
//#endif


#define kUrlScheme @"wxa6e8010fa0b31eb3" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。
#define kIsLogin @"login"
#define kUserName @"userName"
#define kPassWord @"password"
#define kPhoneLogin @"phonelogin"
#define kLoginMethod @"loginMethod"
#define kWeiXinLogin @"weixinlogin"
#define kAppLoadNum @"kAppLoadNum"
#define kWxLoginUserInfo @"userInfo"
#define kWeiXinauthorize @"kWeiXinauthorize"
#define kIsReceivePushTZ @"isReceivePush"
#define kISXLMM @"isXLMM"
#define kUserAgent @"userAgent"
#define LOGINDEVTYPE @"ios"
#define kUserVipStatus @"UserVipStatus"

#define kAPP_WXAPPID = @"wxa6e8010fa0b31eb3"  // wx25fcb32689872499
#define kAPP_WXAPPSECRET = @"a894a72567440fa7317843d76dd7bf03"


UIKIT_EXTERN NSString * Root_URL;
UIKIT_EXTERN NSInteger  const kAppVisitoryDay;
UIKIT_EXTERN CGFloat    const kAppTabBarHeight;
UIKIT_EXTERN CGFloat    const kAppShareViewHeight;
UIKIT_EXTERN CGFloat    const kAppShareEarningViewHeight;
UIKIT_EXTERN NSInteger  const kAPPshopCartType;

@protocol MenuVCPushSideDelegate <NSObject>

- (void)menuVCPushSide;

@end



#endif































































