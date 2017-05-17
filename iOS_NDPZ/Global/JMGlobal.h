//
//  JMGlobal.h
//  XLMM
//
//  Created by zhang on 17/4/8.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMPopView.h"
#import "JMShareView.h"

typedef NS_ENUM(NSUInteger, popType) {
    popViewTypeShare,               // 分享
    popViewTypeBox,                 // 选择框
    popViewTypeReceiveCoupon        // 领取优惠券
};

typedef void(^clearCacheBlock)(NSString *sdImageCacheString);

@interface JMGlobal : NSObject

// 清除缓存回调
@property (nonatomic, copy) clearCacheBlock cacheBlock;

+ (JMGlobal *)global;

- (void)clearAllSDCache;
/*
    判断当前时间与 dayNumber(-前/+后)时间 的判断
 */
- (BOOL)currentTimeWithBeforeDays:(NSInteger)dayNumber;
/*
    清除缓存
 */
- (void)clearCacheWithSDImageCache:(clearCacheBlock)cacheBlock;

/*
    监听网络,配置网络请求头信息
 */
- (void)monitoringNetworkStatus;

//显示无数据页面
- (void)showMessageView:(UIView *)parentView withBlock:(void (^)(UIView* messageView))clickBlock;
- (void)showMessageView:(UIView *)parentView message:(NSString*)message withBlock:(void (^)(UIView* messageView))clickBlock;
- (void)showMessageView:(UIView *)parentView message:(NSString*)message iconImage:(UIImage*)image withBlock:(void (^)(UIView* messageView))clickBlock;
- (void)hideMessageView;


/*
 弹出登录界面
 */
- (void)showLoginViewController;

/*
    弹出视图
 */
- (void)showpopBoxType:(popType)type Frame:(CGRect)frame ViewController:(UIViewController *)viewController WithBlock:(void (^)(UIView *maskView))clickBlock;

/*
    请求个人信息,保存登录信息
 */
- (void)upDataLoginStatusSuccess:(void (^)(id responseObject))success
                         failure:(void (^)(NSInteger errorCode))failure;



- (void)showWaitLoadingInView:(UIView *)viewController;
- (void)hideWaitLoading;

    
- (int)secondOFCurrentTimeInEndtimeInt:(int)endTime;
- (int)secondOfCurrentTimeInEndTime:(NSString *)endTime;


/*
    验证身份证
 */
- (BOOL)validateIdentityCard:(NSString *)value;
/*
    用户身份验证
 */
- (BOOL)userVerificationXLMM;
- (BOOL)userVerificationLogin;

// 获取图片
- (NSData *)getCacheImageWithKey:(NSString *)key;

-(int)getCurrentDeviceModel;




@end
