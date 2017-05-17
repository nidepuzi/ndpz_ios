//
//  CSCustomerServiceManager.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/17.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCustomerServiceManager : NSObject

+ (instancetype)defaultManager;

- (void)registerUserInfo:(NSDictionary *)dic;



@end
