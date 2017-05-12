//
//  JMLogInViewController.m
//  XLMM
//
//  Created by zhang on 16/5/14.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMLogInViewController.h"
#import "WXApi.h"
#import "JMPhonenumViewController.h"
#import "MiPushSDK.h"
#import "JMSelecterButton.h"
#import "JMVerificationCodeController.h"
#import "JMRootTabBarController.h"



#define SECRET @"a894a72567440fa7317843d76dd7bf03"

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

@implementation JMLogInViewController {
    NSMutableString *randomstring;
    NSDictionary *dic;
    NSString *phoneNumber;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [JMNotificationCenter removeObserver:self name:@"phoneNumberLogin" object:nil];
//    [JMNotificationCenter removeObserver:self name:@"WeChatLogin" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:nil selecotr:@selector(btnClick1:)];
    self.fd_interactivePopDisabled = YES;
    
    [JMNotificationCenter addObserver:self selector:@selector(phoneNumberLogin:) name:@"phoneNumberLogin" object:nil];
    [JMNotificationCenter addObserver:self selector: @selector(WeChatLoginNoti:) name:@"WeChatLogin" object:nil];
    
    [self initUI];
    [self isWechatInstall];
    
}
//判断是否安装
- (void)isWechatInstall {
    if ([WXApi isWXAppInstalled]) {
        self.wechatBtn.enabled = YES;
        self.wechatBtn.hidden = NO;
    }else {
        self.wechatBtn.hidden = YES;
        self.wechatBtn.enabled = NO;
    }
}
- (void)initUI {
    UIImageView *headView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:headView];
    headView.image = [UIImage imageNamed:@"login_maskImage"];
    headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.userInteractionEnabled = YES;
    headView.clipsToBounds = YES;
    self.headView = headView;
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.headView addSubview:backButton];
//    [backButton setTitle:@"X" forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    backButton.layer.cornerRadius = 18.;
//    backButton.layer.masksToBounds = YES;
//    backButton.backgroundColor = [UIColor blackColor];
//    backButton.alpha = 0.7;
//    backButton.titleLabel.font = CS_UIFontSize(18.);
//    [backButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.backButton = backButton;
//    if (self.navigationController.viewControllers.count == 1) {
//        self.backButton.hidden = YES;
//    }else {
//        self.backButton.hidden = NO;
//    }
    
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
    
//    UIView *bottomView = [[UIView alloc] init];
//    [self.view addSubview:bottomView];
//    self.bottomView = bottomView;
//    bottomView.backgroundColor = [UIColor colorWithRed:243/255. green:243/255. blue:244/255. alpha:1.];
//    
//    //========微信登录按钮
//    JMSelecterButton *wechatBtn = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
//    [self.bottomView addSubview:wechatBtn];
//    self.wechatBtn = wechatBtn;
//    [wechatBtn setAdjustsImageWhenHighlighted:NO];
//    [wechatBtn addTarget:self action:@selector(wechatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [wechatBtn setSureBackgroundColor:[UIColor wechatBackColor] CornerRadius:20.];
//    [wechatBtn setImage:[UIImage imageNamed:@"wexImage_wither"] forState:UIControlStateNormal];
//    [wechatBtn setTitle:@"微信注册登录" forState:UIControlStateNormal];
//    wechatBtn.titleLabel.font = [UIFont systemFontOfSize:16.];
//    [wechatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    // ===== 手机号登录按钮
//    JMSelecterButton *phoneNumBtn = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
//    [self.bottomView addSubview:phoneNumBtn];
//    self.phoneNumBtn = phoneNumBtn;
//    [phoneNumBtn addTarget:self action:@selector(jumpToPhoneLoginVC:) forControlEvents:UIControlEventTouchUpInside];
//    [phoneNumBtn setSelecterBorderColor:[UIColor buttonEmptyBorderColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"手机登录" TitleFont:15. CornerRadius:20.];
//    
//    // ==== 验证码登录按钮
//    JMSelecterButton *captchaBtn = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
//    [self.bottomView addSubview:captchaBtn];
//    self.captchaBtn = captchaBtn;
//    [captchaBtn addTarget:self action:@selector(jumpToAuthcodeLoginVC:) forControlEvents:UIControlEventTouchUpInside];
//    [captchaBtn setSelecterBorderColor:[UIColor buttonEmptyBorderColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"短信登录" TitleFont:15. CornerRadius:20.];
    //    CGFloat imageH = SCREENHEIGHT - 140 - 64;
    //    CGFloat imageW = self.headView.image.size.width / self.headView.image.size.height * imageH;
    
    kWeakSelf
    //    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(weakSelf.view).offset(64);
    //        make.centerX.equalTo(weakSelf.view.mas_centerX);
    //        make.width.mas_equalTo(imageW);
    //        make.height.mas_equalTo(imageH);
    //    }];
