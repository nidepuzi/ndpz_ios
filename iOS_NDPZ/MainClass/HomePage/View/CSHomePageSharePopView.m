//
//  CSHomePageSharePopView.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSHomePageSharePopView.h"
#import "CSPopAnimationViewController.h"

@interface CSHomePageSharePopView ()

@property (nonatomic, strong) UIImageView *headerImageView;

@end

@implementation CSHomePageSharePopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
+ (instancetype)defaultPopView {
    return [[CSHomePageSharePopView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, (SCREENWIDTH * 0.8) * 1.5)];
}

- (void)createUI {
    self.userInteractionEnabled = YES;
    
    UIImageView *imageV = [UIImageView new];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.userInteractionEnabled = YES;
    imageV.clipsToBounds = YES;
    imageV.layer.cornerRadius = 5.;
    imageV.layer.masksToBounds = YES;
    imageV.image = [UIImage imageNamed:@"iPhone4S"];
    self.headerImageView = imageV;
    
    [self addSubview:imageV];
    
    UIButton *saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:saveImageBtn];
    [saveImageBtn setTitle:@"保存图片到相册" forState:UIControlStateNormal];
    [saveImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveImageBtn.titleLabel.font = CS_UIFontSize(14.);
    saveImageBtn.tag = 10;
    [saveImageBtn sizeToFit];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = CS_UIFontSize(12.);
    button.backgroundColor = [UIColor redColor];
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 11;
    
    kWeakSelf
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(20);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH * 0.75);
        make.height.mas_equalTo(SCREENWIDTH * 0.94);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.right.equalTo(imageV).offset(20);
        make.width.height.mas_equalTo(@40);
    }];
    [saveImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.mas_centerX);
//        make.width.height.mas_equalTo(@40);
    }];
    
    [saveImageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)btnClick:(UIButton *)button {
    if (button.tag == 10) { // 保存
        UIImage *viewImage = [self createViewImage:(UIView *)self.headerImageView];
        UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }else {
        [_parentVC cs_dismissPopViewWithAnimation:[CSPopViewAnimationSpring new]];
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {

    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
- (UIImage *)createViewImage:(UIView *)shareView {
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end
