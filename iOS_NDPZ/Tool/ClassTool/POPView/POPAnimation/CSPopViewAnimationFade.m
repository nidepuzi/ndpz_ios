//
//  CSPopViewAnimationFade.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPopViewAnimationFade.h"

@implementation CSPopViewAnimationFade

- (void)showPopView:(UIView *)popView MaskView:(UIView *)maskView {
    popView.center = maskView.center;
    popView.alpha = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{
        popView.alpha = 1.0f;
    } completion:nil];
}
- (void)dismissPopView:(UIView *)popView MaskView:(UIView *)maskView completion:(void (^)(void))completion {
    [UIView animateWithDuration:0.25 animations:^{
        maskView.alpha = 0.0f;
        popView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            completion();
        }
    }];
}

@end
