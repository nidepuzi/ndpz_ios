//
//  CSChangeUserProfileController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/6/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSChangeUserProfileController.h"
#import "JMSelectAddressView.h"
#import "CSUserProfileModel.h"

@interface CSChangeUserProfileController () <UIGestureRecognizerDelegate, UIActionSheetDelegate> {
    NSString *province;
    NSString *city;
    NSString *county;
    NSString *_dateString;
}

@property (nonatomic, strong) UIScrollView *maskScrollView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UITextField *brithdyTextField;
@property (nonatomic, strong) UITextField *sexTextField;

@property (nonatomic, strong) JMSelectAddressView *selectView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *popDatePickerView;

@property (nonatomic, strong) UIView *maskView;


@end

@implementation CSChangeUserProfileController

- (UIScrollView *)maskScrollView {
    if (!_maskScrollView) {
        _maskScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _maskScrollView.backgroundColor = [UIColor countLabelColor];
    }
    return _maskScrollView;
}
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
        _maskView.alpha = 0.0;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [btn addTarget:self action:@selector(hideMaskView) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
    }
    return _maskView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"设置个人信息" selecotr:@selector(backClick)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.maskScrollView];
    
    [self createUI];
    
}
- (void)createUI {
    JMSelectAddressView *selectView = [[JMSelectAddressView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.selectView = selectView;
    kWeakSelf
    self.selectView.block = ^(NSString *proviceStr,NSString *cityStr,NSString * disStr) {
        NSLog(@"%@,%@,%@",proviceStr , cityStr , disStr);
        weakSelf.addressTextField.text = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,disStr];
        province = [proviceStr copy];
        city = [cityStr copy];
        county = [disStr copy];
    };
    
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 240)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    [self.maskScrollView addSubview:textFieldView];
    
    for (int i = 0; i < 4; i++) {
        UIView *lineView = [UIView new];
        [textFieldView addSubview:lineView];
        lineView.frame = CGRectMake(20, 60 * (i + 1), SCREENWIDTH - 40, 1);
        lineView.backgroundColor = [UIColor countLabelColor];
    }
    UITextField *nameTextField = [self createTextFieldWithFrame:CGRectMake(20, 10, SCREENWIDTH - 40, 40) PlaceHolder:@"姓名" KeyboardType:UIKeyboardTypeDefault];
    UITextField *addressTextField = [self createTextFieldWithFrame:CGRectMake(20, nameTextField.cs_max_Y + 20, SCREENWIDTH - 40, 40) PlaceHolder:@"地址信息" KeyboardType:UIKeyboardTypeNumberPad];
    UITextField *brithdyTextField = [self createTextFieldWithFrame:CGRectMake(20, addressTextField.cs_max_Y + 20, SCREENWIDTH - 40, 40) PlaceHolder:@"生日" KeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    UITextField *sexTextField = [self createTextFieldWithFrame:CGRectMake(20, brithdyTextField.cs_max_Y + 20, SCREENWIDTH - 40, 40) PlaceHolder:@"性别" KeyboardType:UIKeyboardTypeDefault];
    self.nameTextField = nameTextField;
    self.addressTextField = addressTextField;
    self.brithdyTextField = brithdyTextField;
    self.sexTextField = sexTextField;
    [textFieldView addSubview:nameTextField];
    [textFieldView addSubview:addressTextField];
    [textFieldView addSubview:brithdyTextField];
    [textFieldView addSubview:sexTextField];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(30, textFieldView.cs_max_Y + 20, SCREENWIDTH - 60, 40);
    saveButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [saveButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = CS_UIFontSize(14.);
    saveButton.layer.cornerRadius = 5;
    saveButton.layer.masksToBounds = YES;
    [saveButton addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.maskScrollView addSubview:saveButton];
    
    nameTextField.text = [CSUserProfileModel sharInstance].nick;
    addressTextField.text = [NSString isStringEmpty:[CSUserProfileModel sharInstance].province] ? @"" : [NSString stringWithFormat:@"%@%@%@",[CSUserProfileModel sharInstance].province,[CSUserProfileModel sharInstance].city,[CSUserProfileModel sharInstance].district];
    brithdyTextField.text = [CSUserProfileModel sharInstance].birthday_display;
    sexTextField.text = [[CSUserProfileModel sharInstance].sex integerValue] == 0 ? @"" : [[CSUserProfileModel sharInstance].sex integerValue] == 1 ? @"男" : @"女";
    province = [CSUserProfileModel sharInstance].province;
    city = [CSUserProfileModel sharInstance].city;
    county = [CSUserProfileModel sharInstance].district;
    
    
    UIView *popDatePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 220)];
    popDatePickerView.backgroundColor = [UIColor lineGrayColor];
    [self.view addSubview:popDatePickerView];
    self.popDatePickerView = popDatePickerView;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [popDatePickerView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = CS_UIFontSize(16.);
//    cancelButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    cancelButton.layer.cornerRadius = 3.;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.tag = 103;
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [popDatePickerView addSubview:sureButton];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = CS_UIFontSize(16.);
//    sureButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    sureButton.layer.cornerRadius = 3.;
    sureButton.layer.masksToBounds = YES;
    sureButton.tag = 104;
    [sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    self.datePicker = datePicker;
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [datePicker addTarget:self action:@selector(birthdayChange:) forControlEvents:UIControlEventValueChanged];
    [popDatePickerView addSubview:datePicker];
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(popDatePickerView);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@180);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popDatePickerView);
        make.left.equalTo(popDatePickerView);
        make.width.mas_equalTo(@(80));
        make.height.mas_equalTo(@(40));
    }];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popDatePickerView);
        make.right.equalTo(popDatePickerView);
        make.width.mas_equalTo(@(80));
        make.height.mas_equalTo(@(40));
    }];
    
    
    
    self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, saveButton.cs_max_Y + 20);
    
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
//是否允许本字段结束编辑，允许-->文本字段会失去firse responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.addressTextField) {
        [self.nameTextField resignFirstResponder];
        [self.addressTextField resignFirstResponder];
        [self.brithdyTextField resignFirstResponder];
        [self.sexTextField resignFirstResponder];
        [self.selectView show];
        return NO;
    }else if (textField == self.brithdyTextField) {
        [self.nameTextField resignFirstResponder];
        [self.addressTextField resignFirstResponder];
        [self.brithdyTextField resignFirstResponder];
        [self.sexTextField resignFirstResponder];
        [self showPopView];
        return NO;
    }else if (textField == self.sexTextField) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [sheet showInView:self.view];
        [self.nameTextField resignFirstResponder];
        [self.addressTextField resignFirstResponder];
        [self.brithdyTextField resignFirstResponder];
        [self.sexTextField resignFirstResponder];
        return NO;
    }else {
        
        
        return YES;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@" "]) {
        return NO;
    }
    if (textField == self.nameTextField) {
        NSMutableString *muString = [[NSMutableString alloc] initWithString:textField.text];
        [muString appendString:string];
        [muString deleteCharactersInRange:range];
        NSLog(@"%@",muString);
        if (muString.length > 20) {
            return NO;
        }
    }
    
    return YES;
}



