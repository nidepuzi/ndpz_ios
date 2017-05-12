//
//  UIViewController+CSPopAnimationViewController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "UIViewController+CSPopAnimationViewController.h"
#import <objc/runtime.h>
#import "CSPopBackgroundView.h"

#define kCSPopView @"kCSPopView"
#define kCSMaskView @"kCSMaskView"
#define kCSPopViewDismissedBlock @"kCSPopViewDismissedBlock"
#define KCSPopAnimation @"KCSPopAnimation"
#define kCSPopViewController @"kCSPopViewController"

#define kCSPopViewTag 1001
#define kCSMaskViewTag 1002

@interface UIView (CSPopAnimationViewControllerPrivate)

@property (nonatomic, weak, readwrite) UIViewController *csPopViewController;

@end


@interface UIViewController (CSPopAnimationViewControllerPrivate)

@property (nonatomic, strong) UIView *csPopView;
@property (nonatomic, strong) UIView *csMaskView;
@property (nonatomic, copy) void (^csDismissCallBack)(void);
@property (nonatomic, strong) id<CSPopAnimation> popAnimation;

- (UIView *)topView;

@end

@implementation UIViewController (CSPopAnimationViewController)

#pragma mark public Method
- (void)cs_presentPopView:(UIView *)popView animation:(id<CSPopAnimation>)animation {
    [self pressentPopView:popView animation:animation backgroundClickable:YES dismiss:nil];
}
- (void)cs_presentPopView:(UIView *)popView animation:(id<CSPopAnimation>)animation dismiss:(void (^)(void))dismiss {
    [self pressentPopView:popView animation:animation backgroundClickable:YES dismiss:dismiss];
}

- (void)cs_presentPopView:(UIView *)popView animation:(id<CSPopAnimation>)animation backgroundClickable:(BOOL)clickable {
    [self pressentPopView:popView animation:animation backgroundClickable:clickable dismiss:nil];
}
- (void)cs_presentPopView:(UIView *)popView animation:(id<CSPopAnimation>)animation backgroundClickable:(BOOL)clickable dismiss:(void (^)(void))dismiss {
    [self pressentPopView:popView animation:animation backgroundClickable:clickable dismiss:dismiss];
}

- (void)cs_dismissPopView {
    [self dismissPopViewWithAnimation:self.csPopAnimation];
}
- (void)cs_dismissPopViewWithAnimation:(id<CSPopAnimation>)animation {
    [self dismissPopViewWithAnimation:animation];
}

#pragma mark property
- (UIView *)csPopView {
    return objc_getAssociatedObject(self, kCSPopView);
}
- (void)setCsPopView:(UIViewController *)csPopView {
    objc_setAssociatedObject(self, kCSPopView, csPopView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)csMaskView {
    return objc_getAssociatedObject(self, kCSMaskView);
}
- (void)setCsMaskView:(UIViewController *)csMaskView {
    objc_setAssociatedObject(self, kCSMaskView, csMaskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(void))csDismissCallBack {
    return objc_getAssociatedObject(self, kCSPopViewDismissedBlock);
}
- (void)setCsDismissCallBack:(void (^)(void))csDismissCallBack {
    objc_setAssociatedObject(self, kCSPopViewDismissedBlock, csDismissCallBack, OBJC_ASSOCIATION_COPY);
}
- (id<CSPopAnimation>)csPopAnimation {
    return objc_getAssociatedObject(self, KCSPopAnimation);
}
- (void)setCsPopAnimation:(id<CSPopAnimation>)csPopAnimation {
    objc_setAssociatedObject(self, KCSPopAnimation, csPopAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark persentView 
- (void)pressentPopView:(UIView *)popView animation:(id<CSPopAnimation>)animation backgroundClickable:(BOOL)clickable dismiss:(void (^)(void))dismiss {
    if ([self.csMaskView.subviews containsObject:popView]) {
        return;
    }
    if (self.csMaskView && self.csMaskView.subviews.count > 1) {
        [self dismissPopViewWithAnimation:nil];
    }
    self.csPopView = nil;
    self.csPopView = popView;
    self.csPopAnimation = nil;
    self.csPopAnimation = animation;
    
    UIView *sourceView = [self cs_topView];
    // customize popupView
    popView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popView.tag = kCSPopViewTag;
    popView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popView.bounds].CGPath;
    popView.layer.masksToBounds = NO;
    popView.layer.shadowOffset = CGSizeMake(5, 5);
    popView.layer.shadowRadius = 5;
//    popView.layer.shadowOpacity = 0.5;
    popView.layer.shouldRasterize = YES;
    popView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    if (self.csMaskView == nil) {
        UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        maskView.tag = kCSMaskViewTag;
        maskView.backgroundColor = [UIColor clearColor];
        
        // BackgroundView
        UIView *backgroundView = [[CSPopBackgroundView alloc] initWithFrame:maskView.frame BackgroundViewEnable:clickable];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //        backgroundView.backgroundColor = [UIColor clearColor];
        [maskView addSubview:backgroundView];
        
        // Make the Background Clickable
        if (clickable) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cs_dismissPopView)];
            [backgroundView addGestureRecognizer:tap];
        }else {
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cs_dismissPopView)];
//            [backgroundView addGestureRecognizer:tap];
        }
        self.csMaskView = maskView;
    }

    
    [self.csMaskView addSubview:popView];
    if (clickable) {
        [sourceView addSubview:self.csMaskView];
    }else {
        [JMKeyWindow addSubview:self.csMaskView];
    }
    
    
    self.csMaskView.alpha = 1.f;
    popView.center = self.csMaskView.center;
    if (animation) {
        [animation showPopView:popView MaskView:self.csMaskView];
    }
    [self setCsDismissCallBack:dismiss];
}

- (void)dismissPopViewWithAnimation:(id<CSPopAnimation>)animation {
    if (animation) {
        [animation dismissPopView:self.csPopView MaskView:self.csMaskView completion:^{
            [self.csPopView removeFromSuperview];
            [self.csMaskView removeFromSuperview];
            self.csPopView = nil;
            self.csMaskView = nil;
            id dismiss = [self csDismissCallBack];
            if (dismiss != nil) {
                ((void (^)(void))dismiss)();
                [self setCsDismissCallBack:nil];
            }
        }];
    }else {
        [self.csPopView removeFromSuperview];
        [self.csMaskView removeFromSuperview];
        self.csPopView = nil;
        self.csMaskView = nil;
        id dismiss = [self csDismissCallBack];
        if (dismiss != nil) {
            ((void (^)(void))dismiss)();
            [self setCsDismissCallBack:nil];
        }
    }
}


- (UIView *)cs_topView {
    UIViewController *recentView = self;
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}


@end

#pragma mark UIView + CSPopView[
@implementation UIView (CSPopAnimationViewController)

- (UIViewController *)csPopViewController {
    return objc_getAssociatedObject(self, kCSPopViewController);
}
- (void)setCsPopViewController:(UIViewController *_Nullable)csPopViewController {
    objc_setAssociatedObject(self, kCSPopViewController, csPopViewController, OBJC_ASSOCIATION_ASSIGN);
}

@end
















































