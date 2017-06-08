//
//  CSUserProfileManager.m
//  iOS_NDPZ
//
//  Created by zhang on 17/6/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSUserProfileManager.h"
#import "CSDataBase.h"
#import "CSUserProfileModel.h"


@implementation CSUserProfileManager

+ (CSUserProfileManager *)sharInstance {
    static dispatch_once_t onceToken;
    static CSUserProfileManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[CSUserProfileManager alloc] init];
    });
    return instance;
}
- (CSUserProfileModel *)getUserInfo {
    return [[CSDataBase getUsingLKDBHelper] searchSingle:[CSUserProfileModel class] where:@"1=1" orderBy:nil];
}
- (void)saveUserInfoWithModel:(CSUserProfileModel *)model {
    [[CSDataBase getUsingLKDBHelper] deleteWithClass:[CSUserProfileModel class] where:@"1=1"];
    [[CSDataBase getUsingLKDBHelper] insertToDB:model];
}
- (void)deleteUserInfo {
    [[CSDataBase getUsingLKDBHelper] deleteWithClass:[CSUserProfileModel class] where:@"1=1"];

}




@end
