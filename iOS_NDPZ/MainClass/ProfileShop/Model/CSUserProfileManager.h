//
//  CSUserProfileManager.h
//  iOS_NDPZ
//
//  Created by zhang on 17/6/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSUserProfileModel;
@interface CSUserProfileManager : NSObject

+ (CSUserProfileManager *)sharInstance;


- (CSUserProfileModel *)getUserInfo;
- (void)saveUserInfoWithModel:(CSUserProfileModel *)model;
- (void)deleteUserInfo;


@end
