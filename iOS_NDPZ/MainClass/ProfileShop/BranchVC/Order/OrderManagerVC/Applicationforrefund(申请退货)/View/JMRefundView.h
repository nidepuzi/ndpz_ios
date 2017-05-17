//
//  JMRefundView.h
//  XLMM
//
//  Created by zhang on 17/4/20.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMRefundView;

@protocol JMRefundViewDelegate <NSObject>

@optional

- (void)composeRefundButton:(JMRefundView *)refundButton didClick:(NSInteger)index;
@end

@interface JMRefundView : UIView

@property (nonatomic, weak) id<JMRefundViewDelegate> delegate;

+ (instancetype)defaultPopView;

@property (nonatomic, copy) NSString *titleStr;

@end
