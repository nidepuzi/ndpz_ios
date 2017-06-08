//
//  JMLogInViewController.m
//  XLMM
//
//  Created by zhang on 17/5/14.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMLogInViewController.h"
#import "WXApi.h"
#import "JMPhonenumViewController.h"
#import "MiPushSDK.h"
#import "JMSelecterButton.h"
#import "JMVerificationCodeController.h"
#import "JMRootTabBarController.h"
#import "CSLoginManager.h"

@interface JMLogInViewController ()

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIButton *wechatBtn;

@property (nonatomic,strong) UIImageView *wexImage;

@property (nonatomic,strong) UILabel *wexTitleLabel;

@property (nonatomic,strong) UIButton *phoneNumBtn;

@property (nonatomic,strong) UIButton *captchaBtn;

@property (nonatomic,strong) UIButton *registerBtn;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIButton *cancleBtn;

@property (nonatomic,strong) UILabel *titleLa;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation JMLogInViewController

#pragma mark ==== 视图生命周期 ====
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:nil selecotr:@selector(btnClick1:)];
    self.fd_interactivePopDisabled = YES;
    
    [JMNotificationCenter addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
    [JMNotificationCenter addObserver:self selector: @selector(WeChatLoginNoti:) name:@"WeChatLogin" object:nil];
    
    [self initUI];
    
    
    
}
#pragma mark ---- 点击微信登录的按钮
- (void)wechatBtnClick:(UIButton *)btn {
    self.wechatBtn.enabled = NO;
    [self performSelector:@selector(buttonEnable:) withObject:self.wechatBtn afterDelay:1.0];
    [MobClick event:@"JMLogInViewController_Wechat"];
    
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"nidepuzi";
    [WXApi sendReq:req];
    
}
#pragma mark --- 监听通知处理
- (void)WeChatLoginNoti:(NSNotificationCenter *)notification {
    [[CSLoginManager loginInstance] wechatLoginWithViewController:self Success:^(id responseObject) {
    } failure:^(NSError *error) {

    }];
    
}
- (void)phoneNumberLogin:(NSNotification *)notification{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --- 移除通知
- (void)dealloc {
    [JMNotificationCenter removeObserver:self name:@"phoneNumberLogin" object:nil];
    [JMNotificationCenter removeObserver:self name:@"WeChatLogin" object:nil];
}

#pragma mark ---- 选择使用手机号登录 或者 验证码 或者 注册新的账号
//跳转到手机号登陆
- (void)zhanghaoClick:(UIButton *)button {
    [MobClick event:@"JMLogInViewController_PhoneLogin"];
    JMPhonenumViewController *phoneVC = [[JMPhonenumViewController alloc] init];
    [self.navigationController pushViewController:phoneVC animated:YES];
}
//跳转到验证码登录
- (void)jumpToAuthcodeLoginVC:(UIButton *)btn {
    [MobClick event:@"JMLogInViewController_VerificationCode"];
    JMVerificationCodeController *verfyCodeVC = [[JMVerificationCodeController alloc] init];
    verfyCodeVC.verificationCodeType = SMSVerificationCodeWithLogin;
    verfyCodeVC.userLoginMethodWithWechat = YES;
    verfyCodeVC.userNotXLMM = ![JMUserDefaults boolForKey:kISNDPZVIP];
    [self.navigationController pushViewController:verfyCodeVC animated:YES];
}
- (void)buttonEnable:(UIButton *)button {
    button.enabled = YES;
}

- (void)btnClick1:(UIButton *)btn {
}
- (void)btnClick:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)backApointInterface {
    [MBProgressHUD hideHUD];
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if ((count > 2) && (count < [self.navigationController viewControllers].count)) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ==== 创建视图 ====
- (void)initUI {
    UIImageView *headView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:headView];
    headView.image = [UIImage imageNamed:@"login_maskImage"];
    headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.userInteractionEnabled = YES;
    headView.clipsToBounds = YES;
    self.headView = headView;
    
    UIButton *phoneLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headView addSubview:phoneLoginButton];
    [phoneLoginButton setImage:[UIImage imageNamed:@"login_phoneImage"] forState:UIControlStateNormal];
    [phoneLoginButton setTitle:@"手机登录" forState:UIControlStateNormal];
    phoneLoginButton.titleLabel.font = CS_UIFontSize(14.);
    [phoneLoginButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    phoneLoginButton.layer.cornerRadius = 3.;
    phoneLoginButton.layer.masksToBounds = YES;
    phoneLoginButton.layer.borderColor = [UIColor titleDarkGrayColor].CGColor;
    phoneLoginButton.layer.borderWidth = 1.f;
    phoneLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    phoneLoginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    
    UIButton *wechatLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headView addSubview:wechatLoginButton];
    [wechatLoginButton setImage:[UIImage imageNamed:@"login_wechatImage"] forState:UIControlStateNormal];
    [wechatLoginButton setTitle:@"微信登录" forState:UIControlStateNormal];
    wechatLoginButton.titleLabel.font = CS_UIFontSize(14.);
    [wechatLoginButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    wechatLoginButton.layer.cornerRadius = 3.;
    wechatLoginButton.layer.masksToBounds = YES;
    wechatLoginButton.layer.borderColor = [UIColor titleDarkGrayColor].CGColor;
    wechatLoginButton.layer.borderWidth = 1.f;
    wechatLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    wechatLoginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    
    UIButton *zhanghaoLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headView addSubview:zhanghaoLoginButton];
    [zhanghaoLoginButton setTitle:@"账号登录" forState:UIControlStateNormal];
    zhanghaoLoginButton.titleLabel.font = CS_UIFontSize(13.);
    [zhanghaoLoginButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    
    
    self.phoneNumBtn = phoneLoginButton;
    self.wechatBtn = wechatLoginButton;
    [phoneLoginButton addTarget:self action:@selector(jumpToAuthcodeLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    [wechatLoginButton addTarget:self action:@selector(wechatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [zhanghaoLoginButton addTarget:self action:@selector(zhanghaoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    kWeakSelf
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.phoneNumBtn.mas_top).offset(-20);
        make.centerX.equalTo(weakSelf.headView.mas_centerX);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(SCREENWIDTH - 40);
    }];
    
    [self.phoneNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.headView).offset(-90);
        make.centerX.equalTo(weakSelf.headView.mas_centerX);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(SCREENWIDTH - 40);
    }];
    
    [zhanghaoLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.headView).offset(-40);
        make.centerX.equalTo(weakSelf.headView.mas_centerX);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@90);
    }];
    
    if ([WXApi isWXAppInstalled]) {
        self.wechatBtn.hidden = NO;
    }else {
        self.wechatBtn.hidden = YES;
    }
    
    
}

@end




















