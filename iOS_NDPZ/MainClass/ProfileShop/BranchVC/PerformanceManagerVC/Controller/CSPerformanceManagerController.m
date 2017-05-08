//
//  CSPerformanceManagerController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPerformanceManagerController.h"
#import "CSAccountSecurityCell.h"

@interface CSPerformanceManagerController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *dataArr;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CSPerformanceManagerController

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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    self.tableView.tableHeaderView = headerView;
    
    UIView *headerRow = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 85)];
    headerRow.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:headerRow];
    
    UIImageView *iconImageV = [UIImageView new];
    iconImageV.layer.masksToBounds = YES;
    iconImageV.layer.cornerRadius = 30;
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = CS_UIFontSize(16.);
    nameLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *zhiweiLabel = [UILabel new];
    zhiweiLabel.font = CS_UIFontSize(15.);
    zhiweiLabel.textColor = [UIColor dingfanxiangqingColor];
    
    [headerRow addSubview:iconImageV];
    [headerRow addSubview:nameLabel];
    [headerRow addSubview:zhiweiLabel];
    
    [iconImageV sd_setImageWithURL:[NSURL URLWithString:self.profileInfo[@"thumbnail"]] placeholderImage:[UIImage imageNamed:@"icon_placeholder"]];
    nameLabel.text = self.profileInfo[@"nick"];
    zhiweiLabel.text = @"掌柜";//self.profileInfo[@""];
    
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerRow.mas_centerY);
        make.left.equalTo(headerRow).offset(20);
        make.width.height.mas_equalTo(@60);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerRow.mas_centerY).offset(-15);
        make.left.equalTo(iconImageV.mas_right).offset(10);
    }];
    [zhiweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerRow.mas_centerY).offset(15);
        make.left.equalTo(iconImageV.mas_right).offset(10);
    }];
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    [cell configPerformanceManager:dataArr[indexPath.row] Index:indexPath.row];
    //    if (indexPath.section == 1) {
    //        if (indexPath.row == 0) {
    //            cell.settingDescTitleLabel.text = [[CSDevice defaultDevice] getDeviceCacheSize];
    //        }
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSArray *)getData:(NSDictionary *)dic {
    NSArray *arr = @[
                     @{
                         @"title":@"分享好礼",
                         @"descTitle":@"铺子微信免费送",
                         @"cellImage":@"cs_pushInImage"
                         },
                     @{
                         @"title":@"分享记录",
                         @"descTitle":@"",
                         @"cellImage":@"cs_pushInImage"
                         },
                     @{
                         @"title":@"客户总收入",
                         @"descTitle":@"¥0.00",
                         @"cellImage":@"cs_pushInImage"
                         },
                     @{
                         @"title":@"自购成交订单",
                         @"descTitle":@"",
                         @"cellImage":@"cs_pushInImage"
                         },
                     @{
                         @"title":@"分享成交订单",
                         @"descTitle":@"",
                         @"cellImage":@"cs_pushInImage"
                         },
                     ];
    
    return arr;
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}



@end








































