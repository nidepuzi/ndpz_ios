//
//  JMGoodsCountTime.h
//  XLMM
//
//  Created by zhang on 17/4/17.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^countTimeBlock)(int second);

@interface JMGoodsCountTime : NSObject

@property (nonatomic, copy) countTimeBlock countBlock;
@property (nonatomic, strong) dispatch_source_t timer;

+ (instancetype)shareCountTime;

- (instancetype)initWithEndTime:(int)endTime;

+ (instancetype)initCountDownWithCurrentTime:(int)endTime;

@end
