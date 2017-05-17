//
//  JMRefreshLoadView.h
//  XLMM
//
//  Created by zhang on 17/4/3.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMRefreshLoadView : UIView


@property (nonatomic, weak  ) UIScrollView * scrollView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat progressOffsetY;

- (void)setLineLayerStrokeWithProgress:(CGFloat)progress;
- (void)startLoading;
- (void)endLoading;

@end
