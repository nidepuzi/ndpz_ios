//
//  CSPopViewAnimationDrop.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPopViewAnimationDrop.h"

@implementation CSPopViewAnimationDrop

- (void)showPopView:(UIView *)popView MaskView:(UIView *)maskView {
    maskView.center = CGPointMake(maskView.center.x, -popView.bounds.size.height/2);
    popView.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    [UIView animateWithDuration:0.30f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        popView.transform = CGAffineTransformMakeRotation(0);
        popView.center = maskView.center;
    } completion:nil];
}
- (void)dismissPopView:(UIView *)popView MaskView:(UIView *)maskView completion:(void (^)(void))completion {
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        maskView.alpha = 0.0;
        popView.center = CGPointMake(maskView.center.x, maskView.bounds.size.height+popView.bounds.size.height);
        popView.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
    } completion:^(BOOL finished) {
        completion();
    }];
}


@end
