//
//  JMGroupLogistics.h
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMLogistics;
@interface JMGroupLogistics : NSObject

@property (nonatomic, strong) NSArray *logistics;
@property (nonatomic, copy) NSString *title;

-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) groupLogisticsWithDict:(NSDictionary *)dict;

@end
