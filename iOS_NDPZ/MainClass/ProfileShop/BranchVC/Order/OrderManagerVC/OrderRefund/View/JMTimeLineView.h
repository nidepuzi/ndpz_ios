//
//  JMTimeLineView.h
//  XLMM
//
//  Created by zhang on 17/4/16.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMTimeLineView : UIView {
    CGFloat viewWidth;
}

@property (nonatomic, assign) CGFloat viewWidth;

- (id)initWithTimeArray:(NSArray *)time andTimeDesArray:(NSArray *)timeDes andCurrentStatus:(NSInteger)status andFrame:(CGRect)frame;


@end
