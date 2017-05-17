//
//  CSWithDrawPopView.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/10.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSWithDrawPopView.h"
#import "CSPopAnimationViewController.h"
#import "JMRichTextTool.h"
#import "WebViewController.h"

@interface CSWithDrawPopView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation CSWithDrawPopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
        
    }
    return self;
}
+ (instancetype)defaultWithdrawPopView {
    return [[CSWithDrawPopView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH *0.8 , (SCREENWIDTH * 0.8) * 1.5)];
}
- (void)createUI {
    UIImageView *imageV = [UIImageView new];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.clipsToBounds = YES;
    imageV.layer.cornerRadius = 5.;
    imageV.layer.masksToBounds = YES;
    imageV.image = [UIImage imageNamed:@"cs_withDraw_PopImage1"];
    [self addSubview:imageV];

    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = CS_UIFontSize(13.);
    titleLabel.numberOfLines = 0;
    [imageV addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancelButton];
    [cancelButton setImage:[UIImage imageNamed:@"cs_popImageDeleate"] forState:UIControlStateNormal];
    cancelButton.tag = 10;
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:sureButton];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"cs_withDraw_PopImage2"] forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"cs_withDraw_PopImage2"] forState:UIControlStateHighlighted];
    [sureButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = CS_UIFontBoldSize(18.);
    sureButton.tag = 11;
    self.sureButton = sureButton;
    
    kWeakSelf
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(30);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH * 0.72);
        make.height.mas_equalTo(SCREENWIDTH * 0.6);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_centerY).offset(30);
        make.centerX.equalTo(imageV.mas_centerX).offset(10);
        make.width.mas_equalTo(SCREENWIDTH * 0.35);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.width.height.mas_equalTo(@40);
    }];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(40);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(@60);
        make.width.mas_equalTo(@180);
    }];
    
    [cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)setTypeStatus:(popTypeStatus)typeStatus {
    _typeStatus = typeStatus;
    if (typeStatus == popTypeStatusPay) {
        NSString *allString = @"您还有200元购物礼券哦!";
        self.titleLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:18.] AllString:allString SubStringArray:@[@"200"]];
        [self.sureButton setTitle:@"立即使用" forState:UIControlStateNormal];
    }else if (typeStatus == popTypeStatusWithdraw) {
        NSString *allString = @"成为正式掌柜才可以提现哦!";
        self.titleLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:18.] AllString:allString SubStringArray:@[@"掌柜"]];
        [self.sureButton setTitle:@"成为掌柜" forState:UIControlStateNormal];
    }else { }
    
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

















































