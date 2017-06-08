//
//  CSDataBase.h
//  iOS_NDPZ
//
//  Created by zhang on 17/6/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKDBHelper/LKDBHelper.h>



@interface CSDataBase : NSObject

+ (LKDBHelper *)shareUsingLKDBManager;

- (void)initDatabase;
- (void)clearDatabase;

@end
