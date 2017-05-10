//
//  CSPerformanceManagerController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPerformanceManagerController.h"
#import "CSAccountSecurityCell.h"
#import "JMShareViewController.h"
#include "JMShareModel.h"
#import "JMOrderListController.h"

@interface CSPerformanceManagerController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *dataArr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) JMShareViewController *shareView;
@property (nonatomic, strong) JMShareModel *share_model;

@end

@implementation CSPerformanceManagerController
- (JMShareModel*)share_model {
    if (!_share_model) {
        _share_model = [[JMShareModel alloc] init];
    }
    return _share_model;
}
- (JMShareViewController *)shareView {
    if (!_shareView) {
        _shareView = [[JMShareViewController alloc] init];
        _shareView.shareType = shareVCTypeInvite;
    }
    return _shareView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"业绩管理" selecotr:@selector(backClick)];
    dataArr = [self getData:self.profileInfo];
    [self createTableView];
    [self loadData];
    
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

- (void)loadData {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, @"8"];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            return;
        }
        [self resolveActivityShareParam:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } Progress:^(float progress) {
        
    }];
}
- (void)resolveActivityShareParam:(NSDictionary *)dic {
    self.share_model.share_type = [dic objectForKey:@"share_type"];
    self.share_model.share_img = [dic objectForKey:@"share_icon"]; //图片
    self.share_model.desc = [dic objectForKey:@"active_dec"]; // 文字详情
    self.share_model.title = [dic objectForKey:@"title"]; //标题
    self.share_model.share_link = [dic objectForKey:@"share_link"];
    self.shareView.model = self.share_model;
}


- (void)inviteClick {
    [[JMGlobal global] showpopBoxType:popViewTypeShare Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, kAppShareViewHeight) ViewController:self.shareView WithBlock:^(UIView *maskView) {
    }];
    self.shareView.blcok = ^(UIButton *button) {
        [MobClick event:@"WebViewController_shareFail_cancel"];
    };
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    switch (index) {
        case 0: {
            [self inviteClick];
        }
            
            break;
        case 1: {
            [MBProgressHUD showMessage:@"暂无记录"];
        }
            
            break;
        case 2: {
            
        }
            
            break;
        case 3: {
            [self pushOrderIndexVC:0];
        }
            
            break;
        case 4: {
            [self pushOrderIndexVC:0];
        }
            
            break;
            
        default:
            break;
    }
}
- (void)pushOrderIndexVC:(NSInteger)index {
    JMOrderListController *order = [[JMOrderListController alloc] init];
    order.currentIndex = index;
    order.ispopToView = YES;
    [self.navigationController pushViewController:order animated:YES];
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








































