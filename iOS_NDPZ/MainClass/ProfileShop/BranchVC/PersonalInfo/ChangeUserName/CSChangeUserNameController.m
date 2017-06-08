//
//  CSChangeUserNameController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/6/1.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSChangeUserNameController.h"
#import "JMStoreManager.h"
#import "CSUserProfileModel.h"


@interface CSChangeUserNameController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameTF;


@end

@implementation CSChangeUserNameController

#pragma mark ---- 生命周期函数
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor countLabelColor];
    [self createNavigationBarWithTitle:@"修改昵称" selecotr:@selector(backClick)];
    
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 50)];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    
    UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, SCREENWIDTH - 20, 40)];
    [textView addSubview:nameTF];
    nameTF.placeholder = @"设置个性昵称（不超过20个字)";
    nameTF.borderStyle = UITextBorderStyleNone;
    nameTF.keyboardType = UIKeyboardTypeDefault;
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTF.font = [UIFont systemFontOfSize:13.];
    nameTF.delegate = self;
    self.nameTF = nameTF;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, textView.cs_max_Y + 10, SCREENWIDTH - 30, 20)];
    titleLabel.text = @"2-20个字符，可由中英文组成";
    titleLabel.font = CS_UIFontSize(12.);
    titleLabel.textColor = [UIColor dingfanxiangqingColor];
    [self.view addSubview:titleLabel];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:saveButton];
    saveButton.frame = CGRectMake(30, titleLabel.cs_max_Y + 20, SCREENWIDTH - 60, 40);
    saveButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [saveButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = CS_UIFontSize(14.);
    saveButton.layer.cornerRadius = 5;
    saveButton.layer.masksToBounds = YES;
    [saveButton addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.nameTF.text = self.userName;
    
    
    
    
}


#pragma mark ---- 网络请求


#pragma mark ---- 数据处理




#pragma mark ---- 代理
//是否允许本字段结束编辑，允许-->文本字段会失去firse responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
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
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@" "]) {
        return NO;
    }
    NSMutableString *muString = [[NSMutableString alloc] initWithString:textField.text];
    [muString appendString:string];
    [muString deleteCharactersInRange:range];
    NSLog(@"%@",muString);
    if (muString.length > 20) {
        return NO;
    }
    return YES;
}

#pragma mark ---- 自定义事件
- (void)saveClick:(UIButton *)button {
    if ([NSString isStringEmpty:self.nameTF.text]) {
        [MBProgressHUD showMessage:@"请输入昵称"];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/%@", Root_URL, [CSUserProfileModel sharInstance].profileID];
    NSDictionary *params = @{@"nick":self.nameTF.text};
    [JMHTTPManager requestWithType:RequestTypePATCH WithURLString:urlString WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 0) {
            if (self.block) {
                self.block(self.nameTF.text);
            }
            [self backClick];
        }
        [MBProgressHUD showMessage:responseObject[@"info"]];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
    
    
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nameTF resignFirstResponder];
}


#pragma mark ---- 其他






@end





















































