- (void)saveClick:(UIButton *)button {
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/update_profile", Root_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sex"] = [self.sexTextField.text isEqualToString:@"男"] ? @1 : @2;
    params[@"birthday"] = _dateString;
    params[@"province"] = province;
    params[@"city"] = city;
    params[@"district"] = county;
    params[@"nick"] = self.nameTextField.text;
    params[@"id"] = [CSUserProfileModel sharInstance].profileID;
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:params WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 0) {
            [self successSetting];
            [self backClick];
        }
        [MBProgressHUD showMessage:responseObject[@"info"]];
    } WithFail:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"请求失败,请稍后重试"];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)successSetting {
    [CSUserProfileModel sharInstance].sex = [self.sexTextField.text isEqualToString:@"男"] ? @"1" : @"2";
    [CSUserProfileModel sharInstance].birthday_display = self.brithdyTextField.text;
    [CSUserProfileModel sharInstance].nick = self.nameTextField.text;
    [CSUserProfileModel sharInstance].province = province;
    [CSUserProfileModel sharInstance].city = city;
    [CSUserProfileModel sharInstance].district = county;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex --> %ld",buttonIndex);
    if (buttonIndex == 0) {
        self.sexTextField.text = @"男";
    }else if (buttonIndex == 1) {
        self.sexTextField.text = @"女";
    }else {
        
    }
    
    
}
- (void)birthdayChange:(UIDatePicker *)picker {
    NSDate *data = picker.date;
    NSDateFormatter *dataMatter = [[NSDateFormatter alloc] init];
    [dataMatter setDateFormat:@"yyyy-MM-dd"];
    _dateString = [dataMatter stringFromDate:data];
    self.brithdyTextField.text = _dateString;
}
- (void)buttonClick:(UIButton *)button {
    [self hideMaskView];
}
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showPopView {
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popDatePickerView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
//            self.view.layer.transform = [JMPopViewAnimationDrop secondStepTransform];
            self.popDatePickerView.transform = CGAffineTransformTranslate(self.popDatePickerView.transform, 0, -220);
        }];
    }];
    
}
- (void)hideMaskView {
    [UIView animateWithDuration:0.2 animations:^{
//        self.view.layer.transform = [JMPopViewAnimationDrop firstStepTransform];
        self.popDatePickerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
//            self.view.layer.transform = CATransform3DIdentity;
            self.maskView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.popDatePickerView removeFromSuperview];
        }];
    }];
    
}


@end
































































































