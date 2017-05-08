//
//  CSAccountSecurityController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/27.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSAccountSecurityController.h"
#import "CSAccountSecurityCell.h"
#import "MiPushSDK.h"
#import "QYSDK.h"

@interface CSAccountSecurityController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *dataArr;
}
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation CSAccountSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"账户与安全" selecotr:@selector(backClick)];
    
    
    
    dataArr = [self getData:nil];
    [self createTableView];
    
    
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *loginOutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 75)];
    self.tableView.tableFooterView = loginOutView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    lineView.backgroundColor = [UIColor lineGrayColor];
    [loginOutView addSubview:lineView];
    
    UIButton *loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginOutView addSubview:loginOutButton];
    loginOutButton.frame = CGRectMake(0, 15, SCREENWIDTH, 60);
    loginOutButton.backgroundColor = [UIColor whiteColor];
    loginOutButton.titleLabel.font = CS_UIFontBoldSize(16.);
    [loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
    [loginOutButton addTarget:self action:@selector(loginOutClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    sectionView.backgroundColor = [UIColor lineGrayColor];
    return sectionView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = nil;
    if (indexPath.section == 1) {
        if (indexPath.row !=0 ) {
            identifier = @"cell1";
        }else {
            identifier = @"cell0";
        }
    }else {
        identifier = @"cell0";
    }
    CSAccountSecurityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CSAccountSecurityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.itemDic = dataArr[indexPath.section][indexPath.row];
    //    if (indexPath.section == 1) {
    //        if (indexPath.row == 0) {
    //            cell.settingDescTitleLabel.text = [[CSDevice defaultDevice] getDeviceCacheSize];
    //        }
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (NSArray *)getData:(NSDictionary *)dic {
    NSString *settingPayMima = @"未设置";
    NSArray *arr = @[@[
                         @{
                             @"title":@"关联微信",
                             @"descTitle":@"",
                             @"cellImage":@"cs_pushInImage"
                             },
                         ],
                     @[
                         @{
                             @"title":@"Title",
                             @"descTitle":@"",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"支付密码",
                             @"descTitle":settingPayMima,
                             @"cellImage":@"cs_pushInImage"
                             },
                         ],
                     ];
    
    return arr;
}
- (void)loginOutClick:(UIButton *)button {
    NSLog(@"点击 --> 退出登录");
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/customer_logout", Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:@"code"] integerValue] != 0) return;
        //注销账号
        NSString *user_account = [JMUserDefaults objectForKey:@"user_account"];
        if (!([user_account isEqualToString:@""] || [user_account class] == [NSNull null])) {
            [MiPushSDK unsetAccount:user_account];
            [JMUserDefaults setObject:@"" forKey:@"user_account"];
        }
        [[QYSDK sharedSDK] logout:^{
            NSLog(@"七鱼客服已经退出");
        }];
        [JMUserDefaults setBool:NO forKey:@"login"];
        [JMUserDefaults setBool:NO forKey:@"isXLMM"];
        [JMUserDefaults setObject:@"unlogin" forKey:kLoginMethod];
        [JMUserDefaults synchronize];
        [JMNotificationCenter postNotificationName:@"logout" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[JMGlobal global] showLoginViewController];
        //            RootNavigationController *rootNav = [[RootNavigationController alloc] initWithRootViewController:loginVC];
        //            [XLMM_APP.window.rootViewController presentViewController:rootNav animated:YES completion:nil];
        //            [self.navigationController popViewControllerAnimated:YES];
        //            [self removeFromParentViewController];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}








- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end



























