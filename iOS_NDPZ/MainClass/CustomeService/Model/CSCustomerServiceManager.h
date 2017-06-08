//
//  CSCustomerServiceManager.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/17.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^popCustomerServiceBlock)();

@class CSUserProfileModel;
@interface CSCustomerServiceManager : NSObject 

+ (instancetype)defaultManager;

// 清除缓存回调
@property (nonatomic, copy) popCustomerServiceBlock popBlock;

- (void)showCustomerService:(UIViewController *)vc;
- (void)registerUserInfo:(CSUserProfileModel *)model;



@end
