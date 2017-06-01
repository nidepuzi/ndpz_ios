//
//  CSEarningManageController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/27.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSEarningManageController.h"
#import "JMEarningListController.h"

@interface CSEarningManageController ()

@end

@implementation CSEarningManageController

#pragma mark ---- 懒加载


#pragma mark ---- 生命周期函数
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor countLabelColor];
    [self createNavigationBarWithTitle:@"收益管理" selecotr:@selector(backClick)];
    
    [self createUI];
    
    
    
}

#pragma mark ---- 创建UI
- (void)createUI {
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrView];
    
    UIButton *view1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 60)];
    view1.backgroundColor = [UIColor whiteColor];
    [scrView addSubview:view1];
    
    UIView *lineLayer1 = [[UIView alloc] init];
    lineLayer1.backgroundColor = [UIColor lineGrayColor];
    lineLayer1.frame = CGRectMake(10, view1.cs_max_Y, SCREENWIDTH - 20, 0.5);
    [scrView addSubview:lineLayer1];
    
    UIButton *view2 = [[UIButton alloc] initWithFrame:CGRectMake(0, lineLayer1.cs_max_Y, SCREENWIDTH, 60)];
    view2.backgroundColor = [UIColor whiteColor];
    [scrView addSubview:view2];
    
    UIView *lineLayer2 = [[UIView alloc] init];
    lineLayer2.backgroundColor = [UIColor lineGrayColor];
    lineLayer2.frame = CGRectMake(10, view2.cs_max_Y, SCREENWIDTH - 20, 0.5);
    [scrView addSubview:lineLayer2];
    
    UIButton *view3 = [[UIButton alloc] initWithFrame:CGRectMake(0, lineLayer2.cs_max_Y, SCREENWIDTH, 60)];
    view3.backgroundColor = [UIColor whiteColor];
    [scrView addSubview:view3];
    
    [view1 addTarget:self action:@selector(buttonClickTotlaEarning) forControlEvents:UIControlEventTouchUpInside];
    [view2 addTarget:self action:@selector(buttonClickWeekEarning) forControlEvents:UIControlEventTouchUpInside];
    [view3 addTarget:self action:@selector(buttonClickMonthEarning) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label1 = [UILabel new];
    [self label:label1 Text:@"累计收益"];
    
    UILabel *label2 = [UILabel new];
    [self label:label2 Text:@"本周收益"];
    
    UILabel *label3 = [UILabel new];
    [self label:label3 Text:@"本月收益"];
    
    UILabel *valueLabel1 = [UILabel new];
    UILabel *valueLabel2 = [UILabel new];
    UILabel *valueLabel3 = [UILabel new];
    
    [view1 addSubview:label1];
    [view1 addSubview:valueLabel1];
    [view2 addSubview:label2];
    [view2 addSubview:valueLabel2];
    [view3 addSubview:label3];
    [view3 addSubview:valueLabel3];
    
    valueLabel1.textColor = [UIColor buttonEnabledBackgroundColor];
    valueLabel1.font = CS_UIFontSize(24.);
    
    valueLabel2.textColor = [UIColor buttonEnabledBackgroundColor];
    valueLabel2.font = CS_UIFontSize(16.);
    
    valueLabel3.textColor = [UIColor buttonEnabledBackgroundColor];
    valueLabel3.font = CS_UIFontSize(16.);
    
    valueLabel1.text = self.totalEarning;
    valueLabel2.text = [NSString stringWithFormat:@"¥%@",self.weekEarning];
    valueLabel3.text = [NSString stringWithFormat:@"¥%@",self.monthEarning];
    
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1).offset(10);
        make.centerY.equalTo(view1.mas_centerY);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2).offset(10);
        make.centerY.equalTo(view2.mas_centerY);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view3).offset(10);
        make.centerY.equalTo(view3.mas_centerY);
    }];
    [valueLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(20);
        make.centerY.equalTo(label1.mas_centerY);
    }];
    [valueLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(20);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    [valueLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3.mas_right).offset(20);
        make.centerY.equalTo(label3.mas_centerY);
    }];
    
    UILabel *descLabel1 = [UILabel new];
    [scrView addSubview:descLabel1];
    descLabel1.textColor = [UIColor dingfanxiangqingColor];
    descLabel1.font = CS_UIFontSize(12.);
    descLabel1.text = @"说明:";
    
    [descLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrView).offset(10);
        make.top.equalTo(view3.mas_bottom).offset(10);
    }];
    
    UILabel *descLabel2 = [UILabel new];
    [scrView addSubview:descLabel2];
    descLabel2.textColor = [UIColor dingfanxiangqingColor];
    descLabel2.font = CS_UIFontSize(12.);
    descLabel2.numberOfLines = 0;
    
    [descLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descLabel1.mas_right).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 60);
        make.top.equalTo(view3.mas_bottom).offset(10);
    }];
    
    descLabel2.text = @"(1)今日累计收益未考虑可能退换货,请参考实际到账收益 \n(2)累计收益是您在你的铺子平台上因销售产生的相关收入、奖励、不包括因交易、货品产生的补偿以及退款(您可以在余额中查看)";

    scrView.contentSize = CGSizeMake(SCREENWIDTH, view3.cs_max_Y + 80);
    
    
    
    
}
- (void)label:(UILabel *)label Text:(NSString *)text {
    label.textColor = [UIColor blackColor];
    label.font = CS_UIFontSize(14.);
    label.text = text;
}



#pragma mark ---- 刷新


#pragma mark ---- 网络请求


#pragma mark ---- 数据处理


#pragma mark ---- 代理


#pragma mark ---- 自定义事件
- (void)buttonClickTotlaEarning {
    JMEarningListController *vc = [[JMEarningListController alloc] init];
    vc.earningRecodeType = EarningRecodeWithTotal;
    vc.earningValue = self.totalEarning;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)buttonClickWeekEarning {
    JMEarningListController *vc = [[JMEarningListController alloc] init];
    vc.earningRecodeType = EarningRecodeWithWeek;
    vc.earningValue = self.weekEarning;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)buttonClickMonthEarning {
    JMEarningListController *vc = [[JMEarningListController alloc] init];
    vc.earningRecodeType = EarningRecodeWithMonth;
    vc.earningValue = self.monthEarning;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ---- 其他






@end
















































































