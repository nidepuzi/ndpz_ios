//
//  JMDelayPopView.m
//  XLMM
//
//  Created by zhang on 17/4/16.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMDelayPopView.h"

@implementation JMDelayPopView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    return self;
}



+ (instancetype)defaultPopView {
    return [[JMDelayPopView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH  , SCREENWIDTH)];
}

- (void)createUI {
    
    [MBProgressHUD showLoading:@""];
    
    
}

@end
