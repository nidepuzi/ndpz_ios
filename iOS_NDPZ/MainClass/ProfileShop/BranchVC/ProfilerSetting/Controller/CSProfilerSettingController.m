//
//  CSProfilerSettingController.m
//  NDPZ
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSProfilerSettingController.h"
#import "CSProfilerSettingCell.h"
#import "CSDevice.h"
#import "CSAboutNDPZController.h"
#import "CSPersonalInfoController.h"
#import "CSAccountSecurityController.h"
#import "CSOnlineTestController.h"
#import "MiPushSDK.h"
#import "QYPOPSDK.h"
#import "JMVerificationCodeController.h"
#import "JMStoreManager.h"


@interface CSProfilerSettingController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    NSArray *dataArr;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CSProfilerSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"设置" selecotr:@selector(backClick)];
    dataArr = [self getData:[JMStoreManager getDataDictionary:@"userProfile"]];
    [self createTableView];
    
    
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    self.tableView.tableFooterView = bottomView;
    
    UIButton *tuichuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tuichuButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [tuichuButton setTitle:@"退出账号" forState:UIControlStateNormal];
    [tuichuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tuichuButton.titleLabel.font = CS_UIFontSize(16.);
    tuichuButton.layer.cornerRadius = 5.;
    tuichuButton.layer.masksToBounds = YES;
    [tuichuButton addTarget:self action:@selector(tuichuClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tuichuButton];
    
    [tuichuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView.mas_centerX);
        make.bottom.equalTo(bottomView).offset(-40);
        make.width.mas_equalTo(@(SCREENWIDTH - 40));
        make.height.mas_equalTo(@(40));
    }];
    
    
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
//    if (indexPath.section == 1) {
//        if (indexPath.row !=0 ) {
//            identifier = @"cell1";
//        }else {
//            identifier = @"cell0";
//        }
//    }else {
        identifier = @"cell0";
