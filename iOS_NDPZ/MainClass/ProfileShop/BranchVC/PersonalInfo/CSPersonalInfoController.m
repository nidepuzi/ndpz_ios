//
//  CSPersonalInfoController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/27.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPersonalInfoController.h"
#import "CSPersonalInfoCell.h"

@interface CSPersonalInfoController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *dataArr;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CSPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"个人资料" selecotr:@selector(backClick)];
    
    [self createTableView];
    
    
}
- (void)setProfileInfo:(NSDictionary *)profileInfo {
    _profileInfo = profileInfo;
    dataArr = [self getData:profileInfo];
    [self.tableView reloadData];
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor lineGrayColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CSPersonalInfoCell class] forCellReuseIdentifier:CSPersonalInfoCellIdentifier];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            return 80;
        }
    }
    return 60.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    sectionView.backgroundColor = [UIColor lineGrayColor];
    UILabel *label = [UILabel new];
    [sectionView addSubview:label];
    label.textColor = [UIColor buttonTitleColor];
    label.font = CS_UIFontSize(14.);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).offset(15);
        make.centerY.equalTo(sectionView.mas_centerY);
    }];
    label.text = section == 0 ? @"店铺信息" : @"个人信息";
    return sectionView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        if (indexPath.row !=0 ) {
//            identifier = @"CSPersonalInfoCell1";
//        }else {
//            identifier = @"CSPersonalInfoCell0";
//        }
//    }else {
//        identifier = @"CSPersonalInfoCell0";
//    }
    CSPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CSPersonalInfoCellIdentifier];
    if (!cell) {
        cell = [[CSPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CSPersonalInfoCellIdentifier];
    }
    NSDictionary *itemDic = dataArr[indexPath.section][indexPath.row];
    //    if (indexPath.section == 1) {
    //        if (indexPath.row == 0) {
    //            cell.settingDescTitleLabel.text = [[CSDevice defaultDevice] getDeviceCacheSize];
    //        }
    //    }
    [cell configWithItem:itemDic Section:indexPath.section Row:indexPath.row];
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




- (NSArray *)getData:(NSDictionary *)dic {
    NSString *sexStr = @"";
    NSString *shengriStr = @"";
    NSString *diquStr = @"";
    NSString *nikeName = @"";
    NSString *imageUrl = @"";
    if (dic.count == 0) {
        
    }else {
//        sexStr = [dic[@"sex"] boolValue] == 1 ? @"男" : @"女";
        nikeName = dic[@"nick"];
        imageUrl = dic[@"thumbnail"];
    }
    
    NSArray *arr = @[@[
                         @{
                             @"title":@"店名",
                             @"descTitle":@"你的铺子",
                             @"iconImage":@"",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"店铺介绍",
                             @"descTitle":@"",
                             @"iconImage":@"",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"头像",
                             @"descTitle":@"",
                             @"iconImage":imageUrl,
                             @"cellImage":@"cs_pushInImage"
                             },
//                         @{
//                             @"title":@"店招图",
//                             @"descTitle":@"",
//                             @"iconImage":imageUrl,
//                             @"cellImage":@"cs_pushInImage"
//                             },
                         @{
                             @"title":@"店主名片",
                             @"descTitle":@"",
                             @"iconImage":imageUrl,
                             @"cellImage":@"cs_pushInImage"
                             },
                         ],
                     @[
                         @{
                             @"title":@"姓名",
                             @"descTitle":nikeName,
                             @"iconImage":@"",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"生日",
                             @"descTitle":shengriStr,
                             @"iconImage":@"",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"性别",
                             @"descTitle":sexStr,
                             @"iconImage":@"",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"地区",
                             @"descTitle":diquStr,
                             @"iconImage":@"",
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


















































































































































































































