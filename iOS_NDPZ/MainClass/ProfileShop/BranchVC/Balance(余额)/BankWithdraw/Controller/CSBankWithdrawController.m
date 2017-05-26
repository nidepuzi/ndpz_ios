//
//  CSBankWithdrawController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/19.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSBankWithdrawController.h"
#import "TixianSucceedViewController.h"

@interface CSBankWithdrawController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *tixianjineTF;
@property (nonatomic, strong) UITextField *yanzhengmaTF;
@property (nonatomic, strong) UIButton *yanzhengmaButton;
@property (nonatomic, strong) UILabel *dangqianjine;

@end

@implementation CSBankWithdrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor countLabelColor];
    [self createNavigationBarWithTitle:@"提现到银行卡" selecotr:@selector(backClick)];

    NSLog(@"CSBankWithdrawController -- > %@",self.cardInfo);
    
    UILabel *dangqianjine = [[UILabel alloc] initWithFrame:CGRectMake(15, kAPPNavigationHeight, SCREENWIDTH, 60)];
    [self.view addSubview:dangqianjine];
    dangqianjine.textColor = [UIColor dingfanxiangqingColor];
    dangqianjine.font = CS_UIFontSize(14.);
    self.dangqianjine = dangqianjine;
    self.dangqianjine.text = [NSString stringWithFormat:@"当前可提现最大金额: %@",self.accountMoney];
    
    UIView *shurujineView = [[UIView alloc] initWithFrame:CGRectMake(0, dangqianjine.cs_max_Y, SCREENWIDTH, 60)];
    shurujineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shurujineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, shurujineView.cs_max_Y, SCREENWIDTH, 1)];
    lineView1.backgroundColor = [UIColor lineGrayColor];
    [self.view addSubview:lineView1];
    
    UITextField *tixianjineTF = [[UITextField alloc] init];
    tixianjineTF.placeholder = @"请输入提现金额";
    tixianjineTF.borderStyle = UITextBorderStyleNone;
    tixianjineTF.keyboardType = UIKeyboardTypeDecimalPad;
    tixianjineTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    tixianjineTF.font = [UIFont systemFontOfSize:13.];
    tixianjineTF.delegate = self;
    [shurujineView addSubview:tixianjineTF];
    [tixianjineTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shurujineView).offset(15);
        make.centerY.equalTo(shurujineView.mas_centerY);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(@30);
    }];
    self.tixianjineTF = tixianjineTF;
    
    UIView *yanzhengmaView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView1.cs_max_Y, SCREENWIDTH, 60)];
    yanzhengmaView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:yanzhengmaView];
    
    UITextField *yanzhengmaTF = [[UITextField alloc] init];
    yanzhengmaTF.placeholder = @"请输入验证码";
    yanzhengmaTF.borderStyle = UITextBorderStyleNone;
    yanzhengmaTF.keyboardType = UIKeyboardTypeNumberPad;
    yanzhengmaTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    yanzhengmaTF.font = [UIFont systemFontOfSize:13.];
    yanzhengmaTF.delegate = self;
    [yanzhengmaView addSubview:yanzhengmaTF];
    [yanzhengmaTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yanzhengmaView).offset(15);
        make.centerY.equalTo(yanzhengmaView.mas_centerY);
        make.width.mas_equalTo(SCREENWIDTH - 130);
        make.height.mas_equalTo(@30);
    }];
    self.yanzhengmaTF = yanzhengmaTF;
    
    UIButton *yanzhengmaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yanzhengmaView addSubview:yanzhengmaButton];
    [yanzhengmaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yanzhengmaTF.mas_right).offset(10);
        make.centerY.equalTo(yanzhengmaView.mas_centerY);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    [yanzhengmaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yanzhengmaButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    yanzhengmaButton.titleLabel.font = CS_UIFontSize(12.);
    yanzhengmaButton.layer.cornerRadius = 5.;
    yanzhengmaButton.layer.masksToBounds = YES;
    yanzhengmaButton.layer.borderColor = [UIColor lineGrayColor].CGColor;
    yanzhengmaButton.layer.borderWidth = 1.;
    [yanzhengmaButton addTarget:self action:@selector(getAuthcodeClick:) forControlEvents:UIControlEventTouchUpInside];
    self.yanzhengmaButton = yanzhengmaButton;
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, yanzhengmaView.cs_max_Y, SCREENWIDTH, 1)];
    lineView2.backgroundColor = [UIColor lineGrayColor];
    [self.view addSubview:lineView2];
    
    
    UIButton *xiayibu = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:xiayibu];
    xiayibu.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [xiayibu setTitle:@"提交" forState:UIControlStateNormal];
    [xiayibu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    xiayibu.titleLabel.font = CS_UIFontSize(15.);
    xiayibu.layer.cornerRadius = 5.;
    xiayibu.layer.masksToBounds = YES;
    [xiayibu addTarget:self action:@selector(tijiaoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [xiayibu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2.mas_bottom).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 60);
        make.height.mas_equalTo(@40);
    }];
    

}