//    }
    CSProfilerSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CSProfilerSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sectionIndex = indexPath.section;
    NSInteger rowIndex = indexPath.row;
    
    NSInteger mobClickIndex = indexPath.section * 3 + indexPath.row;
    NSArray *itemArr = @[@"个人资料",@"绑定手机",@"修改密码",@"清除缓存",@"关于你的铺子",@"当前版本"];
    NSDictionary *tempDict = @{@"code" : [NSString stringWithFormat:@"%@",itemArr[mobClickIndex]]};
    [MobClick event:@"CSProfilerSettingController_ButtonClick" attributes:tempDict];
    
    if (sectionIndex == 0) {
        if (rowIndex == 0) {
            CSPersonalInfoController *vc = [[CSPersonalInfoController alloc] init];
            vc.profileInfo = self.profileInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (rowIndex == 1) {
            NSDictionary *weChatInfo = [JMUserDefaults objectForKey:kWxLoginUserInfo];
            JMVerificationCodeController *vc = [[JMVerificationCodeController alloc] init];
            vc.verificationCodeType = SMSVerificationCodeWithBind;
            vc.userInfo = weChatInfo;
            vc.profileUserInfo = self.profileInfo;
            vc.userLoginMethodWithWechat = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            JMVerificationCodeController *verfyCodeVC = [[JMVerificationCodeController alloc] init];
            verfyCodeVC.verificationCodeType = SMSVerificationCodeWithChangePWD;
            verfyCodeVC.userLoginMethodWithWechat = YES;
            [self.navigationController pushViewController:verfyCodeVC animated:YES];
        }
    }else if (sectionIndex == 1) {
        if (rowIndex == 0) {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清空缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alterView.delegate = self;
            [alterView show];
        }else {
            NSString *titleString = rowIndex == 1 ? @"关于你的铺子" : @"当前版本";
            CSAboutNDPZController *vc = [[CSAboutNDPZController alloc] init];
            vc.navigationTitleString = titleString;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else { }
//    else if (sectionIndex == 2) {
//        if (rowIndex == 1 || rowIndex == 3) {
//            NSString *titleString = rowIndex == 1 ? @"关于你的铺子" : @"当前版本";
//            CSAboutNDPZController *vc = [[CSAboutNDPZController alloc] init];
//            vc.navigationTitleString = titleString;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if (rowIndex == 2 || rowIndex == 0) {
//            NSString *titleString = rowIndex == 0 ? @"店主服务" : @"在线测试";
//            CSOnlineTestController *vc = [[CSOnlineTestController alloc] init];
//            vc.navigationTitleString = titleString;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    
//    }
//else { }
    
    
    
}
- (void)tuichuClick:(UIButton *)button {
    [MobClick event:@"LoginOutClick"];
    NSLog(@"点击 --> 退出登录");
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/customer_logout", Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] != 0) {
            [MBProgressHUD showMessage:@"退出登录失败"];
            return;
        }
        //注销账号
        NSString *user_account = [JMUserDefaults objectForKey:@"user_account"];
        if (!([user_account isEqualToString:@""] || [user_account class] == [NSNull null])) {
            [MiPushSDK unsetAccount:user_account];
            [JMUserDefaults setObject:@"" forKey:@"user_account"];
        }
        [[QYSDK sharedSDK] logout:^{
            NSLog(@"七鱼客服已经退出");
        }];
        [JMUserDefaults setBool:NO forKey:kIsLogin];
//        [JMUserDefaults setBool:NO forKey:kISNDPZVIP];54
        [JMUserDefaults setObject:@"unlogin" forKey:kLoginMethod];
        [JMUserDefaults synchronize];
        [JMNotificationCenter postNotificationName:@"logout" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[JMGlobal global] showLoginViewController];
        [MBProgressHUD hideHUD];
        //            RootNavigationController *rootNav = [[RootNavigationController alloc] initWithRootViewController:loginVC];
        //            [XLMM_APP.window.rootViewController presentViewController:rootNav animated:YES completion:nil];
        //            [self.navigationController popViewControllerAnimated:YES];
        //            [self removeFromParentViewController];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showMessage:@"退出登录失败"];
    } Progress:^(float progress) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [MBProgressHUD showLoading:@""];
        [[SDImageCache sharedImageCache] clearDisk];
        [self performSelector:@selector(alterMessage) withObject:nil afterDelay:1.0f];
        [self performSelector:@selector(setcacheSize) withObject:nil afterDelay:2.0f];
    }
}
- (void)alterMessage {
    [[CSDevice defaultDevice] showAlertMessage:@"缓存清理完成！"];
}
- (void)setcacheSize{
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    NSLog(@"path = %@", path);
    
    NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog(@"file size = %@",[dict objectForKey:NSFileSize]);
    float sizeValue = [[dict objectForKey:NSFileSize] integerValue]/200.0f;
    if (sizeValue < 1.0) {
        sizeValue = 0.0f;
    }
    dataArr = [self getData:[JMStoreManager getDataDictionary:@"userProfile"]];
    [self.tableView reloadData];
    [MBProgressHUD hideHUD];
}

- (NSArray *)getData:(NSDictionary *)dic {
    if (dic == nil) {
        return nil;
    }
    NSString *appVersion = [[CSDevice defaultDevice] getDeviceAppVersion];
    NSString *appBulidVersion = [[CSDevice defaultDevice] getDeviceAppBuildVersion];
    NSString *deviceVersion = [NSString stringWithFormat:@"%@.%@",appVersion,appBulidVersion];
    NSString *cacheString = [[CSDevice defaultDevice] getDeviceCacheSize];
    
    NSString *phoneString = dic[@"mobile"];
    NSMutableString * mutablePhoneNumber = [phoneString mutableCopy];
    NSRange range = {3,4};
    if (mutablePhoneNumber.length == 11) {
        [mutablePhoneNumber replaceCharactersInRange:range withString:@"****"];
    }
    
    
    NSArray *arr = @[@[
                         @{
                             @"title":@"个人资料",
                             @"descTitle":@"",
                             @"iconImage":@"cs_profile_gerenziliao",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"绑定手机",
                             @"descTitle":mutablePhoneNumber,
                             @"iconImage":@"cs_profile_bindPhone",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"修改密码",
                             @"descTitle":@"",
                             @"iconImage":@"cs_profile_changeMima",
                             @"cellImage":@"cs_pushInImage"
                             },
                         ],
                     @[
                         @{
                             @"title":@"清除缓存",
                             @"descTitle":cacheString,
                             @"iconImage":@"cs_profile_qingchuhuancun",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"关于你的铺子",
                             @"descTitle":@"",
                             @"iconImage":@"cs_profile_guanyu",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"当前版本",
                             @"descTitle":deviceVersion,
                             @"iconImage":@"cs_profile_setting",
                             @"cellImage":@"cs_pushInImage"
                             },
                         ]
                     ];
    
    return arr;
}


- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
















































