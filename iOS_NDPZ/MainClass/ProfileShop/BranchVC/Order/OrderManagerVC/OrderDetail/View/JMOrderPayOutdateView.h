//
//  JMOrderPayOutdateView.h
//  XLMM
//
//  Created by zhang on 17/4/7.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMOrderPayOutdateView;
@protocol JMOrderPayOutdateViewDelegate <NSObject>

- (void)composeOutDateView:(JMOrderPayOutdateView *)outDateView Index:(NSInteger)index;

@end

@interface JMOrderPayOutdateView : UIView

@property (nonatomic, copy) NSString *createTimeStr;

@property (nonatomic, assign) NSInteger statusCount;
@property (nonatomic, assign) BOOL isTeamBuy;

@property (nonatomic, weak) id<JMOrderPayOutdateViewDelegate> delegate;

@end
