//
//  CSPersonalInfoController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/27.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPersonalInfoController.h"
#import "CSPersonalInfoCell.h"
#import "CSUserProfileModel.h"
#import "CSChangeUserProfileController.h"


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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dataArr = [self getData:[CSUserProfileModel sharInstance]];
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
    CSPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CSPersonalInfoCellIdentifier];
    if (!cell) {
        cell = [[CSPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CSPersonalInfoCellIdentifier];
    }
    NSDictionary *itemDic = dataArr[indexPath.section][indexPath.row];
    [cell configWithItem:itemDic Section:indexPath.section Row:indexPath.row];
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CSChangeUserProfileController *vc = [[CSChangeUserProfileController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



- (NSArray *)getData:(CSUserProfileModel *)model {
    NSString *sexStr = @"";
    NSString *shengriStr = @"";
    NSString *diquStr = @"";
    NSString *nikeName = @"";
    NSString *imageUrl = @"";
    NSString *descTitle = @"你的铺子";
    
    if (model != nil) {
        nikeName = model.nick;
        imageUrl = model.thumbnail;
        descTitle = [NSString stringWithFormat:@"%@的铺子",nikeName];
        shengriStr = model.birthday_display;
        sexStr = [model.sex integerValue] == 0 ? @"" : [model.sex integerValue] == 1 ? @"男" : @"女";
        diquStr = [NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.district];
    }
    
    NSArray *arr = @[@[
                         @{
                             @"title":@"店名",
                             @"descTitle":descTitle,
                             @"iconImage":@"",
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"头像",
                             @"descTitle":@"",
                             @"iconImage":imageUrl,
                             @"cellImage":@"cs_pushInImage"
                             },
                         @{
                             @"title":@"店主名片",
                             @"descTitle":@"",
                             @"iconImage":imageUrl,
                             @"cellImage":@"cs_pushInImage"
                             },
                         ],
                     @[
                         @{
                             @"title":@"昵称",
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


















































































































































































































