//
//  CSOnlineTestController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/27.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSOnlineTestController.h"

@interface CSOnlineTestController ()

@end

@implementation CSOnlineTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:self.navigationTitleString selecotr:@selector(backClick)];
    
    UIImageView *headerView = [UIImageView new];
    [self.view addSubview:headerView];
    headerView.image = [UIImage imageNamed:@"iPhone4S"];
    CGFloat headerImageH = SCREENHEIGHT / 2 - 32;
    CGFloat headerImageW = headerImageH * (headerView.image.size.width / headerView.image.size.height);
    
    kWeakSelf
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(128);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(headerImageW);
        make.height.mas_equalTo(headerImageH);
    }];
    
    UILabel *onlineTestLabel = [UILabel new];
    [self.view addSubview:onlineTestLabel];
    onlineTestLabel.font = CS_UIFontSize(16.);
    onlineTestLabel.textColor = [UIColor buttonTitleColor];
    onlineTestLabel.text = @"此功能暂未对外开放,敬请期待!";
    
    [onlineTestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    
}












- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end


























