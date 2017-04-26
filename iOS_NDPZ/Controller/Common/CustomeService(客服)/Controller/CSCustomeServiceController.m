//
//  CSCustomeServiceController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSCustomeServiceController.h"
#import "Udesk.h"

@interface CSCustomeServiceController ()

@end

@implementation CSCustomeServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"客服" selecotr:@selector(backClick)];
    [self setUserInfo];
    
    UIButton *kefuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:kefuButton];
    [kefuButton setTitle:@"进入客服" forState:UIControlStateNormal];
    kefuButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    kefuButton.frame = CGRectMake(SCREENWIDTH / 2 - 50, 200, 100, 50);
    
    [kefuButton addTarget:self action:@selector(kefuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    

    

}
// 个人信息请求
- (void)setUserInfo{
    [[JMGlobal global] upDataLoginStatusSuccess:^(id responseObject) {
        [self updateUserInfo:responseObject];
    } failure:^(NSInteger errorCode) {
        [self updateUserInfo:nil];
        if (errorCode == 403) {
        }else {
            [MBProgressHUD showError:@"请求失败,请手动刷新"];
        }
    }];
}
- (void)updateUserInfo:(NSDictionary *)dic {
    NSString *nick_name = @"测试账号";
    NSString *sdk_token = @"123456";
    if (dic.count == 0) {
        NSLog(@"用户信息失败,使用测试数据");
    }else {
        nick_name = dic[@"nick"];
        sdk_token = [NSString stringWithFormat:@"%@",dic[@"id"]];
    }
    NSDictionary *parameters = @{
                                 @"user": @{
                                         @"sdk_token":sdk_token,
                                         @"nick_name":nick_name,
                                         }
                                 };
    [UdeskManager createCustomerWithCustomerInfo:parameters];

}




- (void)waitButtonStatus:(UIButton *)button {
    button.enabled = YES;
}
- (void)kefuButtonClick:(UIButton *)button {
    button.enabled = NO;
    [self performSelector:@selector(waitButtonStatus:) withObject:button afterDelay:1.];
    UdeskSDKManager *chatViewManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle defaultStyle]];
    [chatViewManager pushUdeskViewControllerWithType:UdeskRobot viewController:self];
    
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end







































