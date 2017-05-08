//
//  CSPopViewAnimationSpring.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPopViewAnimationSpring.h"

@interface CSPopViewAnimationSpring ()

@property (nonatomic,copy)void (^completion)(void);

@end

@implementation CSPopViewAnimationSpring

- (void)showPopView:(UIView *)popView MaskView:(UIView *)maskView {
    popView.alpha = 1.0f;
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [popView.layer addAnimation:popAnimation forKey:nil];
}
- (void)dismissPopView:(UIView *)popView MaskView:(UIView *)maskView completion:(void (^)(void))completion {
    _completion = completion;
    
    [UIView animateWithDuration:0.4 animations:^{
        maskView.alpha = 0;
    }];
    
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    hideAnimation.delegate = self;
    [popView.layer addAnimation:hideAnimation forKey:nil];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _completion();
}

@end
