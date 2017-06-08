//
//  CSBankWithdrawRecordingController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSBankWithdrawRecordingController.h"
#import <STPopup/STPopup.h>
#import "CSPopDescriptionController.h"

#import "CSCreateBankCardController.h"
#import "CSWithDrawPopView.h"
#import "CSPopAnimationViewController.h"

#import "CSWithdrawRecordingCell.h"
#import "CSWithdrawRecordingModel.h"
#import "CSWithdrawDetailController.h"
#import "Account1ViewController.h"
#import "CSPopDescModel.h"
#import "CSDescTitleListCell.h"
#import "CSUserProfileModel.h"



@interface CSBankWithdrawRecordingController ()  <UITableViewDelegate, UITableViewDataSource> {
    BOOL _isPullDown;       // 下拉刷新的标志
    BOOL _isLoadMore;       // 上拉加载的标志
    NSString *_nextPageUrl; // 下一页数据
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) CSWithDrawPopView *popView;

@end

@implementation CSBankWithdrawRecordingController

#pragma mark ==== 懒加载 ==== 
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (CSWithDrawPopView *)popView {
    if (_popView == nil) {
        _popView = [CSWithDrawPopView defaultWithdrawPopView];
        _popView.typeStatus = popTypeStatusWithdraw;
        _popView.parentVC = self;
    }
    return _popView;
}

#pragma mark ==== 生命周期函数 ====
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClick)];
    
    [self createcustomizeUI];
    
}

#pragma mark ==== 自定义UI ====
- (void)createcustomizeUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor countLabelColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CSDescTitleListCell class] forCellReuseIdentifier:@"CSDescTitleListCellIdentifier"];
    self.tableView = tableView;
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
//    [button1 setImage:[UIImage imageNamed:@"cs_wenhao_alpha"] forState:UIControlStateNormal];
    [button1 setTitle:@"提现记录" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.titleLabel.font = CS_UIFontSize(14.);
    button1.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    [button1 addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBarHidden = NO;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    self.tableView.tableHeaderView = headerView;
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    sectionView.backgroundColor = [UIColor countLabelColor];
    [headerView addSubview:sectionView];
    
    UIButton *sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:sectionButton];
    sectionButton.backgroundColor = [UIColor whiteColor];
    sectionButton.frame = CGRectMake(0, sectionView.cs_max_Y, SCREENWIDTH, 45);
    [sectionButton addTarget:self action:@selector(sectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *cellImageView = [UIImageView new];
    [sectionButton addSubview:cellImageView];
    
    UILabel *settingTitleLabel = [UILabel new];
    settingTitleLabel.textColor = [UIColor buttonTitleColor];
    settingTitleLabel.font = CS_UIFontSize(14.);
    [sectionButton addSubview:settingTitleLabel];
    
    UILabel *settingDescTitleLabel = [UILabel new];
    settingDescTitleLabel.textColor = [UIColor dingfanxiangqingColor];
    settingDescTitleLabel.font = CS_UIFontSize(13.);
    [sectionButton addSubview:settingDescTitleLabel];
    
    UIImageView *iconImageView = [UIImageView new];
    [sectionButton addSubview:iconImageView];

    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionButton).offset(10);
        make.centerY.equalTo(sectionButton.mas_centerY);
        make.width.mas_equalTo(@30);
        make.height.mas_equalTo(@23);
    }];
    [settingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(5);
        make.centerY.equalTo(sectionButton.mas_centerY);
    }];
    [settingDescTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(settingTitleLabel.mas_right).offset(5);
        make.centerY.equalTo(sectionButton.mas_centerY);
    }];
    [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionButton).offset(-15);
        make.centerY.equalTo(sectionButton);
        make.width.mas_equalTo(@(8));
        make.height.mas_equalTo(@(15));
    }];
    
    settingTitleLabel.text = @"提现到银行卡";
    settingDescTitleLabel.text = @"(每提现一次收一元手续费)";
    cellImageView.image = [UIImage imageNamed:@"cs_pushInImage"];
    iconImageView.image = [UIImage imageNamed:@"cs_withDraw_yinhangka"];
    
    NSArray *arr = [CSPopDescModel getWithdrawCellData];
    for (NSDictionary *dic in arr) {
        CSPopDescModel *model = [CSPopDescModel mj_objectWithKeyValues:dic];
        [self.dataSource addObject:model];
    }
    
}


#pragma mark ==== 代理事件 ====
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSDescTitleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSDescTitleListCellIdentifier"];
    if (!cell) {
        cell = [[CSDescTitleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSDescTitleListCellIdentifier"];
    }
    cell.descModel = self.dataSource[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPopDescModel *model = self.dataSource[indexPath.row];
    return model.cellHeightP;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
    UILabel *tixianjilu = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, 35)];
    
    [sectionView addSubview:tixianjilu];
    tixianjilu.textColor = [UIColor buttonTitleColor];
    tixianjilu.font = CS_UIFontSize(14.);
    tixianjilu.text = @"提现小知识";
    
    return sectionView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CSWithdrawRecordingModel *model = self.dataSource[indexPath.row];
    NSString *recordingUrl = [NSString stringWithFormat:@"%@/rest/v2/redenvelope/%@",Root_URL,model.recordingID];
    
    CSWithdrawDetailController *vc = [[CSWithdrawDetailController alloc] init];
    vc.recordingUrl = recordingUrl;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ==== 自定义点击事件 ====
- (void)rightBarButtonAction {
//    navigationBarClick = YES;
//    CSPopDescriptionController *popDescVC = [[CSPopDescriptionController alloc] init];
//    popDescVC.popDescType = popDescriptionTypeWithdraw;
//    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:popDescVC];
//    popupController.isTouchBackgorundView = NO;
//    popupController.containerView.layer.cornerRadius = 5;
//    [popupController presentInViewController:self];

    Account1ViewController *vc = [[Account1ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sectionButtonClick:(UIButton *)button {
    if ([[CSUserProfileModel sharInstance].xiaolumm.last_renew_type isEqualToString:@"15"]) {
        [self cs_presentPopView:self.popView animation:[CSPopViewAnimationSpring new] dismiss:^{
        }];
        return;
    }
    CSCreateBankCardController *vc = [[CSCreateBankCardController alloc] init];
    vc.accountMoney = self.accountMoney;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    
}





@end














































































































