//
//  JMInstallPasswordController.m
//  XLMM
//
//  Created by zhang on 17/4/21.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMInstallPasswordController.h"


@interface JMInstallPasswordController () <UIGestureRecognizerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView *maskScrollView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UITextField *pwdTextField1;
@property (nonatomic, strong) UITextField *pwdTextField2;



@end

@implementation JMInstallPasswordController
#pragma mark ==== 懒加载 ====
- (UIScrollView *)maskScrollView {
    if (!_maskScrollView) {
        _maskScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    return _maskScrollView;
}
#pragma mark ==== 生命周期函数 ====
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideKeyBoard];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor countLabelColor];
    if (self.pwdType == PWDWithInstall) {
        self.title = @"设置密码";
    }else {
        self.title = @"修改密码";
    }
    [self createNavigationBarWithTitle:self.title selecotr:@selector(backClick)];
    self.fd_interactivePopDisabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.maskScrollView];
    [self createUI];
    
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.pwdTextField1.rac_textSignal,self.pwdTextField2.rac_textSignal]] map:^id(id value) {
        NSString *value1 = value[0];
        NSString *value2 = value[1];
        BOOL pwd1 = value1.length >= 6 && value1.length <= 16;
        BOOL pwd2 = value2.length >= 6 && value2.length <= 16;
        BOOL pwdEnable = [value1 isEqualToString:value2];
        return @(pwd1 && pwd2 && pwdEnable);
    }];
    self.loginBtn.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    
}


- (void)createUI {
    CGFloat firstSectionViewH = 120.;
    CGFloat spaceing = 15.f;
    
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, firstSectionViewH)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    
    UITextField *pwdTextField1 = [self createTextFieldWithFrame:CGRectMake(spaceing, 15, SCREENWIDTH - spaceing * 2, 30) PlaceHolder:@"请输入6-16位登录密码" KeyboardType:UIKeyboardTypeASCIICapable];
    self.pwdTextField1 = pwdTextField1;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, pwdTextField1.cs_max_Y + 15, SCREENWIDTH, 1.0f)];
    lineView.backgroundColor = [UIColor lineGrayColor];
    UITextField *pwdTextField2 = [self createTextFieldWithFrame:CGRectMake(spaceing, lineView.cs_max_Y + 15, SCREENWIDTH - spaceing * 2, 30 - lineView.cs_h) PlaceHolder:@"请再次输入密码" KeyboardType:UIKeyboardTypeASCIICapable];
    self.pwdTextField2 = pwdTextField2;
    
    [self.maskScrollView addSubview:textFieldView];
    [textFieldView addSubview:lineView];
    [textFieldView addSubview:pwdTextField1];
    [textFieldView addSubview:pwdTextField2];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, textFieldView.cs_max_Y + 20, SCREENWIDTH - 30, 40)];
    [loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = CS_UIFontSize(16.);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"buttonbackground1"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"buttonbackground2"] forState:UIControlStateDisabled];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    [loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.maskScrollView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    
}
- (UITextField *)createTextFieldWithFrame:(CGRect)frame PlaceHolder:(NSString *)placeHolder KeyboardType:(UIKeyboardType)keyboardType {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = YES;
    textField.font = [UIFont systemFontOfSize:13.];
    textField.delegate = self;
    return textField;
}
- (void)buttonClick:(UIButton *)button {
    [self hideKeyBoard];
    [MBProgressHUD showLoading:@""];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mobile"] = self.phomeNumber;
    parameters[@"verify_code"] =  self.verfiyCode;
    parameters[@"password1"] = self.pwdTextField1.text;
    parameters[@"password2"] = self.pwdTextField2.text;
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:TResetPwd_URL WithParaments:parameters WithSuccess:^(id responseObject) {
        NSString *result = [responseObject objectForKey:@"rcode"];
        [MBProgressHUD hideHUD];
        if ([result intValue] == 0) {
            NSString *successString = @"";
            if (self.pwdType == PWDWithInstall) { // 设置密码
                successString = @"密码设置成功,快去登陆吧！";
            }else {
                successString = @"密码设置成功!";
            }
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:successString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alterView.delegate = self;
            [alterView show];
        }else {
            [MBProgressHUD showWarning:responseObject[@"msg"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"密码设置失败~!"];
    } Progress:^(float progress) {
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backApointInterface {
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if (count >= 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end





















