//- (void)setAccountMoney:(NSString *)accountMoney {
//    _accountMoney = accountMoney;
//    self.dangqianjine.text = [NSString stringWithFormat:@"当前可提现最大金额: %@",accountMoney];
//}


#pragma mark ---- 点击获取验证码按钮
- (void)getAuthcodeClick:(UIButton *)sender {
    [self.tixianjineTF resignFirstResponder];
    [self.yanzhengmaTF resignFirstResponder];
    if ([NSString isStringEmpty:self.tixianjineTF.text]) {
        [MBProgressHUD showMessage:@"请输入提现金额"];
        return;
    }
    if (![self isNumInputShouldNumber:self.tixianjineTF.text]) {
        [MBProgressHUD showMessage:@"提现金额包含非法字符"];
        return;
    }
    [MBProgressHUD showLoading:@""];
    NSString *urlString = CS_DSTRING(Root_URL,@"/rest/v2/request_cashout_verify_code");
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        NSInteger rcodeStr = [[responseObject objectForKey:@"code"] integerValue];
        if (rcodeStr == 0) {
            [self startTime];
            [MBProgressHUD hideHUD];
        }else {
            [MBProgressHUD showWarning:[responseObject objectForKey:@"info"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"获取失败！"];
    } Progress:^(float progress) {
        
    }];
    
    
    
    
}
- (void)startTime {
    __block int secondsCountDown = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(secondsCountDown<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.yanzhengmaButton.titleLabel.text = @"获取验证码";
                _yanzhengmaButton.enabled = YES;
                _yanzhengmaButton.selected = YES;
            });
        }else{
            int seconds = secondsCountDown % 60;
            //            NSString *strTime = [NSString stringWithFormat:@"%02d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                self.yanzhengmaButton.titleLabel.text = [NSString stringWithFormat:@" 剩余%02d秒",seconds];
                [UIView commitAnimations];
                _yanzhengmaButton.enabled = NO;
                _yanzhengmaButton.selected = NO;
            });
            secondsCountDown--;
        }
    });
    dispatch_resume(_timer);
    
}

- (BOOL)isNumInputShouldNumber:(NSString *)string {
    NSString *regex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
    
}

- (void)tijiaoClick:(UIButton *)button {
    [self.tixianjineTF resignFirstResponder];
    [self.yanzhengmaTF resignFirstResponder];
    if ([NSString isStringEmpty:self.tixianjineTF.text]) {
        [MBProgressHUD showMessage:@"请输入提现金额"];
        return;
    }
    if (![self isNumInputShouldNumber:self.tixianjineTF.text]) {
        [MBProgressHUD showMessage:@"请检查提现金额"];
        return;
    }
    if ([NSString isStringEmpty:self.yanzhengmaTF.text]) {
        [MBProgressHUD showMessage:@"请输入验证码"];
        return;
    }
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/redenvelope/budget_cash_out",Root_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cashout_amount"] = self.tixianjineTF.text;
    params[@"verify_code"] = self.yanzhengmaTF.text;
    params[@"channel"] = @"sandpay";
    params[@"card_id"] = self.cardInfo[@"id"];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            [MBProgressHUD showSuccess:@"提现申请成功"];
            TixianSucceedViewController *successVC = [[TixianSucceedViewController alloc] init];
            successVC.isActiveValue = NO;
            [self.navigationController pushViewController:successVC animated:YES];
        }else {
            [MBProgressHUD showMessage:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
    }];
    
    
}


#pragma mark ==== UITextField 代理实现 ====
//是否允许本字段结束编辑，允许-->文本字段会失去firse responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
//输入框获得焦点，执行这个方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *muString = [[NSMutableString alloc] initWithString:textField.text];
    [muString appendString:string];
    [muString deleteCharactersInRange:range];
    
    
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.tixianjineTF resignFirstResponder];
    [self.yanzhengmaTF resignFirstResponder];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}






@end
























































































































