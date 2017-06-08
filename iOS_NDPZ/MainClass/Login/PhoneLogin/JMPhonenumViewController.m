//
//  JMPhonenumViewController.m
//  XLMM
//
//  Created by zhang on 17/5/14.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMPhonenumViewController.h"
#import "WXApi.h"
#import "MiPushSDK.h"
#import "JMLogInViewController.h"
#import "JMVerificationCodeController.h"
#import "AESEncryption.h"
#import "JMRootTabBarController.h"
#import "AppDelegate.h"
#import "WebViewController.h"
#import "CSCustomerServiceManager.h"
#import "CSLoginManager.h"


#define rememberPwdKey @"rememberPwd"

@interface JMPhonenumViewController ()

@property (nonatomic,strong) UITextField *phoneNumTextF;

@property (nonatomic,strong) UITextField *passwordTextF;

//是否可以查看密码的按钮
@property (nonatomic,strong) UIButton *isSeePwdBtn;

@property (nonatomic,strong) UIButton *rememberPwdBtn;

@property (nonatomic,strong) UIButton *forgetPwdBtn;

@property (nonatomic,strong) UIButton *loginBtn;


@property (nonatomic, strong) UIScrollView *maskScrollView;

@end

@implementation JMPhonenumViewController

#pragma mark ==== 懒加载 ====
- (UIScrollView *)maskScrollView {
    if (!_maskScrollView) {
        _maskScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _maskScrollView.delegate = self;
    }
    return _maskScrollView;
}

#pragma mark ==== 视图生命周期 ====
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideKeyBoard];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"账号登录" selecotr:@selector(btnClickedLogin:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.maskScrollView];
    [self prepareUI];
    
    //设置记住密码的默认值
    self.rememberPwdBtn.selected = [JMUserDefaults boolForKey:rememberPwdKey];
    //设置账号和密码的默认值
    self.phoneNumTextF.text = [JMUserDefaults objectForKey:kUserName];
    if (self.rememberPwdBtn.selected) {
        NSString *decryptedStr = [AESEncryption decrypt:[JMUserDefaults objectForKey:kPassWord] password:self.phoneNumTextF.text];
        self.passwordTextF.text = decryptedStr;
    }
    
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.phoneNumTextF.rac_textSignal,self.passwordTextF.rac_textSignal]] map:^id(id value) {
        NSString *value1 = value[0];
        NSString *value2 = value[1];
        BOOL phoneEnable = value1.length == 11 && [value1 hasPrefix:@"1"];
        BOOL pwdEnable = value2.length >= 1;
        return @(phoneEnable && pwdEnable);
    }];
    
    self.loginBtn.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
}

