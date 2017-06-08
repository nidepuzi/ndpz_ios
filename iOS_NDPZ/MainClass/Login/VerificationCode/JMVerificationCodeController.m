//
//  JMVerificationCodeController.m
//  XLMM
//
//  Created by zhang on 17/4/20.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMVerificationCodeController.h"
#import "JMGoodsCountTime.h"
#import "MiPushSDK.h"
#import "JMInstallPasswordController.h"
#import "WebViewController.h"
#import "JMRootTabBarController.h"
#import "Udesk.h"
#import "JMRichTextTool.h"
#import <STPopup/STPopup.h>
#import "CSPopDescriptionController.h"
#import "CSCustomerServiceManager.h"
#import "CSUserProfileModel.h"
#import "CSLoginManager.h"


@interface JMVerificationCodeController ()


@property (nonatomic, strong) UIScrollView *maskScrollView;
@property (nonatomic, strong) UIButton *verificationCodeButton;
@property (nonatomic, strong) UITextField *phoneNumberField;
@property (nonatomic, strong) UITextField *verificationCodeField;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UILabel *waringLabel;
@property (nonatomic, strong) UIButton *registeredButton;
@property (nonatomic, assign) BOOL isShowSliderView;


@property (nonatomic, strong) UIButton *loginButton;


@end

@implementation JMVerificationCodeController

#pragma mark ==== 懒加载 ====
- (UIScrollView *)maskScrollView {
    if (!_maskScrollView) {
        _maskScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _maskScrollView.delegate = self;
    }
    return _maskScrollView;
}

#pragma mark ==== 生命周期函数 ====
- (instancetype)init {
    if (self = [super init]) {
        self.verificationCodeType = SMSVerificationCodeWithLogin;
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
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (IS_IOS8) {
    }else {
        self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, self.loginButton.cs_max_Y + 20);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:self.title selecotr:@selector(backClick)];
    
    self.fd_interactivePopDisabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.maskScrollView];
    [self createUI];

    if (self.verificationCodeType == SMSVerificationCodeWithBind) {
        RACSignal *enableSignal = [[RACSignal combineLatest:@[self.phoneNumberField.rac_textSignal,self.verificationCodeField.rac_textSignal,self.nameTF.rac_textSignal]] map:^id(id value) {
            NSString *value1 = value[0];
            NSString *value2 = value[1];
            NSString *value3 = value[2];
            BOOL phoneEnable = value1.length == 11 && [value1 hasPrefix:@"1"];
            BOOL verEnable = value2.length >= 4 && value2.length <= 6;
            BOOL nameEnable = value3.length >= 2 && ![NSString isStringEmpty:value3];
            return @(phoneEnable && verEnable && nameEnable);
        }];
        self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }else {
        RACSignal *enableSignal = [[RACSignal combineLatest:@[self.phoneNumberField.rac_textSignal,self.verificationCodeField.rac_textSignal]] map:^id(id value) {
            NSString *value1 = value[0];
            NSString *value2 = value[1];
            BOOL phoneEnable = value1.length == 11 && [value1 hasPrefix:@"1"];
            BOOL verEnable = value2.length >= 4 && value2.length <= 6;
            return @(phoneEnable && verEnable);
        }];
        self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
        
    }
    
    RACSignal *verifiEnableSignal = [self.phoneNumberField.rac_textSignal map:^id(id value) {
        return @([value length] == 11 && [value hasPrefix:@"1"]);
    }];
    self.verificationCodeButton.rac_command = [[RACCommand alloc] initWithEnabled:verifiEnableSignal signalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    
    
    
    
}

