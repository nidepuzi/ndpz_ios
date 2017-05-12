//
//  CSJoinVipPopView.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/6.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSJoinVipPopView.h"
#import "CSPopAnimationViewController.h"
#import "JMRichTextTool.h"
#import "WebViewController.h"


@interface CSJoinVipPopView ()

@property (nonatomic, strong) UILabel *shengyushijianLabel;

@end

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
    imageV.userInteractionEnabled = YES;
    imageV.image = [UIImage imageNamed:@"cs_joinVip_popImage"];
    
    [self addSubview:imageV];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancelButton];
    [cancelButton setImage:[UIImage imageNamed:@"share_deleateImage"] forState:UIControlStateNormal];
    cancelButton.tag = 10;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = CS_UIFontBoldSize(16.);
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [imageV addSubview:titleLabel];
    self.shengyushijianLabel = titleLabel;
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageV addSubview:sureButton];
    sureButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    sureButton.layer.cornerRadius = 15.;
    sureButton.layer.masksToBounds = YES;
    [sureButton setTitle:@"成为掌柜" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = CS_UIFontSize(14.);
    sureButton.tag = 11;
    
    
    
    
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
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageV.mas_centerY).offset(-30);
        make.centerX.equalTo(imageV.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH * 0.6);
    }];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageV).offset(-30);
        make.centerX.equalTo(imageV.mas_centerX);
        make.width.height.mas_equalTo(SCREENWIDTH * 0.3);
        make.height.mas_equalTo(@30);
    }];
    
    
    
    
    [cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)setShengyushijian:(NSString *)shengyushijian {
    _shengyushijian = shengyushijian;
    if ([NSString isStringEmpty:shengyushijian]) {
        return;
    }
    NSString *allString = [NSString stringWithFormat:@"—   试用剩余%@天   —",shengyushijian];
    self.shengyushijianLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:24.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allString SubStringArray:@[shengyushijian]];
}
- (void)btnClick:(UIButton *)button {
//    if (_delegate && [_delegate respondsToSelector:@selector(composeJoinVipPopButton:didClick:)]) {
//        [_delegate composeJoinVipPopButton:self didClick:button.tag];
//    }
    [_parentVC cs_dismissPopViewWithAnimation:[CSPopViewAnimationSpring new]];
    if (button.tag == 11) {
        NSString *string = [NSString stringWithFormat:@"%@/mall/boutiqueinvite2",Root_URL];
        NSDictionary *diction = [NSMutableDictionary dictionary];
        [diction setValue:string forKey:@"web_url"];
        WebViewController *webView = [[WebViewController alloc] init];
        webView.webDiction = [NSMutableDictionary dictionaryWithDictionary:diction];
        webView.isShowNavBar = true;
        webView.isShowRightShareBtn = false;
        [_parentVC.navigationController pushViewController:webView animated:YES];
        
    }
}

@end





