- (void)loginBtnClick:(UIButton *)btn {
    [self hideKeyBoard];
    [[CSLoginManager loginInstance] accountLoginWithViewController:self Account:self.phoneNumTextF.text Pwd:self.passwordTextF.text Success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark ==== 代理,自定义点击事件 ====
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideKeyBoard];
}
- (void)btnClickedLogin:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hideKeyBoard {
    [self.view endEditing:YES];
}
- (void)backApointInterface {
    [MBProgressHUD hideHUD];
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if (count >= 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)registeredButtonClicked {
    // 点击进入客服
    kWeakSelf
    [[CSCustomerServiceManager defaultManager] showCustomerService:self];
    [CSCustomerServiceManager defaultManager].popBlock = ^() {
        [weakSelf.navigationController popViewControllerAnimated:NO];
    };
}
- (void)forgetPasswordClicked:(UIButton *)sender {
    JMVerificationCodeController *verifyVC = [[JMVerificationCodeController alloc] init];
    verifyVC.verificationCodeType = SMSVerificationCodeWithForgetPWD;
    verifyVC.userLoginMethodWithWechat = YES;
    [self.navigationController pushViewController:verifyVC animated:YES];
}
- (void)seePasswordButtonClicked:(UIButton *)sender {
    UIImage *image = nil;
    if (self.passwordTextF.secureTextEntry) {
        image = [UIImage imageNamed:@"display_passwd_icon.png"];
    } else {
        image = [UIImage imageNamed:@"hide_passwd_icon.png"];
    }
    [self.isSeePwdBtn setImage:image forState:UIControlStateNormal];
    self.passwordTextF.secureTextEntry = !self.passwordTextF.secureTextEntry;
}
- (void)remenberClick:(UIButton *)sender {
    self.rememberPwdBtn.selected = !self.rememberPwdBtn.selected;
    [JMUserDefaults setBool:self.rememberPwdBtn.selected forKey:rememberPwdKey];
    [JMUserDefaults synchronize];
}

#pragma  ==== 创建视图 ====
- (void)prepareUI {
    CGFloat firstSectionViewH = 120.;
    CGFloat spaceing = 15.f;
    CGFloat topSpace = 60.;
    
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, topSpace, SCREENWIDTH, firstSectionViewH)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    [self.maskScrollView addSubview:textFieldView];
    
    UIView *phoneTFView = [[UIView alloc] initWithFrame:CGRectMake(spaceing, 15, SCREENWIDTH - spaceing * 2, 40)];
    phoneTFView.layer.cornerRadius = 5;
    phoneTFView.layer.masksToBounds = YES;
    phoneTFView.layer.borderWidth = 1.;
    phoneTFView.layer.borderColor = [UIColor titleDarkGrayColor].CGColor;
    [textFieldView addSubview:phoneTFView];
    
    UIView *verfiTFView = [[UIView alloc] initWithFrame:CGRectMake(spaceing, phoneTFView.cs_max_Y + 20, SCREENWIDTH - spaceing * 2, 40)];
    verfiTFView.layer.cornerRadius = 5;
    verfiTFView.layer.masksToBounds = YES;
    verfiTFView.layer.borderWidth = 1.;
    verfiTFView.layer.borderColor = [UIColor titleDarkGrayColor].CGColor;
    [textFieldView addSubview:verfiTFView];
    
    
    UITextField *phoneNumberField = [self createTextFieldWithFrame:CGRectMake(10, 5, verfiTFView.cs_w - 20, 30) PlaceHolder:@"请输入手机号" KeyboardType:UIKeyboardTypeNumberPad];
    self.phoneNumTextF = phoneNumberField;
    UITextField *verificationCodeField = [self createTextFieldWithFrame:CGRectMake(10, 5, verfiTFView.cs_w - 80, 30) PlaceHolder:@"请输入登录密码" KeyboardType:UIKeyboardTypeDefault];
    self.passwordTextF = verificationCodeField;
    self.passwordTextF.secureTextEntry = YES;
    [phoneTFView addSubview:phoneNumberField];
    [verfiTFView addSubview:verificationCodeField];
    
    UIView *shuhangV = [[UIView alloc] initWithFrame:CGRectMake(verificationCodeField.cs_max_X + 10, verificationCodeField.cs_y + 5, 1, 20)];
    shuhangV.backgroundColor = [UIColor titleDarkGrayColor];
    [verfiTFView addSubview:shuhangV];
    
    /**
     按钮控件
     */
    UIButton *isSeePwdBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [verfiTFView addSubview:isSeePwdBtn];
    isSeePwdBtn.frame = CGRectMake(verificationCodeField.cs_max_X + 10, verificationCodeField.cs_y, 60, 30);
    self.isSeePwdBtn = isSeePwdBtn;
    [isSeePwdBtn setImage:[UIImage imageNamed:@"hide_passwd_icon"] forState:UIControlStateNormal];
    [isSeePwdBtn addTarget:self action:@selector(seePasswordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rememberPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.maskScrollView addSubview:rememberPwdBtn];
    rememberPwdBtn.frame = CGRectMake(spaceing, textFieldView.cs_max_Y + 10, 100, 20);
    self.rememberPwdBtn = rememberPwdBtn;
    [rememberPwdBtn setAdjustsImageWhenHighlighted:NO];
    [rememberPwdBtn setImage:[UIImage imageNamed:@"cs_duihao_nomal"] forState:UIControlStateNormal];
    [rememberPwdBtn setImage:[UIImage imageNamed:@"cs_duihao_selected"] forState:UIControlStateSelected];
    [rememberPwdBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [rememberPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rememberPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13.];
    rememberPwdBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);//调整图片文字间距
    [rememberPwdBtn addTarget:self action:@selector(remenberClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *forgetPwdBtn  = [[UIButton alloc] init];
    [self.maskScrollView addSubview:forgetPwdBtn];
    forgetPwdBtn.frame = CGRectMake(textFieldView.cs_max_X - 95, textFieldView.cs_max_Y + 10, 80, 20);
    self.forgetPwdBtn = forgetPwdBtn;
    //设置按钮文字的下划线
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange titleRange = {0,[title length]};
    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [forgetPwdBtn setAttributedTitle:title forState:UIControlStateNormal];
    [forgetPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:13.]];
    forgetPwdBtn.titleLabel.textColor = [UIColor colorWithRed:86/255. green:195/255. blue:241/255. alpha:1.];
    [forgetPwdBtn addTarget:self action:@selector(forgetPasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *loginBtn = [UIButton new];
    [self.maskScrollView addSubview:loginBtn];
    loginBtn.frame = CGRectMake(20, rememberPwdBtn.cs_max_Y + 20, SCREENWIDTH - 40, 40);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"buttonbackground1"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"buttonbackground2"] forState:UIControlStateDisabled];
    loginBtn.titleLabel.font = CS_UIFontSize(14.);
    loginBtn.layer.cornerRadius = 5.;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    
    self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.loginBtn.cs_max_Y + 20);
    
}
- (UITextField *)createTextFieldWithFrame:(CGRect)frame PlaceHolder:(NSString *)placeHolder KeyboardType:(UIKeyboardType)keyboardType {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:13.];
    textField.delegate = self;
    return textField;
}

@end





































