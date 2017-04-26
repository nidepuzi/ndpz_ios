//
//  CSNetFailView.m
//  NDPZ
//
//  Created by zhang on 17/4/20.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSNetFailView.h"
#import "CSFont.h"

#define REMINDELABEL_SIZE 60

@implementation CSNetFailView

+ (instancetype)shareInstance {
    
    static CSNetFailView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSNetFailView alloc] init];
    });
    return instance;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAlpha:0.6];
        _remindeLabel = [[UILabel alloc] init];
        [_remindeLabel setBackgroundColor:[UIColor clearColor]];
        _remindeLabel.textColor = [UIColor colorWithHex:0xff5000];
        _remindeLabel.font = [UIFont systemFontOfSize:16];
        _remindeLabel.numberOfLines = 0;
        _remindeLabel.textAlignment = NSTextAlignmentCenter;
        _remindeLabel.frame = CGRectMake(20, 0, self.bounds.size.width - 40, REMINDELABEL_SIZE);
        _remindeLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [self addSubview:_remindeLabel];
        
        _failIm = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_failIm];
        [_remindeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_failIm.mas_bottom).offset(15);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)aTapGesture{
    if (_touchNetFailView) {
        _touchNetFailView(self);
    }
}
- (void)setImName:(NSString *)imName {
    _imName = imName;
    UIImage *ima = [UIImage imageNamed:imName];
    self.iconImage = ima;
    [self setNeedsLayout];
}
- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    _failIm.image = _iconImage;
    [self setNeedsLayout];
}
- (void)setMessage:(NSString *)message {
    _remindeLabel.frame = CGRectMake(20, 0, self.bounds.size.width - 40, REMINDELABEL_SIZE);
    _message = message;
    _remindeLabel.text = message;
    [self setNeedsLayout];
}
- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    if (_customView == nil) {
        _remindeLabel.hidden = NO;
        _failIm.hidden = NO;
    }else {
        _remindeLabel.hidden = YES;
        _failIm.hidden = YES;
        [self addSubview:_customView];
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (_customView) {
        _customView.center = self.cs_center;
    }else{
        
        UIImage *im = _failIm.image;
        if ([[JMGlobal global] getCurrentDeviceModel]>1) {
            _failIm.frame = CGRectMake(0, 0, im.size.width * 0.8 , im.size.height * 0.8);
            _remindeLabel.font = [CSFont heitiLightWithSize:14];
        }else{
            _failIm.frame = CGRectMake(0, 0, im.size.width, im.size.height);
            _remindeLabel.font = [CSFont heitiLightWithSize:16];
        }
        //        _failIm.center = self.center;
        //        _remindeLabel.center = self.center;
        _failIm.bottom = _remindeLabel.cs_top;
        _failIm.center =CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 -im.size.height/2.);
        [_remindeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_failIm.mas_bottom).offset(15);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
        _remindeLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
}



+ (void)showView:(UIView *)view withAnimate:(BOOL)animate {
    [CSNetFailView showView:view withMessage:@"暂无数据" withIconImage:[UIImage imageNamed:@"nodata"] withAnimate:animate];
}

+ (void)showView:(UIView *)view withMessage:(NSString *)message withIconImage:(UIImage *)iconImage withAnimate:(BOOL)animate{
    [CSNetFailView shareInstance].backgroundColor = [UIColor whiteColor];
    [CSNetFailView hideView:NO];
    [view addSubview:[CSNetFailView shareInstance]];
    
    [CSNetFailView shareInstance].frame = view.bounds;
    [[CSNetFailView shareInstance] setMessage:message];
    [[CSNetFailView shareInstance] setIconImage:iconImage];
    [CSNetFailView showAnimation:animate];
}


+ (void)hideView:(BOOL)animate {
    [CSNetFailView hideAnimation:animate];
}
+ (void)showAnimation:(BOOL)animate {
    if (animate) {
        [CSNetFailView shareInstance].alpha = 0.0f;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^(){
            [CSNetFailView shareInstance].alpha = 1.0f;
        } completion:^(BOOL finished){
        }];
    }else {
        [CSNetFailView shareInstance].alpha = 1.0f;
    }
}
+ (void)hideAnimation:(BOOL)animate {
    if (animate) {
        [CSNetFailView shareInstance].alpha = 1.0f;
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^(){
            [CSNetFailView shareInstance].alpha = 0.0f;
        } completion:^(BOOL finished){
            [[CSNetFailView shareInstance] removeFromSuperview];
        }];
    }else {
        [CSNetFailView shareInstance].alpha = 0.0f;
    }
}





@end

























































































































































