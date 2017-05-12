//
//  CSFansTotalRevenueController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/12.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSFansTotalRevenueController.h"
#import "CSFansTotalRevenueCell.h"
#import "CSFansTotlaRevenueModel.h"

@interface CSFansTotalRevenueController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation CSFansTotalRevenueController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < 16; i++) {
        CSFansTotlaRevenueModel *model = [CSFansTotlaRevenueModel new];
        model.title = @"测试数据";
        [self.dataSource addObject:model];
    }
    
    [self createNavigationBarWithTitle:@"粉丝总收入" selecotr:@selector(backClick)];
    [self createTableView];
    
    
    
}
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor countLabelColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CSFansTotalRevenueCell class] forCellReuseIdentifier:@"CSFansTotalRevenueCellIdentifier"];
    self.tableView = tableView;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:leftButton];
    
    UILabel *fansTotalRevenueLabel = [UILabel new];
    [leftButton addSubview:fansTotalRevenueLabel];
    fansTotalRevenueLabel.font = CS_UIFontSize(14.);
    fansTotalRevenueLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *fansTotalRevenueValueLabel = [UILabel new];
    [leftButton addSubview:fansTotalRevenueValueLabel];
    fansTotalRevenueValueLabel.font = CS_UIFontSize(14.);
    fansTotalRevenueValueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *shuxianLabel = [UILabel new];
    [headerView addSubview:shuxianLabel];
    shuxianLabel.backgroundColor = [UIColor buttonTitleColor];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:rightButton];
    
    UILabel *fansNumLabel = [UILabel new];
    [rightButton addSubview:fansNumLabel];
    fansNumLabel.font = CS_UIFontSize(14.);
    fansNumLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *fansNumValueLabel = [UILabel new];
    [rightButton addSubview:fansNumValueLabel];
    fansNumValueLabel.font = CS_UIFontSize(14.);
    fansNumValueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(headerView);
        make.width.mas_equalTo(@(SCREENWIDTH / 2));
        make.height.mas_equalTo(@100);
    }];
    [fansTotalRevenueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftButton.mas_centerX);
        make.centerY.equalTo(leftButton.mas_centerY).offset(-20);
    }];
    [fansTotalRevenueValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftButton.mas_centerX);
        make.centerY.equalTo(leftButton.mas_centerY).offset(20);
    }];
    [shuxianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.centerY.equalTo(headerView.mas_centerY);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@60);
    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(headerView);
        make.width.mas_equalTo(@(SCREENWIDTH / 2));
        make.height.mas_equalTo(@100);
    }];
    [fansNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightButton.mas_centerX);
        make.centerY.equalTo(rightButton.mas_centerY).offset(-20);
    }];
    [fansNumValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightButton.mas_centerX);
        make.centerY.equalTo(rightButton.mas_centerY).offset(20);
    }];
    
    fansTotalRevenueLabel.text = @"粉丝总收入";
    fansTotalRevenueValueLabel.text = @"粉丝总收入";
    fansNumLabel.text = @"粉丝总收入";
    fansNumValueLabel.text = @"粉丝总收入";
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSFansTotalRevenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSFansTotalRevenueCellIdentifier"];
    if (!cell) {
        cell = [[CSFansTotalRevenueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSFansTotalRevenueCellIdentifier"];
    }
    CSFansTotlaRevenueModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
    sectionView.backgroundColor = [UIColor countLabelColor];
    NSArray *labelValueArr = @[@"用户姓名",@"身份",@"总收入"];
    CGFloat labelW = SCREENWIDTH / labelValueArr.count;
    for (int i = 0; i < labelValueArr.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i % 3) * labelW, 0, labelW, 45)];
        label.font = CS_UIFontSize(13.);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor dingfanxiangqingColor];
        label.text = labelValueArr[i];
        [sectionView addSubview:label];
    }
    
    return sectionView;
}







- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}



@end









































































































































































