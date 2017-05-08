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


@interface CSProfilerSettingController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    NSArray *dataArr;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CSProfilerSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"设置" selecotr:@selector(backClick)];
    
    dataArr = [self getData:nil];
    [self createTableView];
    
    
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
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
    if (sectionIndex == 0) {
        if (rowIndex == 0) {
            CSPersonalInfoController *vc = [[CSPersonalInfoController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            CSAccountSecurityController *vc = [[CSAccountSecurityController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (sectionIndex == 1) {
        if (rowIndex == 0) {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清空缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alterView.delegate = self;
            [alterView show];
        }
    }else if (sectionIndex == 2) {
        if (rowIndex == 1 || rowIndex == 3) {
            NSString *titleString = rowIndex == 1 ? @"关于你的铺子" : @"当前版本";
            CSAboutNDPZController *vc = [[CSAboutNDPZController alloc] init];
            vc.navigationTitleString = titleString;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (rowIndex == 2 || rowIndex == 0) {
            NSString *titleString = rowIndex == 0 ? @"店主服务" : @"在线测试";
            CSOnlineTestController *vc = [[CSOnlineTestController alloc] init];
            vc.navigationTitleString = titleString;
            [self.navigationController pushViewController:vc animated:YES];
        }
    
    }else { }
    
    
    
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
    dataArr = [self getData:nil];
    [self.tableView reloadData];
    [MBProgressHUD hideHUD];
}

- (NSArray *)getData:(NSDictionary *)dic {
    NSString *appVersion = [[CSDevice defaultDevice] getDeviceAppVersion];
    NSString *appBulidVersion = [[CSDevice defaultDevice] getDeviceAppBuildVersion];
    NSString *deviceVersion = [NSString stringWithFormat:@"%@.%@",appVersion,appBulidVersion];
    
    NSString *cacheString = [[CSDevice defaultDevice] getDeviceCacheSize];
    
    NSArray *arr = @[@[
                         @{
                             @"title":@"个人资料",
                             @"descTitle":@"",
                             @"iconImage":@"cs_profile_gerenziliao",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"账户与安全",
                             @"descTitle":@"",
                             @"iconImage":@"cs_profile_anquan",
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
                             @"title":@"广告拦截模式已关闭",
                             @"descTitle":@"",
                             @"iconImage":@"cs_profile_guanlao",
                             @"cellImage":@""
                             },
                         @{
                             @"title":@"兼容模式已关闭",
                             @"descTitle":@"",
                             @"iconImage":@"cs_profile_jianrong",
                             @"cellImage":@""
                             },
                         ],
                     @[
                         @{
                             @"title":@"店主服务",
                             @"descTitle":@"",
                             @"iconImage":@"cs_profile_fuwu",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"关于你的铺子",
                             @"descTitle":@"",
                             @"iconImage":@"cs_profile_guanyu",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"在线测试",
                             @"descTitle":@"未测试",
                             @"iconImage":@"cs_profile_ceshi",
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
















































