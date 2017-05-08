//
//  CSPopBackgroundView.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPopBackgroundView.h"

@implementation CSPopBackgroundView


- (instancetype)initWithFrame:(CGRect)frame BackgroundViewEnable:(BOOL)enable {
    if (self == [super initWithFrame:frame]) {
        if (enable) {
            self.backgroundColor = [UIColor blackColor];
            self.alpha = 0.7;
        }else {
//            self.userInteractionEnabled = YES;
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
            blurEffectView.frame = self.frame;
            [self addSubview:blurEffectView];
        }
    }
    return self;
}




@end
