//
//  JMShareButtonView.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMShareButtonView.h"

@implementation JMShareButtonView


- (instancetype)initWithFrame:(CGRect)frame shareType:(shareButtonType)shareType; {
    if (self == [super initWithFrame:frame]) {
        self.buttonType = shareType;
        [self setUpAllChildView];
    }
    return self;
}


- (void)setUpAllChildView {
    NSArray *image1Arr = @[@"share_goodsImage",@"share_linkImage",@"share_recodeImage"];
    NSArray *image2Arr = @[@"share_wechaImage",@"share_qqImage",@"share_weiboImage"];
    NSArray *titleArr1 = @[@"分享商品",@"商品链接",@"商品二维码"];
    NSArray *titleArr2 = @[@"微信",@"QQ",@"微博"];
    
    if (self.buttonType == shareButtonType1) {
        for (int i = 0; i < image1Arr.count; i++) {
//            [self setUpButtonWithImage:[UIImage imageNamed:image1Arr[i]] target:self action:@selector(btnClick:)];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:image1Arr[i]] forState:UIControlStateNormal];
            //    [btn setImage:highImage forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 10 + i;
            [self addSubview:btn];
            
            UILabel *label = [UILabel new];
            label.font = CS_UIFontSize(12.);
            label.textColor = [UIColor buttonTitleColor];
            label.text = titleArr1[i];
            label.tag = 20 + i;
            [self addSubview:label];
            
        }
    }else {
        for (int i = 0; i < image2Arr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:image2Arr[i]] forState:UIControlStateNormal];
            //    [btn setImage:highImage forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 10 + i;
            [self addSubview:btn];
            
            UILabel *label = [UILabel new];
            label.font = CS_UIFontSize(12.);
            label.textColor = [UIColor buttonTitleColor];
            label.text = titleArr2[i];
            label.tag = 20 + i;
            [self addSubview:label];
        }
    }
    
    //微信
//    [self setUpButtonWithImage:[UIImage imageNamed:@"shareweixin"] target:self action:@selector(btnClick:)];
    
    //朋友圈
//    [self setUpButtonWithImage:[UIImage imageNamed:@"shareFirends"] target:self action:@selector(btnClick:)];
    
    //QQ
//    [self setUpButtonWithImage:[UIImage imageNamed:@"shareqq"] target:self action:@selector(btnClick:)];
    
    //QQ空间
//    [self setUpButtonWithImage:[UIImage imageNamed:@"shareQQSpacing"] target:self action:@selector(btnClick:)];
    
    //微博
//    [self setUpButtonWithImage:[UIImage imageNamed:@"shareweibo"] target:self action:@selector(btnClick:)];
    
    //复制链接
//    [self setUpButtonWithImage:[UIImage imageNamed:@"sharecopylink"] target:self action:@selector(btnClick:)];
    
    
    
}

- (void)setButtonType:(shareButtonType)buttonType {
    _buttonType = buttonType;
    
    
}
- (void)setUpButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
//    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.tag = self.subviews.count + 100;
    [self addSubview:btn];
    
    
}
- (void)btnClick:(UIButton *)button {
    NSLog(@"sharebutton btnClick %ld", (long)button.tag);
    //点击工具条的时候
    if (_delegate && [_delegate respondsToSelector:@selector(composeShareBtn:didClickBtn:)]) {
        [_delegate composeShareBtn:self didClickBtn:button.tag];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger count = 3;
    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height / 2;//[UIScreen mainScreen].bounds.size.height;
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = 45;
    CGFloat H = 45;
    
    //图片宽 55  高度 75
    //间距
    CGFloat space = (width - 3 * 45) / 6;
    
    for (int i = 0 ; i < count; i++) {
        NSInteger page = i / 3;
        NSInteger index = i % 3;
        UIButton *btn = (UIButton *)[self viewWithTag:i + 10];
        X = index * (W + space * 2) + space;
        Y = page * (H + 14) + 15;
        btn.frame = CGRectMake(X, Y, W, H);
        
        UILabel *label = (UILabel *)[self viewWithTag:i + 20];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).offset(5);
            make.centerX.equalTo(btn.mas_centerX);
        }];

    }
    

    
    
    
    
}

@end






























