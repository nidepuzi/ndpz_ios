//
//  UIViewController+CSPopAnimationViewController.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSPopAnimation <NSObject>

@required
- (void)showPopView:(UIView *)popView MaskView:(UIView *)maskView;
- (void)dismissPopView:(UIView *)popView MaskView:(UIView *)maskView completion:(void (^)(void))completion;

@end


@interface UIViewController (CSPopAnimationViewController)

@property (nonatomic, retain, readonly) UIView *csPopView;
@property (nonatomic, retain, readonly) UIView *csMaskView;
@property (nonatomic, retain, readonly) id<CSPopAnimation> csPopAnimation;

- (void)cs_presentPopView:(UIView *)popView animation:(id<CSPopAnimation>)animation;
- (void)cs_presentPopView:(UIView *)popView animation:(id<CSPopAnimation>)animation dismiss:(void (^)(void))dismiss;

- (void)cs_presentPopView:(UIView *)popView animation:(id<CSPopAnimation>)animation backgroundClickable:(BOOL)clickable;
- (void)cs_presentPopView:(UIView *)popView animation:(id<CSPopAnimation>)animation backgroundClickable:(BOOL)clickable dismiss:(void (^)(void))dismiss;

- (void)cs_dismissPopView;
- (void)cs_dismissPopViewWithAnimation:(id<CSPopAnimation>)animation;

@end


#pragma mark -
@interface UIView (CSPopAnimationViewController)
@property (nonatomic, weak, readonly) UIViewController *csPopViewController;

@end
