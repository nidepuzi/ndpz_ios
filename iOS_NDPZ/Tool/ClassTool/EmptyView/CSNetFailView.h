//
//  CSNetFailView.h
//  NDPZ
//
//  Created by zhang on 17/4/20.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchNetFailViewBlock)(UIView *view);

@interface CSNetFailView : UIView

@property (nonatomic, strong) UIImageView *failIm;
@property (nonatomic, strong) UILabel *remindeLabel;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *imName;

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) TouchNetFailViewBlock touchNetFailView;
@property (nonatomic, readonly) UITapGestureRecognizer *tapGesture;

+ (instancetype)shareInstance;
- (id)initWithFrame:(CGRect)frame;
+ (void)showView:(UIView *)view withAnimate:(BOOL)animate;
+ (void)showView:(UIView *)view withMessage:(NSString *)message withIconImage:(UIImage *)iconImage withAnimate:(BOOL)animate;
+ (void)hideView:(BOOL)animate;


@end
