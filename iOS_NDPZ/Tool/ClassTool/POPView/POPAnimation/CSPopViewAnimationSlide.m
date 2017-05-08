//
//  CSPopViewAnimationSlide.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPopViewAnimationSlide.h"

@implementation CSPopViewAnimationSlide

- (void)showPopView:(UIView *)popView MaskView:(UIView *)maskView {
    CGSize sourceSize = maskView.bounds.size;
    CGSize popupSize = popView.bounds.size;
    CGRect popupStartRect;
    switch (_type) {
        case CSPopViewAnimationSlideTypeBottomTop:
        case CSPopViewAnimationSlideTypeBottomBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                        sourceSize.height,
                                        popupSize.width,
                                        popupSize.height);
            
            break;
        case CSPopViewAnimationSlideTypeLeftLeft:
        case CSPopViewAnimationSlideTypeLeftRight:
            popupStartRect = CGRectMake(-sourceSize.width,
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width,
                                        popupSize.height);
            break;
            
        case CSPopViewAnimationSlideTypeTopTop:
        case CSPopViewAnimationSlideTypeTopBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                        -popupSize.height,
                                        popupSize.width,
                                        popupSize.height);
            break;
            
        default:
            popupStartRect = CGRectMake(sourceSize.width,
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width,
                                        popupSize.height);
            break;
    }
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    // Set starting properties
    popView.frame = popupStartRect;
    popView.alpha = 1.0f;
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        popView.frame = popupEndRect;
    } completion:nil];
}
- (void)dismissPopView:(UIView *)popView MaskView:(UIView *)maskView completion:(void (^)(void))completion {
    CGSize sourceSize = maskView.bounds.size;
    CGSize popupSize = popView.bounds.size;
    CGRect popupEndRect;
    switch (_type) {
        case CSPopViewAnimationSlideTypeBottomTop:
        case CSPopViewAnimationSlideTypeTopTop:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                      -popupSize.height,
                                      popupSize.width,
                                      popupSize.height);
            break;
        case CSPopViewAnimationSlideTypeBottomBottom:
        case CSPopViewAnimationSlideTypeTopBottom:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                      sourceSize.height,
                                      popupSize.width,
                                      popupSize.height);
            break;
        case CSPopViewAnimationSlideTypeLeftRight:
        case CSPopViewAnimationSlideTypeRightRight:
            popupEndRect = CGRectMake(sourceSize.width,
                                      popView.frame.origin.y,
                                      popupSize.width,
                                      popupSize.height);
            break;
        default:
            popupEndRect = CGRectMake(-popupSize.width,
                                      popView.frame.origin.y,
                                      popupSize.width,
                                      popupSize.height);
            break;
    }
    
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        popView.frame = popupEndRect;
        maskView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        completion();
    }];

}

@end