//    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.headView).offset(15);
//        make.top.equalTo(weakSelf.headView).offset(30);
//        make.width.height.mas_equalTo(@(36));
//    }];
    
    //    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(weakSelf.headView.mas_bottom);
    //        make.width.mas_equalTo(SCREENWIDTH);
    //        make.left.equalTo(weakSelf.view);
    //        make.height.mas_equalTo(140);
    //    }];
    
    [self.phoneNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.wechatBtn.mas_top).offset(-20);
        make.centerX.equalTo(weakSelf.headView.mas_centerX);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(SCREENWIDTH - 40);
    }];
    
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.headView).offset(-80);
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
    
    
    
    
    //    [self.captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(weakSelf.phoneNumBtn);
    //        make.right.equalTo(weakSelf.wechatBtn.mas_right);
    //        make.left.equalTo(weakSelf.wechatBtn.mas_centerX).offset(25/2);
    //        make.height.mas_equalTo(@40);
    //    }];
    
}

- (void)phoneNumberLogin:(NSNotification *)notification{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --- 监听微信登录的通知
- (void)WeChatLoginNoti:(NSNotificationCenter *)notification {
    dic = [JMUserDefaults objectForKey:kWxLoginUserInfo];
    NSArray *randomArray = [self randomArray];
    unsigned long count = (unsigned long)randomArray.count;
    int index = 0;
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);
    __unused long time = [timeSp integerValue];
    NSLog(@"time = %ld", (long)time);
    randomstring = [[NSMutableString alloc] initWithCapacity:0];
    for (int i = 0; i<8; i++) {
        index = arc4random()%count;
        // NSLog(@"index = %d", index);
        NSString *string = [randomArray objectAtIndex:index];
        [randomstring appendString:string];
    }
    NSLog(@"%@%@",timeSp ,randomstring);
    //    NSString *secret = @"3c7b4e3eb5ae4c";
    NSString *noncestr = [NSString stringWithFormat:@"%@%@", timeSp, randomstring];
    //获得参数，升序排列
    NSString* sign_params = [NSString stringWithFormat:@"noncestr=%@&secret=%@&timestamp=%@",noncestr, SECRET,timeSp];
    NSLog(@"1.————》%@", sign_params);
    NSString *sign = [sign_params sha1];
    NSLog(@"sign = %@", sign);
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/weixinapplogin?noncestr=%@&timestamp=%@&sign=%@", Root_URL,noncestr, timeSp, sign];
    NSDictionary *newDic = @{@"headimgurl":[dic objectForKey:@"headimgurl"],
                             @"nickname":[dic objectForKey:@"nickname"],
                             @"openid":[dic objectForKey:@"openid"],
                             @"unionid":[dic objectForKey:@"unionid"],
                             @"devtype":LOGINDEVTYPE};
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:newDic WithSuccess:^(id responseObject) {
        NSDictionary *result = responseObject;
        if (result.count == 0) {
            [MBProgressHUD hideHUD];
            return;
        }
        if ([[result objectForKey:@"rcode"]integerValue] != 0) {
            [MBProgressHUD hideHUD];
            [self alertMessage:[result objectForKey:@"msg"]];
            return;
        }
        [self setDevice];
        [self loadUserInfo];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"登录失败，请重试"];
    } Progress:^(float progress) {
        
    }];
}
#pragma mark --- 移除通知
- (void)dealloc {
    [JMNotificationCenter removeObserver:self name:@"phoneNumberLogin" object:nil];
    [JMNotificationCenter removeObserver:self name:@"WeChatLogin" object:nil];
}
#pragma mark ---- 点击微信登录的按钮
- (void)wechatBtnClick:(UIButton *)btn {
    self.wechatBtn.enabled = NO;
    [self performSelector:@selector(buttonEnable:) withObject:self.wechatBtn afterDelay:1.0];
    if ([WXApi isWXAppInstalled]) {
        
    } else{
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备没有安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
        return;
    }
    [JMUserDefaults setObject:@"wxlogin" forKey:kWeiXinauthorize];
    [JMUserDefaults synchronize];
    
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"nidepuzi"; // xiaolumeimei
    NSLog(@"req = %@", req);
    [WXApi sendReq:req];
    
}
- (void)zhanghaoClick:(UIButton *)button {
    JMPhonenumViewController *phoneVC = [[JMPhonenumViewController alloc] init];
    [self.navigationController pushViewController:phoneVC animated:YES];
}
- (void)buttonEnable:(UIButton *)button {
    button.enabled = YES;
}
#pragma mark ---- 选择使用手机号登录 或者 验证码 或者 注册新的账号
//跳转到手机号登陆
- (void)jumpToPhoneLoginVC:(UIButton *)btn {
    JMPhonenumViewController *phoneL = [[JMPhonenumViewController alloc] init];
    [self.navigationController pushViewController:phoneL animated:YES];
}
//跳转到验证码登录
- (void)jumpToAuthcodeLoginVC:(UIButton *)btn {
    JMVerificationCodeController *verfyCodeVC = [[JMVerificationCodeController alloc] init];
    verfyCodeVC.verificationCodeType = SMSVerificationCodeWithLogin;
    verfyCodeVC.userLoginMethodWithWechat = YES;
    [self.navigationController pushViewController:verfyCodeVC animated:YES];
}
//跳转到注册界面
//- (void)jumpToRegisterVC:(UIButton *)btn {
//    JMVerificationCodeController *verfyCodeVC = [[JMVerificationCodeController alloc] init];
//    verfyCodeVC.verificationCodeType = SMSVerificationCodeWithRegistered;
//    [self.navigationController pushViewController:verfyCodeVC animated:YES];
//}