#pragma mark ==== 创建视图 ====
- (void)createUI {
    CGFloat firstSectionViewH = 120.;
    CGFloat spaceing = 15.f;
    CGFloat topSpace = 60.;
    if (self.verificationCodeType == SMSVerificationCodeWithBind) {
        topSpace = 240.;
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.maskScrollView addSubview:iconImageView];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.font = [UIFont systemFontOfSize:14.];
        nameLabel.textColor = [UIColor buttonTitleColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.maskScrollView addSubview:nameLabel];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:13.];
        titleLabel.textColor = [UIColor dingfanxiangqingColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.maskScrollView addSubview:titleLabel];
        kWeakSelf
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.maskScrollView).offset(30);
            make.centerX.equalTo(weakSelf.maskScrollView.mas_centerX);
            make.width.height.mas_equalTo(@(90));
        }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(10);
            make.centerX.equalTo(weakSelf.maskScrollView.mas_centerX);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(10);
            make.centerX.equalTo(weakSelf.maskScrollView.mas_centerX);
        }];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[CSUserProfileModel sharInstance].thumbnail] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
        nameLabel.text = [NSString stringWithFormat:@"微信号:%@", [CSUserProfileModel sharInstance].nick];
        
        titleLabel.text = @"为了更好的为您服务,请绑定手机号哦~!";
        
        UIView *textView = [UIView new];
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = YES;
        textView.layer.borderWidth = 1.;
        textView.layer.borderColor = [UIColor titleDarkGrayColor].CGColor;
        [self.maskScrollView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.centerX.equalTo(weakSelf.maskScrollView.mas_centerX);
            make.width.mas_equalTo(SCREENWIDTH - 30);
            make.height.mas_equalTo(40);
        }];
        
        UITextField *nameTF = [UITextField new];
        [textView addSubview:nameTF];
        nameTF.placeholder = @"设置姓名（2-20个中英字符)";
        nameTF.borderStyle = UITextBorderStyleNone;
        nameTF.keyboardType = UIKeyboardTypeDefault;
        nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        nameTF.font = [UIFont systemFontOfSize:13.];
        nameTF.delegate = self;
        self.nameTF = nameTF;
        [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(textView);
            make.width.mas_equalTo(SCREENWIDTH - 50);
            make.height.mas_equalTo(30);
        }];
        
        
    }
    
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
    self.phoneNumberField = phoneNumberField;
    UITextField *verificationCodeField = [self createTextFieldWithFrame:CGRectMake(10, 5, verfiTFView.cs_w - 110, 30) PlaceHolder:@"请输入验证码" KeyboardType:UIKeyboardTypeNumberPad];
    self.verificationCodeField = verificationCodeField;
    [phoneTFView addSubview:phoneNumberField];
    [verfiTFView addSubview:verificationCodeField];
    
    UIView *shuhangV = [[UIView alloc] initWithFrame:CGRectMake(verificationCodeField.cs_max_X + 10, verificationCodeField.cs_y + 5, 1, 20)];
    shuhangV.backgroundColor = [UIColor titleDarkGrayColor];
    [verfiTFView addSubview:shuhangV];
    
    self.verificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [verfiTFView addSubview:self.verificationCodeButton];
    self.verificationCodeButton.frame = CGRectMake(verificationCodeField.cs_max_X + 10, verificationCodeField.cs_y, 90, 30);
    [self.verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verificationCodeButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [self.verificationCodeButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateDisabled];
    self.verificationCodeButton.titleLabel.font = CS_UIFontSize(12.);
    [self.verificationCodeButton addTarget:self action:@selector(getAuthcodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat registW = [@"如何注册?" widthWithHeight:20. andFont:13.].width + 20;
    self.registeredButton  = [[UIButton alloc] initWithFrame:CGRectMake(spaceing, textFieldView.cs_max_Y + 10, registW, 20)];
    [self.maskScrollView addSubview:self.registeredButton];
    //设置按钮文字的下划线
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"如何注册?"];
    NSRange titleRange = {0,[title length]};
    [self.registeredButton setTitle:@"如何注册?" forState:UIControlStateNormal];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [self.registeredButton setAttributedTitle:title forState:UIControlStateNormal];
    [self.registeredButton.titleLabel setFont:[UIFont systemFontOfSize:13.]];
    self.registeredButton.titleLabel.textColor = [UIColor redColor];
    [self.registeredButton addTarget:self action:@selector(registeredButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.waringLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceing, self.registeredButton.cs_max_Y + 10, SCREENWIDTH - spaceing * 2, 20)];
    [self.maskScrollView addSubview:self.waringLabel];
    self.waringLabel.text = @"";
    self.waringLabel.textColor = [UIColor redColor];
    self.waringLabel.font = CS_UIFontSize(13.);
    self.waringLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(spaceing, self.waringLabel.cs_max_Y + 20, SCREENWIDTH - spaceing * 2, 40);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"buttonbackground1"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"buttonbackground2"] forState:UIControlStateDisabled];
    loginButton.titleLabel.font = CS_UIFontSize(16.);
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.masksToBounds = YES;
    [loginButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.maskScrollView addSubview:loginButton];
    self.loginButton = loginButton;
    
    
    switch (self.verificationCodeType) {
        case SMSVerificationCodeWithLogin:      // 验证码登录
            [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
            self.verificationCodeField.placeholder = @"请输入验证码";
            self.title = @"手机登录";
            break;
        case SMSVerificationCodeWithRegistered: // 注册新用户
            [self.loginButton setTitle:@"确定" forState:UIControlStateNormal];
            self.title = @"手机注册";
            break;
        case SMSVerificationCodeWithBind:       // 微信登录用户绑定手机号
            [self.loginButton setTitle:@"确定" forState:UIControlStateNormal];
            self.title = @"手机绑定";
            break;
        case SMSVerificationCodeWithChangePWD:  // 修改密码
            [self.loginButton setTitle:@"下一步" forState:UIControlStateNormal];
            self.title = @"修改密码";
            break;
        case SMSVerificationCodeWithForgetPWD:  // 忘记密码
            [self.loginButton setTitle:@"下一步" forState:UIControlStateNormal];
            self.title = @"忘记密码";
            break;
        default:
            break;
    }
    [self createNavigationBarWithTitle:self.title selecotr:@selector(backClick)];
    
    UILabel *registDescLabel = [UILabel new];
    registDescLabel.textColor = [UIColor dingfanxiangqingColor];
    registDescLabel.font = CS_UIFontSize(12.);
    registDescLabel.textAlignment = NSTextAlignmentCenter;
    registDescLabel.numberOfLines = 0;
    [self.maskScrollView addSubview:registDescLabel];
    
    NSString *allString = @"登录代表您以阅读并同意《你的铺子微店用户服务协议》内容";
    registDescLabel.attributedText = [JMRichTextTool cs_changeColorWithColor:[UIColor buttonTitleColor] AllString:allString SubStringArray:@[@"《你的铺子微店用户服务协议》"]];
    registDescLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *termsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsTapClick)];
    [registDescLabel addGestureRecognizer:termsTap];
    self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, registDescLabel.cs_max_Y + 20);
    
    
    
}
- (void)termsTapClick {
    CSPopDescriptionController *popDescVC = [[CSPopDescriptionController alloc] init];
    popDescVC.popDescType = popDescriptionTypeRegist;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:popDescVC];
    popupController.isTouchBackgorundView = NO;
    popupController.containerView.layer.cornerRadius = 5;
    [popupController presentInViewController:self];
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
#pragma mark ---- 点击获取验证码按钮
- (void)getAuthcodeClick:(UIButton *)sender {
    [self hideKeyBoard];
    if (self.userNotXLMM) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"新掌柜首次登录请用微信登录哦!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    if ([NSString isStringEmpty:self.phoneNumberField.text]) {
        self.waringLabel.text = @"请输入手机号";
        return ;
    }
    if ([self.phoneNumberField.text hasPrefix:@"1"] && self.phoneNumberField.text.length == 11) {
    }else {
        self.waringLabel.text = @"请输入正确手机号";
        return ;
    }
    NSString *phoneNumber = self.phoneNumberField.text;
    NSInteger num  = [[phoneNumber substringToIndex:1] integerValue];
    if (num == 1 && phoneNumber.length == 11) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"mobile"] = phoneNumber;
        switch (self.verificationCodeType) {
            case SMSVerificationCodeWithLogin:      // 验证码登录
                parameters[@"action"] = @"sms_login";
                break;
            case SMSVerificationCodeWithRegistered: // 注册新用户
                parameters[@"action"] = @"register";
                break;
            case SMSVerificationCodeWithBind:       // 微信登录用户绑定手机号
                parameters[@"action"] = @"bind";
                break;
            case SMSVerificationCodeWithChangePWD:  // 修改密码
                parameters[@"action"] = @"change_pwd";
                break;
            case SMSVerificationCodeWithForgetPWD:  // 忘记密码
                parameters[@"action"] = @"find_pwd";
                break;
            default:
                break;
        }
        [MBProgressHUD showLoading:@""];
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:TSendCode_URL WithParaments:parameters WithSuccess:^(id responseObject) {
            NSInteger rcodeStr = [[responseObject objectForKey:@"rcode"] integerValue];
            if (rcodeStr == 0) {
                [MBProgressHUD hideHUD];
                [self startTime];
            }else {
                [MBProgressHUD showWarning:[responseObject objectForKey:@"msg"]];
            }
        } WithFail:^(NSError *error) {
            [MBProgressHUD showError:@"获取失败！"];
        } Progress:^(float progress) {
        }];
    }else {
        [MBProgressHUD showError:@"手机号错误！"];
    }
}
// === 验证码 ====
- (void)startTime {
    [JMGoodsCountTime initCountDownWithCurrentTime:61];
    kWeakSelf
    [JMGoodsCountTime shareCountTime].countBlock = ^(int second) {
        [weakSelf verificationButton:second];
    };
}
- (void)verificationButton:(int)second {
    if (second == -1) {
        self.verificationCodeButton.titleLabel.text = @"获取验证码";
        self.verificationCodeButton.enabled = YES;
    }else {
        self.verificationCodeButton.titleLabel.text = [NSString stringWithFormat:@" 剩余%02d秒",second];
        self.verificationCodeButton.enabled = NO;
    }
    
}

