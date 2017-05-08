//
//  CSJoinVipPopView.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/6.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSJoinVipPopView.h"
#import "CSPopAnimationViewController.h"

@implementation CSJoinVipPopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
        
    }
    return self;
}
+ (instancetype)defaultJoinVipPopView {
    return [[CSJoinVipPopView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH *0.6 , (SCREENWIDTH * 0.6) * 1.5)];
}

- (void)createUI {
    UIImageView *imageV = [UIImageView new];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.clipsToBounds = YES;
    imageV.layer.cornerRadius = 5.;
    imageV.layer.masksToBounds = YES;
    imageV.image = [UIImage imageNamed:@"cs_joinVip_popImage"];
    
    [self addSubview:imageV];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancelButton];
    [cancelButton setImage:[UIImage imageNamed:@"share_deleateImage"] forState:UIControlStateNormal];
    
    kWeakSelf
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH * 0.6);
        make.height.mas_equalTo(SCREENWIDTH * 0.75);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.height.mas_equalTo(@40);
    }];
    
    [cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)btnClick:(UIButton *)button {
//    if (_delegate && [_delegate respondsToSelector:@selector(composeJoinVipPopButton:didClick:)]) {
//        [_delegate composeJoinVipPopButton:self didClick:button.tag];
//    }
    [_parentVC cs_dismissPopViewWithAnimation:[CSPopViewAnimationSpring new]];
}

@end
