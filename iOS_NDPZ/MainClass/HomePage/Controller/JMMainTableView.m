//
//  JMMainTableView.m
//  XLMM
//
//  Created by zhang on 17/4/23.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMMainTableView.h"

@implementation JMMainTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