#pragma mark ---- 登录成功后获取用户信息
- (void)loadUserInfo {
    /*
     1. 用户绑定手机, 且是精英妈妈.  ---> 跳转到主页
     2. 用户绑定手机, 但不是精英妈妈. ---> 提示此用户权限不够.
     3. 用户没用绑定手机, 但是是精英妈妈. ---> 跳转到绑定手机.
     4. 用户没有绑定手机, 且不是精英妈妈. ---> 提示用户需要注册成为会员
     */
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/profile", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        BOOL kIsLoginStatus = ([responseObject objectForKey:@"id"] != nil)  && ([[responseObject objectForKey:@"id"] integerValue] != 0);
        BOOL kIsXLMMStatus = [[responseObject objectForKey:@"xiaolumm"] isKindOfClass:[NSDictionary class]];
        BOOL kIsBindPhone = [NSString isStringEmpty:[responseObject objectForKey:@"mobile"]];
        BOOL kIsVIP = NO;
        if (kIsXLMMStatus) {
            NSDictionary *xlmmDict = responseObject[@"xiaolumm"];
            kIsVIP = [xlmmDict[@"status"] isEqual:@"effect"] ? YES : NO;
        }
        [JMUserDefaults setBool:kIsLoginStatus forKey:kIsLogin];
        [JMUserDefaults setBool:kIsXLMMStatus forKey:kISXLMM];
        [JMUserDefaults setObject:kWeiXinLogin forKey:kLoginMethod];
        [JMUserDefaults synchronize];
        
        if (kIsVIP) {
            if (!kIsBindPhone) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [JMNotificationCenter postNotificationName:@"WeChatLoginSuccess" object:nil];
            }else {
                NSDictionary *weChatInfo = [JMUserDefaults objectForKey:kWxLoginUserInfo];
                JMVerificationCodeController *vc = [[JMVerificationCodeController alloc] init];
                vc.verificationCodeType = SMSVerificationCodeWithBind;
                vc.userInfo = weChatInfo;
                vc.userLoginMethodWithWechat = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else {
            JMVerificationCodeController *verfyCodeVC = [[JMVerificationCodeController alloc] init];
            verfyCodeVC.verificationCodeType = SMSVerificationCodeWithLogin;
            verfyCodeVC.userLoginMethodWithWechat = YES;
            verfyCodeVC.userNotXLMM = YES;
            [self.navigationController pushViewController:verfyCodeVC animated:YES];
        }
        
        
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        if (response) {
            if (response.statusCode) {
                NSInteger statusCode = response.statusCode;
                if (statusCode == 403) {
                    NSLog(@"%ld",statusCode);
                    [JMUserDefaults removeObjectForKey:kIsLogin];
                    [JMUserDefaults removeObjectForKey:kISXLMM];
                }
            }
        }
        [JMUserDefaults synchronize];
        [MBProgressHUD showError:@"登录失败，请重试"];
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
    }];
}
#pragma mark ---- 登录成功后获取Device
- (void)setDevice{
    NSDictionary *params = [JMUserDefaults objectForKey:@"MiPush"];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/push/set_device", Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:params WithSuccess:^(id responseObject) {
        NSString *user_account = [responseObject objectForKey:@"user_account"];
        if ([user_account isEqualToString:@""]) {
        } else {
            [MiPushSDK setAccount:user_account];
            //保存user_account
            [JMUserDefaults setObject:user_account forKey:@"user_account"];
            [JMUserDefaults synchronize];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)btnClick1:(UIButton *)btn {
}
- (void)btnClick:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
//    if (self.isTabBarLogin) {
//
//    }else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}

- (NSArray *)randomArray{
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithCapacity:62];
    
    for (int i = 0; i<10; i++) {
        // NSLog(@"%d", i);
        NSString *string = [NSString stringWithFormat:@"%d",i];
        [mutable addObject:string];
    }
    for (char i = 'a'; i<='z'; i++) {
        // NSLog(@"%c", i);
        NSString *string = [NSString stringWithFormat:@"%c", i];
        
        [mutable addObject:string];
    }
    NSArray *array = [NSArray arrayWithArray:mutable];
    
    NSLog(@"array = %@", array);
    return array;
}

#pragma mark --- 弹出框视图
-(void) alertMessage:(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)backApointInterface {
    [MBProgressHUD hideHUD];
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if ((count > 2) && (count < [self.navigationController viewControllers].count)) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
        //        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }

    
}

/**
 *      for (UIViewController *controller in self.navigationController.viewControllers) {
 if ([controller isKindOfClass:[JMLogInViewController class]]) {
 count = [[self.navigationController viewControllers] indexOfObject:self];
 }
 }
 if (count > 2) {
 */



@end




















