//
//  CSDataBase.m
//  iOS_NDPZ
//
//  Created by zhang on 17/6/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSDataBase.h"
#import "CSUserProfileManager.h"


@implementation CSDataBase

+ (LKDBHelper *)shareUsingLKDBManager {
    static LKDBHelper *dbHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        dbHelper = [[LKDBHelper alloc] initWithDBPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"nidepuzi.db"]];
    });
    return dbHelper;
}

- (void)initDatabase {
    LKDBHelper *globalHelper = [CSDataBase shareUsingLKDBManager];
    //创建表
    BOOL result;
    result = [globalHelper getTableCreatedWithClass:[CSUserProfileManager class]];
    
}

- (void)clearDatabase {
    LKDBHelper *globalHelper = [CSDataBase getUsingLKDBHelper];
    //删除表
    [globalHelper deleteWithClass:[CSUserProfileManager class] where:nil];

}



@end
