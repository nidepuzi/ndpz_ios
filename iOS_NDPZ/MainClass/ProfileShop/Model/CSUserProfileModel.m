//
//  CSUserProfileModel.m
//  iOS_NDPZ
//
//  Created by zhang on 17/6/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSUserProfileModel.h"
#import "CSUserProfileManager.h"

@implementation CSUserProfileModel

+ (CSUserProfileModel *)sharInstance {
    static dispatch_once_t onceToken;
    static CSUserProfileModel *item = nil;
    dispatch_once(&onceToken, ^{
        item = [CSUserProfileModel loadFromDB];
        if (item == nil) {
            item = [[CSUserProfileModel alloc] init];
        }
    });
    if ([item.profileID isEqualToString:@"00"]) {
        item = [CSUserProfileModel loadFromDB];
    }
    return item;
}

+ (CSUserProfileModel *)loadFromDB {
    return [[CSUserProfileManager sharInstance] getUserInfo];
}
- (void)loginOut {
    [CSUserProfileModel sharInstance].profileID = @"00";
    [[CSUserProfileManager sharInstance] deleteUserInfo];
}



+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"profileID":@"id"};
}
- (NSString *)nick {
    if ([NSString isStringEmpty:_nick]) {
        return @"";
    }
    return _nick;
}
- (NSString *)thumbnail {
    if ([NSString isStringEmpty:_thumbnail]) {
        return @"";
    }
    return _thumbnail;
}
- (NSString *)email {
    if ([NSString isStringEmpty:_email]) {
        return @"";
    }
    return _email;
}
- (NSString *)birthday_display {
    if ([NSString isStringEmpty:_birthday_display]) {
        return @"";
    }
    return _birthday_display;
}
- (NSString *)province {
    if ([NSString isStringEmpty:_province]) {
        return @"";
    }
    return _province;
}
- (NSString *)city {
    if ([NSString isStringEmpty:_city]) {
        return @"";
    }
    return _city;
}
- (NSString *)district {
    if ([NSString isStringEmpty:_district]) {
        return @"";
    }
    return _district;
}





//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        NSLog(@"initinitinitinitinit");
//        unsigned int count = 0;
////        Ivar *ivarList = class_copyIvarList([self class], &count);
//        objc_property_t * properties = class_copyPropertyList([self class], &count);
//        
//        for (int i = 0; i < count; i++) {
//            const char *propertyName = property_getName(properties[i]);
//            NSString *ivarName = [NSString stringWithUTF8String:propertyName];
//            NSString *ivarType = [NSString stringWithUTF8String:property_getAttributes(properties[i])];
//            if ([ivarType hasPrefix:@"T@\"NSString\""]) {
//                id value = [self valueForKey:ivarName];
//                if ([NSString isStringEmpty:value]) {
//                    value = @"";
//                }
//            }
//        }
//        
//        
//    }
//    return self;
//}













@end



@implementation CSUserVIP

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"UserVipID":@"id"};
}

@end




@implementation CSUserBudget



@end
