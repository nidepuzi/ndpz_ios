//
//  CSCustomeServiceController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSCustomeServiceController.h"
#import "QYPOPSDK.h"
#import "CSCustomerServiceManager.h"
#import "JMStoreManager.h"
#import "WebViewController.h"


@interface CSCustomeServiceController ()



@end

@implementation CSCustomeServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"客服" selecotr:nil];
    

    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[CSCustomerServiceManager defaultManager] showCustomerService:self];
    kWeakSelf
    [CSCustomerServiceManager defaultManager].popBlock = ^() {
        [weakSelf.navigationController popViewControllerAnimated:NO];
        [JMNotificationCenter postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
    };
    
    
//    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
//    [self updateUserInfo:[JMStoreManager getDataDictionary:@"userProfile"]];
//    
//    
//    QYSource *source = [[QYSource alloc] init];
//    source.title =  @"你的铺子";
//    source.urlString = @"https://m.nidepuzi.com";
//    
//    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
//    sessionViewController.delegate = self;
//    sessionViewController.sessionTitle = @"你的铺子";
//    sessionViewController.source = source;
//    
//    sessionViewController.navigationController.navigationBar.translucent = NO;
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    sessionViewController.navigationController.navigationBar.titleTextAttributes = dict;
//    [sessionViewController.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:0x62a8ea]];
//    
//    sessionViewController.navigationItem.leftBarButtonItem =
//    [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain
//                                    target:self action:@selector(onBack:)];
//    
//    [self.navigationController pushViewController:sessionViewController animated:NO];
//
//    
//    
//    [QYCustomActionConfig sharedInstance].linkClickBlock = ^(NSString *linkAddress) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setValue:linkAddress forKey:@"web_url"];
//        WebViewController *activity = [[WebViewController alloc] init];
//        activity.webDiction = dict;
//        activity.isShowNavBar = YES;
//        activity.isShowRightShareBtn = NO;
//        [self.navigationController pushViewController:activity animated:YES];
//    };
}




@end













































































