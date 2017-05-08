//
//  CSSearchSalesHistoryController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/29.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSSearchSalesHistoryController.h"

@interface CSSearchSalesHistoryController () {
    NSString *_dateString;
    NSInteger _seleIndex;
    NSString *_currentDate;
}

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *popDatePickerView;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *finishLabel;

@end

@implementation CSSearchSalesHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor countLabelColor];
    [self createNavigationBarWithTitle:@"查询历史" selecotr:@selector(backClick)];
    
    _seleIndex = 0;
    
    UILabel *warningLabel = [UILabel new];
    [self.view addSubview:warningLabel];
    warningLabel.font = CS_UIFontSize(12.);
    warningLabel.textColor = [UIColor buttonTitleColor];
    warningLabel.numberOfLines = 0;
    warningLabel.text = @"可在下面的框内选择要查询的起止时间,自定义查询。只能查询25天前,6个月内的数据。";
    
    UIView *rowView1 = [UIView new];
    [self.view addSubview:rowView1];
    rowView1.backgroundColor = [UIColor whiteColor];
    rowView1.layer.borderWidth = 1.;
    rowView1.layer.borderColor = [UIColor lineGrayColor].CGColor;
    
    UILabel *hengxianLabel = [UILabel new];
    [rowView1 addSubview:hengxianLabel];
    hengxianLabel.text = @"-";
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rowView1 addSubview:startButton];
    startButton.tag = 100;
    [startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rowView1 addSubview:finishButton];
    finishButton.tag = 101;
    [finishButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *startLabel = [UILabel new];
    startLabel.font = CS_UIFontSize(12.);
    startLabel.textColor = [UIColor buttonTitleColor];
    startLabel.numberOfLines = 0;
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.text = @"开始时间";
    self.startLabel = startLabel;
    [startButton addSubview:startLabel];
    
    UILabel *finishLabel = [UILabel new];
    finishLabel.font = CS_UIFontSize(12.);
    finishLabel.textColor = [UIColor buttonTitleColor];
    finishLabel.numberOfLines = 0;
    finishLabel.textAlignment = NSTextAlignmentCenter;
    finishLabel.text = @"结束时间";
    self.finishLabel = finishLabel;
    [finishButton addSubview:finishLabel];
    
    UIView *rowView2 = [UIView new];
    [self.view addSubview:rowView2];
    rowView2.backgroundColor = [UIColor whiteColor];
   
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rowView2 addSubview:searchButton];
    [searchButton setTitle:@"自定义查询" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchButton.titleLabel.font = CS_UIFontSize(13.);
    searchButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    searchButton.layer.cornerRadius = 5.;
    searchButton.layer.masksToBounds = YES;
    searchButton.tag = 102;
    [searchButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    kWeakSelf
    [warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(74);
        make.left.equalTo(weakSelf.view).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
    }];
    [rowView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(warningLabel.mas_bottom).offset(10);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@60);
    }];
    [hengxianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rowView1.mas_centerX);
        make.centerY.equalTo(rowView1.mas_centerY);
    }];
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hengxianLabel.mas_left).offset(-20);
        make.centerY.equalTo(rowView1.mas_centerY);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@60);
    }];
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hengxianLabel.mas_right).offset(20);
        make.centerY.equalTo(rowView1.mas_centerY);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@60);
    }];
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(startButton.mas_centerX);
        make.centerY.equalTo(startButton.mas_centerY);
    }];
    [finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(finishButton.mas_centerX);
        make.centerY.equalTo(finishButton.mas_centerY);
    }];
    [rowView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rowView1.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@60);
    }];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rowView2.mas_centerX);
        make.centerY.equalTo(rowView2.mas_centerY);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@30);
    }];
    
    UIView *popDatePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 220)];
    [self.view addSubview:popDatePickerView];
    self.popDatePickerView = popDatePickerView;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [popDatePickerView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = CS_UIFontSize(13.);
    cancelButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    cancelButton.layer.cornerRadius = 3.;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.tag = 103;
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [popDatePickerView addSubview:sureButton];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = CS_UIFontSize(13.);
    sureButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
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
        make.top.left.equalTo(popDatePickerView).offset(10);
        make.width.mas_equalTo(@(60));
        make.height.mas_equalTo(@(20));
    }];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popDatePickerView).offset(10);
        make.right.equalTo(popDatePickerView).offset(-10);
        make.width.mas_equalTo(@(60));
        make.height.mas_equalTo(@(20));
    }];
    
    _dateString = [NSString yearDeal:[NSString getCurrentTime]];
    

}
- (void)buttonClick:(UIButton *)button {
    switch (button.tag) {
        case 100: {
            _seleIndex = 1;
            [UIView animateWithDuration:0.3 animations:^{
                self.popDatePickerView.cs_y = SCREENHEIGHT - 220;
//                self.popDatePickerView.transform = CGAffineTransformTranslate(self.popDatePickerView.transform, 0, -220);
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case 101: {
            _seleIndex = 2;
            [UIView animateWithDuration:0.3 animations:^{
                self.popDatePickerView.cs_y = SCREENHEIGHT - 220;
                //                self.popDatePickerView.transform = CGAffineTransformTranslate(self.popDatePickerView.transform, 0, -220);
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case 102: {
            NSLog(@"查不了,你点了也没用啊!");
            [MBProgressHUD showLoading:@""];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:@"暂时不支持查询!"];
            });
        }
            break;
        case 103: {
            [UIView animateWithDuration:0.3 animations:^{
//                self.popDatePickerView.transform = CGAffineTransformIdentity;
                self.popDatePickerView.cs_y = SCREENHEIGHT;
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case 104: {
            [UIView animateWithDuration:0.3 animations:^{
                //                self.popDatePickerView.transform = CGAffineTransformIdentity;
                self.popDatePickerView.cs_y = SCREENHEIGHT;
            } completion:^(BOOL finished) {
                
            }];
            if (_seleIndex == 1) {
                self.startLabel.text = [NSString stringWithFormat:@"%@ \n 开始时间",_dateString];
                
            }else if (_seleIndex == 2) {
                self.finishLabel.text = [NSString stringWithFormat:@"%@ \n 结束时间",_dateString];
                
            }else { }
            
            
        }
            break;
        default:
            break;
    }
    
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)birthdayChange:(UIDatePicker *)picker {
    NSDate *data = picker.date;
    NSDateFormatter *dataMatter = [[NSDateFormatter alloc] init];
    [dataMatter setDateFormat:@"yyyy年MM月dd日"];
    _dateString = [dataMatter stringFromDate:data];
    NSLog(@"%@",_dateString);
}




@end




































