#pragma mark ==== 确定按钮点击 ====
- (void)loginBtnClick:(UIButton *)sender {
    [self hideKeyBoard];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    self.waringLabel.text = @"";
    parameters[@"mobile"] = self.phoneNumberField.text;
    parameters[@"verify_code"] = self.verificationCodeField.text;
    switch (self.verificationCodeType) {
        case SMSVerificationCodeWithLogin:      // 验证码登录
            parameters[@"action"] = @"sms_login";
            parameters[@"devtype"] = LOGINDEVTYPE;
            [MBProgressHUD showLoading:@"登录中....."];
            break;
        case SMSVerificationCodeWithRegistered: // 注册新用户
            parameters[@"action"] = @"register";
            parameters[@"devtype"] = LOGINDEVTYPE;
            [MBProgressHUD showLoading:@""];
            break;
        case SMSVerificationCodeWithBind:       // 微信登录用户绑定手机号
            if ([NSString isStringEmpty:self.nameTF.text] || self.nameTF.text.length < 2) {
                self.waringLabel.text = @"请检查输入姓名";
                return ;
            }
            parameters[@"action"] = @"bind";
            parameters[@"nickname"] = self.nameTF.text;
            [MBProgressHUD showLoading:@""];
            break;
        case SMSVerificationCodeWithChangePWD:  // 修改密码
            parameters[@"action"] = @"change_pwd";
            [MBProgressHUD showLoading:@""];
            break;
        case SMSVerificationCodeWithForgetPWD:  // 忘记密码
            parameters[@"action"] = @"find_pwd";
            [MBProgressHUD showLoading:@""];
            break;
        default:
            break;
    }
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:TVerifyCode_URL WithParaments:parameters WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self verifyAfter:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败,请稍后重试~!"];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)verifyAfter:(NSDictionary *)dic {
    if (dic.count == 0)return;
    if ([[dic objectForKey:@"rcode"] integerValue] != 0) {
        [self alertMessage:[dic objectForKey:@"msg"]];
        [MBProgressHUD hideHUD];
        return;
    }
    [MBProgressHUD hideHUD];
    if (self.verificationCodeType == SMSVerificationCodeWithRegistered || self.verificationCodeType == SMSVerificationCodeWithLogin) {
        [[CSLoginManager loginInstance] phoneLoginWithViewController:self Success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }else if (self.verificationCodeType == SMSVerificationCodeWithForgetPWD) {
        JMInstallPasswordController *pwdVC = [[JMInstallPasswordController alloc] init];
        pwdVC.pwdType = 0;
        pwdVC.verfiyCode = self.verificationCodeField.text;
        pwdVC.phomeNumber = self.phoneNumberField.text;
        [self.navigationController pushViewController:pwdVC animated:YES];
    }else if (self.verificationCodeType == SMSVerificationCodeWithChangePWD) {
        JMInstallPasswordController *pwdVC = [[JMInstallPasswordController alloc] init];
        pwdVC.pwdType = 1;
        pwdVC.verfiyCode = self.verificationCodeField.text;
        pwdVC.phomeNumber = self.phoneNumberField.text;
        [self.navigationController pushViewController:pwdVC animated:YES];
    }else {
        [[CSLoginManager loginInstance] phoneLoginWithViewController:self Success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideKeyBoard];
}
- (void) alertMessage:(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)hideKeyBoard {
    [self.view endEditing:YES];
}
- (void)backClick {
    if (self.userLoginMethodWithWechat) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self backApointInterface];
    }
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
- (void)registeredButtonClicked {
    // 点击进入客服
    kWeakSelf
    [[CSCustomerServiceManager defaultManager] showCustomerService:self];
    [CSCustomerServiceManager defaultManager].popBlock = ^() {
        [weakSelf.navigationController popViewControllerAnimated:NO];
    };
}


@end























































































