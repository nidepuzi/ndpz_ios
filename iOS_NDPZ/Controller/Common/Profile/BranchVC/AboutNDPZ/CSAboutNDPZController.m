//
//  CSAboutNDPZController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSAboutNDPZController.h"
#import "CSDevice.h"

@interface CSAboutNDPZController ()

@end

@implementation CSAboutNDPZController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:self.navigationTitleString selecotr:@selector(backClick)];
    
    
    UIImageView *maskImageView = [UIImageView new];
    [self.view addSubview:maskImageView];
    maskImageView.image = [UIImage imageNamed:@"iPhone6"];
    
    CGFloat imageW = SCREENWIDTH * 0.6;
    CGFloat imageH = imageW * maskImageView.image.size.height / maskImageView.image.size.width;
    
    maskImageView.frame = CGRectMake(SCREENWIDTH * 0.2, 100, imageW, imageH);
    
    
    UILabel *verSionLabel = [UILabel new];
    verSionLabel.font = CS_UIFontSize(18.);
    verSionLabel.textColor = [UIColor dingfanxiangqingColor];
    NSString *appVersion = [[CSDevice defaultDevice] getDeviceAppVersion];
    NSString *appBulidVersion = [[CSDevice defaultDevice] getDeviceAppBuildVersion];
    NSString *deviceVersion = [NSString stringWithFormat:@"当前版本 : %@.%@",appVersion,appBulidVersion];
    verSionLabel.text = deviceVersion;
    [self.view addSubview:verSionLabel];
    
    kWeakSelf
    
    UILabel *goongsiLabel = [UILabel new];
    goongsiLabel.font = CS_UIFontSize(10.);
    goongsiLabel.textColor = [UIColor buttonTitleColor];
    goongsiLabel.text = @"上海但来电子商务有限公司";
    [self.view addSubview:goongsiLabel];
    
    UILabel *gongsiDescLabel = [UILabel new];
    gongsiDescLabel.font = CS_UIFontSize(10.);
    gongsiDescLabel.textColor = [UIColor buttonTitleColor];
    gongsiDescLabel.text = @"Copyright (c) 2017 上海但来. All rights reserved";
    [self.view addSubview:gongsiDescLabel];
    
    [verSionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(goongsiLabel.mas_top).offset(-20);
    }];
    
    [goongsiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(gongsiDescLabel.mas_top).offset(-5);
    }];
    [gongsiDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view).offset(-10);
    }];
    
    
    
    
    
    
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
