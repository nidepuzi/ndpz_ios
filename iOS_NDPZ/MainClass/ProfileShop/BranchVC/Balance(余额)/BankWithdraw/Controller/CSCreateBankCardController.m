//
//  CSCreateBankCardController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/19.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSCreateBankCardController.h"
#import "CSChoiseBankController.h"
#import "CSBankWithdrawController.h"

@interface CSCreateBankCardController () <UITextFieldDelegate, UIAlertViewDelegate> {
    NSString *_bankName;
}

@property (nonatomic, strong) UITextField *cardNameTF;
@property (nonatomic, strong) UITextField *cardIDTF;
@property (nonatomic, strong) UIImageView *bankImageView;



@end

@implementation CSCreateBankCardController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.cardIDTF resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor countLabelColor];
    [self createNavigationBarWithTitle:@"输入银行卡账号" selecotr:@selector(backClick)];
    
    [self createUI];
    [self loadData];

}
- (void)loadData {
    NSString *url = [NSString stringWithFormat:@"%@/rest/v2/bankcards/get_default", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        NSString *accountNum = responseObject[@"account_no"];
        if (![NSString isStringEmpty:accountNum]) {
            self.cardNameTF.text = responseObject[@"account_name"];
            self.cardIDTF.text = responseObject[@"account_no"];
            self.cardNameTF.userInteractionEnabled = NO;
            _bankName = responseObject[@"bank_name"];
            if (![NSString isStringEmpty:responseObject[@"bank_img"]]) {
                [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"bank_img"]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image != nil) {
                        CGFloat imageWidth = (image.size.width / image.size.height) * 30;
                        [self.bankImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.width.mas_equalTo(imageWidth);
                        }];
                    }
                }];
            }
            CGFloat nameW = [self.cardNameTF.text widthWithHeight:20 andFont:13].width + 10;
            [self.cardNameTF mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(nameW);
            }];
            
        }
        
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)createUI {
    UIView *cardNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 15 + kAPPNavigationHeight, SCREENWIDTH, 60)];
    cardNameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cardNameView];
    
    UILabel *huming = [UILabel new];
    [cardNameView addSubview:huming];
    huming.text = @"户名";
    huming.textColor = [UIColor buttonTitleColor];
    huming.font = CS_UIFontSize(14.);
    [huming mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardNameView).offset(15);
        make.centerY.equalTo(cardNameView.mas_centerY);
    }];
    
    UITextField *cardNameTF = [[UITextField alloc] init];
    cardNameTF.placeholder = @"持卡人";
    cardNameTF.borderStyle = UITextBorderStyleNone;
    cardNameTF.keyboardType = UIKeyboardTypeDefault;
    cardNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    cardNameTF.font = [UIFont systemFontOfSize:13.];
    cardNameTF.delegate = self;
    [cardNameView addSubview:cardNameTF];
    [cardNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(huming.mas_right).offset(15);
        make.centerY.equalTo(cardNameView.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(@30);
    }];
    self.cardNameTF = cardNameTF;
    
    UILabel *huming1 = [UILabel new];
    [cardNameView addSubview:huming1];
    huming1.text = @"(只能提现到本人银行卡)";
    huming1.textColor = [UIColor dingfanxiangqingColor];
    huming1.font = CS_UIFontSize(14.);
    [huming1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardNameTF.mas_right).offset(5);
        make.centerY.equalTo(cardNameView.mas_centerY);
    }];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, cardNameView.cs_max_Y, SCREENWIDTH, 1)];
    lineView1.backgroundColor = [UIColor lineGrayColor];
    [self.view addSubview:lineView1];
    
    UIView *cardIDView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView1.cs_max_Y, SCREENWIDTH, 60)];
    cardIDView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cardIDView];
    
    UILabel *kahao = [UILabel new];
    [cardIDView addSubview:kahao];
    kahao.text = @"卡号";
    kahao.textColor = [UIColor buttonTitleColor];
    kahao.font = CS_UIFontSize(14.);
    [kahao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardIDView).offset(15);
        make.centerY.equalTo(cardIDView.mas_centerY);
    }];
    
    UITextField *cardIDTF = [[UITextField alloc] init];
    cardIDTF.placeholder = @"请输入本人银行卡号";
    cardIDTF.borderStyle = UITextBorderStyleNone;
    cardIDTF.keyboardType = UIKeyboardTypeNumberPad;
    cardIDTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    cardIDTF.font = [UIFont systemFontOfSize:13.];
    cardIDTF.delegate = self;
    [cardIDView addSubview:cardIDTF];
    [cardIDTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kahao.mas_right).offset(15);
        make.centerY.equalTo(cardIDView.mas_centerY);
        make.width.mas_equalTo(SCREENWIDTH - 80);
        make.height.mas_equalTo(@30);
    }];
    self.cardIDTF = cardIDTF;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, cardIDView.cs_max_Y, SCREENWIDTH, 1)];
    lineView2.backgroundColor = [UIColor lineGrayColor];
    [self.view addSubview:lineView2];
    
    UIButton *bankButton = [[UIButton alloc] initWithFrame:CGRectMake(0, lineView2.cs_max_Y, SCREENWIDTH, 60)];
    bankButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bankButton];
    [bankButton addTarget:self action:@selector(choiseBank:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bankImageView = [UIImageView new];
    [bankButton addSubview:bankImageView];
    self.bankImageView = bankImageView;
    bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    bankImageView.clipsToBounds = YES;
    bankImageView.image = [UIImage imageNamed:@"cs_bankname_chinabank"];
    CGFloat imageWidth = (bankImageView.image.size.width / bankImageView.image.size.height) * 30;
    
    UIImageView *pushImageView = [UIImageView new];
    [bankButton addSubview:pushImageView];
    pushImageView.image = [UIImage imageNamed:@"cs_pushInImage"];
    
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankButton).offset(15);
        make.centerY.equalTo(bankButton.mas_centerY);
        make.width.mas_equalTo(imageWidth);
        make.height.mas_equalTo(30);
    }];
    [pushImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bankButton).offset(-10);
        make.centerY.equalTo(bankButton.mas_centerY);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(15);
    }];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, bankButton.cs_max_Y, SCREENWIDTH, 1)];
    lineView3.backgroundColor = [UIColor lineGrayColor];
    [self.view addSubview:lineView3];
    
    UILabel *tishiLabel = [UILabel new];
    tishiLabel.text = @"*如果持卡人非店主本人,或者银行卡信息与卡号不符,提现申请将被系统驳回";
    tishiLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    tishiLabel.font = CS_UIFontSize(12.);
    tishiLabel.numberOfLines = 0;
    
    [self.view addSubview:tishiLabel];
    [tishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView3.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 30);
    }];
    
    UIButton *xiayibu = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:xiayibu];
    xiayibu.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [xiayibu setTitle:@"下一步" forState:UIControlStateNormal];
    [xiayibu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    xiayibu.titleLabel.font = CS_UIFontSize(14.);
    xiayibu.layer.cornerRadius = 5.;
    xiayibu.layer.masksToBounds = YES;
    [xiayibu addTarget:self action:@selector(xiayibuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [xiayibu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tishiLabel.mas_bottom).offset(60);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH * 0.5);
        make.height.mas_equalTo(@40);
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
    NSLog(@"%@ : %@",self.cardIDTF.text,muString);
    
    return YES;
}

- (void)choiseBank:(UIButton *)button {
    CSChoiseBankController *vc = [[CSChoiseBankController alloc] init];
    kWeakSelf
    vc.block = ^(NSDictionary *dic) {
        [weakSelf.bankImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"bank_img"]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
        _bankName = dic[@"bank_name"];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)xiayibuClick:(UIButton *)button {
    [MBProgressHUD showLoading:@""];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"account_no"] = self.cardIDTF.text;
    params[@"account_name"] = self.cardNameTF.text;
    params[@"bank_name"] = _bankName;
    params[@"default"] = [NSNumber numberWithBool:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@/rest/v2/bankcards", Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:url WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            [MBProgressHUD hideHUD];
            // 跳转提现界面 把银行卡ID传入
            CSBankWithdrawController *vc = [[CSBankWithdrawController alloc] init];
            vc.accountMoney = self.accountMoney;
            vc.cardInfo = responseObject[@"card"];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
        
    } WithFail:^(NSError *error) {
        [MBProgressHUD showMessage:@"请求失败,请稍后重试"];
    } Progress:^(float progress) {
        
    }];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.cardNameTF resignFirstResponder];
    [self.cardIDTF resignFirstResponder];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}






@end








































































