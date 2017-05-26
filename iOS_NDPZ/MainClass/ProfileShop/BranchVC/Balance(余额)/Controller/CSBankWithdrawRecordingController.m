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


@interface CSBankWithdrawRecordingController ()  <UITableViewDelegate, UITableViewDataSource> {
    BOOL _isPullDown;       // 下拉刷新的标志
    BOOL _isLoadMore;       // 上拉加载的标志
    NSString *_nextPageUrl; // 下一页数据
    BOOL navigationBarClick;
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
    if (!navigationBarClick) {
        [self.tableView.mj_header beginRefreshing];
    }
    navigationBarClick = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"提现" selecotr:@selector(backClick)];
    
    navigationBarClick = NO;
    [self createcustomizeUI];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
    
}

#pragma mark ==== 下拉刷新,上拉加载 ====
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.tableView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{  // MJAnimationHeader
        _isPullDown = YES;
        [self.tableView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.tableView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark ==== 网络请求 ==== 
- (void)loadDataSource {
    NSString *url = [NSString stringWithFormat:@"%@/rest/v2/redenvelope", Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:url WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return;
        [self.dataSource removeAllObjects];
        [self dataAnalysis:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)loadMore {
    if ([NSString isStringEmpty:_nextPageUrl]) {
        [self endRefresh];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrl WithParaments:nil WithSuccess:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if (!responseObject)return;
        [self dataAnalysis:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
- (void)dataAnalysis:(NSDictionary *)data {
    _nextPageUrl = data[@"next"];
    NSArray *results = data[@"results"];
    if (results.count != 0 ) {
        for (NSDictionary *account in results) {
            CSWithdrawRecordingModel *accountM = [CSWithdrawRecordingModel mj_objectWithKeyValues:account];
            [self.dataSource addObject:accountM];
        }
    }
    [self.tableView reloadData];
}


#pragma mark ==== 自定义UI ====
- (void)createcustomizeUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor countLabelColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableFooterView = [UIView new];
    tableView.separatorColor = [UIColor lineGrayColor];
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    tableView.layoutMargins = UIEdgeInsetsZero;
    [tableView registerClass:[CSWithdrawRecordingCell class] forCellReuseIdentifier:@"CSWithdrawRecordingCellIdentifier"];
    self.tableView = tableView;
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button1 setImage:[UIImage imageNamed:@"cs_wenhao_alpha"] forState:UIControlStateNormal];
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
    
    
    
}


#pragma mark ==== 代理事件 ====
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSWithdrawRecordingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWithdrawRecordingCellIdentifier"];
    if (!cell) {
        cell = [[CSWithdrawRecordingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWithdrawRecordingCellIdentifier"];
    }
    cell.recordingModel = self.dataSource[indexPath.row];
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    sectionView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    sectionView.layer.borderWidth = 1.;
    UILabel *hengxianL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    hengxianL.backgroundColor = [UIColor countLabelColor];
    [sectionView addSubview:hengxianL];
    UILabel *tixianjilu = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 45)];
    tixianjilu.backgroundColor = [UIColor whiteColor];
    [sectionView addSubview:tixianjilu];
    tixianjilu.textColor = [UIColor buttonTitleColor];
    tixianjilu.font = CS_UIFontSize(16.);
    tixianjilu.textAlignment = NSTextAlignmentCenter;
    tixianjilu.text = @"提现记录";
    
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
    navigationBarClick = YES;
    CSPopDescriptionController *popDescVC = [[CSPopDescriptionController alloc] init];
    popDescVC.popDescType = popDescriptionTypeWithdraw;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:popDescVC];
    popupController.isTouchBackgorundView = NO;
    popupController.containerView.layer.cornerRadius = 5;
    [popupController presentInViewController:self];
}
- (void)sectionButtonClick:(UIButton *)button {
    NSString *vipStatus = [JMUserDefaults valueForKey:kUserVipStatus];
    if (![NSString isStringEmpty:vipStatus]) {
        if ([vipStatus isEqual:@"15"]) { // 试用期 弹出框
            [self cs_presentPopView:self.popView animation:[CSPopViewAnimationSpring new] dismiss:^{
            }];
            return;
        }
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














































































































